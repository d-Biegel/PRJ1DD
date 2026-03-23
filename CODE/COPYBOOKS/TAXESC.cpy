      *****************************************************************
      * FILE: TAXESC.CPY                                              *
      * RECORD LENGTH: 80 BYTES                                       *
      *****************************************************************
       01  TAXES-COPYBOOK-RECORD.               
           02 WS-FED-TAX           PIC 9V99.
           02 FILLER               PIC X.
           02 WS-STATE-TAX         PIC 9V99.
           02 FILLER               PIC X.
           02 WS-LOC-TAX           PIC 9V99.
           02 FILLER               PIC X(69).