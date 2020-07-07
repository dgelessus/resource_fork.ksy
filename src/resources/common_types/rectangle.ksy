meta:
  id: rectangle
  title: QuickDraw rectangle
  application: Mac OS QuickDraw
  license: MIT
  ks-version: "0.8"
  imports:
    - point
  endian: be
doc: |
  A QuickDraw rectangle.
  This is a pair of QuickDraw points representing the top-left and bottom-right corners of the rectangle.
  
  This is equivalent to the Rez `rect` type.
doc-ref: 'Inside Macintosh, Volume I, About QuickDraw, The Mathematical Foundation of QuickDraw'
seq:
  - id: top_left
    -orig-id: topLeft
    type: point
    doc: The top-left corner of the rectangle.
  - id: bottom_right
    -orig-id: bottomRight
    type: point
    doc: The bottom-right corner of the rectangle.
instances:
  top:
    value: top_left.y
    doc: The Y position of the rectangle's top edge.
  left:
    value: top_left.x
    doc: The X position of the rectangle's left edge.
  bottom:
    value: bottom_right.y
    doc: The Y position of the rectangle's bottom edge.
  right:
    value: bottom_right.x
    doc: The X position of the rectangle's right edge.
