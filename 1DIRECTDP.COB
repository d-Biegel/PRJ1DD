      ************************************************************
      *
      *  PROGRAM ID DIRECTDP
      *  DATE CREATED:  15FEB2026
      *
      *  DEMO PROG SHOWS YOU HOW 
      *  DIRECT DEPOSIT WORKS 
      *  WITH INPUT DATA
      *
      *  CHANGE LOG
      *  USER ID     DATE     CHANGE DESCRIPTION
      * ---------   ------    -------------------------------------
      *  DAN BIEG   15FEB2026 CODE PROG
      **************************************************************
       IDENTIFICATION DIVISION.                               
       PROGRAM-ID. DIRECTDP.  

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. IBM-370.
       OBJECT-COMPUTER. IBM-370. 

       INPUT-OUTPUT SECTION.

       FILE-CONTROL.                                                    
           SELECT FILE-PEOPLE ASSIGN TO UT-S-NAMES.  
           SELECT FILE-TAXES ASSIGN TO UT-S-TAXES.
           SELECT FILE-RATES ASSIGN TO UT-S-RATES.

       DATA DIVISION.       

       FILE SECTION.                                                    
       FD     FILE-PEOPLE                                            
              LABEL RECORDS ARE OMITTED                                 
              BLOCK CONTAINS 0 RECORDS                                  
              DATA RECORD IS FIL-PEOPLE. 

       01  FIL-PEOPLE.                                        
          02 FIL-PERS-NM     PIC X(20).
          02 FIL-BRTH-DT     PIC X(10).
          02 FILLLER         PIC X(1).
          02 FIL-HOUR-WK     PIC 9(3).
          02 FILLER          PIC X.
          02 FIL-ROUTE-NO    PIC 9(7).
          02 FILLER          PIC X.
          02 FIL-ACCT-NO     PIC 9(7).
          02 FILLER          PIC X.
          02 FIL-ACCT-TYPE   PIC X(4).
          02 FILLER          PIC X(25).                      
                      
                      
  

       FD     FILE-TAXES        
              LABEL RECORDS ARE OMITTED            
              BLOCK CONTAINS 0 RECORDS               
              DATA RECORD IS FIL-TAXES. 
       
       01  FIL-TAXES.                 
          02 FED-TAX-PERCT        PIC 9V99.
          02 FILLER               PIC X.
          02 STATE-TAX-PERCT      PIC 9V99.
          02 FILLER               PIC X.
          02 LOC-TAX-PERCT        PIC 9V99.
          02 FILLER               PIC X(69).



       FD     FILE-RATES
              LABEL RECORDS ARE OMITTED
              BLOCK CONTAINS 0 RECORDS
              DATA RECORD IS FIL-RATES.

       01  FIL-RATES.
          02 FIL-HRLY-RATE        PIC 9(3)V9.
          02 FILLER               PIC X.
          02 FIL-OVERTIME-RATE    PIC 9(3)V9.
          02 FILLER               PIC X(69).
       


       WORKING-STORAGE SECTION. 
      * USE THE COPYBOOK              
       01  WS-PERSON COPY NAMESC.
       01  WS-PAY-RATES COPY RATESC.
       01  WS-TAXES COPY TAXESC.


       01  WS-BREAKPT   PIC X(23) VALUE '-=-=-=-=-=-=-=-=-=-=-=-'
       01  WS-MESSAGE   PIC X(23) VALUE 'DIRECT DEPOSIT PROGRAM!'


      * FLAGS
       01 WS-VAL.
          02 WS-EOF-NAMES           PIC X VALUE 'N'.
          02 WS-EOF-RATES           PIC X VALUE 'N'.
          02 WS-EOF-TAXES           PIC X VALUE 'N'.
          02 WS-OVERTIME-FL         PIC X VALUE 'N'.

      * DOLLAR AMOUNT VARIABLES TO STORE CALCULATIONS
       01 WS-AMOUNTS.
          02 GROSS-PAY         PIC 9(5)V99 VALUE ZEROS.
          02 FED-TAX           PIC 9(5)V99 VALUE ZEROS.
          02 STATE-TAX         PIC 9(5)V99 VALUE ZEROS.
          02 LOCAL-TAX         PIC 9(5)V99 VALUE ZEROS.
          02 NET-PAY           PIC 9(5)V99 VALUE ZEROS.
          02 TEMP-NET-PAY      PIC 9(5)V99 VALUE ZEROS.

      * CALS FOR OVERTIME HOURS    
       01 WS-OVERTIME-HOURS    PIC 9(3) VALUE ZEROS.
       01 WS-OVERTIME-PAY      PIC 9(5)V99 VALUE ZEROS.
        
                 
       PROCEDURE DIVISION.                                    
          
           PERFORM R1000-OPEN-DATASETS.

           DISPLAY WS-BREAKPT.
           DISPLAY WS-MESSAGE.
           DISPLAY WS-BREAKPT.


           READ FILE-RATES INTO WS-PAY-RATES
              AT END MOVE 'Y' TO WS-EOF-RATES.

           READ FILE-TAXES INTO WS-TAXES
              AT END MOVE 'Y' TO WS-EOF-TAXES.
      
      *READ THROUGH ALL NAMES AND PERFORM CALCS
           PERFORM R2000-READ-NAMES.

      *PRINT OUT OUR LOG
           PERFORM R3000-READ-LOGO.

           PERFORM R4000-CLOSE-DATASETS.
           STOP RUN.     

        R1000-OPEN-DATASETS.
           OPEN INPUT FILE-PEOPLE.
           OPEN INPUT FILE-TAXES.
           OPEN INPUT FILE-RATES.

        R2000-READ-NAMES.
           READ FILE-PEOPLE INTO WS-PERSON
                AT END MOVE 'Y' TO WS-EOF-NAMES.
           
           MOVE 'N' TO WS-OVERTIME-FL.
           MOVE ZEROS TO GROSS-PAY.
           MOVE ZEROS TO WS-OVERTIME-PAY.

           IF WS-EOF-NAMES NOT = 'Y'
              
              DISPLAY 'WORKER: ' WS-PERSON-NM.
              DISPLAY 'DOB: ' WS-BRTH-DT.
              DISPLAY 'HOURS WORKED: ' WS-HOUR-WK.

      * CHECK TO SEE IF MORE THAN 40 HOURS WORKED
              IF WS-HOUR-WK > 40
                 MOVE 'Y' TO WS-OVERTIME-FL

                 DISPLAY '> HIT FULL TIME, CALC OVERTIME'

                 COMPUTE WS-OVERTIME-HOURS = WS-HOUR-WK - 40 

                 DISPLAY 'OVERTIME HOURS: ' WS-OVERTIME-HOURS 

                 COMPUTE WS-OVERTIME-PAY = WS-OVERTIME-HOURS *
                                            WS-OVERTIME-RATE 

                 COMPUTE GROSS-PAY  = (40 * WS-HRLY-RATE) +
                                      WS-OVERTIME-PAY 

              ELSE 
                 DISPLAY '> SUB 40 HOURS, NO OVERTIME'
                 COMPUTE GROSS-PAY = WS-HOUR-WK  * WS-HRLY-RATE 
              .

      *   COMPUTE SALARY + TAX RATES
              DISPLAY 'GROSS-PAY: ' GROSS-PAY.

              COMPUTE FED-TAX  = GROSS-PAY * WS-FED-TAX.
              DISPLAY 'FED-TAX: ' FED-TAX.

              COMPUTE STATE-TAX  = GROSS-PAY * WS-STATE-TAX.
              DISPLAY 'STATE-TAX: ' STATE-TAX.
                                       
              COMPUTE LOCAL-TAX  = GROSS-PAY * WS-LOC-TAX.
              DISPLAY 'LOC-TAX: ' LOCAL-TAX.

              MOVE ZEROS TO TEMP-NET-PAY.
              MOVE ZEROS TO NET-PAY.


              COMPUTE TEMP-NET-PAY = GROSS-PAY - FED-TAX.
      *       MOVE NET-PAY TO TEMP-NET-PAY.

              COMPUTE NET-PAY = TEMP-NET-PAY - STATE-TAX.
              MOVE ZEROS TO TEMP-NET-PAY. 
              MOVE NET-PAY TO TEMP-NET-PAY.

              COMPUTE NET-PAY = TEMP-NET-PAY - LOCAL-TAX.
              MOVE ZEROS TO TEMP-NET-PAY.

      * DISPLAY NET PAY AFTER TAXES

              DISPLAY 'NET-PAY: ' NET-PAY.

              DISPLAY 'BANK ACCT INFO'.

              DISPLAY 'ROUTING NO: ' WS-ROUTE-NO.

              DISPLAY 'ACCOUNT NO: ' WS-ACCT-TYPE.

              DISPLAY 'ACCT TYPE: ' WS-ACCT-TYPE.


              DISPLAY WS-BREAKPT.
              DISPLAY ' '.
            .

        R3000-READ-LOGO.
           DISPLAY ' __     __   ___  __  ___     __   __  '.
           DISPLAY '|  \ | |__) |__  /  `  |     |  \ |__) '.
           DISPLAY '|__/ | |  \ |___ \__,  |     |__/ |    '.
           DISPLAY '                                       '.
           .
 
        R4000-CLOSE-DATASETS.
           CLOSE FILE-PEOPLE.
           CLOSE FILE-TAXES.
           CLOSE FILE-RATES.