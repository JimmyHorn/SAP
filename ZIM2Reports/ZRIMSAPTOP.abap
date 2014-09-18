*----------------------------------------------------------------------*
*   INCLUDE ZRIMSAPTOP                                                 *
*----------------------------------------------------------------------*

*>> Inbound Delivery Table
TABLES :  ZTFTZHD_LOG.
  CONSTANTS: C_NRO_NR_09   VALUE '09' LIKE INRI-NRRANGENR.
  DATA:  IT_FUNC TYPE STANDARD TABLE OF RSMPE-FUNC.
  DATA:  WA_FUNC LIKE LINE OF IT_FUNC.
  DATA:  W_TITLE(80).
  DATA:  CC_NAME TYPE SCRFNAME VALUE 'CC_0100'.

* For OK code
  DATA: OK_CODE TYPE SY-UCOMM,  SAVE_OK_CODE LIKE OK_CODE.

* For PF-STATUS and Titlebar
  CLASS LCL_PS DEFINITION DEFERRED.
  DATA: CRV_PS TYPE REF TO LCL_PS.
  DATA: CRV_CUSTOM_CONTAINER TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
        CRV_ALV_GRID         TYPE REF TO CL_GUI_ALV_GRID.

* Variables for ALV
  DATA: WA_LAYOUT   TYPE LVC_S_LAYO.
  DATA: IT_FIELDCAT TYPE LVC_T_FCAT WITH HEADER LINE.
  DATA: WA_TOOLBAR  TYPE STB_BUTTON.
  DATA: WA_SORT     TYPE LVC_S_SORT.
  DATA: IT_SORT     LIKE TABLE OF WA_SORT.
  DATA: IT_ROID TYPE LVC_T_ROID.
  DATA: WA_ROID LIKE LINE OF IT_ROID.
  DATA: IT_ROW TYPE LVC_T_ROW.
  DATA: WA_ROW LIKE LINE OF IT_ROW.

  DATA : IT_ROW_ID  TYPE LVC_S_ROW.
  DATA : IT_COL_ID  TYPE LVC_S_COL.
  DATA : IT_ROW_NO  TYPE LVC_S_ROID.
  DATA : WS_ROW     TYPE I,
         WS_VALUE(30)   TYPE C,
         WS_COL     TYPE I.

  DATA: BEGIN OF WA_ZTFTZHD_LOG.
          INCLUDE STRUCTURE ZTFTZHD_LOG.
  DATA:  "profl LIKE mara-profl,
        END OF WA_ZTFTZHD_LOG.

DATA: BEGIN OF IT_ZSFTZHD OCCURS 1000.
        INCLUDE STRUCTURE ZSFTZHD.
DATA  END OF IT_ZSFTZHD.

DATA: BEGIN OF IT_ZSFTZMT OCCURS 1000.
        INCLUDE STRUCTURE ZSFTZMT.
DATA  END OF IT_ZSFTZMT.

DATA: BEGIN OF IT_ZSFTZHS OCCURS 1000.
        INCLUDE STRUCTURE ZSFTZHS.
DATA  END OF IT_ZSFTZHS.

  DATA: IT_ZTFTZHD_LOG LIKE TABLE OF WA_ZTFTZHD_LOG.