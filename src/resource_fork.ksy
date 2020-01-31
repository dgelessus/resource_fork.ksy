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
