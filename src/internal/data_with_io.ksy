meta:
  id: data_with_io
  title: Byte array with an `_io` member (internal helper type)
  license: MIT
  ks-version: "0.8"
doc: |
  Internal helper type to work around Kaitai Struct not providing an `_io` member for plain byte arrays.
  
  This type (and fields of this type) should only be used in KSY code.
  External code should not use any attributes of this type directly,
  not even `data` -
  see the documentation of the `data` attribute for details.
seq:
  - id: data
    size-eos: true
    doc: |
      The actual data.
      
      This attribute should not be used directly.
      Instead,
      all types that use `data_with_io` should provide value instances that expose the `data` field as a top-level member of the parent type.
      For example,
      if a type has a field of type `data_with_io` called `some_field_internal`,
      it should also provide a value instance called `some_field` with `value: some_field_internal.data`.
      External code should then only use `some_field`,
      and not `some_field_internal`.
