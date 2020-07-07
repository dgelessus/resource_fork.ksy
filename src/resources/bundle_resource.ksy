meta:
  id: bundle_resource
  title: Bundle resource ('BNDL')
  application: Mac OS
  license: MIT
  ks-version: "0.9"
  endian: be
doc: |
  A bundle resource.
  Bundles are used to store some metadata about applications,
  most notably their signature (creator code)
  and associations of file type codes with icons
  (stored as a list of `'ICN#'` and `'FREF'` resource IDs).
  
  The structure of bundle resources is very general:
  it allows storing mappings between "local IDs" and real resource IDs for an arbitrary number of resource types.
  This indirection allows changing the real IDs of resources without having to update all other resources that reference them -
  as long as only the local IDs are used to reference resources listed in the bundle,
  only the bundle needs to be updated when the resources' real IDs change.
  
  This mechanism is used by the Finder to resolve resource ID conflicts when copying bundles and the resources referenced by them into the Desktop file.
  According to older versions of Inside Macintosh (such as the three-volume version),
  it was originally planned to use the same mechanism for more purposes as well,
  but this was never implemented.
  In newer Inside Macintosh versions,
  the bundle resource is only documented in the specific form used by the Finder,
  i. e. containing only the two resource types `'ICN#'` and `'FREF'`,
  and the generic structure is no longer explained.
doc-ref:
  - 'Inside Macintosh, Volume I, The Finder Interface, Finder-Related Resources'
  - '<CarbonCore/Finder.r>'
seq:
  - id: application_signature
    size: 4
    doc: |
      The signature (creator code) of the application to which this bundle belongs.
      
      For bundles stored in an application's resource fork,
      this should always be the application file's creator code.
  - id: version_string_resource_id
    type: s2
    doc: |
      The resource ID of the application's version string resource.
      The type code of the version string resource is *not* `'STR '`,
      but the application's signature (creator code) stored in the previous field.
      The format of the version string resource is otherwise identical to regular `'STR '` resources.
      
      By convention,
      this ID should be 0.
  - id: num_resource_types_m1
    # Yes, despite being a count field, this is a signed integer (according to <CarbonCore/Finder.r>).
    type: s2
    doc: |
      The number of resource types in this bundle,
      minus one.
  - id: resource_types
    type: bundle_resource_type
    repeat: expr
    repeat-expr: num_resource_types
    doc: |
      The resource types and associated resource ID mappings.
      
      This array should always contain exactly two elements,
      where the first one has type code `'ICN#'`
      and the second one has type code `'FREF'`.
      The local IDs assigned to the `'ICN#'` resources are used in the `'FREF'` resources listed in the same bundle.
      The local IDs assigned to the `'FREF'` resources are never used for anything -
      it is only important that the needed `'FREF'`s are listed in the bundle at all,
      not what their local IDs are.
types:
  bundle_resource_type:
    seq:
      - id: type
        size: 4
        doc: The resource type to which the following mappings belong.
      - id: num_resource_id_mappings_m1
        # Yes, despite being a count field, this is a signed integer (according to <CarbonCore/Finder.r>).
        type: s2
        doc: |
          The number of resource ID mappings for this resource type,
          minus one.
      - id: resource_id_mappings
        type: bundle_resource_id_mapping
        repeat: expr
        repeat-expr: num_resource_id_mappings
        doc: The resource ID mappings for this resource type.
    instances:
      num_resource_id_mappings:
        value: num_resource_id_mappings_m1 + 1
        doc: The number of resource ID mappings for this resource type.
    types:
      bundle_resource_id_mapping:
        seq:
          - id: local_id
            type: s2
            doc: The resource's local ID in this bundle.
          - id: resource_id
            type: s2
            doc: The resource's actual ID in the resource file.
        doc: |
          A single resource ID mapping,
          as stored in a bundle resource type.
    doc: |
      A single resource type and associated list of resource ID mappings,
      as stored in a bundle.
instances:
  num_resource_types:
    value: num_resource_types_m1 + 1
    doc: The number of resource types in this bundle.
