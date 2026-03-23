# PRJ1DD - Direct Deposit Batch Program
An example of a scheduled Direct Deposit program that is resposible for paying employees. Takes input data from 3 sequential filesfiles (Names, Tax Rates, Pay Rates), calculates normal pay based on rate, determines if the employee is eligible for overtime payand witholds payroll taxes that are due. Then formats and prints out each payment calculation + account info to the sysout.

COMPILES ON MVS 3.8 TK5 - FITS COBOL 68 STANDARD

You will need to have the following folders/files created:
- PRJ1.DEV.BCOB - for source files
- PRJ1.DEV.JCL  - for jcl files
- PRJ1.DEV.COPYBOOk - for copybooks
- PRJ1.DEV.LOADLIB - for output binaries
- PRJ1.DEV.INPUT.NAMES - for input name + account info dataset
- PRJ1.DEV.INPUT.TAXES - for input tax rate dataset
- PRJ1.DEV.INPUT.RATES - for input pay rate dataset
(NOTE: if you use the 0-FULL-PRJ1-SETUP.jcl, you wont have to create all these manually)

## How to setup:
### SHORT WAY:
- copy 0-FULL-PRJ1-SETUP.jcl to your mainframe and run, it will create all the files you need
- submit the COMPILE.jcl in your PRJ1.DEV.JCL to compile
- submit the RUN.jcl in your PRJ1.DEV.JCL to run
- Voila! You can view the JES2 Output by going to 3.8 and finding your job name.

### LONG WAY: 
- create and run 0DEMOSTUP.jcl on MVS to create all the folders/input files you will need for this project
- copy NAMESC.cpy, RATESC.cpy and TAXESC.cpy to your copybooks storage
- copy NAMES to the PRJ1.DEV.INPUT.NAMES file
- copy TAXES to the PRJ1.DEV.INPUT.TAXES file
- copy RATES to the PRJ1.DEV.INPUT.RATES file
- copy 1DIRECTDP.cob to your BCOB cobol storage and name it DIRECTDP
- copy 2COMPILE.jcl to your JCL storage, name it COMPILE and submit it to compile your Direct Deposit Program
- copy 3RUN.jcl to your JCL storage and submit it to run your Direct Deposit Program
- Voila! You can view the JES2 Output by going to 3.8 and finding your job name.

## Code:
- If you want to just view the code that went into this in a more seemless manner, you can dig into the CODE folder to each component part

## Sources:
- Based on what I learned from the Mainframe Mojo Youtube Channel: https://www.youtube.com/@MainframeMojo
