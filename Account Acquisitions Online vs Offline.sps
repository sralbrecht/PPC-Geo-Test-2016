GET FILE = '/usr/spss/userdata/Albrecht/Contact LTV/Contact Acquisition and Sales History Master.sav'
   /KEEP USER_ID TO ACCT_GCOM_FPD Registration_Date TO Acq_Source Acquisition_Type Acq_MY Valid_Acq_Time Has_Purchase Valid_Post10_Acq.
CACHE.
EXE.

DATASET NAME CA.
DATASET ACTIVATE CA.

SELECT IF(Valid_Post10_Acq = 1).
EXE.

MEANS Acquisition_Date
   /CELLS MIN MAX.

FREQ Acquisition_Type.

FILTER BY Acquisition_Type.

FREQ Acq_Source.

FILTER OFF.

DATASET COPY CA_FC.
DATASET ACTIVATE CA_FC.

SELECT IF(Acquisition_Type = 1 AND Acq_MY >= 201411).
EXE.

SORT CASES BY account(A).

COMPUTE Unique = 1.
IF(account = LAG(account)) Unique = 0.
FORMATS Unique(F1.0).
EXE.

FREQ Unique.

DATASET DECLARE AA.

AGGREGATE
   /OUTFILE = 'AA'
   /BREAK = ACCOUNT Acq_Source
   /Num_Contacts = N.

DATASET ACTIVATE AA.

SORT CASES BY account(A) Acq_Source(D).

SELECT IF(Unique = 1).
EXE.

FREQ Acq_Source.
