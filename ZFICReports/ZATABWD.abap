REPORT ZATABWD.

* Structures
DATA: LS_TABWD TYPE TABWD,
      LS_TABWD_VID TYPE TABWD_VID,
      LS_TABWD_VIT TYPE TABWD_VIT.

* Tables
DATA: LT_TABWD TYPE TABLE OF TABWD,
      LT_TABWD_VID TYPE TABLE OF TABWD_VID,
      LT_TABWD_VIT TYPE TABLE OF TABWD_VIT.

* Write Header information
write: / 'This reports creates control information'.
write: / 'for component FI-AA for use with MIRO'.
write: /.


* Gutschrift. aus Rechnungseingang
LS_TABWD_VID = 'RMRPRMRP000000100000'.
LS_TABWD_VIT-VORGID = LS_TABWD_VID.
LS_TABWD_VIT-VOTEXT = 'Gutschrift. aus Rechnungseingang'.
LS_TABWD_VIT-SPRAS = 'D'.
LS_TABWD-TCODE = LS_TABWD_VID.
LS_TABWD-BWASL = '105'.
APPEND LS_TABWD_VID TO LT_TABWD_VID.
APPEND LS_TABWD_VIT TO LT_TABWD_VIT.
APPEND LS_TABWD TO LT_TABWD.
LS_TABWD_VIT-SPRAS = 'E'.
LS_TABWD_VIT-VOTEXT = 'Credit memo, invoice receipt (crr. year)'.
APPEND LS_TABWD_VIT TO LT_TABWD_VIT.


* Gutschrift. aus Rechnungseingang (Folgejahr)
LS_TABWD_VID = 'RMRPRMRP000000110000'.
LS_TABWD_VIT-VORGID = LS_TABWD_VID.
LS_TABWD_VIT-VOTEXT = 'Gutschrift. aus Rechnungseingang (Folgejahr)'.
LS_TABWD_VIT-SPRAS = 'D'.
LS_TABWD-TCODE = LS_TABWD_VID.
LS_TABWD-BWASL = '160'.
APPEND LS_TABWD_VID TO LT_TABWD_VID.
APPEND LS_TABWD_VIT TO LT_TABWD_VIT.
APPEND LS_TABWD TO LT_TABWD.
LS_TABWD_VIT-SPRAS = 'E'.
LS_TABWD_VIT-VOTEXT = 'Credit memo, invoice receipt (prior year)'.
APPEND LS_TABWD_VIT TO LT_TABWD_VIT.


* Gutschrift. aus Rechnungseingang (verbunden)
LS_TABWD_VID = 'RMRPRMRP100000100000'.
LS_TABWD_VIT-VORGID = LS_TABWD_VID.
LS_TABWD_VIT-VOTEXT = 'Gutschrift. aus Rechnungseingang (verbunden)'.
LS_TABWD_VIT-SPRAS = 'D'.
LS_TABWD-TCODE = LS_TABWD_VID.
LS_TABWD-BWASL = '106'.
APPEND LS_TABWD_VID TO LT_TABWD_VID.
APPEND LS_TABWD_VIT TO LT_TABWD_VIT.
APPEND LS_TABWD TO LT_TABWD.
LS_TABWD_VIT-SPRAS = 'E'.
LS_TABWD_VIT-VOTEXT = 'Credit memo, invoice receipt (aff., crr. year)'.
APPEND LS_TABWD_VIT TO LT_TABWD_VIT.


* Gutschrift. aus Rchngsngng (verbunden, Folgejahr)
LS_TABWD_VID = 'RMRPRMRP100000110000'.
LS_TABWD_VIT-VORGID = LS_TABWD_VID.
LS_TABWD_VIT-VOTEXT
     = 'Gutschrift. aus Rchngsngng (verbunden, Folgejahr)'.
LS_TABWD_VIT-SPRAS = 'D'.
LS_TABWD-TCODE = LS_TABWD_VID.
LS_TABWD-BWASL = '161'.
APPEND LS_TABWD_VID TO LT_TABWD_VID.
APPEND LS_TABWD_VIT TO LT_TABWD_VIT.
APPEND LS_TABWD TO LT_TABWD.
LS_TABWD_VIT-SPRAS = 'E'.
LS_TABWD_VIT-VOTEXT = 'Credit memo, invoice receipt (aff., prior year)'.
APPEND LS_TABWD_VIT TO LT_TABWD_VIT.


MODIFY TABWD_VID FROM TABLE LT_TABWD_VID.
WRITE:/ SY-DBCNT, 'entries were created or updated in table TABWD_VID'.

MODIFY TABWD_VIT FROM TABLE LT_TABWD_VIT.
WRITE:/ SY-DBCNT, 'entries were created or updated in table TABWD_VIT'.

MODIFY TABWD FROM TABLE LT_TABWD.
WRITE:/ SY-DBCNT, 'entries were created or updated in table TABWD'.
