meta:
  id: file_reference_resource
  title: File reference resource ('FREF')
  application: Mac OS
  license: MIT
  ks-version: "0.9"
  imports:
    - common_types/pascal_string
  endian: be
doc: |
  A file reference resource.
  The name is misleading -
  file references do not refer to files on the file system.
  They are used in combination with a bundle (`'BNDL'`) resource to associate icons with file types.
doc-ref:
  - 'Inside Macintosh, Volume I, The Finder Interface, Finder-Related Resources'
  - '<CarbonCore/Finder.r>'
seq:
  - id: file_type
    size: 4
    doc: The type code for the file type described by this file reference.
  - id: icon_local_id
    type: s2
    doc: |
      The "local ID" of the icon that should be displayed for files of this type.
      
      Local IDs are mapped to actual resource IDs by the bundle (`'BNDL'`) resource that references this resource.
      This indirection is used by the Finder to resolve resource ID conflicts
      when copying an aapplication's bundle (and related resources) into the Desktop file.
  - id: file_name
    type: pascal_string
    doc: |
      This field is optional and can be set to an empty string if not used.
      In practice it is nearly always an empty string.
      
      According to the Inside Macintosh Promotional Edition,
      this field can store the name of a file that should be automatically copied if the application is copied to a different volume.
      The three-volume release version of Inside Macintosh no longer describes this feature and (incorrectly) omits this field from the resource format description.
      The new "split" version of Inside Macintosh documents this field again,
      but says that it should always be an empty string.
