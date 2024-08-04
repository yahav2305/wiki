# How to format pages?
In order for hugo to play nicely with markdown pages, some rules need to be kept in mind.

## Subject
- Each subject must be in each own folder.
- The subject folder can be either lowercase or uppercase, but when accessing it the subject folder name will be converted to lowercase.
- Each subject will have one `_index.md` file with the following front matter:
  ```yaml
  ---
  title: '<SubjectName>'
  draft: false
  ---
  ```
  where **SubjectName** is the name of the subject in capital case.

## Article
- Each article name will be in lowercase with dashes between words and end in `.md`.
- Each article must start with the front matter:
  ```yaml
  ---
  title: '<title>'
  draft: <true|false>
  weight: <weightNum>
  series: ["<seriesName>"]
  series_order: <seriesOrder>
  ---
  ```
  - **title** is the name of the file in capital case with spaces between words instead of dashes.
  - **draft** can be `true` or `false` depending on if the article should be displayed in the website.
  - **weight** is the order of the article. This will alter the place of the article in the subject list page.
  - **seriesName** is the name of the series in capital case, which is the name of the subject. This must be the same between all articles in the same subject, and must not be used in articles outside of the subject.
  - **seriesOrder** is the place of the article in the series. 1 means that the article will be first, 2 is second, etc.
- After the front matter, each article must have the article content itself.