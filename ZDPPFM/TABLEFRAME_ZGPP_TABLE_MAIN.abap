*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZGPP_TABLE_MAIN
*   generation date: 12/04/2003 at 01:15:00 by user EZLOVE
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZGPP_TABLE_MAIN    .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
