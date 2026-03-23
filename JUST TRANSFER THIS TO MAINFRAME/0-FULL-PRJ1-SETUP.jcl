//FULLP1 JOB  (SETUP),                                               
//             'FULL PRJ1 STUP',                                      
//             CLASS=A,                                               
//             MSGCLASS=X,                                            
//             MSGLEVEL=(0,0),                                        
//             NOTIFY=&SYSUID                                         
//********************************************************************
//*   -----------------    FULL PRJ1 FILE SETUP    ----------------- 
//********************************************************************
//* DELETE PRIOR VERSIONS OF SOURCE AND OBJECT DATASETS               *
//*********************************************************************
//*                                                          
//IDCAMS  EXEC PGM=IDCAMS,REGION=1024K                       
//SYSPRINT DD  SYSOUT=*                                      
//SYSIN    DD  *                                             
    DELETE PRJ1.DEV.BCOB NONVSAM SCRATCH PURGE               
    DELETE PRJ1.DEV.COPYBOOK NONVSAM SCRATCH PURGE           
    DELETE PRJ1.DEV.JCL NONVSAM SCRATCH PURGE                
    DELETE PRJ1.DEV.LOADLIB NONVSAM SCRATCH PURGE 
    DELETE PRJ1.DEV.INPUT.RATES NONVSAM                                 
    DELETE PRJ1.DEV.INPUT.TAXES NONVSAM                
    DELETE PRJ1.DEV.INPUT.NAMES NONVSAM                
    SET MAXCC=0
/*                                                           
//*   
//*********************************************************************
//* CREATE A PDS WITH PROGRAM SOURCE                                  *
//*********************************************************************
//*                                                                    
//STEP01 EXEC PGM=IEBUPDTE,REGION=1024K,PARM=NEW                      
//SYSPRINT DD  SYSOUT=*                                                 
//*                                                                     
//SYSUT2   DD  DSN=PRJ1.DEV.BCOB,DISP=(,CATLG,DELETE),             
//             UNIT=TSO,SPACE=(TRK,(15,,2)),                            
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=800)                      
//SYSPRINT DD  SYSOUT=*                                                 
//SYSIN    DD  DATA,DLM='><'                                            
./ ADD NAME=DIRECTDP,LIST=ALL                      
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
      *  DAN BIEG   23MAR2026 FIX COMPILE ISSUES + CLEANUP
      **************************************************************
       IDENTIFICATION DIVISION.                  
      **************************************************************

       PROGRAM-ID. DIRECTDP.  

      **************************************************************
       ENVIRONMENT DIVISION.
      **************************************************************
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. IBM-370.
       OBJECT-COMPUTER. IBM-370. 

       INPUT-OUTPUT SECTION.

       FILE-CONTROL.                                                    
           SELECT FILE-PEOPLE ASSIGN TO UT-S-NAMES.  
           SELECT FILE-TAXES ASSIGN TO UT-S-TAXES.
           SELECT FILE-RATES ASSIGN TO UT-S-RATES.

      **************************************************************
       DATA DIVISION.       
      **************************************************************

       FILE SECTION.                                                    
       FD     FILE-PEOPLE                                            
              LABEL RECORDS ARE OMITTED                                 
              BLOCK CONTAINS 0 RECORDS  
              DATA RECORD IS FIL-PEOPLE. 

       01  FIL-PEOPLE PIC X(80).                                        
                      
      *   ------------
  

       FD     FILE-TAXES        
              LABEL RECORDS ARE OMITTED            
              BLOCK CONTAINS 0 RECORDS               
              DATA RECORD IS FIL-TAXES. 
       
       01  FIL-TAXES PIC X(80).                 
       
      *   ------------


       FD     FILE-RATES
              LABEL RECORDS ARE OMITTED
              BLOCK CONTAINS 0 RECORDS
              DATA RECORD IS FIL-RATES.

       01  FIL-RATES PIC X(80).


       WORKING-STORAGE SECTION. 
      * USE THE COPYBOOK              
       01  WS-PERSON COPY NAMESC.
       01  WS-PAY-RATES COPY RATESC.
       01  WS-TAXES COPY TAXESC.


       01  WS-BREAKPT   PIC X(23) VALUE '-=-=-=-=-=-=-=-=-=-=-=-'.
       01  WS-MESSAGE   PIC X(23) VALUE 'DIRECT DEPOSIT PROGRAM!'.
       01  WS-FULL-LINE PIC X(50) VALUE ALL '*'.


      * FLAGS
       01  WS-VAL.
           02 WS-EOF-NAMES           PIC X VALUE 'N'.
           02 WS-EOF-RATES           PIC X VALUE 'N'.
           02 WS-EOF-TAXES           PIC X VALUE 'N'.
           02 WS-OVERTIME-FL         PIC X VALUE 'N'.

      * DOLLAR AMOUNT VARIABLES TO STORE CALCULATIONS
       01  WS-AMOUNTS.
           02 GROSS-PAY         PIC 9(5)V99 VALUE ZEROS.
           02 FED-TAX           PIC 9(5)V99 VALUE ZEROS.
           02 STATE-TAX         PIC 9(5)V99 VALUE ZEROS.
           02 LOCAL-TAX         PIC 9(5)V99 VALUE ZEROS.
           02 NET-PAY           PIC 9(5)V99 VALUE ZEROS.
           02 TEMP-NET-PAY      PIC 9(5)V99 VALUE ZEROS.

      * CALS FOR OVERTIME HOURS    
       01  WS-OVERTIME-HOURS    PIC 9(3) VALUE ZEROS.
       01  WS-OVERTIME-PAY      PIC 9(5)V99 VALUE ZEROS.
        
                 
      **************************************************************
       PROCEDURE DIVISION.                                    
      **************************************************************
          
           PERFORM R1000-OPEN-DATASETS.

           DISPLAY WS-FULL-LINE.
           DISPLAY WS-MESSAGE.
      *PRINT OUT OUR LOG
           PERFORM R3000-READ-LOGO.
           DISPLAY WS-FULL-LINE.
           
      *LOAD FIRST ENTRY
           PERFORM R1100-READ-REC-ENTRY.

           READ FILE-RATES INTO WS-PAY-RATES
              AT END MOVE 'Y' TO WS-EOF-RATES.

           READ FILE-TAXES INTO WS-TAXES
              AT END MOVE 'Y' TO WS-EOF-TAXES.
      
      *READ THROUGH ALL NAMES AND PERFORM CALCS
           PERFORM R2000-READ-NAMES
              UNTIL WS-EOF-NAMES = 'Y'.

           DISPLAY WS-FULL-LINE.
           DISPLAY ' -- HIT END OF NAMES, EXITING... -- '
           DISPLAY WS-FULL-LINE.

           PERFORM R4000-CLOSE-DATASETS.
           STOP RUN.     

      * ---
        R1000-OPEN-DATASETS.
      * ---
           OPEN INPUT FILE-PEOPLE.
           OPEN INPUT FILE-TAXES.
           OPEN INPUT FILE-RATES.

      *  ------
        R1100-READ-REC-ENTRY.
      *  ------
           READ FILE-PEOPLE INTO WS-PERSON 
                 AT END MOVE 'Y' TO WS-EOF-NAMES.
      * ---
        R2000-READ-NAMES.
      * ---
      *    READ FILE-PEOPLE INTO WS-PERSON
      *         AT END MOVE 'Y' TO WS-EOF-NAMES.
           
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

              DISPLAY 'ACCOUNT NO: ' WS-ACCT-NO.

              DISPLAY 'ACCT TYPE: ' WS-ACCT-TYPE.

              DISPLAY WS-BREAKPT.

              DISPLAY ' '.

      * NEXT ENTRY
              PERFORM R1100-READ-REC-ENTRY.
            .
      * ---
        R3000-READ-LOGO.
      * ---
           DISPLAY ' __     __   ___  __  ___     __   __  '.
           DISPLAY '|  \ | |__) |__  /  `  |     |  \ |__) '.
           DISPLAY '|__/ | |  \ |___ \__,  |     |__/ |    '.
           DISPLAY '                                       '.
 
      * ---
        R4000-CLOSE-DATASETS.
      * ---
           CLOSE FILE-PEOPLE.
           CLOSE FILE-TAXES.
           CLOSE FILE-RATES.
./ ENDUP 
><       
/*  
//*********************************************************************
//* CREATE A PDS WITH COPYBOOKS                                       *
//*********************************************************************
//*                                                                    
//STEP02 EXEC PGM=IEBUPDTE,REGION=1024K,PARM=NEW                     
//SYSPRINT DD  SYSOUT=*                                                
//*                                                                    
//SYSUT2   DD  DSN=PRJ1.DEV.COPYBOOK,DISP=(,CATLG,DELETE),            
//             UNIT=TSO,SPACE=(TRK,(15,,2)),                           
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=800)                     
//SYSPRINT DD  SYSOUT=*                                                
//SYSIN    DD  DATA,DLM='><'                                           
./ ADD NAME=NAMESC,LIST=ALL                                           
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
./ ADD NAME=RATESC,LIST=ALL 
      *****************************************************************
      * FILE: RATESC.CPY                                              *
      * RECORD LENGTH: 80 BYTES                                       *
      *****************************************************************
       01  RATES-COPYBOOK-RECORD.     
           02 WS-HRLY-RATE        PIC 9(3)V99.
           02 FILLER              PIC X.
           02 WS-OVERTIME-RATE    PIC 9(3)V99.
           02 FILLER              PIC X(69).
./ ADD NAME=TAXESC,LIST=ALL
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
./ ENDUP 
><       
/*  
//*********************************************************************
//* CREATE A PDS WITH JCL                                             *
//*********************************************************************
//*                                                                    
//STEP03 EXEC PGM=IEBUPDTE,REGION=1024K,PARM=NEW                     
//SYSPRINT DD  SYSOUT=*                                                
//*                                                                    
//SYSUT2   DD  DSN=PRJ1.DEV.JCL,DISP=(,CATLG,DELETE),            
//             UNIT=TSO,SPACE=(TRK,(15,,2)),                           
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=800)                     
//SYSPRINT DD  SYSOUT=*                                                
//SYSIN    DD  DATA,DLM='><'                                           
./ ADD NAME=COMPILE,LIST=ALL  
//CMPDIRDP JOB (001),'COMPILE DIRECTDP',                            
//             CLASS=A,MSGCLASS=X,MSGLEVEL=(1,1),                     
//             NOTIFY=&SYSUID                                   
//********************************************************************
//* STEP 1: COMPILE THE COBOL PROGRAM                                 
//********************************************************************
//COBSTEP EXEC PGM=IKFCBL00,REGION=4096K,                             
//             PARM='LIB,LOAD,LIST,NOSEQ,SIZE=2048K,BUF=1024K'        
//STEPLIB  DD DSN=SYS1.COBLIB,DISP=SHR                                
//SYSLIB   DD DSN=PRJ1.DEV.COPYBOOK,DISP=SHR                         
//SYSIN    DD DSN=PRJ1.DEV.BCOB(DIRECTDP),DISP=SHR                 
//SYSPRINT DD SYSOUT=*                                                
//SYSPUNCH DD SYSOUT=B                                                
//SYSLIN   DD DSN=&&LOADSET,UNIT=SYSDA,DISP=(MOD,PASS),               
//            SPACE=(80,(500,100))                                    
//SYSUT1   DD UNIT=SYSDA,SPACE=(460,(700,100))                        
//SYSUT2   DD UNIT=SYSDA,SPACE=(460,(700,100))                        
//SYSUT3   DD UNIT=SYSDA,SPACE=(460,(700,100))                        
//SYSUT4   DD UNIT=SYSDA,SPACE=(460,(700,100))                        
//********************************************************************
//* STEP 2: LINK-EDIT THE OBJECT CODE                                 
//********************************************************************
//LKED    EXEC PGM=IEWL,REGION=256K,PARM='LIST,XREF,LET',             
//             COND=(5,LT,COBSTEP)                                    
//SYSLIN   DD DSN=&&LOADSET,DISP=(OLD,DELETE)                         
//         DD DDNAME=SYSIN                                            
//SYSLMOD  DD DSN=PRJ1.DEV.LOADLIB(DIRECTDP),DISP=SHR              
//SYSUT1   DD UNIT=SYSDA,SPACE=(1024,(50,20))                      
//SYSPRINT DD SYSOUT=*                                                
//SYSLIB   DD DSN=SYS1.COBLIB,DISP=SHR                                
//SYSIN    DD DUMMY                                                   
//                                                                    
./ ADD NAME=RUN,LIST=ALL  
//RUNDRTDP JOB  'RUN DIRECTDP',          
//        CLASS=A,
//        MSGCLASS=X,
//        MSGLEVEL=(1,1),                            
//        NOTIFY=&SYSUID               
//********************************************************************
//STEP1    EXEC PGM=DIRECTDP             
//STEPLIB  DD DSN=PRJ1.DEV.LOADLIB,DISP=SHR 
//NAMES  DD DSN=PRJ1.DEV.INPUT.NAMES,DISP=SHR   
//RATES  DD DSN=PRJ1.DEV.INPUT.RATES,DISP=SHR   
//TAXES DD DSN=PRJ1.DEV.INPUT.TAXES,DISP=SHR 
//SYSOUT   DD SYSOUT=*      
//
./ ENDUP 
><       
/*  
//*                                                                  
//********************************************************************
//* SETUP YOUR LOADLIB NOTE RECFM=U                                   
//********************************************************************
//STEP04  EXEC PGM=IEFBR14                                            
//ALLOC4   DD  DSN=PRJ1.DEV.LOADLIB,                               
//             DISP=(NEW,CATLG,DELETE),                               
//             UNIT=TSO,                                              
//             SPACE=(CYL,(5,5,15),RLSE),                             
//             DCB=(LRECL=0,RECFM=U,BLKSIZE=6144,DSORG=PO)            
//SYSPRINT DD  SYSOUT=*                                               
//SYSOUT   DD  SYSOUT=*                                               
//*                                                                  
//********************************************************************
//* CREATE INPUT FILES (SEQUENTIAL, 80 BYTE RECORDS)                         
//********************************************************************
//* NAMES
//STEP05 EXEC PGM=IEBGENER,REGION=128K                      
//SYSIN    DD  DUMMY                                           
//SYSPRINT DD  SYSOUT=*                                        
//*                                                            
//SYSUT2   DD  DSN=PRJ1.DEV.INPUT.NAMES,DISP=(,CATLG,DELETE),  
//             UNIT=TSO,SPACE=(CYL,(1,1),RLSE),          
//             DCB=(LRECL=80,RECFM=FB,BLKSIZE=27920,DSORG=PS)     
//SYSUT1   DD  *                                                  
MICHAEL JONES       1963-05-02 080 8675309 9035768 CHCK                         
JOHN SMITH          1972-02-04 046 3712743 6362513 SAVE                         
CAROL MARCUS        1981-05-06 078 8736631 8372763 CHCK                         
JEREMY POWELL       1900-03-02 032 4732623 4323132 SAVE                         
SARAH WILLIAMS      1978-11-15 055 5551234 7654321 CHCK                         
ROBERT ANDERSON     1985-07-22 091 8889876 3456789 SAVE                         
PATRICIA DAVIS      1969-03-18 067 7772345 8901234 CHCK                         
DAVID MARTINEZ      1992-09-30 104 6663456 4567890 SAVE                         
JENNIFER GARCIA     1975-12-08 042 4445678 1234567 CHCK                         
WILLIAM RODRIGUEZ   1988-01-25 088 3334567 9876543 SAVE                         
ELIZABETH WILSON    1965-06-14 073 2228901 2345678 CHCK                         
JAMES TAYLOR        1990-04-03 099 1112345 8765432 SAVE                         
MARY THOMAS         1973-08-19 051 9998765 3210987 CHCK                         
RICHARD MOORE       1982-10-27 086 8887654 6543210 SAVE                         
LINDA JACKSON       1971-02-11 038 7776543 7890123 CHCK                         
CHARLES WHITE       1995-05-16 112 6665432 4321098 SAVE                         
BARBARA HARRIS      1968-07-29 063 5554321 8901234 CHCK                         
THOMAS MARTIN       1987-12-05 095 4443210 5432109 SAVE                         
SUSAN THOMPSON      1976-09-23 048 3332109 9012345 CHCK                         
DANIEL LEE          1991-03-12 102 2221098 6789012 SAVE                         
/*                                                       
//SYSOUT   DD  SYSOUT=*                                   
//* RATES
//STEP06 EXEC PGM=IEBGENER,REGION=128K                      
//SYSIN    DD  DUMMY                                           
//SYSPRINT DD  SYSOUT=*                                        
//*                                                            
//SYSUT2   DD  DSN=PRJ1.DEV.INPUT.RATES,DISP=(,CATLG,DELETE),  
//             UNIT=TSO,SPACE=(CYL,(1,1),RLSE),          
//             DCB=(LRECL=80,RECFM=FB,BLKSIZE=27920,DSORG=PS)     
//SYSUT1   DD  *                                                  
01545 02257                                                                     
/*                                                       
//SYSOUT   DD  SYSOUT=*                                   
//* TAXES
//STEP07 EXEC PGM=IEBGENER,REGION=128K                      
//SYSIN    DD  DUMMY                                           
//SYSPRINT DD  SYSOUT=*                                        
//*                                                            
//SYSUT2   DD  DSN=PRJ1.DEV.INPUT.TAXES,DISP=(,CATLG,DELETE),  
//             UNIT=TSO,SPACE=(CYL,(1,1),RLSE),          
//             DCB=(LRECL=80,RECFM=FB,BLKSIZE=27920,DSORG=PS)     
//SYSUT1   DD  *                                                  
013 008 003                                                                     
/*                                                       
//SYSOUT   DD  SYSOUT=*                                  