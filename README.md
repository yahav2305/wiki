# wiki

## How to format pages?
In order for hugo to play nicely with markdown pages, some rules need to be kept in mind.

### Subject
- Each subject must be in each own folder.
- The subject folder can be either lowercase or uppercase, but when accessing it the subject folder name will be converted to lowercase.
- Each subject will have one `_index.md` file with links to the rest of the files in the subject folder. Each link will contain the name of the file in lowercase with dashes between words as the url (e.g. `1. [What is Kubernetes](1-what-is-kubernetes)`).

### Article
- Each article name will be in lowercase with dashes between words and end in `.md`.
- Each article must start with the front matter:
    ```
    ---
    title: <title>
    draft: <true|false>
    ---
    ```
    Where title is the name of the file in capital case with spaces between words instead of dashes, and draft can be `true` or `false` depending on if the article should be displayed in the website.
- After the front matter, each article must have a table of content and then the article content itself.