*Select GIS sales by account and zipcode for the dates we would like.
GET DATA 
  /TYPE=ODBC 
  /CONNECT='DSN=Teradata;DB=PRD_DWH_VIEW;PORT=1025;DBCNL=10.4.165.29;UID=spss;PWD=$-<~*x#N3@!/-!!+'
  /SQL='SELECT '+
             '  CU.CUSTOMER, CU.ZZIPCD5 ZIPCODE, CU.CREATEDON CREATE_DATE, CPD.FIRST_PURCH_DT FPD, ' +
            '   A.ORDERS JUNE_ORDERS, A.SALES JUNE_SALES, B.ORDERS JULY_ORDERS, B.SALES JULY_SALES,  C.ORDERS AUG_ORDERS, C.SALES AUG_SALES '+
           'FROM PRD_DWH_VIEW.Customer_V CU ' +
           'LEFT JOIN PRD_DWH_VIEW.CUSTOMER_PURCH_DATES_V CPD ' +
              'ON CU.CUSTOMER = CPD.CUSTOMER ' +
           'LEFT JOIN (SELECT SIA.SOLD_TO CUSTOMER, COUNT(DISTINCT SIA.S_ORD_NUM) ORDERS, SUM(SIA.SUBTOTAL_2) SALES '+
                             'FROM PRD_DWH_VIEW.Sales_Invoice_V SIA '+
                             'WHERE '+
                                  '  SIA.ZZCOMFLG = ''Y'' ' +
                                  '  AND SIA.ZORD_DATE >= {d ''2016-06-15''} '+
                                  '  AND SIA.ZORD_DATE <= {d ''2016-06-30''} '+
                                  '  AND SIA.SHIP_COND <> ''RE'' ' +
                                  '  AND SIA.SUBTOTAL_2 > 0 ' +
                              'GROUP BY 1) A ' +
           'ON CU.CUSTOMER = A.CUSTOMER '+
           'LEFT JOIN (SELECT SIB.SOLD_TO CUSTOMER, COUNT(DISTINCT SIB.S_ORD_NUM) ORDERS, SUM(SIB.SUBTOTAL_2) SALES '+
                             'FROM PRD_DWH_VIEW.Sales_Invoice_V SIB '+
                             'WHERE '+
                                  '  SIB.ZZCOMFLG = ''Y'' ' +
                                  '  AND SIB.ZORD_DATE >= {d ''2016-07-01''} '+
                                  '  AND SIB.ZORD_DATE <= {d ''2016-07-31''} '+
                                  '  AND SIB.SHIP_COND <> ''RE'' ' +
                                  '  AND SIB.SUBTOTAL_2 > 0 ' +
                              'GROUP BY 1) B ' +
           'ON CU.CUSTOMER = B.CUSTOMER '+
           'LEFT JOIN (SELECT SIC.SOLD_TO CUSTOMER, COUNT(DISTINCT SIC.S_ORD_NUM) ORDERS, SUM(SIC.SUBTOTAL_2) SALES '+
                             'FROM PRD_DWH_VIEW.Sales_Invoice_V SIC '+
                             'WHERE '+
                                  '  SIC.ZZCOMFLG = ''Y'' ' +
                                  '  AND SIC.ZORD_DATE >= {d ''2016-08-01''} '+
                                  '  AND SIC.ZORD_DATE <= {d ''2016-08-10''} '+
                                  '  AND SIC.SHIP_COND <> ''RE'' ' +
                                  '  AND SIC.SUBTOTAL_2 > 0 ' +
                              'GROUP BY 1) C ' +
           'ON CU.CUSTOMER = C.CUSTOMER '+
           'WHERE CU.ZZIPCD5 <> '''' AND ' +
                         'CU.ACCNT_GRP = ''0001'' '.
CACHE.
EXE.

DATASET NAME SLS_BY_AZ.
DATASET ACTIVATE SLS_BY_AZ.

SORT CASES BY CUSTOMER(A) ZIPCODE(A).

*Select Gcom sales by account and zipcode for the dates we would like.
GET DATA 
  /TYPE=ODBC 
  /CONNECT='DSN=Teradata;DB=PRD_DWH_VIEW;PORT=1025;DBCNL=10.4.165.29;UID=spss;PWD=$-<~*x#N3@!/-!!+'
  /SQL='SELECT '+
             '  CU.CUSTOMER, ' +
             '  A.ORDERS JUNE_ORDERS, A.SALES JUNE_SALES, B.ORDERS JULY_ORDERS, B.SALES JULY_SALES, C.ORDERS AUG_ORDERS, C.SALES AUG_SALES ' +
           'FROM PRD_DWH_VIEW.Customer_V CU ' +
           'LEFT JOIN (SELECT SIA.SOLD_TO CUSTOMER, COUNT(DISTINCT SIA.S_ORD_NUM) ORDERS, SUM(SIA.SUBTOTAL_2) SALES '+
                             'FROM PRD_DWH_VIEW.Sales_Invoice_V SIA '+
                             'WHERE '+
                                  '  SIA.ZZCOMFLG = ''Y'' ' +
                                  '  AND SIA.ZORD_DATE >= {d ''2016-06-15''} '+
                                  '  AND SIA.ZORD_DATE <= {d ''2016-06-30''} '+
                                  '  AND SIA.SALES_OFF = ''E01'' ' +
                                  '  AND SIA.SHIP_COND <> ''RE'' ' +
                                  '  AND SIA.SUBTOTAL_2 > 0 ' +
                              'GROUP BY 1) A ' +
           'ON CU.CUSTOMER = A.CUSTOMER '+
           'LEFT JOIN (SELECT SIB.SOLD_TO CUSTOMER, COUNT(DISTINCT SIB.S_ORD_NUM) ORDERS, SUM(SIB.SUBTOTAL_2) SALES '+
                             'FROM PRD_DWH_VIEW.Sales_Invoice_V SIB '+
                             'WHERE '+
                                  '  SIB.ZZCOMFLG = ''Y'' ' +
                                  '  AND SIB.ZORD_DATE >= {d ''2016-07-01''} '+
                                  '  AND SIB.ZORD_DATE <= {d ''2016-07-31''} '+
                                  '  AND SIB.SALES_OFF = ''E01'' ' +
                                  '  AND SIB.SHIP_COND <> ''RE'' ' +
                                  '  AND SIB.SUBTOTAL_2 > 0 ' +
                              'GROUP BY 1) B ' +
           'ON CU.CUSTOMER = B.CUSTOMER '+
           'LEFT JOIN (SELECT SIC.SOLD_TO CUSTOMER, COUNT(DISTINCT SIC.S_ORD_NUM) ORDERS, SUM(SIC.SUBTOTAL_2) SALES '+
                             'FROM PRD_DWH_VIEW.Sales_Invoice_V SIC '+
                             'WHERE '+
                                  '  SIC.ZZCOMFLG = ''Y'' ' +
                                  '  AND SIC.ZORD_DATE >= {d ''2016-08-01''} '+
                                  '  AND SIC.ZORD_DATE <= {d ''2016-08-10''} '+
                                  '  AND SIC.SALES_OFF = ''E01'' ' +
                                  '  AND SIC.SHIP_COND <> ''RE'' ' +
                                  '  AND SIC.SUBTOTAL_2 > 0 ' +
                              'GROUP BY 1) C ' +
           'ON CU.CUSTOMER = C.CUSTOMER '+
           'WHERE CU.ZZIPCD5 <> '''' AND ' +
                        'CU.ACCNT_GRP = ''0001'' '.
CACHE.
EXE.

DATASET NAME GCSLS_BY_AZ.
DATASET ACTIVATE GCSLS_BY_AZ.

*Rename the variables.
RENAME VARIABLES 
   JUNE_ORDERS = GC_JUNE_ORDERS
   JUNE_SALES = GC_JUNE_SALES
   JULY_ORDERS = GC_JULY_ORDERS
   JULY_SALES = GC_JULY_SALES
   AUG_ORDERS = GC_AUG_ORDERS
   AUG_SALES = GC_AUG_SALES.
   
SORT CASES BY CUSTOMER(A).

DATASET ACTIVATE SLS_BY_AZ.

MATCH FILES
   /FILE = *
   /TABLE = 'GCSLS_BY_AZ'
   /BY CUSTOMER.
EXE.

DATASET CLOSE GCSLS_BY_AZ.
DATASET ACTIVATE SLS_BY_AZ.

*Select Gcom guest sales by zipcode for the dates we would like.
GET DATA 
  /TYPE=ODBC 
  /CONNECT='DSN=Teradata;DB=PRD_DWH_VIEW;PORT=1025;DBCNL=10.4.165.29;UID=spss;PWD=$-<~*x#N3@!/-!!+'
  /SQL='SELECT DISTINCT SI.SOLD_TO CUSTOMER, SI.ZSHIPZIP, ' +
             '  A.ORDERS JUNE_ORDERS, A.SALES JUNE_SALES, B.ORDERS JULY_ORDERS, B.SALES JULY_SALES, C.ORDERS AUG_ORDERS, C.SALES AUG_SALES ' +
            'FROM PRD_DWH_VIEW.Sales_Invoice_V SI ' +
                 'LEFT JOIN (SELECT SIA.SOLD_TO CUSTOMER, SIA.ZSHIPZIP, COUNT(DISTINCT SIA.S_ORD_NUM) ORDERS, SUM(SIA.SUBTOTAL_2) SALES '+
                                   'FROM PRD_DWH_VIEW.Sales_Invoice_V SIA '+
                                   'WHERE '+
                                        '  SIA.ZZCOMFLG = ''Y'' ' +
                                        '  AND SIA.ZORD_DATE >= {d ''2016-06-15''} '+
                                        '  AND SIA.ZORD_DATE <= {d ''2016-06-30''} '+
                                        '  AND SIA.SALES_OFF = ''E01'' ' +
                                        '  AND SIA.SOLD_TO = ''0222222226'' ' +
                                        '  AND SIA.SHIP_COND <> ''RE'' ' +
                                        '  AND SIA.SUBTOTAL_2 > 0 ' +
                                    'GROUP BY 1,2) A ' +
                 'ON SI.SOLD_TO = A.CUSTOMER AND SI.ZSHIPZIP = A.ZSHIPZIP '+
                 'LEFT JOIN (SELECT SIB.SOLD_TO CUSTOMER, SIB.ZSHIPZIP, COUNT(DISTINCT SIB.S_ORD_NUM) ORDERS, SUM(SIB.SUBTOTAL_2) SALES '+
                                   'FROM PRD_DWH_VIEW.Sales_Invoice_V SIB '+
                                   'WHERE '+
                                        '  SIB.ZZCOMFLG = ''Y'' ' +
                                        '  AND SIB.ZORD_DATE >= {d ''2016-07-01''} '+
                                        '  AND SIB.ZORD_DATE <= {d ''2016-07-31''} '+
                                        '  AND SIB.SALES_OFF = ''E01'' ' +
                                        '  AND SIB.SOLD_TO = ''0222222226'' ' +
                                        '  AND SIB.SHIP_COND <> ''RE'' ' +
                                        '  AND SIB.SUBTOTAL_2 > 0 ' +
                                    'GROUP BY 1,2) B ' +
                 'ON SI.SOLD_TO = B.CUSTOMER AND SI.ZSHIPZIP = B.ZSHIPZIP '+
                 'LEFT JOIN (SELECT SIC.SOLD_TO CUSTOMER, SIC.ZSHIPZIP, COUNT(DISTINCT SIC.S_ORD_NUM) ORDERS, SUM(SIC.SUBTOTAL_2) SALES '+
                                   'FROM PRD_DWH_VIEW.Sales_Invoice_V SIC '+
                                   'WHERE '+
                                        '  SIC.ZZCOMFLG = ''Y'' ' +
                                        '  AND SIC.ZORD_DATE >= {d ''2016-08-01''} '+
                                        '  AND SIC.ZORD_DATE <= {d ''2016-08-10''} '+
                                        '  AND SIC.SALES_OFF = ''E01'' ' +
                                        '  AND SIC.SOLD_TO = ''0222222226'' ' +
                                        '  AND SIC.SHIP_COND <> ''RE'' ' +
                                        '  AND SIC.SUBTOTAL_2 > 0 ' +
                                    'GROUP BY 1,2) C ' +
                 'ON SI.SOLD_TO = C.CUSTOMER AND SI.ZSHIPZIP = C.ZSHIPZIP '+
            'WHERE SI.ZORD_DATE >= {d ''2016-06-15''}  AND ' +
                          'SI.ZORD_DATE <= {d ''2016-08-10''} AND ' +
                          'SI.SALES_OFF = ''E01'' AND ' +
                          'SI.SOLD_TO = ''0222222226'' AND ' +
                          'SI.ZZCOMFLG = ''Y'' AND ' +
                          'SI.SHIP_COND <> ''RE'' AND ' +
                          'SI.SUBTOTAL_2 > 0 '.

CACHE.
EXE.

DATASET NAME GUEST.
DATASET ACTIVATE GUEST.

COMPUTE GC_JUNE_ORDERS = JUNE_ORDERS.
COMPUTE GC_JUNE_SALES = JUNE_SALES.
COMPUTE GC_JULY_ORDERS = JULY_ORDERS.
COMPUTE GC_JULY_SALES = JULY_SALES.
COMPUTE GC_AUG_ORDERS = AUG_ORDERS.
COMPUTE GC_AUG_SALES = AUG_SALES.

STRING ZIPCODE(A5).
COMPUTE ZIPCODE=SUBSTR(ZSHIPZIP,1,5).
EXE.

DELETE VARIABLES ZSHIPZIP.

DATASET ACTIVATE SLS_BY_AZ.

ADD FILES
   /FILE = *
   /FILE = 'GUEST'.
EXE.

DATASET CLOSE GUEST.
DATASET ACTIVATE SLS_BY_AZ.

*Recode missing values to 0.
VECTOR KF = JUNE_ORDERS TO GC_AUG_SALES.

LOOP #i = 1 TO 12.

   IF(MISSING(KF(#i))) KF(#i) = 0.

END LOOP.
EXE.

*Sort the cases by Zipcode.
SORT CASES BY ZIPCODE(A).

*Open the file containing the Zipcode to DMA mapping.
GET FILE = '/usr/spss/userdata/LWhately/Media/2015 Media Test/dma_zip_xref_mine.sav'
   /KEEP Zipcode DMA.
CACHE.
EXE.

DATASET NAME ZTD.
DATASET ACTIVATE ZTD.

*Select only the test and control DMAs we would like to use.
 * SELECT IF(ANY(DMA,'ERIE','PEORIA - BLOOMINGTON','BIRMINGHAM (ANN & TUSC)','KNOXVILLE','FARGO - VALLEY CITY','LAS VEGAS',
                                  'AUGUSTA - AIKEN','SPRINGFIELD - HOLYOKE','FRESNO - VISALIA','LEXINGTON','JACKSON, MS','MADISON',
                                  'BLUEFIELD - BECKLEY - OAK HILL','FT- SMITH - FAY - SPRNGDL - RG','RICHMOND - PETERSBURG', 
                                  'GREENSBORO - H- POINT - W- SAL','LA CROSSE - EAU CLAIRE','TUCSON (SIERRA VISTA)',
                                  'DAVENPORT - R- ISLAND - MOLINE','YOUNGSTOWN','LANSING','GREENVLL - SPART - ASHEVLL - A','OMAHA','SIOUX CITY')).

COMPUTE Group = 0.
IF(ANY(DMA,'ERIE','PEORIA - BLOOMINGTON','BIRMINGHAM (ANN & TUSC)','KNOXVILLE','FARGO - VALLEY CITY','LAS VEGAS')) Group = 1.
IF(ANY(DMA, 'AUGUSTA - AIKEN','SPRINGFIELD - HOLYOKE','FRESNO - VISALIA','LEXINGTON','JACKSON, MS','MADISON')) Group = 2.
IF(ANY(DMA,'BLUEFIELD - BECKLEY - OAK HILL','FT- SMITH - FAY - SPRNGDL - RG','RICHMOND - PETERSBURG', 
                    'GREENSBORO - H- POINT - W- SAL','LA CROSSE - EAU CLAIRE','TUCSON (SIERRA VISTA)')) Group = 3.
IF(ANY(DMA, 'DAVENPORT - R- ISLAND - MOLINE','YOUNGSTOWN','LANSING','GREENVLL - SPART - ASHEVLL - A','OMAHA','SIOUX CITY')) Group = 4.
VALUE LABELS Group 1 'Spend Down' 2 'Zero Spend' 3 'Spend Up' 4 'Control'.
FORMATS Group(F1.0).
EXE.

SORT CASES BY ZIPCODE(A).

DATASET ACTIVATE SLS_BY_AZ.

MATCH FILES
   /FILE = *
   /TABLE = 'ZTD'
   /BY ZIPCODE.
EXE.

DATASET CLOSE ZTD.

*Filter out any accounts which were identified as having high avg monthly orders or unstable order history.
GET FILE = '/usr/spss/userdata/Albrecht/PPC Geo/Weekly Updates/Final Analysis/June 11 to May 16 Sales and Orders by Account from TD.sav'
   /KEEP account ZIPCODE Order_Outlier Stable_Order_Outlier.
CACHE.
EXE.

DATASET NAME ORD_OUT.

DATASET ACTIVATE SLS_BY_AZ.

STRING account(A10).
COMPUTE account = CUSTOMER.
EXE.

ALTER TYPE account(F10.0).

SORT CASES BY account(A) ZIPCODE(A).

MATCH FILES
   /FILE = *
   /TABLE = 'ORD_OUT'
   /BY account ZIPCODE.
EXE.

DATASET CLOSE ORD_OUT.
DATASET ACTIVATE SLS_BY_AZ.

RECODE Group(MISSING = 0) /Order_Outlier(MISSING = 0) /Stable_Order_Outlier(MISSING = 0).

 * COMPUTE Include_Acq = (ZIPCODE <> '35007' OR (CREATE_DATE <> DATE.MDY(6,13,2016) AND CREATE_DATE <> DATE.MDY(7,11,2016) ) ).
 * FORMATS Include_Acq(F1.0).

COMPUTE Include_Orders = (CUSTOMER <> '0855313060' AND Order_Outlier = 0 AND Stable_Order_Outlier = 0).
FORMATS Include_Orders(F1.0).
EXE.

*Save the resulting file.
SAVE OUTFILE = '/usr/spss/userdata/Albrecht/PPC Geo/Weekly Updates/Final Analysis/June July and Aug GIS and Gcom Sales and Acquisitions by Account_v2.sav'.

*Aggregate the data by DMA and group.
FILTER BY Include_Orders.

DATASET DECLARE SLS_BY_DMA.

AGGREGATE
   /OUTFILE = 'SLS_BY_DMA'
   /BREAK = DMA Group
   /JUNE_ORDERS = SUM(JUNE_ORDERS)
   /JUNE_SALES = SUM(JUNE_SALES)
   /JULY_ORDERS = SUM(JULY_ORDERS)
   /JULY_SALES = SUM(JULY_SALES)
   /AUG_ORDERS = SUM(AUG_ORDERS)
   /AUG_SALES = SUM(AUG_SALES)
   /GC_JUNE_ORDERS = SUM(GC_JUNE_ORDERS)
   /GC_JUNE_SALES = SUM(GC_JUNE_SALES)
   /GC_JULY_ORDERS = SUM(GC_JULY_ORDERS)
   /GC_JULY_SALES = SUM(GC_JULY_SALES)
   /GC_AUG_ORDERS = SUM(GC_AUG_ORDERS)
   /GC_AUG_SALES = SUM(GC_AUG_SALES).

DATASET ACTIVATE SLS_BY_DMA.

SORT CASES BY Group(A) DMA(A).

SELECT IF(Group > 0).

 * COMPUTE Include = (DMA <> 'BIRMINGHAM (ANN & TUSC)').
 * FORMATS Include(F1.0).
EXE.

***LOOK AT TOTAL GIS AND GCOM SALES AND ORDERS FOR THE FIRST WEEK OF THE ANALYSIS PERIOD***.

 * FILTER BY Include.

MEANS JUNE_SALES GC_JUNE_SALES JULY_SALES GC_JULY_SALES AUG_SALES GC_AUG_SALES BY Group
   /CELLS SUM.

MEANS JUNE_ORDERS GC_JUNE_ORDERS JULY_ORDERS GC_JULY_ORDERS AUG_ORDERS GC_AUG_ORDERS BY Group
   /CELLS SUM.

