FORM CD_CALL_ZTIMIMG03                     .
   IF   ( UPD_ZTIMIMG03                      NE SPACE )
     OR ( UPD_ICDTXT_ZTIMIMG03       NE SPACE )
   .
     CALL FUNCTION 'SWE_REQUESTER_TO_UPDATE'.
     CALL FUNCTION 'ZTIMIMG03_WRITE_DOCUMENT      ' IN UPDATE TASK
        EXPORTING OBJECTID              = OBJECTID
                  TCODE                 = TCODE
                  UTIME                 = UTIME
                  UDATE                 = UDATE
                  USERNAME              = USERNAME
                  PLANNED_CHANGE_NUMBER = PLANNED_CHANGE_NUMBER
                  OBJECT_CHANGE_INDICATOR = CDOC_UPD_OBJECT
                  PLANNED_OR_REAL_CHANGES = CDOC_PLANNED_OR_REAL
                  NO_CHANGE_POINTERS = CDOC_NO_CHANGE_POINTERS
                  O_ZTIMIMG03
                      = *ZTIMIMG03
                  N_ZTIMIMG03
                      = ZTIMIMG03
                  UPD_ZTIMIMG03
                      = UPD_ZTIMIMG03
                  UPD_ICDTXT_ZTIMIMG03
                      = UPD_ICDTXT_ZTIMIMG03
          TABLES  ICDTXT_ZTIMIMG03
                      = ICDTXT_ZTIMIMG03
     .
   ENDIF.
   CLEAR PLANNED_CHANGE_NUMBER.
ENDFORM.
