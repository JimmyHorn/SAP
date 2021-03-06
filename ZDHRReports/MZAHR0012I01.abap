*----------------------------------------------------------------------*
***INCLUDE MZAHR0012I01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  BACK_EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module BACK_EXIT input.
  SET SCREEN 0. LEAVE SCREEN.

endmodule.                 " BACK_EXIT  INPUT
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9000  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module USER_COMMAND_9000 input.
  CASE SY-UCOMM.
    WHEN 'EXEC'.
       CLEAR SY-UCOMM.
      PERFORM SELECT_MAIN_DATA.
    WHEN 'EXCL'.
      CLEAR SY-UCOMM.
      PERFORM EXCEL_DOWN_LOAD.
  ENDCASE.
*
  CLEAR SY-UCOMM.

endmodule.                 " USER_COMMAND_9000  INPUT
*&---------------------------------------------------------------------*
*&      Module  GET_ZYEAR_VALUE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module GET_ZYEAR_VALUE input.
  CLEAR IT_YEARS. REFRESH IT_YEARS.
*
  CLEAR ZTHR_PCP02.
  SELECT ZVAL1 INTO ZTHR_PCP02-ZVAL1
    FROM ZTHR_PCP02 WHERE ZMODL = '02'
                      AND ZGRUP = '1020'.
    IT_YEARS-ZYEAR = ZTHR_PCP02-ZVAL1(4).
    APPEND IT_YEARS. CLEAR IT_YEARS.
  ENDSELECT.
*
  CLEAR IT_FIELD. REFRESH IT_FIELD.
*
  IT_FIELD-TABNAME    = 'ZTHR_PCP03'.
  IT_FIELD-FIELDNAME  = 'ZYEAR'.
  IT_FIELD-SELECTFLAG = 'X'.
  APPEND IT_FIELD. CLEAR IT_FIELD.
*
  CLEAR: W_FNAME, W_TABIX, W_FLDVL.
*
  CALL FUNCTION 'HELP_VALUES_GET_NO_DD_NAME'
       EXPORTING
            SELECTFIELD      = W_FNAME
       IMPORTING
            IND              = W_TABIX
            SELECT_VALUE     = W_FLDVL
       TABLES
            FIELDS           = IT_FIELD
            FULL_TABLE       = IT_YEARS.
*
  W_ZYEAR = W_FLDVL.

endmodule.                 " GET_ZYEAR_VALUE  INPUT
*&---------------------------------------------------------------------*
*&      Module  GET_ZVERS_VALUE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module GET_ZVERS_VALUE input.
  CLEAR IT_VERSN. REFRESH IT_VERSN.
*
  CLEAR ZTHR_PCP02.
  SELECT ZVAL1 ZVAL3 INTO (ZTHR_PCP02-ZVAL1, ZTHR_PCP02-ZVAL3)
    FROM ZTHR_PCP02 WHERE ZMODL = '02'
                      AND ZGRUP = '1030'
                      AND ZVAL2 = W_ZYEAR.
    IT_VERSN-ZVERS = ZTHR_PCP02-ZVAL1(2).
    APPEND IT_VERSN. CLEAR IT_VERSN.
  ENDSELECT.
*
  IF IT_VERSN[] IS INITIAL.
    EXIT.
  ENDIF.
*
  CLEAR IT_FIELD. REFRESH IT_FIELD.
*
  IT_FIELD-TABNAME    = 'ZTHR_PCP03'.
  IT_FIELD-FIELDNAME  = 'ZVERS'.
  IT_FIELD-SELECTFLAG = 'X'.
  APPEND IT_FIELD. CLEAR IT_FIELD.
*
  CLEAR: W_FNAME, W_TABIX, W_FLDVL.
*
  CALL FUNCTION 'HELP_VALUES_GET_NO_DD_NAME'
       EXPORTING
            SELECTFIELD      = W_FNAME
       IMPORTING
            IND              = W_TABIX
            SELECT_VALUE     = W_FLDVL
       TABLES
            FIELDS           = IT_FIELD
            FULL_TABLE       = IT_VERSN.
*
  W_ZVERS = W_FLDVL.

endmodule.                 " GET_ZVERS_VALUE  INPUT
*&---------------------------------------------------------------------*
*&      Module  GET_WERKS_VALUE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE GET_WERKS_VALUE INPUT.
*
  CLEAR IT_PERSA. REFRESH IT_PERSA.
*
  CLEAR T500P.
  SELECT PERSA NAME1 INTO (T500P-PERSA, T500P-NAME1)
    FROM T500P WHERE MOLGA = '10'.
    IT_PERSA-WERKS = T500P-PERSA.
    IT_PERSA-NAME1 = T500P-NAME1.
    APPEND IT_PERSA. CLEAR IT_PERSA.
  ENDSELECT.
*
  CLEAR IT_FIELD. REFRESH IT_FIELD.
*
  IT_FIELD-TABNAME    = 'T500P'.
  IT_FIELD-FIELDNAME  = 'PERSA'.
  IT_FIELD-SELECTFLAG = 'X'.
  APPEND IT_FIELD. CLEAR IT_FIELD.

  IT_FIELD-TABNAME    = 'T500P'.
  IT_FIELD-FIELDNAME  = 'NAME1'.
  IT_FIELD-SELECTFLAG = ' '.
  APPEND IT_FIELD. CLEAR IT_FIELD.
*
  CLEAR: W_FNAME, W_TABIX, W_FLDVL.
*
  CALL FUNCTION 'HELP_VALUES_GET_NO_DD_NAME'
       EXPORTING
            SELECTFIELD      = W_FNAME
       IMPORTING
            IND              = W_TABIX
            SELECT_VALUE     = W_FLDVL
       TABLES
            FIELDS           = IT_FIELD
            FULL_TABLE       = IT_PERSA.
*
  W_WERKS = W_FLDVL.
*
  CLEAR DYNPFIELDS. REFRESH DYNPFIELDS.

  READ TABLE IT_PERSA INDEX W_TABIX.
  DYNPFIELDS-FIELDNAME   = 'W_NAME1'.
  DYNPFIELDS-FIELDVALUE  = IT_PERSA-NAME1.
  APPEND DYNPFIELDS. CLEAR DYNPFIELDS.
*
  CALL FUNCTION 'DYNP_VALUES_UPDATE'
       EXPORTING
            DYNAME                     = SY-CPROG
            DYNUMB                     = SY-DYNNR
       TABLES
            DYNPFIELDS                 = DYNPFIELDS
       EXCEPTIONS
            INVALID_ABAPWORKAREA       = 1
            INVALID_DYNPROFIELD        = 2
            INVALID_DYNPRONAME         = 3
            INVALID_DYNPRONUMMER       = 4
            INVALID_REQUEST            = 5
            NO_FIELDDESCRIPTION        = 6
            UNDEFIND_ERROR             = 7
            OTHERS                     = 8.

ENDMODULE.                 " GET_WERKS_VALUE  INPUT
