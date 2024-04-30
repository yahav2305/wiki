package main

import (
	"testing"
)

func TestConvertMarkdownPathToHTMLPath(t *testing.T) {
	md_path := "../docs/Prod/index.md"
	expected := "../web/app/index.html"
	result := convertMarkdownPathToHTMLPath(md_path)

	if result != expected {
		t.Errorf("Want: %v, Result: %v", expected, result)
	}

}

/*
func TestConvertMarkdownToHTML(t *testing.T) {
	md_path := filepath.Join("..", "test", "markdown", "test-file.md")
	html_path := filepath.Join("..", "test", "html", "test-file.html")

	// Read markdown file
	md_contents, err := os.ReadFile(md_path)
	if err != nil {
		t.Errorf("Error opening file %v", md_path)
	}

	// Read html file
	expected, err := os.ReadFile(html_path)
	if err != nil {
		t.Errorf("Error opening file %v", html_path)
	}

	result := convertMarkdownToHTML(md_contents)

	if !bytes.Equal(result, expected) {
		t.Errorf("Generated html doesn't match expected html")
	}
}
*/
