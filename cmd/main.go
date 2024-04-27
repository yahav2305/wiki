package main

import (
	"io/fs"
	"net/http"
	"os"
	"path/filepath"
	"slices"
	"strings"
	"time"

	"github.com/gomarkdown/markdown"
	"github.com/gomarkdown/markdown/html"
	"github.com/gomarkdown/markdown/parser"
	"github.com/gorilla/mux"
	"github.com/sirupsen/logrus"
	"github.com/yosssi/gohtml"
)

// Gets path to markdown file, returns converted path to html file
func convertMarkdownPathToHTMLPath(markdown_path string) string {
	markdown_path_slice := strings.Split(markdown_path, string(os.PathSeparator))
	markdown_path_slice[1] = "web"
	markdown_path_slice[2] = "app"
	markdown_path_replaced_dir := filepath.Join(markdown_path_slice...)
	return strings.TrimSuffix(markdown_path_replaced_dir, filepath.Ext(markdown_path_replaced_dir)) + ".html"
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

	// Read prepend html file
	prepend_contents, err := os.ReadFile(filepath.Join("..", "web", "template", "prepend.html"))
	if err != nil {
		logrus.Fatal(err)
	}

	// Read append html file
	append_contents, err := os.ReadFile(filepath.Join("..", "web", "template", "append.html"))
	if err != nil {
		logrus.Fatal(err)
	}

	full_html_page_contents := slices.Concat(prepend_contents, html_bytes, append_contents)

	// HTML may be malformed due to header, main and footer not matching exactly. Format it.
	return gohtml.FormatBytes(full_html_page_contents)
}

func generateWebStructure(path string, d fs.DirEntry, err error) error {
	if err != nil {
		return err
	}

	if !d.IsDir() && filepath.Ext(path) == ".md" {
		// Read markdown file
		md_contents, err := os.ReadFile(path)
		if err != nil {
			return err
		}

		// Convert markdown to html
		html_contents := convertMarkdownToHTML(md_contents)

		// Convert markdown file path to html file path
		html_path := convertMarkdownPathToHTMLPath(path)

		// Ensure necessary directories exist
		err = os.MkdirAll(filepath.Dir(html_path), 0700)
		if err != nil {
			return err
		}

		// Write HTML to file
		file, err := os.OpenFile(html_path, os.O_CREATE|os.O_WRONLY, 0600)
		if err != nil {
			return err
		}

		// Delays the closing of the file until the end of the program
		defer file.Close()

		_, err = file.Write(html_contents)
		if err != nil {
			return err
		}

	}

	return nil
}

func main() {
	// For local development: removes any pre-existing html files
	os.RemoveAll(filepath.Join("..", "web", "app"))

	// For each .md file, generate a .html file for it
	err := filepath.WalkDir(filepath.Join("..", "docs", "Prod"), generateWebStructure)
	if err != nil {
		logrus.Error(err)
	}

	router := mux.NewRouter()

	// Create handler to serve all public files (css, js, etc.)
	router.PathPrefix("/public/").Handler(http.StripPrefix("/public/", http.FileServer(http.Dir(filepath.Join("..", "public")))))
	// Create handler to serve all assets (images, logos, etc.)
	router.PathPrefix("/assets/").Handler(http.StripPrefix("/assets/", http.FileServer(http.Dir(filepath.Join("..", "assets")))))
	// Create handler to serve all .html files (must be last to allow routes to access above directories)
	router.PathPrefix("/").Handler(http.FileServer(http.Dir(filepath.Join("..", "web", "app", "/"))))

	// Serve content!
	srv := &http.Server{
		Handler:     router,
		Addr:        "127.0.0.1:5500",
		ReadTimeout: 15 * time.Second,
	}
	logrus.Fatal(srv.ListenAndServe())
}
