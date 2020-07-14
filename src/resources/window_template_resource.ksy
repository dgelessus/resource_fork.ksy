meta:
  id: window_template_resource
  title: Window template ('WIND') resource
  application: Mac OS
  license: MIT
  ks-version: "0.9"
  imports:
    - common_types/macintosh_boolean
    - common_types/pascal_string
    - common_types/rectangle
  endian: be
doc: |
  A Mac OS window template,
  used to initialize some properties of newly created windows.
  
  These resources are read by the Toolbox Window Manager `GetNewWindow` and `GetNewCWindow` functions.
doc-ref:
  - 'Inside Macintosh, Volume I, The Window Manager, Formats of Resources for Windows'
  - 'Inside Macintosh, Macintosh Toolbox Essentials, Window Manager, Window Manager Reference'
  - '<HIToolbox/MacWindows.r>'
  - "ResEdit 'WIND' template"
  - 'http://preserve.mactech.com/macintosh-c/classic-chap04-1.html'
seq:
  - id: bounds
    -orig-id: boundsRect
    type: rectangle
    doc: The initial location and size of the window on screen.
  - id: definition_id
    -orig-id: procID
    type: definition_id
    size: sizeof<definition_id> # Force creation of substream
    doc: |
      The window definition to be used.
  - id: window_visible
    -orig-id: visible
    type: macintosh_boolean
    doc: Whether the window is initially visible.
  - id: close_button_visible
    -orig-id: goAwayFlag
    type: macintosh_boolean
    doc: |
      Whether the window's close button is initially visible.
      
      Older documentation calls the close button the "go-away region".
  - id: reference_constant
    -orig-id: refCon
    type: u4
    doc: |
      An arbitrary value for free use by applications.
      It is ignored by the system.
  - id: title
    -orig-id: title
    type: pascal_string
    doc: The initial window title.
  - id: align
    type: u1
    if: not _io.eof and _io.pos % 2 != 0
    doc: Ensures that the following field is 2-byte-aligned.
  - id: position_override
    type: u2
    enum: position_override
    if: not _io.eof
    doc: |
      Controls the location and size of the window when it is created.
      This field is only understood since System 7.0.
      If present,
      this field takes precedence over the explicit location and size in the `bounds` field.
enums:
  position_override:
    0x0000:
      id: use_bounds
      -orig-id: noAutoCenter
      doc: Use the explicit location and size from the `bounds` field.
    0x280a:
      id: center_main_screen
      -orig-id: centerMainScreen
      doc: Place centered on the main screen.
    0x300a:
      id: alert_position_main_screen
      -orig-id: alertPositionMainScreen
      doc: Place in alert position on the main screen.
    0x380a:
      id: stagger_main_screen
      -orig-id: staggerMainScreen
      doc: Place staggered on the main screen.
    0xa80a:
      id: center_parent_window
      -orig-id: centerParentWindow
      doc: Place centered relative to parent window.
    0xb00a:
      id: alert_position_parent_window
      -orig-id: alertPositionParentWindow
      doc: Place in alert position relative to parent window.
    0xb80a:
      id: stagger_parent_window
      -orig-id: staggerParentWindow
      doc: Place staggered relative to parent window.
    0x680a:
      id: center_parent_window_screen
      -orig-id: centerParentWindowScreen
      doc: Place centered on the screen with the parent window.
    0x700a:
      id: alert_position_parent_window_screen
      -orig-id: alertPositionParentWindowScreen
      doc: Place in alert position on the screen with the parent window.
    0x780a:
      id: stagger_parent_window_screen
      -orig-id: staggerParentWindowScreen
      doc: Place staggered on the screen with the parent window.
types:
  definition_id:
    seq:
      - id: procedure_resource_id
        type: b12
        doc: |
          The resource ID of the window definition procedure (`'WDEF'`) to use.
          IDs `0 <= x <= 127` are reserved by Apple,
          the remaining IDs `128 <= x <= 4095` are available for use by applications.
      - id: variation_code
        type: b4
        doc: |
          The variation code passed to the window definition procedure.
    instances:
      as_int:
        pos: 0
        type: u2
        doc: |
          The definition ID as a packed 16-bit unsigned integer.
          This format is commonly used in documentation, uncompiled resources, ResEdit, etc.
