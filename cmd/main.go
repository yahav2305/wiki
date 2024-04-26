package main

import (
	"io/fs"
	"net/http"
	"os"
	"path/filepath"
	"strings"

	"github.com/gomarkdown/markdown"
	"github.com/gomarkdown/markdown/html"
	"github.com/gomarkdown/markdown/parser"
	"github.com/sirupsen/logrus"
)

// Gets path to markdown file, returns converted path to html file
func convertMarkdownPathToHTMLPath(markdown_path string) string {
	markdown_path_slice := strings.Split(markdown_path, string(os.PathSeparator))
	markdown_path_slice[1] = "web"
	markdown_path_slice = append(markdown_path_slice[:2], markdown_path_slice[3:]...)
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
	return markdown.Render(doc, renderer)
}

func generateHTML(path string, d fs.DirEntry, err error) error {
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
	// For each .md file, generate a .html file for it
	err := filepath.WalkDir("../docs/Prod", generateHTML)
	if err != nil {
		logrus.Error(err)
	}

	// Create handler to display each .html file
	http.Handle("/", http.FileServer(http.Dir("/web")))

	// Serve content!
	err = http.ListenAndServe(":5500", nil)
	if err != nil {
		logrus.Error(err)
	}
}
