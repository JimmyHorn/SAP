*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZTIMIMG08
*   generation date: 2001/10/31 at 15:51:20 by user ESBKANG
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZTIMIMG08          .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
