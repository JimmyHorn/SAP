*----------------------------------------------------------------------*
*   INCLUDE ZACO05U_1TOP                                               *
*----------------------------------------------------------------------*

*----------------------------------------------------------------------*
*   Data Definition
*----------------------------------------------------------------------*
REPORT ZACO05U_MHCC MESSAGE-ID ZMCO.
* type-pools
TYPE-POOLS: SLIS.

** Tables
TABLES : ZTCO_MHHRTRANS, TKA01, MARA, MARC, COSS, ZTCO_MHPCPOST,
         AUFK, BLPK, BLPP, MKAL, CAUFV, AFKO, AFPO, RMUSER_TAV,
         CKMLHD, MLCD.
TABLES : PPC_ACT, PPC_HEAD, PPC_SHOW_EXT, PPC_SHOW_EXT_ACT.


** Internal table
*DATA : IT_ZTCO_MHHRTRANS LIKE STANDARD TABLE OF ZTCO_MHHRTRANS
*                         WITH HEADER LINE .
DATA : BEGIN OF IT_ZTCO_MHHRTRANS  OCCURS 0,
        GJAHR   LIKE ZTCO_MHHRTRANS-GJAHR,
        PERID   LIKE ZTCO_MHHRTRANS-PERID,
        KOSTL   LIKE ZTCO_MHHRTRANS-KOSTL,
        LSTAR   LIKE ZTCO_MHHRTRANS-LSTAR,
        VAEQTY  LIKE ZTCO_MHHRTRANS-VAEQTY,
        UNIT    LIKE ZTCO_MHHRTRANS-UNIT,
       END OF  IT_ZTCO_MHHRTRANS.
* For MATNR
DATA : BEGIN OF IT_MARC OCCURS 0,
        MATNR   LIKE MARA-MATNR,
        MTART   LIKE MARA-MTART,
        WERKS   LIKE MARC-WERKS,
        SAUFT   LIKE MARC-SAUFT,
        SFEPR   LIKE MARC-SFEPR,
       END OF   IT_MARC.
* For Object Key
DATA : BEGIN OF IT_MA_OBJ OCCURS 0.
        INCLUDE STRUCTURE IT_MARC.
DATA :  AUFNR   LIKE AFPO-AUFNR,
        KOSTL   LIKE ANLP-KOSTL,
        LSTAR   LIKE CSLA-LSTAR,
        OBJNR   LIKE COSS-OBJNR,
        PAROB   LIKE COSS-PAROB,
        USPOB   LIKE COSS-USPOB,
        VERID   LIKE MKAL-VERID,
       END OF   IT_MA_OBJ.
* For Coss
DATA : BEGIN OF IT_COSS OCCURS 0.
DATA :  KOSTL   LIKE ANLP-KOSTL,
        LSTAR   LIKE CSLA-LSTAR,
        AUFNR   LIKE AFPO-AUFNR.
        INCLUDE STRUCTURE IT_MARC.
        INCLUDE STRUCTURE ZSCO_COSS_KEY01.
        INCLUDE STRUCTURE ZSCO_COSS_MEG01.
DATA : END OF  IT_COSS.
DATA : BEGIN OF IT_COL_PCC OCCURS 0,
        PERID   LIKE RKU01G-PERBI, "Period
        AUFNR   LIKE AFPO-AUFNR,
        KOSTL   LIKE ANLP-KOSTL,
        LSTAR   LIKE CSLA-LSTAR,
        MEGXXX  LIKE COSS-MEG001,
        MEINH   LIKE COSS-MEINH,
        VAEQTY  LIKE ZTCO_MHHRTRANS-VAEQTY,
        UNIT    LIKE ZTCO_MHHRTRANS-UNIT,
        RATE_%(16)  TYPE P DECIMALS 6,
        TOMEG   LIKE COSS-MEG001,
        MEGXXX_RATE_%
                LIKE COSS-MEG001.
DATA : END OF  IT_COL_PCC.
* For ZTCO_MHPCPOST
DATA : IT_ZTCO_MHPCPOST LIKE STANDARD TABLE OF ZTCO_MHPCPOST
                        WITH HEADER LINE .
* For DD data
DATA : IT_ET_FIELDLIST LIKE TABLE OF RFVICP_DDIC_TABL_FIELDNAME
                       WITH HEADER LINE.
* For POSTING (MTO)
DATA : BEGIN OF IT_PO_POST OCCURS 500.
        INCLUDE STRUCTURE IT_ZTCO_MHPCPOST.
DATA :    PO_AUFNR    LIKE  AUFK-AUFNR,
          PLNTY_EXP   LIKE  CAUFVD-PLNTY,
          PLNNR_EXP   LIKE  CAUFVD-PLNNR,
          PLNAL_EXP   LIKE  CAUFVD-PLNAL,
          PLNME_EXP   LIKE  CAUFVD-PLNME,
          ARBID       LIKE  PLPO-ARBID,
          ARBPL       LIKE  CRHD-ARBPL,
          VORNR       LIKE  PLPO-VORNR.
DATA : END OF IT_PO_POST.
* For POSTING (MTS-REM)
DATA : BEGIN OF IT_REM_POST OCCURS 500.
        INCLUDE STRUCTURE IT_ZTCO_MHPCPOST.
DATA :
          PWERK       LIKE BLPK-PWERK,
          PLNTY_EXP   LIKE  CAUFVD-PLNTY,
          PLNNR_EXP   LIKE  CAUFVD-PLNNR,
          PLNAL_EXP   LIKE  CAUFVD-PLNAL,
          PLNME_EXP   LIKE  CAUFVD-PLNME,
          ARBID       LIKE  PLPO-ARBID,
          ARBPL       LIKE  CRHD-ARBPL,
          VORNR       LIKE  PLPO-VORNR.
DATA : END OF IT_REM_POST.
DATA  : WA_REM_POST LIKE IT_REM_POST.
* For DI B/F
DATA : BEGIN OF IT_DI_POST OCCURS 500.
DATA :  FLG_REVERSAL  LIKE BAPI_PPC_APOHEADS-FLG_REVERSAL.
        INCLUDE STRUCTURE IT_ZTCO_MHPCPOST.
DATA :  WRONG_PPC.
DATA : END OF IT_DI_POST.

* For BDC
*       Batchinputdata of single transaction
DATA:   IT_BDCDATA LIKE BDCDATA    OCCURS 0 WITH HEADER LINE.
*       messages of call transaction
DATA:   IT_MESSTAB LIKE BDCMSGCOLL OCCURS 0 WITH HEADER LINE.

** Variable
* For DD Table name
DATA : GV_CI_TABNAME     TYPE  DDOBJNAME .
DATA : GV_PERCOUNT       LIKE  COSP-PERBL. "Period Counter
* Global Indicator (existence of records to be posted)
DATA : GV_NEW.
DATA : GV_POSTDATE_BDC(10). "    LIKE  SY-DATUM.
DATA : GV_STR_DATE LIKE SY-DATUM.
DATA : GV_END_DATE LIKE SY-DATUM.

** For BAPI
DATA : IT_COSTCENTERLIST LIKE STANDARD TABLE OF BAPI0012_CCLIST
                         WITH HEADER LINE.
DATA : IT_RETURN         LIKE STANDARD TABLE OF BAPIRET2
                         WITH HEADER LINE.
** REM Profile
DATA : GV_REMPF_FSC      LIKE MARC-SFEPR VALUE 'VEHI'.
DATA : GV_REMPF_ENG      LIKE MARC-SFEPR VALUE 'ENGI'.
DATA : GV_REMPF_BLANK    LIKE MARC-SFEPR VALUE SPACE.

** For resource data
DATA: IT_RESGUID16 TYPE KCR_GUID_16_TAB.
DATA: IF_MODEID16 TYPE PPC_MODE_GUID_INT.
DATA: IT_ACT_RAW TYPE PPC_T_ACT_RAW
                 WITH HEADER LINE.
DATA: IT_PPC_SHOW_EXT_ACT TYPE TABLE OF PPC_SHOW_EXT_ACT
                 WITH HEADER LINE.
* For the Combined PPC_Activity master data.
DATA : BEGIN OF IT_PPC_ACT_MOD OCCURS 0.
        INCLUDE STRUCTURE PPC_ACT.
DATA :  HEADID         LIKE PPC_SHOW_EXT_ACT-HEADID       ,
        RESOURCE_EXT   LIKE PPC_SHOW_EXT_ACT-RESOURCE_EXT ,
        ACTIVITY_NAME  LIKE PPC_SHOW_EXT_ACT-ACTIVITY_NAME,
        MODE_NO        LIKE PPC_SHOW_EXT_ACT-MODE_NO      ,
        COST_CENTER    LIKE PPC_SHOW_EXT_ACT-COST_CENTER  ,
        ACTTYPE        LIKE PPC_SHOW_EXT_ACT-ACTTYPE      ,
        CO_BUSPROC     LIKE PPC_SHOW_EXT_ACT-CO_BUSPROC   .
DATA : END OF  IT_PPC_ACT_MOD.

* For PPC DI B/F
DATA : WA_PPC_HEAD  TYPE PPC_VA_HEAD.
DATA:  IT_PPC_HEADS TYPE TABLE OF BAPI_PPC_APOHEADS
                    WITH HEADER LINE .
DATA : IT_APOHEADS  LIKE STANDARD TABLE OF  BAPI_PPC_APOHEADS
                    WITH HEADER LINE ,
       IT_APOCOMPLISTS
                    LIKE STANDARD TABLE OF  BAPI_PPC_APOCOMPLISTS
                    WITH HEADER LINE ,
       IT_APOACTLISTS
                    LIKE STANDARD TABLE OF  BAPI_PPC_APOACTLISTS
                    WITH HEADER LINE .



*----------------------------------------------------------------------*
*   Selection Condition                                                *
*----------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK BL1 WITH FRAME TITLE TEXT-001.
PARAMETERS : P_KOKRS LIKE CSKS-KOKRS   MEMORY   ID CAC OBLIGATORY,
             P_GJAHR LIKE ANLP-GJAHR   MEMORY   ID GJR OBLIGATORY.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(31) TEXT-002.
*   From Period.
PARAMETERS: P_FRPER LIKE RKU01G-PERAB OBLIGATORY.
SELECTION-SCREEN COMMENT 52(05) TEXT-003.
*   To Period.
PARAMETERS: P_TOPER LIKE RKU01G-PERBI  NO-DISPLAY. " OBLIGATORY.
SELECTION-SCREEN END OF LINE.
PARAMETERS : P_LSTAR LIKE CSLA-LSTAR            DEFAULT 'MAN_HR'
                                                       OBLIGATORY,
             P_NCOAL LIKE GRPDYNP-NAME_COALL    DEFAULT 'DIRECT'
                                                       OBLIGATORY,
             P_MODE(1)                  DEFAULT 'N'    OBLIGATORY,
* Reverse?
             P_REVS AS CHECKBOX .
SELECTION-SCREEN END OF BLOCK BL1.

SELECTION-SCREEN BEGIN OF BLOCK BL2 WITH FRAME TITLE TEXT-004.
SELECT-OPTIONS : S_MTART FOR MARA-MTART         OBLIGATORY.
PARAMETERS : P_VERSN LIKE COSS-VERSN            DEFAULT '000'
                                                OBLIGATORY,
             P_WRTTP LIKE COSS-WRTTP            DEFAULT '4'
                                                OBLIGATORY.
SELECT-OPTIONS : S_VRGNG FOR COSS-VRGNG        .
SELECTION-SCREEN END OF BLOCK BL2.
