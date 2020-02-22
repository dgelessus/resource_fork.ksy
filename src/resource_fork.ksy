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
  resource_data:
    pos: header.ofs_resource_data
    size: header.len_resource_data
    doc: Storage area for the contents of all resources.
  resource_map:
    pos: header.ofs_resource_map
    type: resource_map
    size: header.len_resource_map
    doc: The resource file's resource map.
types:
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
      resource_names:
        pos: ofs_resource_names
        size-eos: true
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
                doc: |
                  A single entry in the resource type list.
                  
                  Each entry corresponds to exactly one resource reference list.
            doc: Resource type list in the resource map.
        doc: |
          Resource type list and storage area for resource reference lists in the resource map.
          
          The two parts are combined into a single type here for technical reasons:
          the start of the resource reference list area is not stored explicitly in the file,
          instead it always starts directly after the resource type list.
          The simplest way to implement this is by placing both types into a single `seq`.
    doc: |
      Resource map,
      containing information about the resources in the file and where they are located in the data area.
