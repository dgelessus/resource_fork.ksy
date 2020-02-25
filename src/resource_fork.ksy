meta:
  id: resource_fork
  title: Macintosh resource fork data
  application: Mac OS
  file-extension:
    - rsrc # Resource fork data stored in a separate file (as a data fork)
    - dfont # Datafork font suitcase (a special case of the above, used by certain Mac fonts)
  xref:
    justsolve: Resource_Fork
    wikidata: Q3933446
  license: MIT
  ks-version: "0.9"
  endian: be
doc: |
  The data format of Macintosh resource forks,
  used on Classic Mac OS and Mac OS X/macOS to store additional structured data along with a file's main data (the data fork).
  The kinds of data stored in resource forks include:
  
  * Document resources:
    images, sounds, etc. used by a document
  * Application resources:
    graphics, GUI layouts, localizable strings,
    and even code used by an application, a library, or system files
  * Common metadata:
    custom icons and version metadata that could be displayed by the Finder
  * Application-specific metadata:
    because resource forks follow a common format,
    other applications can store new metadata in them,
    even if the original application does not recognize or understand it
  
  Macintosh file systems (MFS, HFS, HFS+, APFS) support resource forks natively,
  which allows storing resources along with any file.
  Non-Macintosh file systems and protocols have little or no support for resource forks,
  so the resource fork data must be stored in some other way when using such file systems or protocols.
  Various file formats and tools exist for this purpose,
  such as BinHex, MacBinary, AppleSingle, AppleDouble, or QuickTime RezWack.
  In some cases,
  resource forks are stored as plain data in separate files with a .rsrc extension,
  even on Mac systems that natively support resource forks.
  
  On modern Mac OS X/macOS systems,
  resource forks are used far less commonly than on classic Mac OS systems,
  because of compatibility issues with other systems and historical limitations in the format.
  Modern macOS APIs and libraries do not use resource forks,
  and the legacy Carbon API that still used them has been deprecated since OS X 10.8.
  Despite this,
  even current macOS systems still use resource forks for certain purposes,
  such as custom file icons.
doc-ref:
  - 'https://developer.apple.com/library/archive/documentation/mac/pdf/MoreMacintoshToolbox.pdf#page=151'
  - 'http://www.pagetable.com/?p=50'
  - 'https://github.com/kreativekorp/ksfl/wiki/Macintosh-Resource-File-Format'
  - 'https://github.com/dgelessus/mac_file_format_docs/blob/master/README.md#resource-forks'
seq:
  - id: header
    type: resource_file_header
    doc: The resource file's header information.
  - id: system_data
    size: 112
    doc: |
      System-reserved data area.
      This field can generally be ignored when reading and writing.
      
      This field is used by the Classic Mac OS Finder as temporary storage space.
      It usually contains parts of the file metadata (name, type/creator code, etc.).
      Any existing data in this field is ignored and overwritten.
      
      In resource files written by Mac OS X,
      this field is set to all zero bytes.
  - id: application_data
    size: 128
    doc: |
      Application-specific data area.
      This field can generally be ignored when reading and writing.
      
      According to early revisions of Inside Macintosh,
      this field is "available for application data".
      In practice, it is almost never used for this purpose,
      and usually contains only junk data.
      
      In resource files written by Mac OS X,
      this field is set to all zero bytes.
instances:
  resource_data_with_io:
    pos: header.ofs_resource_data
    type: data_with_io
    size: header.len_resource_data
    doc: |
      Internal helper instance,
      do not use,
      use `resource_data` instead.
  resource_data:
    value: resource_data_with_io.data
    doc: |
      Storage area for the data blocks of all resources.
      
      These data blocks are not required to appear in any particular order,
      and there may be unused space between and around them.
      
      In practice,
      the data blocks in newly created resource files are usually contiguous.
      When existing resources are shortened,
      the Mac OS resource manager leaves unused space where the now removed resource data was,
      as this is quicker than moving the following resource data into the newly freed space.
      Such unused space may be cleaned up later when the resource manager "compacts" the resource file,
      which happens when resources are removed entirely,
      or when resources are added or grown so that more space is needed in the data area.
  resource_map:
    pos: header.ofs_resource_map
    type: resource_map
    size: header.len_resource_map
    doc: The resource file's resource map.
types:
  data_with_io:
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
    doc: |
      Internal helper type to work around Kaitai Struct not providing an `_io` member for plain byte arrays.
      
      This type (and fields of this type) should only be used in KSY code.
      External code should not use any attributes of this type directly,
      not even `data` -
      see the documentation of the `data` attribute for details.
  resource_file_header:
    seq:
      - id: ofs_resource_data
        type: u4
        doc: |
          Offset of the resource data area,
          from the start of the resource file.
          
          In practice,
          this should always be `256`,
          i. e. the resource data area should directly follow the application-specific data area.
      - id: ofs_resource_map
        type: u4
        doc: |
          Offset of the resource map,
          from the start of the resource file.
          
          In practice,
          this should always be `ofs_resource_data + len_resource_data`,
          i. e. the resource map should directly follow the resource data area.
      - id: len_resource_data
        type: u4
        doc: |
          Length of the resource data area.
      - id: len_resource_map
        type: u4
        doc: |
          Length of the resource map.
          
          In practice,
          this should always be `_root._io.size - ofs_resource_map`,
          i. e. the resource map should extend to the end of the resource file.
    doc: |
      Resource file header,
      containing the offsets and lengths of the resource data area and resource map.
  resource_data_block:
    seq:
      - id: len_data
        type: u4
        doc: |
          The length of the resource data stored in this block.
      - id: data
        size: len_data
        doc: |
          The data stored in this block.
    doc: |
      A resource data block,
      as stored in the resource data area.
      
      Each data block stores the data contained in a resource,
      along with its length.
  resource_map:
    seq:
      - id: reserved_resource_file_header_copy
        type: resource_file_header
        doc: Reserved space for a copy of the resource file header.
      - id: reserved_next_resource_map_handle
        type: u4
        doc: Reserved space for a handle to the next loaded resource map in memory.
      - id: reserved_file_reference_number
        type: u2
        doc: Reserved space for the resource file's file reference number.
      - id: file_attributes
        type: u2
        doc: The resource file's attributes.
      - id: ofs_resource_type_list
        type: u2
        doc: |
          Offset of the resource type list,
          from the start of the resource map.
          
          In practice,
          this should always be `sizeof<resource_map>`,
          i. e. the resource type list should directly follow the resource map.
      - id: ofs_resource_names
        type: u2
        doc: |
          Offset of the resource name area,
          from the start of the resource map.
    instances:
      resource_type_list_and_reference_lists:
        pos: ofs_resource_type_list
        type: resource_type_list_and_reference_lists
        size: ofs_resource_names - ofs_resource_type_list
        doc: The resource map's resource type list, followed by the resource reference list area.
      resource_names_with_io:
        pos: ofs_resource_names
        type: data_with_io
        size-eos: true
        doc: |
          Internal helper instance,
          do not use,
          use `resource_names` instead.
      resource_names:
        value: resource_names_with_io.data
        doc: Storage area for the names of all resources.
    types:
      resource_type_list_and_reference_lists:
        seq:
          - id: resource_type_list
            type: resource_type_list
            doc: The resource map's resource type list.
          - id: resource_reference_lists
            size-eos: true
            doc: |
              Storage area for the resource map's resource reference lists.
              
              According to Inside Macintosh,
              the reference lists are stored contiguously,
              in the same order as their corresponding resource type list entries.
        types:
          resource_type_list:
            seq:
              - id: num_resource_types_m1
                type: u2
                doc: |
                  The number of resource types in this list,
                  minus one.
                  
                  If the resource list is empty,
                  the value of this field is `0xffff`,
                  i. e. `-1` truncated to a 16-bit unsigned integer.
              - id: entries
                type: resource_type_list_entry
                repeat: expr
                repeat-expr: num_resource_types
                doc: Entries in the resource type list.
            instances:
              num_resource_types:
                # The modulo 0x10000 simulates 16-bit unsigned integer wraparound,
                # so that empty lists are handled correctly (see doc for num_resource_types_m1).
                value: (num_resource_types_m1 + 1) % 0x10000
                doc: The number of resource types in this list.
            types:
              resource_type_list_entry:
                seq:
                  - id: resource_type
                    size: 4
                    doc: The four-character type code of the resources in the reference list.
                  - id: num_resource_references_m1
                    type: u2
                    doc: |
                      The number of resources in the reference list for this type,
                      minus one.
                      
                      Empty reference lists should never exist.
                  - id: ofs_resource_reference_list
                    type: u2
                    doc: |
                      Offset of the resource reference list for this resource type,
                      from the start of the resource type list.
                      
                      Although the offset is relative to the start of the type list,
                      it should never point into the type list itself,
                      but into the reference list storage area that directly follows it.
                      That is,
                      it should always be at least `_parent._sizeof`.
                instances:
                  num_resource_references:
                    # Reference lists should never be empty,
                    # but just in case simulate the wraparound behavior here as well.
                    value: (num_resource_references_m1 + 1) % 0x10000
                    doc: The number of resources in the reference list for this type.
                  resource_reference_list:
                    io: _parent._parent._io
                    pos: ofs_resource_reference_list
                    type: resource_reference_list(num_resource_references)
                    doc: |
                      The resource reference list for this resource type.
                doc: |
                  A single entry in the resource type list.
                  
                  Each entry corresponds to exactly one resource reference list.
            doc: Resource type list in the resource map.
          resource_reference_list:
            params:
              - id: num_resource_references
                type: u2
                doc: |
                  The number of references in this resource reference list.
                  
                  This information needs to be passed in as a parameter,
                  because it is stored in the reference list's type list entry,
                  and not in the reference list itself.
            seq:
              - id: references
                type: resource_reference
                repeat: expr
                repeat-expr: num_resource_references
                doc: The resource references in this reference list.
            types:
              resource_reference:
                seq:
                  - id: resource_id
                    type: s2
                    doc: ID of the resource described by this reference.
                  - id: ofs_resource_name
                    type: u2
                    doc: |
                      Offset of the name for the resource described by this reference,
                      from the start of the resource name area.
                      
                      If the resource has no name,
                      the value of this field is `0xffff`
                      i. e. `-1` truncated to a 16-bit unsigned integer.
                  - id: attributes
                    type: u1
                    doc: Attributes of the resource described by this reference.
                  - id: ofs_data_block
                    type: b24 # 3-byte unsigned integer, packed together with the previous 1-byte field.
                    doc: |
                      Offset of the data block for the resource described by this reference,
                      from the start of the resource data area.
                  - id: reserved_handle
                    type: u4
                    doc: Reserved space for the resource's handle in memory.
                instances:
                  resource_name:
                    io: _root.resource_map.resource_names_with_io._io
                    pos: ofs_resource_name
                    type: resource_name
                    if: ofs_resource_name != 0xffff
                    doc: |
                      The name (if any) of the resource described by this reference.
                  data_block:
                    io: _root.resource_data_with_io._io
                    pos: ofs_data_block
                    type: resource_data_block
                    doc: |
                      The data block containing the data for the resource described by this reference.
                doc: A single resource reference in a resource reference list.
            doc: |
              A resource reference list,
              as stored in the reference list area.
              
              Each reference list has exactly one matching entry in the resource type list,
              and describes all resources of a single type in the file.
        doc: |
          Resource type list and storage area for resource reference lists in the resource map.
          
          The two parts are combined into a single type here for technical reasons:
          the start of the resource reference list area is not stored explicitly in the file,
          instead it always starts directly after the resource type list.
          The simplest way to implement this is by placing both types into a single `seq`.
      resource_name:
        seq:
          - id: len_value
            type: u1
            doc: |
              The length of the resource name, in bytes.
          - id: value
            size: len_value
            doc: |
              The resource name.
              
              This field is exposed as a byte array,
              because there is no universal encoding for resource names.
              Most Classic Mac software does not deal with encodings explicitly and instead assumes that all strings,
              including resource names,
              use the system encoding,
              which varies depending on the system language.
              This means that resource names can use different encodings depending on what system language they were created with.
              
              Many resource names are plain ASCII,
              meaning that the encoding often does not matter
              (because all Mac OS encodings are ASCII-compatible).
              For non-ASCII resource names,
              the most common encoding is perhaps MacRoman
              (used for English and other Western languages),
              but other encodings are also sometimes used,
              especially for software in non-Western languages.
              
              There is no requirement that all names in a single resource file use the same encoding.
              For example,
              localized software may have some (but not all) of its resource names translated.
              For non-Western languages,
              this can lead to some resource names using MacRoman,
              and others using a different encoding.
        doc: |
          A resource name,
          as stored in the resource name storage area in the resource map.
          
          The resource names are not required to appear in any particular order.
          There may be unused space between and around resource names,
          but in practice they are often contiguous.
    doc: |
      Resource map,
      containing information about the resources in the file and where they are located in the data area.
