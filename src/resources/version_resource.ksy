meta:
  id: version_resource
  title: Version resource ('vers')
  application: Mac OS
  license: MIT
  ks-version: "0.9"
  imports:
    - common_types/pascal_string
  endian: be
doc: |
  A version number resource,
  used to store version information on an application or other file.
  
  A version resource with ID 1 specifies the version information for an individual file,
  and one with ID 2 specifies the version information for a group of files that the file belongs to.
  For example,
  for Mac OS system files,
  version resource 1 stores the version of the file itself,
  and version resource 2 stores the version of Mac OS that it was bundled with.
doc-ref:
  - 'Inside Macintosh, Macintosh Toolbox Essentials, Finder Interface'
  - '<CarbonCore/MacTypes.r>'
seq:
  - id: major_digits
    type: b4
    repeat: expr
    repeat-expr: 2
    doc: |
      The two digits of the major version number (the first part of a three-part version number).
      Both digits should be in the range 0 through 9.
  - id: minor
    type: b4
    doc: |
      The minor version number (the second part of a three-part version number).
      Should be in the range 0 through 9.
  - id: patch
    type: b4
    doc: |
      The patch version number (the third part of a three-part version number).
      Should be in the range 0 through 9.
  - id: development_stage
    type: u1
    enum: development_stage
    doc: |
      Indicates the development stage of the file
      (development, alpha, beta, or release).
  - id: prerelease_revision
    type: u1
    doc: |
      A prerelease revision/build number.
      For release versions,
      this value should be 0.
  - id: region
    type: u2
    enum: region
    doc: The region/language for which the file is intended.
  - id: version_number_string
    type: pascal_string
    doc: |
      A string form of the version number.
      This string is used by the Finder to display the version number to the user.
  - id: version_message
    type: pascal_string
    doc: |
      A descriptive message associated with the version information,
      usually containing copyright information or a product name.
      This string is displayed by the Finder in the Get Info window.
enums: 
  development_stage:
    0x20: development
    0x40: alpha
    0x60: beta
    0x80: release # alias final
  region:
    0:
      id: us
      -orig-id: verUS
    1:
      id: france
      -orig-id: verFrance
    2:
      id: britain
      -orig-id: verBritain
    3:
      id: germany
      -orig-id: verGermany
    4:
      id: italy
      -orig-id: verItaly
    5:
      id: netherlands
      -orig-id: verNetherlands
    6:
      id: flemish
      -orig-id: verFlemish # aliases verFrBelgiumLux, verBelgiumLux
    7:
      id: sweden
      -orig-id: verSweden
    8:
      id: spain
      -orig-id: verSpain
    9:
      id: denmark
      -orig-id: verDenmark
    10:
      id: portugal
      -orig-id: verPortugal
    11:
      id: canada_french
      -orig-id: verFrCanada
    12:
      id: norway
      -orig-id: verNorway
    13:
      id: israel
      -orig-id: verIsrael
    14:
      id: japan
      -orig-id: verJapan
    15:
      id: australia
      -orig-id: verAustralia
    16:
      id: arabic
      -orig-id: verArabic # alias verArabia
    17:
      id: finland
      -orig-id: verFinland
    18:
      id: swiss_french
      -orig-id: verFrSwiss
    19:
      id: swiss_german
      -orig-id: verGrSwiss
    20:
      id: greece
      -orig-id: verGreece
    21:
      id: iceland
      -orig-id: verIceland
    22:
      id: malta
      -orig-id: verMalta
    23:
      id: cyprus
      -orig-id: verCyprus
    24:
      id: turkey
      -orig-id: verTurkey
    25:
      id: yugoslavia_croatian
      -orig-id: verYugoCroatian # alias verYugoslavia
    26:
      id: netherlands_comma
      -orig-id: verNetherlandsComma
    27:
      id: flemish_point
      -orig-id: verFlemishPoint # alias verBelgiumLuxPoint
    28:
      id: canada_comma
      -orig-id: verCanadaComma
    29:
      id: canada_point
      -orig-id: verCanadaPoint
    30:
      id: variant_portugal
      -orig-id: vervariantPortugal
    31:
      id: variant_norway
      -orig-id: vervariantNorway
    32:
      id: variant_denmark
      -orig-id: vervariantDenmark
    33:
      id: india_hindi
      -orig-id: verIndiaHindi # alias verIndia
    34:
      id: pakistan_urdu
      -orig-id: verPakistanUrdu # alias verPakistan
    35:
      id: turkish_modified
      -orig-id: verTurkishModified
    36:
      id: swiss_italian
      -orig-id: verItalianSwiss
    37:
      id: international
      -orig-id: verInternational
    39:
      id: romania
      -orig-id: verRomania # alias verRumania
    40:
      id: greek_ancient
      -orig-id: verGreekAncient # alias verGreecePoly
    41:
      id: lithuania
      -orig-id: verLithuania
    42:
      id: poland
      -orig-id: verPoland
    43:
      id: hungary
      -orig-id: verHungary
    44:
      id: estonia
      -orig-id: verEstonia
    45:
      id: latvia
      -orig-id: verLatvia
    46:
      id: sami
      -orig-id: verSami # alias verLapland
    47:
      id: faroe_islands
      -orig-id: verFaroeIsl # alias verFaeroeIsl
    48:
      id: iran
      -orig-id: verIran
    49:
      id: russia
      -orig-id: verRussia
    50:
      id: ireland
      -orig-id: verIreland
    51:
      id: korea
      -orig-id: verKorea
    52:
      id: china
      -orig-id: verChina
    53:
      id: taiwan
      -orig-id: verTaiwan
    54:
      id: thailand
      -orig-id: verThailand
    55:
      id: script_generic
      -orig-id: verScriptGeneric
    56:
      id: czech
      -orig-id: verCzech
    57:
      id: slovak
      -orig-id: verSlovak
    58:
      id: east_asia_generic
      -orig-id: verEastAsiaGeneric # aliases verGenericFE, verFarEastGeneric
    59:
      id: magyar
      -orig-id: verMagyar
    60:
      id: bengali
      -orig-id: verBengali
    61:
      id: belarus
      -orig-id: verBelarus # alias verByeloRussian
    62:
      id: ukraine
      -orig-id: verUkraine # alias verUkrania
    64:
      id: greece_alt
      -orig-id: verGreeceAlt # alias verAlternateGr
    65:
      id: serbian
      -orig-id: verSerbian # alias verSerbia
    66:
      id: slovenian
      -orig-id: verSlovenian # alias verSlovenia
    67:
      id: macedonian
      -orig-id: verMacedonian # alias verMacedonia
    68:
      id: croatia
      -orig-id: verCroatia
    70:
      id: german_reformed
      -orig-id: verGermanReformed
    71:
      id: brazil
      -orig-id: verBrazil
    72:
      id: bulgaria
      -orig-id: verBulgaria
    73:
      id: catalonia
      -orig-id: verCatalonia
    74:
      id: multilingual
      -orig-id: verMultilingual
    75:
      id: scottish_gaelic
      -orig-id: verScottishGaelic
    76:
      id: manx_gaelic
      -orig-id: verManxGaelic
    77:
      id: breton
      -orig-id: verBreton # alias verBrittany
    78:
      id: nunavut
      -orig-id: verNunavut
    79:
      id: welsh
      -orig-id: verWelsh # alias verWales
    81:
      id: irish_gaelic_script
      -orig-id: verIrishGaelicScript
    82:
      id: canada_english
      -orig-id: verEngCanada
    83:
      id: bhutan
      -orig-id: verBhutan
    84:
      id: armenian
      -orig-id: verArmenian # alias verArmenia
    85:
      id: georgian
      -orig-id: verGeorgian # alias verGeorgia
    86:
      id: latin_america_spanish
      -orig-id: verSpLatinAmerica
    88:
      id: tonga
      -orig-id: verTonga
    91:
      id: french_universal
      -orig-id: verFrenchUniversal
    92:
      id: austria
      -orig-id: verAustria # alias verAustriaGerman
    94:
      id: gujarati
      -orig-id: verGujarati
    95:
      id: punjabi
      -orig-id: verPunjabi
    96:
      id: india_urdu
      -orig-id: verIndiaUrdu
    97:
      id: vietnam
      -orig-id: verVietnam
    98:
      id: belgium_french
      -orig-id: verFrBelgium
    99:
      id: uzbek
      -orig-id: verUzbek
    100:
      id: singapore
      -orig-id: verSingapore
    101:
      id: nynorsk
      -orig-id: verNynorsk
    102:
      id: afrikaans
      -orig-id: verAfrikaans
    103:
      id: esperanto
      -orig-id: verEsperanto
    104:
      id: marathi
      -orig-id: verMarathi
    105:
      id: tibetan
      -orig-id: verTibetan # alias verTibet
    106:
      id: nepal
      -orig-id: verNepal
    107:
      id: greenland
      -orig-id: verGreenland
    108:
      id: irelandenglish
      -orig-id: verIrelandEnglish
