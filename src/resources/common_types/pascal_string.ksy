meta:
  id: pascal_string
  title: Pascal string (1-byte length)
  xref:
    justsolve: 'Character_encoding#Pascal'
    wikidata: Q184754
  license: MIT
  ks-version: "0.8"
doc: |
  A Pascal string,
  i. e. a 1-byte length followed by a sequence of bytes.
  
  This is equivalent to the Rez `pstring` type.
seq:
  - id: len_contents
    type: u1
    doc: The number of bytes in the string.
  - id: contents
    size: len_contents
    doc: |
      The contents of the string.
  
      This field is exposed as a byte array,
      because there is no universal encoding for strings on Classic Mac OS.
      Most Classic Mac software does not deal with encodings explicitly
      and instead assumes that all strings use the system encoding,
      which varies depending on the system language.
      
      All Mac OS encodings are ASCII-compatible.
