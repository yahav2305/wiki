package main

import (
	"bytes"
	"os"
	"path/filepath"
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

func TestConvertMarkdownToHTML(t *testing.T) {
	md_path := filepath.Join("..", "test", "TestConvertMarkdownToHTML", "markdown", "test-file.md")
	html_path := filepath.Join("..", "test", "TestConvertMarkdownToHTML", "html", "test-file.html")

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

// TODO: Add test for prepareMarkDown
func TestPrepareMarkDown(t *testing.T) {
	md_dir_before_path := filepath.Join("..", "test", "TestPrepareMarkDown", "dir", "before.md")
	md_dir_after_path := filepath.Join("..", "test", "TestPrepareMarkDown", "dir", "after.md")

	md_not_dir_before_path := filepath.Join("..", "test", "TestPrepareMarkDown", "notDir", "before.md")
	md_not_dir_after_path := filepath.Join("..", "test", "TestPrepareMarkDown", "notDir", "after.md")

	// Read markdown dir file that is going to be compared
	md_dir_before, err := os.ReadFile(md_dir_before_path)
	if err != nil {
		t.Errorf("Error opening file %v", md_dir_before_path)
	}

	// Read markdown dir file that is the expected output
	md_dir_expected, err := os.ReadFile(md_dir_after_path)
	if err != nil {
		t.Errorf("Error opening file %v", md_dir_after_path)
	}

	// Read markdown file that is going to be compared
	md_not_dir_before, err := os.ReadFile(md_not_dir_before_path)
	if err != nil {
		t.Errorf("Error opening file %v", md_not_dir_before_path)
	}

	// Read markdown file that is the expected output
	md_not_dir_expected, err := os.ReadFile(md_not_dir_after_path)
	if err != nil {
		t.Errorf("Error opening file %v", md_not_dir_after_path)
	}

	dir_result := prepareMarkDown(md_dir_before, true)
	not_dir_result := prepareMarkDown(md_not_dir_before, false)

	if !bytes.Equal(dir_result, md_dir_expected) && !bytes.Equal(not_dir_result, md_not_dir_expected) {
		t.Errorf("File %v and %v don't match, and files %v and %v don't match", md_dir_before_path, md_dir_after_path, md_not_dir_before_path, md_not_dir_after_path)
	} else if !bytes.Equal(dir_result, md_dir_expected) {
		t.Errorf("File %v and %v don't match", md_dir_before_path, md_dir_after_path)
	} else if !bytes.Equal(not_dir_result, md_not_dir_expected) {
		t.Errorf("File %v and %v don't match", md_not_dir_before_path, md_not_dir_after_path)
	}
}
