FUNCTION z_fmm_6003_02.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  EXPORTING
*"     VALUE(SUBRC) LIKE  SYST-SUBRC
*"  TABLES
*"      TA_ZSMM_6003_02 STRUCTURE  ZSMM_6003_02 OPTIONAL
*"      MESSTAB STRUCTURE  BDCMSGCOLL OPTIONAL
*"----------------------------------------------------------------------
  READ TABLE ta_zsmm_6003_02 INDEX 1. "To use header of itab
  subrc = 0.

  ta_zsmm_6003_02-ctu     = 'X'.
  ta_zsmm_6003_02-zmode   = 'N'.
  ta_zsmm_6003_02-zupdate = 'L'.
  ta_zsmm_6003_02-nodata  = '/'.

  ta_zsmm_6003_02-d0110_031 = ta_zsmm_6003_02-d0120_032 =
  ta_zsmm_6003_02-d0130_033 = ta_zsmm_6003_02-d0210_034 =
  ta_zsmm_6003_02-d0215_035 = ta_zsmm_6003_02-d0220_036 =
  ta_zsmm_6003_02-d0310_037 = ta_zsmm_6003_02-d0320_038 = 'X'.

  ta_zsmm_6003_02-reprf_027 = 'X'.


  PERFORM bdc_nodata      USING ta_zsmm_6003_02-nodata.

  PERFORM open_group      USING ta_zsmm_6003_02-zgroup
                                ta_zsmm_6003_02-zuser
                                ta_zsmm_6003_02-keep
                                ta_zsmm_6003_02-holddate
                                ta_zsmm_6003_02-ctu.

  PERFORM bdc_dynpro      USING 'SAPMF02K' '0108'.
  PERFORM bdc_field       USING 'BDC_CURSOR'
                                'WRF02K-D0320'.
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '/00'.
  PERFORM bdc_field       USING 'RF02K-LIFNR'
                                ta_zsmm_6003_02-lifnr_001.
  PERFORM bdc_field       USING 'RF02K-EKORG'
                                ta_zsmm_6003_02-ekorg_003.
  PERFORM bdc_field       USING 'RF02K-D0110'
                                ta_zsmm_6003_02-d0110_031.
  PERFORM bdc_field       USING 'RF02K-D0120'
                                ta_zsmm_6003_02-d0120_032.
  PERFORM bdc_field       USING 'RF02K-D0130'
                                ta_zsmm_6003_02-d0130_033.
  PERFORM bdc_field       USING 'RF02K-D0310'
                                ta_zsmm_6003_02-d0310_037.
  PERFORM bdc_field       USING 'WRF02K-D0320'
                                ta_zsmm_6003_02-d0320_038.

  PERFORM bdc_dynpro      USING 'SAPMF02K' '0110'.
  PERFORM bdc_field       USING 'BDC_CURSOR'
                                'LFA1-TELFX'.
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '=VW'.
  PERFORM bdc_field       USING 'LFA1-NAME1'
                                ta_zsmm_6003_02-name1_005.
  PERFORM bdc_field       USING 'LFA1-SORTL'
                                ta_zsmm_6003_02-sortl_006.
  PERFORM bdc_field       USING 'LFA1-STRAS'
                                ta_zsmm_6003_02-stras_010.
  PERFORM bdc_field       USING 'LFA1-PSTLZ'
                                ta_zsmm_6003_02-pstlz_013.
  PERFORM bdc_field       USING 'LFA1-LAND1'
                                ta_zsmm_6003_02-land1_015.
  PERFORM bdc_field       USING 'LFA1-TELF1'
                                ta_zsmm_6003_02-telf1_019.
  PERFORM bdc_field       USING 'LFA1-TELFX'
                                ta_zsmm_6003_02-telfx_020.

  PERFORM bdc_dynpro      USING 'SAPMF02K' '0120'.
  PERFORM bdc_field       USING 'BDC_CURSOR'
                                'LFA1-KUNNR'.
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '=VW'.

  PERFORM bdc_dynpro      USING 'SAPMF02K' '0130'.
  PERFORM bdc_field       USING 'BDC_CURSOR'
                                'LFBK-BANKS(01)'.
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '=VW'.

  PERFORM bdc_dynpro      USING 'SAPMF02K' '0310'.
  PERFORM bdc_field       USING 'BDC_CURSOR'
                                'LFM1-ZTERM'.
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '=UPDA'.
  PERFORM bdc_field       USING 'LFM1-WAERS'
                                ta_zsmm_6003_02-waers_029.
  PERFORM bdc_field       USING 'LFM1-ZTERM'
                                ta_zsmm_6003_02-zterm_030.

  CLEAR: WA_ztca_if_log.  "Clear Interface table
  PERFORM bdc_transaction TABLES messtab
  USING                         'MK02'
                                ta_zsmm_6003_02-ctu
                                ta_zsmm_6003_02-zmode
                                ta_zsmm_6003_02-zupdate.

  IF sy-subrc <> 0.
    subrc = sy-subrc.
    ta_zsmm_6003_02-zzret = 'E'.      "Error
    WA_ztca_if_log-zsucc = 0.        "Success Quantity
    WA_ztca_if_log-error = 1.        "Fail Quantity
*    EXIT.
  ELSE.
    ta_zsmm_6003_02-zzret = 'S'.      "Success
    WA_ztca_if_log-zsucc = 0.        "Success Quantity
    WA_ztca_if_log-error = 1.        "Fail Quantity
  ENDIF.

  MODIFY ta_zsmm_6003_02 INDEX 1.     "Update Internal table

  DATA: logno_h TYPE num10.
  PERFORM number_get_next USING    '00'
                                   'ZMMNRO0002'
                          CHANGING logno_h.

  DATA: ls_ztmm_6003_01 LIKE ztmm_6003_01.

  MOVE-CORRESPONDING ta_zsmm_6003_02 TO ls_ztmm_6003_01.

  MOVE logno_h   TO ls_ztmm_6003_01-logno_h. "Log number
*/ Begin of Time stamp
  MOVE sy-uname  TO ls_ztmm_6003_01-zuser.   "Created User ID
  MOVE sy-datum  TO ls_ztmm_6003_01-zsdat.   "SEND FILE CREATED DATE
  MOVE sy-uzeit  TO ls_ztmm_6003_01-zstim.   "SEND FILE CREATED TIME
  MOVE sy-datum  TO ls_ztmm_6003_01-zedat.   "SAP INTERFACE DATE
  MOVE sy-uzeit  TO ls_ztmm_6003_01-zetim.   "SAP INTERFACE TIME
  MOVE sy-datum  TO ls_ztmm_6003_01-zbdat.   "SAP BDC EXECUTED DATE
  MOVE sy-uzeit  TO ls_ztmm_6003_01-zbtim.   "SAP BDC EXECUTED TIME
  MOVE sy-uname  TO ls_ztmm_6003_01-zbnam.   "BDC User ID
  MOVE 'U'       TO ls_ztmm_6003_01-zmode.   "(Create/Update/Delete)
*Result of the Processing
  MOVE ta_zsmm_6003_02-zzret TO ls_ztmm_6003_01-zresult.
  MOVE space                 TO ls_ztmm_6003_01-zmsg."Message text
*/ End of Time stamp

* BDC Logging to the tables ZTMM_6003_01 and ZBDCMSGCOLL.
  INSERT INTO ztmm_6003_01 VALUES ls_ztmm_6003_01.
  PERFORM bdc_log_to_zbdcmsgcoll TABLES messtab
                                 USING  logno_h.

***Function Module for Interface Log
*
*Where to be inserted:
* 1. Inbound: When interface table is updated after Standard BDC/BAPI
*             executed.
* 2. Outbound: After calling EAI
*
*====================================================================
*
*Function name : Z_FCA_EAI_INTERFACE_LOG
*
*Import/Export Parameter Structure : ZTCA_IF_LOG
*
*IFDOC   <= Serial No. for Log. Leave as empty
*TCODE   <= Present Transaction Code
*TOTAL   <= Total Execution number
*ZSUCC   <= Successful occurrences(number) for BDC/BAPI Processing
*ERROR   <= Failed occurrences(number) for BDC/BAPI Processing
*ERDAT   <= Created on.
*ERZET   <= Created time.
*ERNAM   <= Creator.
*AEDAT   <= Changed on.
*AEZET   <= Changed time
*AENAM   <= the person who change
  WA_ztca_if_log-tcode = 'MK02'.   "Present Transaction Code
  WA_ztca_if_log-total = 1.        "Total Execution number
  WA_ztca_if_log-erdat = sy-datum. "Created on.
  WA_ztca_if_log-erzet = sy-uname. "Created time.
  WA_ztca_if_log-ernam = sy-uname. "Created by.
  CALL FUNCTION 'Z_FCA_EAI_INTERFACE_LOG'
    EXPORTING
      i_ztca_if_log     = WA_ztca_if_log
* IMPORTING
*   E_ZTCA_IF_LOG              =
   EXCEPTIONS
     update_failed              = 1
     number_range_error         = 2
     tcode_does_not_exist       = 3
     OTHERS                     = 4.
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

****
  PERFORM close_group USING     ta_zsmm_6003_02-ctu.
ENDFUNCTION.
*INCLUDE zbdcrecxy .
