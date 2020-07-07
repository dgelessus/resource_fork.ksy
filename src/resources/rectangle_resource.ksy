meta:
  id: rectangle_resource
  title: Rectangle resource ('RECT')
  license: MIT
  ks-version: "0.8"
  imports:
    - common_types/rectangle
  endian: be
doc: |
  A single rectangle stored as a resource.
doc-ref: '<CarbonCore/MacTypes.r>'
seq:
  - id: rectangle
    type: rectangle
    doc: The rectangle stored in the resource.
