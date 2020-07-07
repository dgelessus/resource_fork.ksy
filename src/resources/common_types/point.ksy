meta:
  id: point
  title: QuickDraw point
  application: Mac OS QuickDraw
  license: MIT
  ks-version: "0.8"
  endian: be
doc: |
  A QuickDraw point.
  This is a pair of 16-bit signed integer coordinates,
  representing a point in a 2D coordinate plane.
  
  This is equivalent to the Rez `point` type.
doc-ref: 'Inside Macintosh, Volume I, About QuickDraw, The Mathematical Foundation of QuickDraw'
seq:
  - id: y
    -orig-id: v
    type: s2
    doc: The point's Y coordinate (vertical position).
  - id: x
    -orig-id: h
    type: s2
    doc: The point's X coordinate (horizontal position).
