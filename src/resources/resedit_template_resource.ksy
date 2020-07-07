meta:
  id: resedit_template_resource
  title: ResEdit resource template resource ('TMPL')
  application: ResEdit
  license: MIT
  ks-version: "0.8"
  imports:
    - common_types/pascal_string
doc: |
  A ResEdit resource template,
  which describes the structure of a resource type and how it should be presented to the user in ResEdit.
doc-ref: 'https://developer.apple.com/legacy/mac/library/documentation/mac/pdf/ResEditReference.pdf ResEdit Reference, ResEdit Templates'
seq:
  - id: fields
    type: field
    repeat: eos
    doc: The fields that make up the resource template.
types:
  field:
    seq:
      - id: label
        type: pascal_string
        doc: |
          A human-readable text label for the field,
          which is displayed to the user in ResEdit.
      - id: type
        size: 4
        doc: |
          A four-character code that determines the field's data type and size,
          as well as how it is presented to the user in ResEdit.
          
          The following field type codes are supported by ResEdit.
          All integers are big-endian,
          and all strings are assumed to use the system default encoding.
          
          * `'DBYT'`, `'DWRD'`, `'DLNG'`:
            1-byte, 2-byte, or 4-byte signed integer,
            displayed as decimal.
          * `'HBYT'`, `'HWRD'`, `'HLNG'`:
            1-byte, 2-byte, or 4-byte unsigned integer,
            displayed as hexadecimal.
          * `'AWRD'`, `'ALNG'`:
            Padding bytes for 2-byte or 4-byte alignment.
            Not displayed to the user.
          * `'FBYT'`, `'FWRD'`, `'FLNG'`:
            1-byte, 2-byte, or 4-byte fill,
            set to all zero bytes.
            Not displayed to the user.
          * `'HEXD'`:
            The remainder of the resource data,
            displayed as a hex dump.
            Only allowed as the last field in the template.
          * `'PSTR'`, `'WSTR'`, `'LSTR'`:
            Pascal string (length-prefixed string) with a 1-byte, 2-byte, or 4-byte length field.
          * `'ESTR'`, `'OSTR'`:
            Pascal string (length-prefixed string) with a 1-byte length field,
            with the field's *total* length (including the length byte) padded to an even or odd number of bytes.
            The length byte is *not* adjusted,
            i. e. the trailing padding byte (if any) is not part of the string contents.
          * `'CSTR'`:
            C string (zero-terminated string).
          * `'ECST'`, `'OCST'`:
            C string (zero-terminated string),
            with the field's *total* length (including the terminating zero byte) padded to an even or odd number of bytes using an extra zero byte.
            This does not change the string's length or contents,
            because the padding byte (if any) is added after the terminator.
          * `'BOOL'`:
            Macintosh boolean stored in 2 bytes,
            displayed as a pair of radio buttons labeled True/False.
            The actual boolean value is stored in the first byte's lowest bit.
            The rest of the field (the first byte's high bits and the entire second byte) are ignored.
            This unusual format comes from a combination of the Macintosh boolean format
            (which is 1 byte large but only uses the lowest bit)
            and the 68k requirement to keep the stack 2-byte-aligned
            (which makes it necessary to add a second unused byte for alignment).
          * `'BBIT'`:
            Single bit,
            displayed as a pair of radio buttons labeled 0/1.
            Bits are traversed from high to low.
            This type can only be used in groups of 8,
            so any unused bits in a byte must be declared explicitly.
            Because there is no "fill" version of this type,
            such unused bytes will always be visible to the user.
          * `'TNAM'`:
            Four-character code,
            i. e. a 4-byte string.
          * `'CHAR'`:
            Single character,
            i. e. a 1-byte string.
          * `'H`*nnn*`'` (where *nnn* is a 3-digit hex number):
            *nnn* bytes of data,
            displayed as a hex dump.
          * `'C`*nnn*`'` (where *nnn* is a 3-digit hex number):
            C string (zero-terminated string) stored in *nnn* bytes.
            The terminating zero byte is included in *nnn*,
            i. e. the string contains *nnn*-1 bytes.
          * `'P0`*nn*`'` (where *nn* is a 2-digit hex number):
            Pascal string (length-prefixed string) with a 1-byte length field and a fixed length of *nn* bytes.
            The length field is *not* included in *nn*,
            i. e. the total length of the field is *nn*+1 bytes.
          * `'LSTZ'`:
            Marks the beginning of a list that will be terminated once a zero byte is encountered where the next list item would start.
            The terminating zero byte is consumed.
            The label is displayed before each list item,
            along with a 1-based index.
          * `'ZCNT'`, `'OCNT'`:
            2-byte unsigned integer that will be used as the zero-based or one-based item count of the list started by the next `'LSTC'` field.
            Displayed to the user,
            but cannot be edited directly,
            only by adding or removing items in the corresponding list.
          * `'LSTC'`:
            Marks the beginning of a list that contains as many items as indicated by the last `'ZCNT'` or `'OCNT'` field.
            The label is displayed before each list item,
            along with a 1-based index.
          * `'LSTB'`:
            Marks the beginning of a list that will continue until the end of the resource.
            The label is displayed before each list item,
            along with a 1-based index.
          * `'LSTE'`:
            Marks the end of a list.
            The label should be identical to the corresponding list beginning field.
    doc: A single field in a template.
