; inherits: html_tags

; Inject CSS into style blocks
((style_element
  (start_tag)
  (raw_text) @injection.content)
  (#set! injection.language "css"))

((style_element
  (start_tag
    (attribute
      (attribute_name) @_attr
      (quoted_attribute_value
        (attribute_value) @_lang)))
  (raw_text) @injection.content)
  (#eq? @_attr "lang")
  (#any-of? @_lang "scss" "postcss" "less")
  (#set! injection.language "scss"))

; Inject JavaScript into script blocks without lang attribute
((script_element
  (start_tag)
  (raw_text) @injection.content)
  (#set! injection.language "javascript"))

; Inject TypeScript into script blocks with lang="ts"
((script_element
  (start_tag
    (attribute
      (attribute_name) @_attr
      (quoted_attribute_value
        (attribute_value) @_lang)))
  (raw_text) @injection.content)
  (#eq? @_attr "lang")
  (#any-of? @_lang "ts" "typescript")
  (#set! injection.language "typescript"))

; Inject JavaScript into Svelte expressions
((svelte_raw_text) @injection.content
  (#set! injection.language "javascript"))

; Inject JavaScript into attribute values with expressions
((attribute_value) @injection.content
  (#set! injection.language "javascript"))
