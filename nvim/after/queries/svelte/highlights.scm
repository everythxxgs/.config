; inherits: html_tags

; HTML tag names
(tag_name) @tag

; HTML attributes
(attribute_name) @tag.attribute

; Attribute values
((attribute
  (quoted_attribute_value) @string)
  (#set! priority 99))

; HTML tag delimiters
[
  "<"
  ">"
  "</"
  "/>"
] @tag.delimiter

"=" @operator

; Comments
(comment) @comment @spell

; Text content
(text) @none @spell

; Svelte-specific keywords
[
  "as"
  "key"
  "html"
  "snippet"
  "render"
] @keyword

"const" @keyword.modifier

[
  "if"
  "else if"
  "else"
  "then"
] @keyword.conditional

"each" @keyword.repeat

[
  "await"
  "then"
] @keyword.coroutine

"catch" @keyword.exception

"debug" @keyword.debug

; Svelte expression brackets
[
  "{"
  "}"
] @punctuation.bracket

; Svelte special characters
[
  "#"
  ":"
  "/"
  "@"
] @tag.delimiter
