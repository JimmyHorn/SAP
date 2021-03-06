FUNCTION Z_FPP_GET_ZTPPVM.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  TABLES
*"      I_ZSPPVM STRUCTURE  ZSPPVM
*"  EXCEPTIONS
*"      NO_PO_IN_VM
*"      NO_PLAN_ORDER
*"      NO_ENGINE_CODE
*"      UPDATE_FAIL
*"----------------------------------------------------------------------
  DATA : L_ERROR     TYPE    C ,
         L_TABIX     TYPE    I ,
         L_FLAG      TYPE    C.

*-----> Check PP Log
  CLEAR : ZTPP_IF_STATUS .
  SELECT SINGLE *
              FROM ZTPP_IF_STATUS
              WHERE TABNAME EQ 'ZTPPVM' .

  IF ZTPP_IF_STATUS-ZGO EQ 'X' .
    I_ZSPPVM-ZZRET = 'E' .
    MODIFY I_ZSPPVM TRANSPORTING ZZRET WHERE ZZRET EQ SPACE .
  ENDIF.

  CHECK ZTPP_IF_STATUS-ZGO NE 'X' .
  LOOP AT I_ZSPPVM .
    I_ZSPPVM-MANDT   = SY-MANDT    .
    I_ZSPPVM-ZRESULT = 'I'.
    I_ZSPPVM-ZMSG    = 'Initialize'.
    MOVE-CORRESPONDING I_ZSPPVM TO IT_ZTPPVM.
    MODIFY ZTPPVM FROM IT_ZTPPVM.
    IF SY-SUBRC EQ 0  AND  L_ERROR = SPACE .
      MOVE  'S'         TO      I_ZSPPVM-ZZRET .
    ELSE.
      L_ERROR = 'E' .
      MOVE  'E'         TO      I_ZSPPVM-ZZRET .
    ENDIF.
    MODIFY I_ZSPPVM  .
  ENDLOOP.

  COMMIT WORK.  CLEAR: L_ERROR .
* CHECK L_ERROR = SPACE .

  LOOP AT I_ZSPPVM INTO WA_ZSPPVM  WHERE ZZRET = 'S' .
    COMMIT WORK.
    L_TABIX  =  L_TABIX + 1      .
    CLEAR : WA_SUBRC_BDC, WA_SUBRC.
    MOVE-CORRESPONDING WA_ZSPPVM TO IT_ZTPPVM.
    MOVE-CORRESPONDING WA_ZSPPVM TO I_ZSPPVM.
    CLEAR WA_EQUIPMENT.
    CONCATENATE WA_ZSPPVM-P_MODEL WA_ZSPPVM-P_BODY_SERIAL
                                      INTO WA_EQUIPMENT.
    PERFORM MANIFEST_DATA.

    PERFORM ENGINE_DATA  .
*   IF WA_SUBRC_BDC IS INITIAL.    "Check BDC Success of Before Process
    PERFORM FTP_HANDLING_MASTER TABLES IT_VIN
                                 USING WA_EQUIPMENT 'W' '002' .
    IF WA_SUBRC NE SPACE .
      ROLLBACK WORK.
      IT_ZTPPVM-ZRESULT = I_ZSPPVM-ZRESULT = I_ZSPPVM-ZZRET = 'E'.
      CONCATENATE WA_EQUIPMENT TEXT-001  INTO I_ZSPPVM-ZMSG .
      IT_ZTPPVM-ZMSG    = I_ZSPPVM-ZMSG .
      MODIFY I_ZSPPVM   INDEX L_TABIX.
      MODIFY ZTPPVM FROM IT_ZTPPVM .
      EXIT.
    ENDIF.

    IF WA_SUBRC_BDC IS INITIAL.
      PERFORM FTP_HANDLING_MASTER TABLES IT_ENGIN
                                   USING WA_ENGINE    'W' '002' .
      IF WA_SUBRC NE SPACE .
        ROLLBACK WORK.
        IT_ZTPPVM-ZRESULT = I_ZSPPVM-ZRESULT = I_ZSPPVM-ZZRET = 'E'.
        CONCATENATE WA_ENGINE    TEXT-002  INTO I_ZSPPVM-ZMSG .
        IT_ZTPPVM-ZMSG    = I_ZSPPVM-ZMSG .
        MODIFY I_ZSPPVM  INDEX L_TABIX.
        MODIFY ZTPPVM FROM IT_ZTPPVM .
        EXIT.
      ENDIF.
    ENDIF.

    REFRESH IT_VIN. CLEAR IT_VIN.
    MODIFY ZTPPVM FROM IT_ZTPPVM.
    IF WA_SUBRC NE SPACE .
      ROLLBACK WORK.
      IT_ZTPPVM-ZRESULT = I_ZSPPVM-ZRESULT = I_ZSPPVM-ZZRET = 'E'.
      I_ZSPPVM-ZMSG  = TEXT-003 .
      IT_ZTPPVM-ZMSG    = I_ZSPPVM-ZMSG .
      MODIFY I_ZSPPVM  INDEX L_TABIX.
      MODIFY ZTPPVM FROM IT_ZTPPVM .
      EXIT.
    ENDIF.

    CONCATENATE WA_EQUIPMENT '/' WA_ENGINE 'OK!' INTO I_ZSPPVM-ZMSG .
    IT_ZTPPVM-ZRESULT = I_ZSPPVM-ZRESULT = I_ZSPPVM-ZZRET = 'S'.
    IT_ZTPPVM-ZMSG    = I_ZSPPVM-ZMSG .
    MODIFY I_ZSPPVM INDEX L_TABIX.
    MODIFY ZTPPVM FROM IT_ZTPPVM .
*    ELSE.
*      WA_SUBRC = 'X' .
*      CONCATENATE IT_ZTPPVM-P_ENGINE_NO TEXT-004   IT_ZTPPVM-ZMSG
*             INTO I_ZSPPVM-ZMSG .
*      IT_ZTPPVM-ZRESULT = I_ZSPPVM-ZRESULT = I_ZSPPVM-ZZRET = 'E'.
*      IT_ZTPPVM-ZMSG    = I_ZSPPVM-ZMSG .
*      MODIFY I_ZSPPVM   INDEX L_TABIX.
*      MODIFY ZTPPVM FROM IT_ZTPPVM .
*      EXIT .
*    ENDIF.

*  requested by MY Hur changed by CHris
*  check the reserved engine code and
*  update with actual engine code
    PERFORM UPDATE_ENGINE USING L_FLAG .
    IF L_FLAG NE SPACE.
      MODIFY ZTPPVM FROM IT_ZTPPVM.
    ENDIF.

  ENDLOOP.

  L_TABIX = L_TABIX + 1   .

  LOOP AT I_ZSPPVM FROM L_TABIX .
    MOVE-CORRESPONDING I_ZSPPVM TO IT_ZTPPVM.
    IT_ZTPPVM-ZRESULT = I_ZSPPVM-ZRESULT = I_ZSPPVM-ZZRET = 'E'.
    IT_ZTPPVM-ZMSG    = I_ZSPPVM-ZMSG    = TEXT-005            .
    MODIFY I_ZSPPVM .
    MODIFY ZTPPVM FROM IT_ZTPPVM .
  ENDLOOP.

* REQUESED BY MY HUR CHANGED BY CHRIS
* RE-PROCESS UNSUCCESSFUL ENGINE CODE UPDATE
  PERFORM ENGINE_CODE_REPROCESS.
* end of change on 06/23/2005

ENDFUNCTION.
