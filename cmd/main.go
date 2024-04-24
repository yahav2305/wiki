package main

import (
	"io/fs"
	"os"
	"path/filepath"
	"strings"

	"github.com/gomarkdown/markdown"
	"github.com/gomarkdown/markdown/html"
	"github.com/gomarkdown/markdown/parser"
)

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

		// create markdown parser with extensions
		extensions := parser.CommonExtensions | parser.AutoHeadingIDs | parser.NoEmptyLineBeforeBlock
		parser := parser.NewWithExtensions(extensions)
		doc := parser.Parse(md_contents)

		// create HTML renderer with extensions
		htmlFlags := html.CommonFlags | html.HrefTargetBlank
		opts := html.RendererOptions{Flags: htmlFlags}
		renderer := html.NewRenderer(opts)

		// Convert markdown to HTML
		html_contents := markdown.Render(doc, renderer)

		// Create new file path for HTML file
		html_path := strings.TrimSuffix(path, filepath.Ext(path)) + ".html"

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
	filepath.WalkDir("../documentations and explanations/Prod", generateHTML)

	// Create handler to display each .html file

	// Serve content!
}
