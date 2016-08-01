/*PULL TOTAL SALES AND ORDERS BY DATE AND ZIPCODE*/.

***DEC 15***.
GET DATA 
  /TYPE=ODBC 
  /CONNECT='DSN=Teradata;DB=PRD_DWH_VIEW;PORT=1025;DBCNL=10.4.165.29;UID=spss;PWD=$-<~*x#N3@!/-!!+'
  /SQL='SELECT '+
             '  SI.ZORD_DATE ORD_DATE, '+
             '  CC.ZIPCODE ZIP, '+
             '  COUNT(DISTINCT SI.S_ORD_NUM) ORDERS, '+
             '  SUM(SI.SUBTOTAL_2) SALES '+
          'FROM '+
             '  PRD_DWH_VIEW.Sales_Invoice_V SI '+
          'LEFT JOIN PRD_DWH_VIEW.CUSTOMER_CURRENT_V CC '+
             '  ON CC.CUSTOMER = SI.SOLD_TO '+
          'WHERE '+
             '  SI.ZPOSTSTAT=''C'' '+
             '  AND SI.COMP_CODE = ''0300'' '+
             '  AND SI.ACCNT_ASGN <> ''12'' '+
             '  AND SI.ZORD_DATE >= {d ''2015-12-01''} '+
             '  AND SI.ZORD_DATE <= {d ''2015-12-31''} '+
             '  AND SI.SHIP_COND <> ''RE'' ' +
             '  AND SI.SUBTOTAL_2 > 0 ' +
          'GROUP BY '+
             '  1, 2'.
CACHE.
EXE.

DATASET NAME DEC15.
DATASET ACTIVATE DEC15.

*Get the first 5 characters of zipcode.
STRING ZIP5(A5).
COMPUTE ZIP5 = SUBSTR(ZIP,1,5).
EXE.

*Aggregate the sales and orders by the 5 digit zipcode.
DATASET DECLARE DEC15_2.

AGGREGATE
   /OUTFILE = 'DEC15_2'
   /BREAK = ORD_DATE ZIP5
   /SALES = SUM(SALES)
   /ORDERS = SUM(ORDERS).

DATASET CLOSE DEC15.
DATASET ACTIVATE DEC15_2.
DATASET NAME DEC15.

***JAN 16***.
GET DATA 
  /TYPE=ODBC 
  /CONNECT='DSN=Teradata;DB=PRD_DWH_VIEW;PORT=1025;DBCNL=10.4.165.29;UID=spss;PWD=$-<~*x#N3@!/-!!+'
  /SQL='SELECT '+
             '  SI.ZORD_DATE ORD_DATE, '+
             '  CC.ZIPCODE ZIP, '+
             '  COUNT(DISTINCT SI.S_ORD_NUM) ORDERS, '+
             '  SUM(SI.SUBTOTAL_2) SALES '+
          'FROM '+
             '  PRD_DWH_VIEW.Sales_Invoice_V SI '+
          'LEFT JOIN PRD_DWH_VIEW.CUSTOMER_CURRENT_V CC '+
             '  ON CC.CUSTOMER = SI.SOLD_TO '+
          'WHERE '+
             '  SI.ZPOSTSTAT=''C'' '+
             '  AND SI.COMP_CODE = ''0300'' '+
             '  AND SI.ACCNT_ASGN <> ''12'' '+
             '  AND SI.ZORD_DATE >= {d ''2016-01-01''} '+
             '  AND SI.ZORD_DATE <= {d ''2016-01-31''} '+
             '  AND SI.SHIP_COND <> ''RE'' ' +
             '  AND SI.SUBTOTAL_2 > 0 ' +
          'GROUP BY '+
             '  1, 2'.
CACHE.
EXE.

DATASET NAME JAN16.
DATASET ACTIVATE JAN16.

*Get the first 5 characters of zipcode.
STRING ZIP5(A5).
COMPUTE ZIP5 = SUBSTR(ZIP,1,5).
EXE.

*Aggregate the sales and orders by the 5 digit zipcode.
DATASET DECLARE JAN16_2.

AGGREGATE
   /OUTFILE = 'JAN16_2'
   /BREAK = ORD_DATE ZIP5
   /SALES = SUM(SALES)
   /ORDERS = SUM(ORDERS).

DATASET CLOSE JAN16.
DATASET ACTIVATE JAN16_2.
DATASET NAME JAN16.

***FEB 16***.
GET DATA 
  /TYPE=ODBC 
  /CONNECT='DSN=Teradata;DB=PRD_DWH_VIEW;PORT=1025;DBCNL=10.4.165.29;UID=spss;PWD=$-<~*x#N3@!/-!!+'
  /SQL='SELECT '+
             '  SI.ZORD_DATE ORD_DATE, '+
             '  CC.ZIPCODE ZIP, '+
             '  COUNT(DISTINCT SI.S_ORD_NUM) ORDERS, '+
             '  SUM(SI.SUBTOTAL_2) SALES '+
          'FROM '+
             '  PRD_DWH_VIEW.Sales_Invoice_V SI '+
          'LEFT JOIN PRD_DWH_VIEW.CUSTOMER_CURRENT_V CC '+
             '  ON CC.CUSTOMER = SI.SOLD_TO '+
          'WHERE '+
             '  SI.ZPOSTSTAT=''C'' '+
             '  AND SI.COMP_CODE = ''0300'' '+
             '  AND SI.ACCNT_ASGN <> ''12'' '+
             '  AND SI.ZORD_DATE >= {d ''2016-02-01''} '+
             '  AND SI.ZORD_DATE <= {d ''2016-02-29''} '+
             '  AND SI.SHIP_COND <> ''RE'' ' +
             '  AND SI.SUBTOTAL_2 > 0 ' +
          'GROUP BY '+
             '  1, 2'.
CACHE.
EXE.

DATASET NAME FEB16.
DATASET ACTIVATE FEB16.

*Get the first 5 characters of zipcode.
STRING ZIP5(A5).
COMPUTE ZIP5 = SUBSTR(ZIP,1,5).
EXE.

*Aggregate the sales and orders by the 5 digit zipcode.
DATASET DECLARE FEB16_2.

AGGREGATE
   /OUTFILE = 'FEB16_2'
   /BREAK = ORD_DATE ZIP5
   /SALES = SUM(SALES)
   /ORDERS = SUM(ORDERS).

DATASET CLOSE FEB16.
DATASET ACTIVATE FEB16_2.
DATASET NAME FEB16.

ADD FILES
   /FILE = *
   /FILE = 'JAN16'
   /FILE = 'DEC15'.
EXE.

DATASET CLOSE DEC15.
DATASET CLOSE JAN16.
DATASET ACTIVATE FEB16.
DATASET NAME TS.

SORT CASES BY ORD_DATE(A) ZIP5(A).

/*PULL GCOM SALES AND ORDERS BY DATE AND ZIPCODE*/.

***DEC 15***.
GET DATA 
  /TYPE=ODBC 
  /CONNECT='DSN=Teradata;DB=PRD_DWH_VIEW;PORT=1025;DBCNL=10.4.165.29;UID=spss;PWD=$-<~*x#N3@!/-!!+'
  /SQL='SELECT '+
             '  SI.ZORD_DATE ORD_DATE, '+
             '  CC.ZIPCODE ZIP, '+
             '  COUNT(DISTINCT SI.S_ORD_NUM) ORDERS, '+
             '  SUM(SI.SUBTOTAL_2) SALES '+
          'FROM '+
             '  PRD_DWH_VIEW.Sales_Invoice_V SI '+
          'LEFT JOIN PRD_DWH_VIEW.CUSTOMER_CURRENT_V CC '+
             '  ON CC.CUSTOMER = SI.SOLD_TO '+
          'WHERE '+
             '  SI.ZPOSTSTAT=''C'' '+
             '  AND SI.COMP_CODE = ''0300'' '+
             '  AND SI.ACCNT_ASGN <> ''12'' '+
             '  AND SI.ZORD_DATE >= {d ''2015-12-01''} '+
             '  AND SI.ZORD_DATE <= {d ''2015-12-31''} '+
             '  AND SI.SHIP_COND <> ''RE'' ' +
             '  AND SI.SUBTOTAL_2 > 0 ' +
             '  AND SI.SALES_OFF IN(''E01'',''E02'',''E03'',''E04'',''E05'',''E06'',''E07'',''E12'') ' +
          'GROUP BY '+
             '  1, 2'.
CACHE.
EXE.

DATASET NAME GC_DEC15.
DATASET ACTIVATE GC_DEC15.

*Get the first 5 characters of zipcode.
STRING ZIP5(A5).
COMPUTE ZIP5 = SUBSTR(ZIP,1,5).
EXE.

*Aggregate the sales and orders by the 5 digit zipcode.
DATASET DECLARE GC_DEC15_2.

AGGREGATE
   /OUTFILE = 'GC_DEC15_2'
   /BREAK = ORD_DATE ZIP5
   /SALES = SUM(SALES)
   /ORDERS = SUM(ORDERS).

DATASET CLOSE GC_DEC15.
DATASET ACTIVATE GC_DEC15_2.
DATASET NAME GC_DEC15.

***JAN 16***.
GET DATA 
  /TYPE=ODBC 
  /CONNECT='DSN=Teradata;DB=PRD_DWH_VIEW;PORT=1025;DBCNL=10.4.165.29;UID=spss;PWD=$-<~*x#N3@!/-!!+'
  /SQL='SELECT '+
             '  SI.ZORD_DATE ORD_DATE, '+
             '  CC.ZIPCODE ZIP, '+
             '  COUNT(DISTINCT SI.S_ORD_NUM) ORDERS, '+
             '  SUM(SI.SUBTOTAL_2) SALES '+
          'FROM '+
             '  PRD_DWH_VIEW.Sales_Invoice_V SI '+
          'LEFT JOIN PRD_DWH_VIEW.CUSTOMER_CURRENT_V CC '+
             '  ON CC.CUSTOMER = SI.SOLD_TO '+
          'WHERE '+
             '  SI.ZPOSTSTAT=''C'' '+
             '  AND SI.COMP_CODE = ''0300'' '+
             '  AND SI.ACCNT_ASGN <> ''12'' '+
             '  AND SI.ZORD_DATE >= {d ''2016-01-01''} '+
             '  AND SI.ZORD_DATE <= {d ''2016-01-31''} '+
             '  AND SI.SHIP_COND <> ''RE'' ' +
             '  AND SI.SUBTOTAL_2 > 0 ' +
             '  AND SI.SALES_OFF IN(''E01'',''E02'',''E03'',''E04'',''E05'',''E06'',''E07'',''E12'') ' +
          'GROUP BY '+
             '  1, 2'.
CACHE.
EXE.

DATASET NAME GC_JAN16.
DATASET ACTIVATE GC_JAN16.

*Get the first 5 characters of zipcode.
STRING ZIP5(A5).
COMPUTE ZIP5 = SUBSTR(ZIP,1,5).
EXE.

*Aggregate the sales and orders by the 5 digit zipcode.
DATASET DECLARE GC_JAN16_2.

AGGREGATE
   /OUTFILE = 'GC_JAN16_2'
   /BREAK = ORD_DATE ZIP5
   /SALES = SUM(SALES)
   /ORDERS = SUM(ORDERS).

DATASET CLOSE GC_JAN16.
DATASET ACTIVATE GC_JAN16_2.
DATASET NAME GC_JAN16.

***FEB 16***.
GET DATA 
  /TYPE=ODBC 
  /CONNECT='DSN=Teradata;DB=PRD_DWH_VIEW;PORT=1025;DBCNL=10.4.165.29;UID=spss;PWD=$-<~*x#N3@!/-!!+'
  /SQL='SELECT '+
             '  SI.ZORD_DATE ORD_DATE, '+
             '  CC.ZIPCODE ZIP, '+
             '  COUNT(DISTINCT SI.S_ORD_NUM) ORDERS, '+
             '  SUM(SI.SUBTOTAL_2) SALES '+
          'FROM '+
             '  PRD_DWH_VIEW.Sales_Invoice_V SI '+
          'LEFT JOIN PRD_DWH_VIEW.CUSTOMER_CURRENT_V CC '+
             '  ON CC.CUSTOMER = SI.SOLD_TO '+
          'WHERE '+
             '  SI.ZPOSTSTAT=''C'' '+
             '  AND SI.COMP_CODE = ''0300'' '+
             '  AND SI.ACCNT_ASGN <> ''12'' '+
             '  AND SI.ZORD_DATE >= {d ''2016-02-01''} '+
             '  AND SI.ZORD_DATE <= {d ''2016-02-29''} '+
             '  AND SI.SHIP_COND <> ''RE'' ' +
             '  AND SI.SUBTOTAL_2 > 0 ' +
             '  AND SI.SALES_OFF IN(''E01'',''E02'',''E03'',''E04'',''E05'',''E06'',''E07'',''E12'') ' +
          'GROUP BY '+
             '  1, 2'.
CACHE.
EXE.

DATASET NAME GC_FEB16.
DATASET ACTIVATE GC_FEB16.

*Get the first 5 characters of zipcode.
STRING ZIP5(A5).
COMPUTE ZIP5 = SUBSTR(ZIP,1,5).
EXE.

*Aggregate the sales and orders by the 5 digit zipcode.
DATASET DECLARE GC_FEB16_2.

AGGREGATE
   /OUTFILE = 'GC_FEB16_2'
   /BREAK = ORD_DATE ZIP5
   /SALES = SUM(SALES)
   /ORDERS = SUM(ORDERS).

DATASET CLOSE GC_FEB16.
DATASET ACTIVATE GC_FEB16_2.
DATASET NAME GC_FEB16.

ADD FILES
   /FILE = *
   /FILE = 'GC_JAN16'
   /FILE = 'GC_DEC15'.
EXE.

DATASET CLOSE GC_DEC15.
DATASET CLOSE GC_JAN16.
DATASET ACTIVATE GC_FEB16.
DATASET NAME GCS.

SORT CASES BY ORD_DATE(A) ZIP5(A).

RENAME VARIABLES SALES = GC_SALES ORDERS = GC_ORDERS.

/*MERGE GCOM SALES WITH TOTAL SALES*/.

DATASET ACTIVATE TS.

MATCH FILES
   /FILE = *
   /TABLE = 'GCS'
   /BY ORD_DATE ZIP5.
EXE.

DATASET CLOSE GCS.
DATASET ACTIVATE TS.

/*CALCULATE AND CHECK OFFLINE SALES*/.

*Recode any missing Gcom Sales and Orders to 0.
RECODE GC_SALES(MISSING = 0).
RECODE GC_ORDERS(MISSING = 0).

*Compute offline sales and total sales - Gcom sales.
COMPUTE OFF_SALES = (SALES - GC_SALES).
COMPUTE OFF_ORDERS = (ORDERS - GC_ORDERS).

*Look to see if offline sales or orders are negative.
COMPUTE Neg_Val = (OFF_SALES < 0 OR OFF_ORDERS < 0).
FORMATS Neg_Val(F1.0).
EXE.

FREQ Neg_Val.

DELETE VARIABLES Neg_Val.

/*FORMATTING*/.

*Date variable should be YYYY-MM-DD.
STRING #DD(A2).
STRING #MMM(A3).
STRING #YYYY(A4).

ALTER TYPE ORD_DATE(A11).

COMPUTE #DD = SUBSTR(ORD_DATE,1,2).
COMPUTE #MMM = SUBSTR(ORD_DATE,4,3).
COMPUTE #YYYY = SUBSTR(ORD_DATE,8,4).

STRING #MM(A2).

COMPUTE #MM = ''.
IF(#MMM = 'DEC') #MM = '12'.
IF(#MMM = 'JAN') #MM = '01'.
IF(#MMM = 'FEB') #MM = '02'.

STRING ORDER_DATE(A10).

COMPUTE ORDER_DATE = CONCAT(#YYYY,'-',#MM,'-',#DD).
EXE.

ALTER TYPE ORD_DATE(DATE11).

FORMATS ORDERS(F8.0) GC_ORDERS(F8.0) OFF_ORDERS(F8.0).

*Save the resulting file.
SAVE OUTFILE = '/usr/spss/userdata/Albrecht/PPC Geo/Sales and Orders by Date and Zipcode.sav'.

*Remove records without a zipcode.
SELECT IF(ZIP5 <> '').
EXE.

RENAME VARIABLES ZIP5 = ZIPCODE GC_SALES = ONLINE_SALES GC_ORDERS = ONLINE_ORDERS OFF_SALES = OFFLINE_SALES OFF_ORDERS = OFFLINE_ORDERS.

*Save as a CSV file.
SAVE TRANSLATE OUTFILE='/usr/spss/userdata/Albrecht/PPC Geo/Sales and Orders by Date and Zipcode.csv'
  /TYPE=CSV
  /MAP
  /REPLACE
  /FIELDNAMES
  /CELLS=VALUES
  /DROP=ORD_DATE SALES ORDERS.
