meta:
  id: string_list_resource
  title: String list resource ('STR#')
  license: MIT
  ks-version: "0.9"
  imports:
    - common_types/pascal_string
  endian: be
doc: |
  A string list resource.
doc-ref:
  - 'Inside Macintosh, Volume I, Toolbox Utilities, Formats of Miscellaneous Resources'
  - '<CarbonCore/MacTypes.r>'
seq:
  - id: num_strings
    type: u2
    doc: The number of strings in the list.
  - id: strings
    type: pascal_string
    repeat: expr
    repeat-expr: num_strings
    doc: The string values.
