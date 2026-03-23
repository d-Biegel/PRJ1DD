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