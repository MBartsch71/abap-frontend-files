CLASS zcl_mbh_file_upload DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor IMPORTING default_path TYPE string OPTIONAL.

    METHODS file_upload_in_table IMPORTING expected_table_type TYPE REF TO data
                                 RETURNING VALUE(result)       TYPE REF TO data.

    METHODS file_upload_in_stringtab RETURNING VALUE(result) TYPE stringtab.

  PRIVATE SECTION.
    DATA default_path TYPE string.

    METHODS get_file_from_open_dialog RETURNING VALUE(result) TYPE string.

    METHODS upload_file_in_table IMPORTING file_name     TYPE string
                                                table_type    TYPE REF TO data
                                      RETURNING VALUE(result) TYPE REF TO data.
ENDCLASS.

CLASS zcl_mbh_file_upload IMPLEMENTATION.

  METHOD constructor.
    me->default_path = default_path.
  ENDMETHOD.

  METHOD file_upload_in_table.
    DATA(file_name) = get_file_from_open_dialog( ).
    result = upload_file_in_table( file_name  = file_name
                                   table_type = expected_table_type ).
  ENDMETHOD.

  METHOD get_file_from_open_dialog.
    DATA files TYPE filetable.
    DATA returncode TYPE i.

    cl_gui_frontend_services=>file_open_dialog(
      EXPORTING
        window_title            = |Choose file to upload|
        initial_directory       =  default_path
      CHANGING
        file_table              =  files
        rc                      =  returncode
      EXCEPTIONS
        file_open_dialog_failed = 1
        cntl_error              = 2
        error_no_gui            = 3
        not_supported_by_gui    = 4
        OTHERS                  = 5 ).
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
    result = files[ 1 ]-filename.
  ENDMETHOD.

  METHOD upload_file_in_table.
    ASSIGN table_type->* TO FIELD-SYMBOL(<table>).
    cl_gui_frontend_services=>gui_upload(
      EXPORTING
        filename                = file_name
      CHANGING
        data_tab                =  <table>
      EXCEPTIONS
        file_open_error         = 1
        file_read_error         = 2
        no_batch                = 3
        gui_refuse_filetransfer = 4
        invalid_type            = 5
        no_authority            = 6
        unknown_error           = 7
        bad_data_format         = 8
        header_not_allowed      = 9
        separator_not_allowed   = 10
        header_too_long         = 11
        unknown_dp_error        = 12
        access_denied           = 13
        dp_out_of_memory        = 14
        disk_full               = 15
        dp_timeout              = 16
        not_supported_by_gui    = 17
        error_no_gui            = 18
        OTHERS                  = 19 ).

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
    result = REF #( <table> ).
  ENDMETHOD.

  METHOD file_upload_in_stringtab.
    DATA(table) = file_upload_in_table( REF #( result ) ).
    ASSIGN table->* TO FIELD-SYMBOL(<result>).
    result = <result>.
  ENDMETHOD.

ENDCLASS.
