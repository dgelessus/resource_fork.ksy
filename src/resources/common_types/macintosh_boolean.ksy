meta:
  id: macintosh_boolean
  title: Macintosh padded 2-byte boolean
  application: Mac OS
  license: MIT
  ks-version: "0.8"
doc: |
  A "2-byte boolean" as found in some Macintosh data structures
  (both in memory and on disk in resources).
  
  The actual boolean value is stored in the first byte's lowest bit.
  All other bits are ignored.
  This unusual format comes from a combination of the Macintosh boolean format
  (which is 1 byte large but only uses the lowest bit)
  and the 68k requirement to keep the stack 2-byte-aligned
  (which makes it necessary to add a second unused byte for alignment).
doc-ref: 'Inside Macintosh, Volume I, Using Assembly Language, Calling Conventions'
seq:
  - id: ignored
    type: b7
    valid: 0
    doc: |
      The high bits of the byte in which the boolean value is stored.
      These bits are ignored and should be all zero.
  - id: value
    type: b1
    doc: The actual boolean value.
  - id: padding
    type: u1
    valid: 0
    doc: |
      Padding byte after the byte containing the boolean,
      to ensure 2-byte alignment,
      as required on the 68k's stack.
      This byte is ignored and should be zero.
