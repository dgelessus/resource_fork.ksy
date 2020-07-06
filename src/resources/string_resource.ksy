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
  - id: tail
    size-eos: true
    doc: |
      Excess data after the end of the actual string.
      
      In some cases,
      string resources contain more data than the length byte indicates.
      This extra "tail" data is not part of the string and is generally ignored.
      In most cases it consists of all zero bytes.
      
      The purpose of this extra data is usually to preallocate space in the resource file,
      so that in the future the string can be easily replaced with a longer value without having to resize the resource data.
      Resizing a resource may require reorganizing/"compacting" the resource file,
      which is slower than overwriting already allocated data,
      and in the worst case could even fail if there is no more space left on the disk.
