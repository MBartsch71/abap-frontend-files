CLASS zcl_mbh_file_upload_manifest DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_apack_manifest.
    METHODS constructor.

ENDCLASS.

CLASS zcl_mbh_file_upload_manifest IMPLEMENTATION.

  METHOD constructor.
    if_apack_manifest~descriptor = VALUE #( group_id = 'MBH_DEV'
                                             artifact_id = 'abap-frontend-files'
                                             version = '0.1'
                                             git_url = 'https://github.com/MBartsch71/abap-frontend-files.git'  ).

  ENDMETHOD.

ENDCLASS.
