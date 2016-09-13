*Select GIS Orders.
GET DATA 
  /TYPE=ODBC 
  /CONNECT='DSN=Teradata;DB=PRD_DWH_VIEW;PORT=1025;DBCNL=10.4.165.29;UID=spss;PWD=$-<~*x#N3@!/-!!+'
  /SQL='SELECT '+
             '  CU.CUSTOMER, CU.ZZIPCD5 ZIPCODE, A.ORDERS PY_ORDERS, A.SALES PY_SALES, B.ORDERS TP_ORDERS, B.SALES TP_SALES '+
           'FROM PRD_DWH_VIEW.Customer_V CU ' +
           'LEFT JOIN PRD_DWH_VIEW.CUSTOMER_PURCH_DATES_V CPD ' +
              'ON CU.CUSTOMER = CPD.CUSTOMER ' +
           'LEFT JOIN (SELECT SIA.SOLD_TO CUSTOMER, COUNT(DISTINCT SIA.BILL_NUM) ORDERS, SUM(SIA.SUBTOTAL_2) SALES '+
                             'FROM PRD_DWH_VIEW.Sales_Invoice_V SIA '+
                             'WHERE '+
                                  '  SIA.ZZCOMFLG = ''Y'' ' +
                                  '  AND SIA.BILL_DATE >= {d ''2015-06-15''} '+
                                  '  AND SIA.BILL_DATE <= {d ''2015-08-10''} '+
                              'GROUP BY 1) A ' +
           'ON CU.CUSTOMER = A.CUSTOMER '+
           'LEFT JOIN (SELECT SIB.SOLD_TO CUSTOMER, COUNT(DISTINCT SIB.BILL_NUM) ORDERS, SUM(SIB.SUBTOTAL_2) SALES '+
                             'FROM PRD_DWH_VIEW.Sales_Invoice_V SIB '+
                             'WHERE '+
                                  '  SIB.ZZCOMFLG = ''Y'' ' +
                                  '  AND SIB.BILL_DATE >= {d ''2016-06-15''} '+
                                  '  AND SIB.BILL_DATE <= {d ''2016-08-10''} '+
                              'GROUP BY 1) B ' +
           'ON CU.CUSTOMER = B.CUSTOMER '+
             'WHERE CU.ZZIPCD5 <> '''' AND ' +
                          'CU.ACCNT_GRP = ''0001'' '.
CACHE.
EXE.

DATASET NAME GIS.

*Select Gcom Orders.
GET DATA 
  /TYPE=ODBC 
  /CONNECT='DSN=Teradata;DB=PRD_DWH_VIEW;PORT=1025;DBCNL=10.4.165.29;UID=spss;PWD=$-<~*x#N3@!/-!!+'
  /SQL='SELECT '+
             '  CU.CUSTOMER, A.ORDERS PY_GC_ORDERS, A.SALES PY_GC_SALES, B.ORDERS TP_GC_ORDERS, B.SALES TP_GC_SALES ' +
           'FROM PRD_DWH_VIEW.Customer_V CU ' +
           'LEFT JOIN (SELECT SIA.SOLD_TO CUSTOMER, COUNT(DISTINCT SIA.S_ORD_NUM) ORDERS, SUM(SIA.SUBTOTAL_2) SALES '+
                             'FROM PRD_DWH_VIEW.Sales_Invoice_V SIA '+
                             'WHERE '+
                                  '  SIA.ZZCOMFLG = ''Y'' ' +
                                  '  AND SIA.BILL_DATE >= {d ''2015-06-15''} '+
                                  '  AND SIA.BILL_DATE <= {d ''2015-08-10''} '+
                                  '  AND SIA.SALES_OFF = ''E01'' ' +
                              'GROUP BY 1) A ' +
           'ON CU.CUSTOMER = A.CUSTOMER '+
           'LEFT JOIN (SELECT SIB.SOLD_TO CUSTOMER, COUNT(DISTINCT SIB.S_ORD_NUM) ORDERS, SUM(SIB.SUBTOTAL_2) SALES '+
                             'FROM PRD_DWH_VIEW.Sales_Invoice_V SIB '+
                             'WHERE '+
                                  '  SIB.ZZCOMFLG = ''Y'' ' +
                                  '  AND SIB.BILL_DATE >= {d ''2016-06-15''} '+
                                  '  AND SIB.BILL_DATE <= {d ''2016-08-10''} '+
                                  '  AND SIB.SALES_OFF = ''E01'' ' +
                              'GROUP BY 1) B ' +
           'ON CU.CUSTOMER = B.CUSTOMER '+
           'WHERE CU.ZZIPCD5 <> '''' AND ' +
                        'CU.ACCNT_GRP = ''0001'' '.
CACHE.
EXE.

DATASET NAME GCOM.

SORT CASES BY CUSTOMER(A).

DATASET ACTIVATE GIS.

SORT CASES BY CUSTOMER(A).

MATCH FILES
   /FILE = *
   /TABLE = 'GCOM'
   /BY CUSTOMER.
EXE.

DATASET CLOSE GCOM.
DATASET ACTIVATE GIS.

*Select Gcom guest sales by zipcode for the dates we would like.
GET DATA 
  /TYPE=ODBC 
  /CONNECT='DSN=Teradata;DB=PRD_DWH_VIEW;PORT=1025;DBCNL=10.4.165.29;UID=spss;PWD=$-<~*x#N3@!/-!!+'
  /SQL='SELECT DISTINCT SI.SOLD_TO CUSTOMER, SI.ZSHIPZIP, A.ORDERS PY_ORDERS, A.SALES PY_SALES, B.ORDERS TP_ORDERS, B.SALES TP_SALES ' +
            'FROM PRD_DWH_VIEW.Sales_Invoice_Summary_V SI ' +
                 'LEFT JOIN (SELECT SIA.SOLD_TO CUSTOMER, SIA.ZSHIPZIP, COUNT(DISTINCT SIA.S_ORD_NUM) ORDERS, SUM(SIA.SUBTOTAL_2) SALES '+
                                   'FROM PRD_DWH_VIEW.Sales_Invoice_Summary_V SIA '+
                                   'WHERE '+
                                        '  SIA.ZZCOMFLG = ''Y'' ' +
                                        '  AND SIA.BILL_DATE >= {d ''2015-06-15''} '+
                                        '  AND SIA.BILL_DATE <= {d ''2015-08-10''} '+
                                        '  AND SIA.SALES_OFF = ''E01'' ' +
                                        '  AND SIA.SOLD_TO = ''0222222226'' ' +
                                    'GROUP BY 1,2) A ' +
                 'ON SI.SOLD_TO = A.CUSTOMER AND SI.ZSHIPZIP = A.ZSHIPZIP '+
                 'LEFT JOIN (SELECT SIB.SOLD_TO CUSTOMER, SIB.ZSHIPZIP, COUNT(DISTINCT SIB.S_ORD_NUM) ORDERS, SUM(SIB.SUBTOTAL_2) SALES '+
                                   'FROM PRD_DWH_VIEW.Sales_Invoice_Summary_V SIB '+
                                   'WHERE '+
                                        '  SIB.ZZCOMFLG = ''Y'' ' +
                                        '  AND SIB.BILL_DATE >= {d ''2016-06-15''} '+
                                        '  AND SIB.BILL_DATE <= {d ''2016-08-10''} '+
                                        '  AND SIB.SALES_OFF = ''E01'' ' +
                                        '  AND SIB.SOLD_TO = ''0222222226'' ' +
                                    'GROUP BY 1,2) B ' +
                 'ON SI.SOLD_TO = B.CUSTOMER AND SI.ZSHIPZIP = B.ZSHIPZIP '+
            'WHERE ( (SI.BILL_DATE >= {d ''2015-06-15''}  AND SI.BILL_DATE <= {d ''2015-08-10''}) OR ' +
                         '   (SI.BILL_DATE >= {d ''2016-06-15''} AND SI.BILL_DATE <= {d ''2016-08-10''}) ) AND '
                          'SI.SALES_OFF = ''E01'' AND ' +
                          'SI.SOLD_TO = ''0222222226'' AND ' +
                          'SI.ZZCOMFLG = ''Y'' '.
CACHE.
EXE.

DATASET NAME GUEST.
DATASET ACTIVATE GUEST.

COMPUTE PY_GC_ORDERS = PY_ORDERS.
COMPUTE PY_GC_SALES = PY_SALES.
COMPUTE TP_GC_ORDERS = TP_ORDERS.
COMPUTE TP_GC_SALES = TP_SALES.

STRING ZIPCODE(A5).
COMPUTE ZIPCODE=SUBSTR(ZSHIPZIP,1,5).
EXE.

DELETE VARIABLES ZSHIPZIP.

DATASET ACTIVATE GIS.

ADD FILES
   /FILE = *
   /FILE = 'GUEST'.
EXE.

DATASET CLOSE GUEST.
DATASET ACTIVATE GIS.

*Recode missing values to 0.
VECTOR KF = PY_ORDERS TO TP_GC_SALES.

LOOP #i = 1 TO 8.

   IF(MISSING(KF(#i))) KF(#i) = 0.

END LOOP.
EXE.

*Filter out any accounts which were identified as having high avg monthly orders or unstable order history.
GET FILE = '/usr/spss/userdata/Albrecht/PPC Geo/Weekly Updates/Five Year Orders through May16 by Account for Target Markets.sav'
   /KEEP account ZIPCODE Order_Outlier Stable_Order_Outlier.
CACHE.
EXE.

DATASET NAME ORD_OUT.

DATASET ACTIVATE GIS.

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
DATASET ACTIVATE GIS.

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

DATASET ACTIVATE GIS.

MATCH FILES
   /FILE = *
   /TABLE = 'ZTD'
   /BY ZIPCODE.
EXE.

DATASET CLOSE ZTD.
DATASET ACTIVATE GIS.

RECODE Group(MISSING = 0) /Order_Outlier(MISSING = 0) /Stable_Order_Outlier(MISSING = 0).

COMPUTE Include = (CUSTOMER <> '0855313060' AND Order_Outlier = 0 AND Stable_Order_Outlier = 0).
FORMATS Include(F1.0).
EXE.

*Save the resulting file.
SAVE OUTFILE = '/usr/spss/userdata/Albrecht/PPC Geo/Weekly Updates/Final Analysis/YoY V Pct Metrics by Account.sav'.

*Aggregate the data by DMA.
FILTER BY Include.

DATASET DECLARE YOY_VP.

AGGREGATE
  /OUTFILE='YOY_VP'
  /BREAK=DMA Group
  /PY_ORDERS=SUM(PY_ORDERS) 
  /PY_SALES=SUM(PY_SALES) 
  /TP_ORDERS=SUM(TP_ORDERS) 
  /TP_SALES=SUM(TP_SALES) 
  /PY_GC_ORDERS=SUM(PY_GC_ORDERS) 
  /PY_GC_SALES=SUM(PY_GC_SALES) 
  /TP_GC_ORDERS=SUM(TP_GC_ORDERS) 
  /TP_GC_SALES=SUM(TP_GC_SALES).

DATASET ACTIVATE YOY_VP.

SORT CASES BY Group(A) DMA(A).

SELECT IF(Group > 0).
EXE.

*Now look at each account in the YoY variance metrics and see if there are any accounts with a large difference in GIS and Gcom orders between the forecast and PY testing period.

*Get the list of accounts that were used in the forecast.
GET FILE = '/usr/spss/userdata/Albrecht/PPC Geo/Weekly Updates/Five Year Orders through May16 by Account for Target Markets.sav'
   /KEEP account ZIPCODE DMA Group TRNS_0615 TRNS_0715 TRNS_0815 Gcom_Orders_0615 Gcom_Orders_0715 Gcom_Orders_0815 Has_Trans Order_Outlier Stable_Order_Outlier.
CACHE.
EXE.

DATASET NAME FC.
DATASET ACTIVATE FC.

COMPUTE PY_ORDERS_FC = SUM(TRNS_0615 TO TRNS_0815).
COMPUTE PY_GC_ORD_FC = SUM(Gcom_Orders_0615 TO Gcom_Orders_0815).

COMPUTE Include = ( (account <> 855313060 AND Order_Outlier = 0 AND Stable_Order_Outlier = 0) OR Has_Trans = 0).
FORMATS Include(F1.0).

SELECT IF(Group > 0 AND Include = 1).
EXE.

DELETE VARIABLES TRNS_0615 TO TRNS_0815 Gcom_Orders_0615 TO Gcom_Orders_0815 Order_Outlier Stable_Order_Outlier.

*Now get the list of accounts, zipcodes, and the YoY Metrics from TD.
GET FILE = '/usr/spss/userdata/Albrecht/PPC Geo/Weekly Updates/Final Analysis/YoY V Pct Metrics by Account.sav'
   /KEEP account ZIPCODE Group PY_ORDERS PY_GC_ORDERS Include.
CACHE.
EXE.

DATASET NAME YOY.
DATASET ACTIVATE YOY.

SELECT IF(Group > 0 AND Include = 1).
EXE.

DATASET DECLARE YOY2.

AGGREGATE
   /OUTFILE = 'YOY2'
   /BREAK = account ZIPCODE
   /PY_ORDERS = SUM(PY_ORDERS)
   /PY_GC_ORDERS = SUM(PY_GC_ORDERS).

DATASET ACTIVATE YOY2.

COMPUTE YOY_ACCT = 1.
FORMATS YOY_ACCT(F1.0).
EXE.

DATASET ACTIVATE FC.

MATCH FILES
   /FILE = *
   /TABLE = 'YOY2'
   /BY account ZIPCODE.
EXE.

*Examine GIS Orders.
SORT CASES BY YOY_ACCT(D) PY_ORDERS(D).

*Compute a variable to show whether orders from the months of the forecast in the previous year are ever less than the previous year orders during the testing period from TD.
COMPUTE Missing_FC = 0.
IF(YOY_ACCT = 1 AND PY_ORDERS_FC < PY_ORDERS) Missing_FC = 1.
FORMATS Missing_FC(F1.0).
EXE.

FREQ Missing_FC.

*Copy the dataset and look only at those accouns which are missing from the forecast.
DATASET COPY MFC.
DATASET ACTIVATE MFC.

SELECT IF(Missing_FC = 1).
EXE.

DO IF(PY_ORDERS_FC > 0).

   COMPUTE PCT_DIFF = ( (PY_ORDERS - PY_ORDERS_FC) / PY_ORDERS_FC) * 100.

ELSE.

   COMPUTE PCT_DIFF = 100.

END IF.
FORMATS PCT_DIFF(PCT5.2).
EXE.

SORT CASES BY PCT_DIFF(D).

*Select only those accounts whose difference is greater than 80% and with orders from the previous year test period from TD > 20.
SELECT IF(PCT_DIFF >= 80 AND PY_ORDERS > 20).
EXE.

*Save the resulting file. 
SAVE OUTFILE = '/usr/spss/userdata/Albrecht/PPC Geo/Weekly Updates/Final Analysis/Accounts in Results Missing from GIS Forecast.sav'.

*Examine Gcom Orders.
SORT CASES BY YOY_ACCT(D) PY_GC_ORDERS(D).

*Compute a variable to show whether orders from the months of the forecast in the previous year are ever less than the previous year orders during the testing period from TD.
COMPUTE Missing_GC_FC = 0.
IF(YOY_ACCT = 1 AND PY_GC_ORD_FC < PY_GC_ORDERS) Missing_GC_FC = 1.
FORMATS Missing_GC_FC(F1.0).
EXE.

FREQ Missing_GC_FC.

