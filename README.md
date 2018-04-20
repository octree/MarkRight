# MarkRight



A simple Markdown Parser written in `swift`, Powered by [ParserCombinator](https://github.com/octree/ParserCombinator)



## Ugly Demo



![Demo](./Shots/demo1.png)



![Demo](./Shots/demo2.png)

## Supported grammars

* Preliminaries
  - [x] Characters and lines
  - [x] Tabs
  - [x] Insecure characters
* Blocks and inlines
  - [x] Precedence
  - [x] Container blocks and leaf blocks
* Leaf blocks
  - [x] Thematic breaks
  - [x] ATX headings
  - [ ] Setext headings
  - [x] Indented code blocks
  - [x] Fenced code blocks
  - [ ] HTML blocks
  - [ ] Link reference definitions
  - [x] Paragraphs
  - [x] Blank lines
  - [x] Tables (extension)
* Container blocks
  - [x] Block quotes
  - [x] List items
  - [x] Task list items (extension)
  - [x] Lists
* Inlines
  - [x] Backslash escapes
  - [x] Entity and numeric character references
  - [x] Code spans
  - [x] Emphasis and strong emphasis
  - [ ] Strikethrough (extension)
  - [x] Links
  - [x] Images
  - [ ] Autolinks
  - [ ] Autolinks (extension)
  - [ ] Raw HTML
  - [x] Disallowed Raw HTML (extension)
  - [x] Hard line breaks
  - [x] Soft line breaks
  - [x] Textual content
