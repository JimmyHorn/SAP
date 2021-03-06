*&---------------------------------------------------------------------*
*& Report  ZRHR_STLT_GOAL_REPORT
*&
*&---------------------------------------------------------------------*
*& Program name      : ZRHR_STLT_GOAL_REPORT
*& Creation date     : 12/09/2013
*& Writer            : T00320
*&---------------------------------------------------------------------*
*& Description       :
*& 1. Development Plan Report
*&---------------------------------------------------------------------*
*& Modified date     :
*& Modified user     :
*&---------------------------------------------------------------------*
REPORT  zrhr_stlt_goal_report MESSAGE-ID zmhrpms.

INCLUDE zrhr_stlt_goal_reporttop.
INCLUDE zrhr_stlt_goal_reportf01.
INCLUDE zrhr_stlt_goal_reporto01.
INCLUDE zrhr_stlt_goal_reporti01.


*----------------------------------------------------------------------*
*   INITIALIZATION
*----------------------------------------------------------------------*
INITIALIZATION.
  PERFORM set_init_value.       " set initial value

*----------------------------------------------------------------------*
*   AT SELECTION-SCREEN OUTPUT
*----------------------------------------------------------------------*
AT SELECTION-SCREEN OUTPUT.
  PERFORM set_droplist_year.    " set droplist Year

*----------------------------------------------------------------------*
*   AT SELECTION-SCREEN ON VALUE-REQUEST FOR
*----------------------------------------------------------------------*

*----------------------------------------------------------------------*
*   AT SELECTION-SCREEN
*----------------------------------------------------------------------*

*----------------------------------------------------------------------*
*   START-OF-SELECTION
*----------------------------------------------------------------------*
*START-OF-SELECTION.
*  PERFORM get_data.

*----------------------------------------------------------------------*
*   END-OF-SELECTION
*----------------------------------------------------------------------*
END-OF-SELECTION.
  CALL SCREEN 100.
