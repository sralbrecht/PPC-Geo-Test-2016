/*Account registration and first purchase date from HYB*/.
GET DATA
   /TYPE = ODBC
   /CONNECT = 'DSN=GCOMPROD;Host=pr01-scan.db.grainger.com;Port=1521;SN=PRTGCOM;UID=ROUSER;PWD=!_*u,'+
    'V-R#I!`'
   /SQL =   'SELECT ' +
                    'nvl(substr(A.SAP_ID,2,9),''0'') ACCT, ' +
                    'trunc(A.ACCOUNTREGISTRATIONDATE) REG_DATE, ' +
                    'trunc(FO.FIRST_ORDER_DT) FO_DATE ' +
                 'FROM HBADMIN.HB_ACCOUNTS A, HBADMIN.HB_ACCOUNT_FIRST_ORDER_DT_V FO ' +
                 'WHERE A.PK = FO.PK '.
CACHE.
EXE.

DATASET NAME HYB_AD.
DATASET ACTIVATE HYB_AD.

ALTER TYPE ACCT(F10.0) REG_DATE(DATE11) FO_DATE(DATE11).

RENAME VARIABLES ACCT = account REG_DATE = Gcom_Reg_Date FO_Date = Gcom_FO_Date.

SORT CASES BY account(A).

SELECT IF(account > 800000000 AND account <= 899999999).
EXE.

DO IF(MISSING(Gcom_Reg_Date) = 1 AND MISSING(Gcom_FO_Date) = 0).

   COMPUTE Gcom_Acq_Date = Gcom_FO_Date.

ELSE IF(MISSING(Gcom_Reg_Date) = 0 AND MISSING(Gcom_FO_Date) = 1).

   COMPUTE Gcom_Acq_Date = Gcom_Reg_Date.

ELSE IF(MISSING(Gcom_Reg_Date) = 0 AND MISSING(Gcom_FO_Date) = 0).

   COMPUTE Gcom_Acq_Date = MIN(Gcom_Reg_Date,Gcom_FO_Date).

END IF.
FORMATS Gcom_Acq_Date(DATE11).
EXE.

DELETE VARIABLES Gcom_Reg_Date Gcom_FO_Date.


SELECT IF(account <> 222222226).
EXE.

COMPUTE Recent_Acq = (CREATE_DATE >= DATE.MDY(6,1,2015)).
FORMATS Recent_Acq(F1.0).
EXE.

FREQ Recent_Acq.

FILTER BY Recent_Acq.

COMPUTE FPD_Before_CD = (FPD < CREATE_DATE).
FORMATS FPD_Before_CD(F1.0).

COMPUTE Missing_FPD = MISSING(FPD).
FORMATS Missing_FPD(F1.0).
EXE.

FREQ FPD_Before_CD.
FREQ Missing_FPD.

FILTER OFF.

DATASET NAME SLS_BY_AZ.
CACHE.
EXE.

SORT CASES BY account(A).

MATCH FILES
   /FILE = *
   /TABLE = 'HYB_AD'
   /BY account.
EXE.


DATASET COPY TEST_DMAS.
DATASET ACTIVATE TEST_DMAS.

SELECT IF(Group > 0).
EXE.

FILTER BY Include.

COMPUTE TP_ACQ = SUM(WK1_ACQ TO WK7_ACQ).
FORMATS TP_ACQ(F1.0).

COMPUTE TP_PY_GC_ACQ = 0.
IF(TP_PY_ACQ = 1 AND Gcom_Acq_Date <= CREATE_DATE) TP_PY_GC_ACQ = 1.
FORMATS TP_PY_GC_ACQ(F1.0).

COMPUTE TP_GC_ACQ = 0.
IF(TP_ACQ = 1 AND Gcom_Acq_Date <= CREATE_DATE) TP_GC_ACQ = 1.
FORMATS TP_GC_ACQ(F1.0).
EXE.

MEANS TP_PY_ACQ TP_ACQ BY Group
   /CELLS SUM.

MEANS TP_PY_GC_ACQ TP_GC_ACQ BY Group
   /CELLS SUM.



