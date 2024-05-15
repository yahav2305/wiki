package main

import (
	"io/fs"
	"net/http"
	"os"
	"path/filepath"
	"regexp"
	"strings"
	"text/template"
	"time"

	"github.com/gomarkdown/markdown"
	"github.com/gomarkdown/markdown/html"
	"github.com/gomarkdown/markdown/parser"
	"github.com/gorilla/mux"
	"github.com/sirupsen/logrus"
	"github.com/yosssi/gohtml"
)

const (
	// Reletive Paths

	md_dir_rel_path            = "../docs/Prod"                   // Reletive path to directory that contains .md files that will be converted to .html files
	gen_html_dir_rel_path      = "../web/app"                     // Reletive path to directory that contains generated .html files
	template_html_dir_rel_path = "../web/template"                // Reletive path to directory that contains .html file templates
	public_dir_rel_path        = "../public/"                     // Relative path to directory that contains public files (css, js, etc.)
	assets_dir_rel_path        = "../assets/"                     // Relative path to directory that contains assets files (images, icons, etc.)
	base_template_file         = "../web/template/base.tmpl.html" // Relative path to template file for all html pages

	// Port

	port = "5500" // Port the website will be served at

	// Routes

	public_route = "/public/" // Route to directory that contains public files (css, js, etc.)
	assets_route = "/assets/" // Route to directory that contains assets files (images, icons, etc.)

	// File Extensions

	docs_file_ext = ".md"   // File extension of doc files
	web_file_ext  = ".html" // File extension of web files
)

type PageData struct {
	Title    string
	Contents string
}

// Retrieves an environment variable value. If it doesn't exist, use fallback value
func getEnv(env_name, fallback_value string) string {
	env_value, exists := os.LookupEnv(env_name)
	if !exists {
		env_value = fallback_value
	}
	return env_value
}

// Gets path to markdown file, returns converted path to html file
func convertMarkdownPathToHTMLPath(markdown_path string) string {
	// Change start of path to dir that stores html
	html_path := strings.Replace(markdown_path, filepath.FromSlash(md_dir_rel_path), filepath.FromSlash(gen_html_dir_rel_path), 1)
	// Replaces spaces with dashes for better url look
	html_path = strings.ReplaceAll(html_path, " ", "-")
	// Change extension to html
	return strings.TrimSuffix(html_path, filepath.Ext(html_path)) + web_file_ext
}

// Changes markdown file to adapt to the wiki's needs
func prepareMarkDown(md_contents []byte, dir_file bool) []byte {

	md_string := string(md_contents)

	// Removes docs folder file path from all links, since we serve doc files from root route
	md_string = strings.ReplaceAll(md_string, strings.Replace(md_dir_rel_path, "../", "", 1), "")

	// Removes all md file extension for navigating between files
	md_string = strings.ReplaceAll(md_string, docs_file_ext, "")

	// If file serves as a file that is a directory for a subject, replace all spaces with dashes for url compatability
	if dir_file {
		md_string = strings.ReplaceAll(md_string, "%20", "-")
	}

	return []byte(md_string)
}

// Gets bytes of markdown file, returns bytes of converted html
func convertMarkdownToHTML(md_contents []byte) []byte {
	// create markdown parser with extensions
	extensions := parser.CommonExtensions | parser.AutoHeadingIDs | parser.NoEmptyLineBeforeBlock
	parser := parser.NewWithExtensions(extensions)
	doc := parser.Parse(md_contents)

	// create HTML renderer with extensions
	htmlFlags := html.CommonFlags | html.HrefTargetBlank
	opts := html.RendererOptions{Flags: htmlFlags}
	renderer := html.NewRenderer(opts)

	// Convert markdown to HTML
	html_bytes := markdown.Render(doc, renderer)

	return html_bytes
}

func generateWebStructure(path string, d fs.DirEntry, err error) error {
	if err != nil {
		return err
	}

	if !d.IsDir() && filepath.Ext(path) == docs_file_ext {
		// Read markdown file
		md_contents, err := os.ReadFile(path)
		if err != nil {
			return err
		}

		// If md file doesn't start with number, must be dir file
		md_contents = prepareMarkDown(md_contents, !regexp.MustCompile(`^\d`).MatchString(path))

		// Convert markdown to html, specifying if is dir file (a file that is a directory for a subject, must not start with a number)
		html_contents := convertMarkdownToHTML(md_contents)

		// Convert markdown file path to html file path
		html_path := convertMarkdownPathToHTMLPath(path)

		// Ensure necessary directories exist
		err = os.MkdirAll(filepath.Dir(html_path), 0700)
		if err != nil {
			return err
		}

		// Opens HTML file to write only
		file_r, err := os.OpenFile(html_path, os.O_CREATE|os.O_WRONLY, 0600)
		if err != nil {
			return err
		}

		// Delays the closing of the file until the end of the program
		defer file_r.Close()

		page_structure := PageData{
			Title:    strings.TrimSuffix(filepath.Base(html_path), filepath.Ext(html_path)),
			Contents: string(html_contents),
		}

		tmpl, err := template.ParseFiles(filepath.FromSlash(base_template_file))
		if err != nil {
			return err
		}

		template_output := &strings.Builder{}

		// Write completed template
		err = tmpl.ExecuteTemplate(template_output, "base", page_structure)
		if err != nil {
			return err
		}

		// Clean up html file and write to file
		file_r.Write(gohtml.FormatBytes([]byte(template_output.String())))
		file_r.Close()
	}

	return nil
}

func main() {
	// For local development: removes any pre-existing html files
	os.RemoveAll(filepath.FromSlash(gen_html_dir_rel_path))

	// For each .md file, generate a .html file for it
	err := filepath.WalkDir(filepath.FromSlash(md_dir_rel_path), generateWebStructure)
	if err != nil {
		logrus.Error(err)
	}

	router := mux.NewRouter()

	// Create handler to serve all public files (css, js, etc.)
	router.PathPrefix(public_route).Handler(http.StripPrefix(public_route, http.FileServer(http.Dir(filepath.FromSlash(public_dir_rel_path)))))
	// Create handler to serve all assets (images, logos, etc.)
	router.PathPrefix(assets_route).Handler(http.StripPrefix(assets_route, http.FileServer(http.Dir(filepath.FromSlash(assets_dir_rel_path)))))

	// Serve all html files in route without the user needing to specify file extension in the route
	html_handler := http.HandlerFunc(
		func(w http.ResponseWriter, r *http.Request) {
			file_path := filepath.Join(filepath.FromSlash(gen_html_dir_rel_path), r.URL.Path) + web_file_ext

			// Special case: serve index.html in route /
			if r.URL.Path == "/" {
				file_path := filepath.Join(filepath.Join(filepath.FromSlash(gen_html_dir_rel_path), "home")) + web_file_ext
				if _, err := os.Stat(file_path); err == nil {
					http.ServeFile(w, r, file_path)
					return
				}
			}

			if _, err := os.Stat(file_path); err == nil {
				http.ServeFile(w, r, file_path)
				return
			}

			// Handle case where no file is found
			http.NotFound(w, r)
		})

	// Serve all html files in routes under "/"
	router.PathPrefix("/").Handler(html_handler)

	port := getEnv("PORT", port)

	logrus.Printf("Started web server on localhost:%v", port)

	// Serve content!
	srv := &http.Server{
		Handler:     router,
		Addr:        ":" + port,
		ReadTimeout: 15 * time.Second,
	}

	logrus.Fatal(srv.ListenAndServe())
}
