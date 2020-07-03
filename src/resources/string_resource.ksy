meta:
  id: string_resource
  title: String resource ('STR ')
  license: MIT
  ks-version: "0.9"
  imports:
    - common_types/pascal_string
doc: |
  A simple string resource.
doc-ref:
  - 'Inside Macintosh, Volume I, Toolbox Utilities, Formats of Miscellaneous Resources'
  - '<CarbonCore/MacTypes.r>'
seq:
  - id: string
    type: pascal_string
    doc: The string value.
