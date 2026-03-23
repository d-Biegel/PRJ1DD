//SETUPDV JOB  (SETUP),                                               
//             'SETUP DIRECTDP',                                      
//             CLASS=A,                                               
//             MSGCLASS=X,                                            
//             MSGLEVEL=(0,0),                                        
//             NOTIFY=&SYSUID                                         
//********************************************************************
//*                                                                   
//* JOBNAME SETUPDV                                                   
//*                                                                   
//* DESC: SEVERAL STEPS TO ALLOCATE PARTITION DATA SETS               
//*                                                                   
//********************************************************************
//STEP01  EXEC PGM=IEFBR14                                            
//ALLOC1   DD  DSN=PRJ1.DEV.BCOB,                                  
//             DISP=(NEW,CATLG,DELETE),                               
//             UNIT=TSO,                                              
//             SPACE=(CYL,(1,1,15),RLSE),                             
//             DCB=(LRECL=80,RECFM=FB,BLKSIZE=27920,DSORG=PO)         
//SYSPRINT DD  SYSOUT=*                                               
//SYSOUT   DD  SYSOUT=*                                               
//*                                                                  
//STEP02  EXEC PGM=IEFBR14                                            
//ALLOC2   DD  DSN=PRJ1.DEV.COPYBOOK,                              
//             DISP=(NEW,CATLG,DELETE),                               
//             UNIT=TSO,                                              
//             SPACE=(CYL,(1,1,15),RLSE),                             
//             DCB=(LRECL=80,RECFM=FB,BLKSIZE=27920,DSORG=PO)         
//SYSPRINT DD  SYSOUT=*                                               
//SYSOUT   DD  SYSOUT=*                                               
//*                                                                  
//STEP03  EXEC PGM=IEFBR14                                            
//ALLOC3   DD  DSN=PRJ1.DEV.JCL,                                   
//             DISP=(NEW,CATLG,DELETE),                               
//             UNIT=TSO,                                              
//             SPACE=(CYL,(1,1,15),RLSE),                             
//             DCB=(LRECL=80,RECFM=FB,BLKSIZE=27920,DSORG=PO)         
//SYSPRINT DD  SYSOUT=*                                               
//SYSOUT   DD  SYSOUT=*                                               
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
//* INPUT FILES (SEQUENTIAL, 80 BYTE RECORDS)                         
//********************************************************************
//STEP05  EXEC PGM=IEFBR14                                            
//INFILE1  DD  DSN=PRJ1.DEV.INPUT.NAMES,                                
//             DISP=(NEW,CATLG,DELETE),                               
//             UNIT=TSO,                                              
//             SPACE=(CYL,(1,1),RLSE),                                
//             DCB=(LRECL=80,RECFM=FB,BLKSIZE=27920,DSORG=PS)         
//SYSPRINT DD  SYSOUT=*                                               
//SYSOUT   DD  SYSOUT=*                                               
//*                                                                  
//STEP06  EXEC PGM=IEFBR14                                            
//INFILE2  DD  DSN=PRJ1.DEV.INPUT.TAXES,                                
//             DISP=(NEW,CATLG,DELETE),                               
//             UNIT=TSO,                                              
//             SPACE=(CYL,(1,1),RLSE),                                
//             DCB=(LRECL=80,RECFM=FB,BLKSIZE=27920,DSORG=PS)         
//SYSPRINT DD  SYSOUT=*                                               
//SYSOUT   DD  SYSOUT=*                                               
//*                                                                  
//STEP07  EXEC PGM=IEFBR14                                            
//INFILE2  DD  DSN=PRJ1.DEV.INPUT.RATES,                             
//             DISP=(NEW,CATLG,DELETE),                               
//             UNIT=TSO,                                              
//             SPACE=(CYL,(1,1),RLSE),                                
//             DCB=(LRECL=80,RECFM=FB,BLKSIZE=27920,DSORG=PS)         
//SYSPRINT DD  SYSOUT=*                                               
//SYSOUT   DD  SYSOUT=*                                               
//*                                                                  
//********************************************************************
//* OUTPUT FILE (SEQUENTIAL, 80 BYTE RECORDS)                         
//********************************************************************
//* //STEP08  EXEC PGM=IEFBR14                                            
//* //OUTFILE  DD  DSN=PRJ1.DEV.OUTPUT1,                               
//* //             DISP=(NEW,CATLG,DELETE),                               
//* //             UNIT=TSO,                                              
//* //             SPACE=(CYL,(2,2),RLSE),                                
//* //             DCB=(LRECL=80,RECFM=FB,BLKSIZE=27920,DSORG=PS)         
//* //SYSPRINT DD  SYSOUT=*                                               
//* //SYSOUT   DD  SYSOUT=*                                               
//*                                                                  
