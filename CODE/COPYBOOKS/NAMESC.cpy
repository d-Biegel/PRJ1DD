      *****************************************************************
      * FILE: NAMESC.CPY                                              *
      * RECORD LENGTH: 80 BYTES                                       *
      *****************************************************************
       01  NAMES-COPYBOOK-RECORD.               
           02  WS-PERSON-NM            PIC X(20).  
           02  WS-BRTH-DT.
              03 WS-BRTH-DT-YR         PIC 9(4).
              03 FILLER                PIC X.
              03 WS-BRTH-DT-MM         PIC 9(2).
              03 FILLER                PIC X.
              03 WS-BRTH-DT-DD         PIC 9(2).
           02  FILLER                  PIC X.
           02  WS-HOUR-WK              PIC 9(3).  
           02  FILLER                  PIC X. 
           02  WS-ROUTE-NO             PIC 9(7).
           02  FILLER                  PIC X. 
           02  WS-ACCT-NO              PIC 9(7).
           02  FILLER                  PIC X. 
           02  WS-ACCT-TYPE            PIC X(4).
           02  FILLER                  PIC X(25).
