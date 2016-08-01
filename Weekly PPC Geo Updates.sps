*Select GIS sales by account and zipcode for the dates we would like.
GET DATA 
  /TYPE=ODBC 
  /CONNECT='DSN=Teradata;DB=PRD_DWH_VIEW;PORT=1025;DBCNL=10.4.165.29;UID=spss;PWD=$-<~*x#N3@!/-!!+'
  /SQL='SELECT '+
             '  CU.CUSTOMER, CU.ZZIPCD5 ZIPCODE, CU.CREATEDON CREATE_DATE, CPD.FIRST_PURCH_DT FPD, ' +
             '  A.ORDERS CP1_ORDERS, A.SALES CP1_SALES, B.ORDERS CP2_ORDERS, B.SALES CP2_SALES, C.ORDERS WK1_ORDERS, C.SALES WK1_SALES, ' +
             '  D.ORDERS WK2_ORDERS, D.SALES WK2_SALES, E.ORDERS WK3_ORDERS, E.SALES WK3_SALES, F.ORDERS WK4_ORDERS, F.SALES WK4_SALES, ' + 
             '  G.ORDERS WK5_ORDERS, G.SALES WK5_SALES, H.ORDERS WK6_ORDERS, H.SALES WK6_SALES ' +
           'FROM PRD_DWH_VIEW.Customer_V CU ' +
           'LEFT JOIN PRD_DWH_VIEW.CUSTOMER_PURCH_DATES_V CPD ' +
              'ON CU.CUSTOMER = CPD.CUSTOMER ' +
           'LEFT JOIN (SELECT SIA.SOLD_TO CUSTOMER, COUNT(DISTINCT SIA.BILL_NUM) ORDERS, SUM(SIA.SUBTOTAL_2) SALES '+
                             'FROM PRD_DWH_VIEW.Sales_Invoice_V SIA '+
                             'WHERE '+
                                  '  SIA.ZZCOMFLG = ''Y'' ' +
                                  '  AND SIA.BILL_DATE >= {d ''2016-06-01''} '+
                                  '  AND SIA.BILL_DATE <= {d ''2016-06-07''} '+
                              'GROUP BY 1) A ' +
           'ON CU.CUSTOMER = A.CUSTOMER '+
           'LEFT JOIN (SELECT SIB.SOLD_TO CUSTOMER, COUNT(DISTINCT SIB.BILL_NUM) ORDERS, SUM(SIB.SUBTOTAL_2) SALES '+
                             'FROM PRD_DWH_VIEW.Sales_Invoice_V SIB '+
                             'WHERE '+
                                  '  SIB.ZZCOMFLG = ''Y'' ' +
                                  '  AND SIB.BILL_DATE >= {d ''2016-06-08''} '+
                                  '  AND SIB.BILL_DATE <= {d ''2016-06-14''} '+
                              'GROUP BY 1) B ' +
           'ON CU.CUSTOMER = B.CUSTOMER '+
           'LEFT JOIN (SELECT SIC.SOLD_TO CUSTOMER, COUNT(DISTINCT SIC.BILL_NUM) ORDERS, SUM(SIC.SUBTOTAL_2) SALES '+
                              'FROM PRD_DWH_VIEW.Sales_Invoice_V SIC '+
                              'WHERE '+
                                   '  SIC.ZZCOMFLG = ''Y'' ' +
                                   '  AND SIC.BILL_DATE >= {d ''2016-06-15''} '+
                                   '  AND SIC.BILL_DATE <= {d ''2016-06-21''} '+
                               'GROUP BY 1) C ' +
             'ON CU.CUSTOMER = C.CUSTOMER ' +
           'LEFT JOIN (SELECT SID.SOLD_TO CUSTOMER, COUNT(DISTINCT SID.BILL_NUM) ORDERS, SUM(SID.SUBTOTAL_2) SALES '+
                              'FROM PRD_DWH_VIEW.Sales_Invoice_V SID '+
                              'WHERE '+
                                   '  SID.ZZCOMFLG = ''Y'' ' +
                                   '  AND SID.BILL_DATE >= {d ''2016-06-22''} '+
                                   '  AND SID.BILL_DATE <= {d ''2016-06-28''} '+
                               'GROUP BY 1) D ' +
             'ON CU.CUSTOMER = D.CUSTOMER ' +
           'LEFT JOIN (SELECT SIE.SOLD_TO CUSTOMER, COUNT(DISTINCT SIE.BILL_NUM) ORDERS, SUM(SIE.SUBTOTAL_2) SALES '+
                              'FROM PRD_DWH_VIEW.Sales_Invoice_V SIE '+
                              'WHERE '+
                                   '  SIE.ZZCOMFLG = ''Y'' ' +
                                   '  AND SIE.BILL_DATE >= {d ''2016-06-29''} '+
                                   '  AND SIE.BILL_DATE <= {d ''2016-07-06''} '+
                               'GROUP BY 1) E ' +
             'ON CU.CUSTOMER = E.CUSTOMER ' +
           'LEFT JOIN (SELECT SIF.SOLD_TO CUSTOMER, COUNT(DISTINCT SIF.BILL_NUM) ORDERS, SUM(SIF.SUBTOTAL_2) SALES '+
                              'FROM PRD_DWH_VIEW.Sales_Invoice_V SIF '+
                              'WHERE '+
                                   '  SIF.ZZCOMFLG = ''Y'' ' +
                                   '  AND SIF.BILL_DATE >= {d ''2016-07-07''} '+
                                   '  AND SIF.BILL_DATE <= {d ''2016-07-13''} '+
                               'GROUP BY 1) F ' +
             'ON CU.CUSTOMER = F.CUSTOMER ' +
           'LEFT JOIN (SELECT SIG.SOLD_TO CUSTOMER, COUNT(DISTINCT SIG.BILL_NUM) ORDERS, SUM(SIG.SUBTOTAL_2) SALES '+
                              'FROM PRD_DWH_VIEW.Sales_Invoice_V SIG '+
                              'WHERE '+
                                   '  SIG.ZZCOMFLG = ''Y'' ' +
                                   '  AND SIG.BILL_DATE >= {d ''2016-07-14''} '+
                                   '  AND SIG.BILL_DATE <= {d ''2016-07-20''} '+
                               'GROUP BY 1) G ' +
             'ON CU.CUSTOMER = G.CUSTOMER ' +
           'LEFT JOIN (SELECT SIH.SOLD_TO CUSTOMER, COUNT(DISTINCT SIH.BILL_NUM) ORDERS, SUM(SIH.SUBTOTAL_2) SALES '+
                              'FROM PRD_DWH_VIEW.Sales_Invoice_V SIH '+
                              'WHERE '+
                                   '  SIH.ZZCOMFLG = ''Y'' ' +
                                   '  AND SIH.BILL_DATE >= {d ''2016-07-21''} '+
                                   '  AND SIH.BILL_DATE <= {d ''2016-07-27''} '+
                               'GROUP BY 1) H ' +
             'ON CU.CUSTOMER = H.CUSTOMER ' +
             'WHERE CU.ZZIPCD5 <> '''' AND ' +
                          'CU.ACCNT_GRP = ''0001'' '.
CACHE.
EXE.

DATASET NAME SLS_BY_AZ.
DATASET ACTIVATE SLS_BY_AZ.

SORT CASES BY CUSTOMER(A) ZIPCODE(A).

*Compute a variable to show accounts acquired during the cleansing period as well as those acquired during the weeks of the test.
DO IF(MISSING(FPD) = 0).

   COMPUTE JUN15_ACQ = ( (CREATE_DATE >= DATE.MDY(6,1,2015) AND CREATE_DATE <= DATE.MDY(6,30,2015)) OR 
                                          (FPD >= DATE.MDY(6,1,2015) AND FPD <= DATE.MDY(6,30,2015)) ).
   FORMATS JUN15_ACQ(F1.0).

   COMPUTE JUL15_ACQ = ( (CREATE_DATE >= DATE.MDY(7,1,2015) AND CREATE_DATE <= DATE.MDY(7,31,2015)) OR 
                                          (FPD >= DATE.MDY(7,1,2015) AND FPD <= DATE.MDY(7,31,2015)) ).
   FORMATS JUL15_ACQ(F1.0).

   COMPUTE CP1_ACQ = ( (CREATE_DATE >= DATE.MDY(6,1,2016) AND CREATE_DATE <= DATE.MDY(6,7,2016)) OR 
                                        (FPD >= DATE.MDY(6,1,2016) AND FPD <= DATE.MDY(6,7,2016)) ).
   FORMATS CP1_ACQ(F1.0).

   COMPUTE CP2_ACQ = ( (CREATE_DATE >= DATE.MDY(6,8,2016) AND CREATE_DATE <= DATE.MDY(6,14,2016)) OR 
                                        (FPD >= DATE.MDY(6,8,2016) AND FPD <= DATE.MDY(6,14,2016)) ).
   FORMATS CP2_ACQ(F1.0).

   COMPUTE WK1_ACQ = ( (CREATE_DATE >= DATE.MDY(6,15,2016) AND CREATE_DATE <= DATE.MDY(6,21,2016)) OR 
                                          (FPD >= DATE.MDY(6,15,2016) AND FPD <= DATE.MDY(6,15,2016)) ).
   FORMATS WK1_ACQ(F1.0).

   COMPUTE WK2_ACQ = ( (CREATE_DATE >= DATE.MDY(6,22,2016) AND CREATE_DATE <= DATE.MDY(6,28,2016)) OR 
                                          (FPD >= DATE.MDY(6,22,2016) AND FPD <= DATE.MDY(6,28,2016)) ).
   FORMATS WK2_ACQ(F1.0).

   COMPUTE WK3_ACQ = ( (CREATE_DATE >= DATE.MDY(6,29,2016) AND CREATE_DATE <= DATE.MDY(7,6,2016)) OR 
                                          (FPD >= DATE.MDY(6,29,2016) AND FPD <= DATE.MDY(7,6,2016)) ).
   FORMATS WK3_ACQ(F1.0).

   COMPUTE WK4_ACQ = ( (CREATE_DATE >= DATE.MDY(7,7,2016) AND CREATE_DATE <= DATE.MDY(7,13,2016)) OR 
                                          (FPD >= DATE.MDY(7,7,2016) AND FPD <= DATE.MDY(7,13,2016)) ).
   FORMATS WK4_ACQ(F1.0).

   COMPUTE WK5_ACQ = ( (CREATE_DATE >= DATE.MDY(7,14,2016) AND CREATE_DATE <= DATE.MDY(7,20,2016)) OR 
                                          (FPD >= DATE.MDY(7,14,2016) AND FPD <= DATE.MDY(7,20,2016)) ).
   FORMATS WK5_ACQ(F1.0).

   COMPUTE WK6_ACQ = ( (CREATE_DATE >= DATE.MDY(7,21,2016) AND CREATE_DATE <= DATE.MDY(7,28,2016)) OR 
                                          (FPD >= DATE.MDY(7,21,2016) AND FPD <= DATE.MDY(7,27,2016)) ).
   FORMATS WK6_ACQ(F1.0).

ELSE.

   COMPUTE JUN15_ACQ = ( (CREATE_DATE >= DATE.MDY(6,1,2015) AND CREATE_DATE <= DATE.MDY(6,30,2015)) ).
   FORMATS JUN15_ACQ(F1.0).

   COMPUTE JUL15_ACQ = ( (CREATE_DATE >= DATE.MDY(7,1,2015) AND CREATE_DATE <= DATE.MDY(7,31,2015)) ).
   FORMATS JUL15_ACQ(F1.0).

   COMPUTE CP1_ACQ = ( (CREATE_DATE >= DATE.MDY(6,1,2016) AND CREATE_DATE <= DATE.MDY(6,7,2016)) ).
   FORMATS CP1_ACQ(F1.0).

   COMPUTE CP2_ACQ = ( (CREATE_DATE >= DATE.MDY(6,8,2016) AND CREATE_DATE <= DATE.MDY(6,14,2016)) ).
   FORMATS CP2_ACQ(F1.0).

   COMPUTE WK1_ACQ = ( (CREATE_DATE >= DATE.MDY(6,15,2016) AND CREATE_DATE <= DATE.MDY(6,21,2016)) ).
   FORMATS WK1_ACQ(F1.0).

   COMPUTE WK2_ACQ = ( (CREATE_DATE >= DATE.MDY(6,22,2016) AND CREATE_DATE <= DATE.MDY(6,28,2016)) ).
   FORMATS WK2_ACQ(F1.0).

   COMPUTE WK3_ACQ = ( (CREATE_DATE >= DATE.MDY(6,29,2016) AND CREATE_DATE <= DATE.MDY(7,6,2016)) ).
   FORMATS WK3_ACQ(F1.0).

   COMPUTE WK4_ACQ = ( (CREATE_DATE >= DATE.MDY(7,7,2016) AND CREATE_DATE <= DATE.MDY(7,13,2016)) ).
   FORMATS WK4_ACQ(F1.0).

   COMPUTE WK5_ACQ = ( (CREATE_DATE >= DATE.MDY(7,14,2016) AND CREATE_DATE <= DATE.MDY(7,20,2016)) ).
   FORMATS WK5_ACQ(F1.0).

   COMPUTE WK6_ACQ = ( (CREATE_DATE >= DATE.MDY(7,21,2016) AND CREATE_DATE <= DATE.MDY(7,27,2016)) ).
   FORMATS WK6_ACQ(F1.0).

END IF.
EXE.

*Select Gcom sales by account and zipcode for the dates we would like.
GET DATA 
  /TYPE=ODBC 
  /CONNECT='DSN=Teradata;DB=PRD_DWH_VIEW;PORT=1025;DBCNL=10.4.165.29;UID=spss;PWD=$-<~*x#N3@!/-!!+'
  /SQL='SELECT '+
             '  CU.CUSTOMER, ' +
             '  A.ORDERS CP1_ORDERS, A.SALES CP1_SALES, B.ORDERS CP2_ORDERS, B.SALES CP2_SALES, C.ORDERS WK1_ORDERS, C.SALES WK1_SALES, ' +
             '  D.ORDERS WK2_ORDERS, D.SALES WK2_SALES, E.ORDERS WK3_ORDERS, E.SALES WK3_SALES, F.ORDERS WK4_ORDERS, F.SALES WK4_SALES, ' +
             '  G.ORDERS WK5_ORDERS, G.SALES WK5_SALES, H.ORDERS WK6_ORDERS, H.SALES WK6_SALES ' +
           'FROM PRD_DWH_VIEW.Customer_V CU ' +
           'LEFT JOIN (SELECT SIA.SOLD_TO CUSTOMER, COUNT(DISTINCT SIA.S_ORD_NUM) ORDERS, SUM(SIA.SUBTOTAL_2) SALES '+
                             'FROM PRD_DWH_VIEW.Sales_Invoice_V SIA '+
                             'WHERE '+
                                  '  SIA.ZZCOMFLG = ''Y'' ' +
                                  '  AND SIA.BILL_DATE >= {d ''2016-06-01''} '+
                                  '  AND SIA.BILL_DATE <= {d ''2016-06-07''} '+
                                  '  AND SIA.SALES_OFF = ''E01'' ' +
                              'GROUP BY 1) A ' +
           'ON CU.CUSTOMER = A.CUSTOMER '+
           'LEFT JOIN (SELECT SIB.SOLD_TO CUSTOMER, COUNT(DISTINCT SIB.S_ORD_NUM) ORDERS, SUM(SIB.SUBTOTAL_2) SALES '+
                             'FROM PRD_DWH_VIEW.Sales_Invoice_V SIB '+
                             'WHERE '+
                                  '  SIB.ZZCOMFLG = ''Y'' ' +
                                  '  AND SIB.BILL_DATE >= {d ''2016-06-08''} '+
                                  '  AND SIB.BILL_DATE <= {d ''2016-06-14''} '+
                                  '  AND SIB.SALES_OFF = ''E01'' ' +
                              'GROUP BY 1) B ' +
           'ON CU.CUSTOMER = B.CUSTOMER '+
           'LEFT JOIN (SELECT SIC.SOLD_TO CUSTOMER, COUNT(DISTINCT SIC.S_ORD_NUM) ORDERS, SUM(SIC.SUBTOTAL_2) SALES '+
                              'FROM PRD_DWH_VIEW.Sales_Invoice_V SIC '+
                              'WHERE '+
                                   '  SIC.ZZCOMFLG = ''Y'' ' +
                                   '  AND SIC.BILL_DATE >= {d ''2016-06-15''} '+
                                   '  AND SIC.BILL_DATE <= {d ''2016-06-21''} '+
                                  '  AND SIC.SALES_OFF = ''E01'' ' +
                               'GROUP BY 1) C ' +
             'ON CU.CUSTOMER = C.CUSTOMER ' +
           'LEFT JOIN (SELECT SID.SOLD_TO CUSTOMER, COUNT(DISTINCT SID.S_ORD_NUM) ORDERS, SUM(SID.SUBTOTAL_2) SALES '+
                              'FROM PRD_DWH_VIEW.Sales_Invoice_V SID '+
                              'WHERE '+
                                   '  SID.ZZCOMFLG = ''Y'' ' +
                                   '  AND SID.BILL_DATE >= {d ''2016-06-22''} '+
                                   '  AND SID.BILL_DATE <= {d ''2016-06-28''} '+
                                  '  AND SID.SALES_OFF = ''E01'' ' +
                               'GROUP BY 1) D ' +
             'ON CU.CUSTOMER = D.CUSTOMER ' +
           'LEFT JOIN (SELECT SIE.SOLD_TO CUSTOMER, COUNT(DISTINCT SIE.S_ORD_NUM) ORDERS, SUM(SIE.SUBTOTAL_2) SALES '+
                              'FROM PRD_DWH_VIEW.Sales_Invoice_V SIE '+
                              'WHERE '+
                                   '  SIE.ZZCOMFLG = ''Y'' ' +
                                   '  AND SIE.BILL_DATE >= {d ''2016-06-29''} '+
                                   '  AND SIE.BILL_DATE <= {d ''2016-07-06''} '+
                                  '  AND SIE.SALES_OFF = ''E01'' ' +
                               'GROUP BY 1) E ' +
             'ON CU.CUSTOMER = E.CUSTOMER ' +
           'LEFT JOIN (SELECT SIF.SOLD_TO CUSTOMER, COUNT(DISTINCT SIF.S_ORD_NUM) ORDERS, SUM(SIF.SUBTOTAL_2) SALES '+
                              'FROM PRD_DWH_VIEW.Sales_Invoice_V SIF '+
                              'WHERE '+
                                   '  SIF.ZZCOMFLG = ''Y'' ' +
                                   '  AND SIF.BILL_DATE >= {d ''2016-07-07''} '+
                                   '  AND SIF.BILL_DATE <= {d ''2016-07-13''} '+
                                  '  AND SIF.SALES_OFF = ''E01'' ' +
                               'GROUP BY 1) F ' +
             'ON CU.CUSTOMER = F.CUSTOMER ' +
           'LEFT JOIN (SELECT SIG.SOLD_TO CUSTOMER, COUNT(DISTINCT SIG.S_ORD_NUM) ORDERS, SUM(SIG.SUBTOTAL_2) SALES '+
                              'FROM PRD_DWH_VIEW.Sales_Invoice_V SIG '+
                              'WHERE '+
                                   '  SIG.ZZCOMFLG = ''Y'' ' +
                                   '  AND SIG.BILL_DATE >= {d ''2016-07-14''} '+
                                   '  AND SIG.BILL_DATE <= {d ''2016-07-20''} '+
                                  '  AND SIG.SALES_OFF = ''E01'' ' +
                               'GROUP BY 1) G ' +
             'ON CU.CUSTOMER = G.CUSTOMER ' +
           'LEFT JOIN (SELECT SIH.SOLD_TO CUSTOMER, COUNT(DISTINCT SIH.S_ORD_NUM) ORDERS, SUM(SIH.SUBTOTAL_2) SALES '+
                              'FROM PRD_DWH_VIEW.Sales_Invoice_V SIH '+
                              'WHERE '+
                                   '  SIH.ZZCOMFLG = ''Y'' ' +
                                   '  AND SIH.BILL_DATE >= {d ''2016-07-21''} '+
                                   '  AND SIH.BILL_DATE <= {d ''2016-07-27''} '+
                                  '  AND SIH.SALES_OFF = ''E01'' ' +
                               'GROUP BY 1) H ' +
             'ON CU.CUSTOMER = H.CUSTOMER ' +
             'WHERE CU.ZZIPCD5 <> '''' AND ' +
                          'CU.ACCNT_GRP = ''0001'' '.
CACHE.
EXE.

DATASET NAME GCSLS_BY_AZ.
DATASET ACTIVATE GCSLS_BY_AZ.

*Rename the variables.
RENAME VARIABLES 
   CP1_ORDERS = GC_CP1_ORDERS
   CP1_SALES = GC_CP1_SALES
   CP2_ORDERS = GC_CP2_ORDERS
   CP2_SALES = GC_CP2_SALES
   WK1_ORDERS = GC_WK1_ORDERS
   WK1_SALES = GC_WK1_SALES
   WK2_ORDERS = GC_WK2_ORDERS
   WK2_SALES = GC_WK2_SALES
   WK3_ORDERS = GC_WK3_ORDERS
   WK3_SALES = GC_WK3_SALES
   WK4_ORDERS = GC_WK4_ORDERS
   WK4_SALES = GC_WK4_SALES
   WK5_ORDERS = GC_WK5_ORDERS
   WK5_SALES = GC_WK5_SALES
   WK6_ORDERS = GC_WK6_ORDERS
   WK6_SALES = GC_WK6_SALES.

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
             '  A.ORDERS CP1_ORDERS, A.SALES CP1_SALES, B.ORDERS CP2_ORDERS, B.SALES CP2_SALES, C.ORDERS WK1_ORDERS, C.SALES WK1_SALES, ' +
             '  D.ORDERS WK2_ORDERS, D.SALES WK2_SALES, E.ORDERS WK3_ORDERS, E.SALES WK3_SALES, F.ORDERS WK4_ORDERS, F.SALES WK4_SALES, ' +
             '  G.ORDERS WK5_ORDERS, G.SALES WK5_SALES, H.ORDERS WK6_ORDERS, H.SALES WK6_SALES ' +
            'FROM PRD_DWH_VIEW.Sales_Invoice_Summary_V SI ' +
                 'LEFT JOIN (SELECT SIA.SOLD_TO CUSTOMER, SIA.ZSHIPZIP, COUNT(DISTINCT SIA.S_ORD_NUM) ORDERS, SUM(SIA.SUBTOTAL_2) SALES '+
                                   'FROM PRD_DWH_VIEW.Sales_Invoice_V SIA '+
                                   'WHERE '+
                                        '  SIA.ZZCOMFLG = ''Y'' ' +
                                        '  AND SIA.BILL_DATE >= {d ''2016-06-01''} '+
                                        '  AND SIA.BILL_DATE <= {d ''2016-06-07''} '+
                                        '  AND SIA.SALES_OFF = ''E01'' ' +
                                        '  AND SIA.SOLD_TO = ''0222222226'' ' +
                                    'GROUP BY 1,2) A ' +
                 'ON SI.SOLD_TO = A.CUSTOMER AND SI.ZSHIPZIP = A.ZSHIPZIP '+
                 'LEFT JOIN (SELECT SIB.SOLD_TO CUSTOMER, SIB.ZSHIPZIP, COUNT(DISTINCT SIB.S_ORD_NUM) ORDERS, SUM(SIB.SUBTOTAL_2) SALES '+
                                   'FROM PRD_DWH_VIEW.Sales_Invoice_V SIB '+
                                   'WHERE '+
                                        '  SIB.ZZCOMFLG = ''Y'' ' +
                                        '  AND SIB.BILL_DATE >= {d ''2016-06-08''} '+
                                        '  AND SIB.BILL_DATE <= {d ''2016-06-14''} '+
                                        '  AND SIB.SALES_OFF = ''E01'' ' +
                                        '  AND SIB.SOLD_TO = ''0222222226'' ' +
                                    'GROUP BY 1,2) B ' +
                 'ON SI.SOLD_TO = B.CUSTOMER AND SI.ZSHIPZIP = B.ZSHIPZIP '+
                 'LEFT JOIN (SELECT SIC.SOLD_TO CUSTOMER, SIC.ZSHIPZIP, COUNT(DISTINCT SIC.S_ORD_NUM) ORDERS, SUM(SIC.SUBTOTAL_2) SALES '+
                                   'FROM PRD_DWH_VIEW.Sales_Invoice_V SIC '+
                                   'WHERE '+
                                        '  SIC.ZZCOMFLG = ''Y'' ' +
                                        '  AND SIC.BILL_DATE >= {d ''2016-06-15''} '+
                                        '  AND SIC.BILL_DATE <= {d ''2016-06-21''} '+
                                        '  AND SIC.SALES_OFF = ''E01'' ' +
                                        '  AND SIC.SOLD_TO = ''0222222226'' ' +
                                    'GROUP BY 1,2) C ' +
                 'ON SI.SOLD_TO = C.CUSTOMER AND SI.ZSHIPZIP = C.ZSHIPZIP '+
                 'LEFT JOIN (SELECT SID.SOLD_TO CUSTOMER, SID.ZSHIPZIP, COUNT(DISTINCT SID.S_ORD_NUM) ORDERS, SUM(SID.SUBTOTAL_2) SALES '+
                                   'FROM PRD_DWH_VIEW.Sales_Invoice_V SID '+
                                   'WHERE '+
                                        '  SID.ZZCOMFLG = ''Y'' ' +
                                        '  AND SID.BILL_DATE >= {d ''2016-06-22''} '+
                                        '  AND SID.BILL_DATE <= {d ''2016-06-28''} '+
                                        '  AND SID.SALES_OFF = ''E01'' ' +
                                        '  AND SID.SOLD_TO = ''0222222226'' ' +
                                    'GROUP BY 1,2) D ' +
                 'ON SI.SOLD_TO = D.CUSTOMER AND SI.ZSHIPZIP = D.ZSHIPZIP '+
                 'LEFT JOIN (SELECT SIE.SOLD_TO CUSTOMER, SIE.ZSHIPZIP, COUNT(DISTINCT SIE.S_ORD_NUM) ORDERS, SUM(SIE.SUBTOTAL_2) SALES '+
                                   'FROM PRD_DWH_VIEW.Sales_Invoice_V SIE '+
                                   'WHERE '+
                                        '  SIE.ZZCOMFLG = ''Y'' ' +
                                        '  AND SIE.BILL_DATE >= {d ''2016-06-29''} '+
                                        '  AND SIE.BILL_DATE <= {d ''2016-07-06''} '+
                                        '  AND SIE.SALES_OFF = ''E01'' ' +
                                        '  AND SIE.SOLD_TO = ''0222222226'' ' +
                                    'GROUP BY 1,2) E ' +
                 'ON SI.SOLD_TO = E.CUSTOMER AND SI.ZSHIPZIP = E.ZSHIPZIP '+
                 'LEFT JOIN (SELECT SIF.SOLD_TO CUSTOMER, SIF.ZSHIPZIP, COUNT(DISTINCT SIF.S_ORD_NUM) ORDERS, SUM(SIF.SUBTOTAL_2) SALES '+
                                   'FROM PRD_DWH_VIEW.Sales_Invoice_V SIF '+
                                   'WHERE '+
                                        '  SIF.ZZCOMFLG = ''Y'' ' +
                                        '  AND SIF.BILL_DATE >= {d ''2016-07-07''} '+
                                        '  AND SIF.BILL_DATE <= {d ''2016-07-13''} '+
                                        '  AND SIF.SALES_OFF = ''E01'' ' +
                                        '  AND SIF.SOLD_TO = ''0222222226'' ' +
                                    'GROUP BY 1,2) F ' +
                 'ON SI.SOLD_TO = F.CUSTOMER AND SI.ZSHIPZIP = F.ZSHIPZIP '+
                 'LEFT JOIN (SELECT SIG.SOLD_TO CUSTOMER, SIG.ZSHIPZIP, COUNT(DISTINCT SIG.S_ORD_NUM) ORDERS, SUM(SIG.SUBTOTAL_2) SALES '+
                                   'FROM PRD_DWH_VIEW.Sales_Invoice_V SIG '+
                                   'WHERE '+
                                        '  SIG.ZZCOMFLG = ''Y'' ' +
                                        '  AND SIG.BILL_DATE >= {d ''2016-07-14''} '+
                                        '  AND SIG.BILL_DATE <= {d ''2016-07-20''} '+
                                        '  AND SIG.SALES_OFF = ''E01'' ' +
                                        '  AND SIG.SOLD_TO = ''0222222226'' ' +
                                    'GROUP BY 1,2) G ' +
                 'ON SI.SOLD_TO = G.CUSTOMER AND SI.ZSHIPZIP = G.ZSHIPZIP '+
                 'LEFT JOIN (SELECT SIH.SOLD_TO CUSTOMER, SIH.ZSHIPZIP, COUNT(DISTINCT SIH.S_ORD_NUM) ORDERS, SUM(SIH.SUBTOTAL_2) SALES '+
                                   'FROM PRD_DWH_VIEW.Sales_Invoice_V SIH '+
                                   'WHERE '+
                                        '  SIH.ZZCOMFLG = ''Y'' ' +
                                        '  AND SIH.BILL_DATE >= {d ''2016-07-21''} '+
                                        '  AND SIH.BILL_DATE <= {d ''2016-07-27''} '+
                                        '  AND SIH.SALES_OFF = ''E01'' ' +
                                        '  AND SIH.SOLD_TO = ''0222222226'' ' +
                                    'GROUP BY 1,2) H ' +
                 'ON SI.SOLD_TO = H.CUSTOMER AND SI.ZSHIPZIP = H.ZSHIPZIP '+
            'WHERE SI.BILL_DATE >= {d ''2016-06-01''}  AND ' +
                          'SI.BILL_DATE <= {d ''2016-07-27''} AND ' +
                          'SI.SALES_OFF = ''E01'' AND ' +
                          'SI.SOLD_TO = ''0222222226'' AND ' +
                          'SI.ZZCOMFLG = ''Y'' '.
CACHE.
EXE.

DATASET NAME GUEST.
DATASET ACTIVATE GUEST.

COMPUTE GC_CP1_ORDERS = CP1_ORDERS.
COMPUTE GC_CP1_SALES = CP1_SALES.
COMPUTE GC_CP2_ORDERS = CP2_ORDERS.
COMPUTE GC_CP2_SALES = CP2_SALES.
COMPUTE GC_WK1_ORDERS = WK1_ORDERS.
COMPUTE GC_WK1_SALES = WK1_SALES.
COMPUTE GC_WK2_ORDERS = WK2_ORDERS. 
COMPUTE GC_WK2_SALES = WK2_SALES. 
COMPUTE GC_WK3_ORDERS = WK3_ORDERS.
COMPUTE GC_WK3_SALES = WK3_SALES.
COMPUTE GC_WK4_ORDERS = WK4_ORDERS.
COMPUTE GC_WK4_SALES = WK4_SALES.
COMPUTE GC_WK5_ORDERS = WK5_ORDERS.
COMPUTE GC_WK5_SALES = WK5_SALES.
COMPUTE GC_WK6_ORDERS = WK6_ORDERS.
COMPUTE GC_WK6_SALES = WK6_SALES.

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
VECTOR KF = CP1_ORDERS TO GC_WK6_SALES.

LOOP #i = 1 TO 42.

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

DATASET ACTIVATE SLS_BY_AZ.

MATCH FILES
   /FILE = *
   /TABLE = 'ZTD'
   /BY ZIPCODE.
EXE.

DATASET CLOSE ZTD.
DATASET ACTIVATE SLS_BY_AZ.

*Filter out any accounts which were identified as being more than a $500K annual spend account prior to creating the forecast.
 * GET FILE = '/usr/spss/userdata/Albrecht/PPC Geo/Weekly Updates/Five Year Sales through May16 by Account for Target Markets.sav'
   /KEEP account HSV.
 * CACHE.
 * EXE.

 * DATASET NAME HSV.

*Filter out any accounts which were identified as having high avg monthly orders or unstable order history.
GET FILE = '/usr/spss/userdata/Albrecht/PPC Geo/Weekly Updates/Five Year Orders through May16 by Account for Target Markets.sav'
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

*Filter out the record for account 855313060.
*This is an amazon account we say is in Seattle but DUNS says is in Lexington.
*This account was not included in the initial forecast and will skew results if left in the analysis.

*Also filter out DSI (Electrical Reseller?) accounts which were created on June 13th and June 14th in Birmingham, AL.
*These acquisitions are skewing the acquisition numbers.

 * COMPUTE Include = (CUSTOMER <> '0855313060' AND (ZIPCODE <> '35007' OR CREATE_DATE <> DATE.MDY(6,13,2016) ) AND HSV = 0).
 * FORMATS Include(F1.0).

 * COMPUTE Include = (CUSTOMER <> '0855313060' AND (ZIPCODE <> '35007' OR (CREATE_DATE <> DATE.MDY(6,13,2016) AND CREATE_DATE <> DATE.MDY(7,11,2016) ) ) ).
 * FORMATS Include(F1.0).

COMPUTE Include = (CUSTOMER <> '0855313060' AND Order_Outlier = 0 AND Stable_Order_Outlier = 0 AND
                                  (ZIPCODE <> '35007' OR (CREATE_DATE <> DATE.MDY(6,13,2016) AND CREATE_DATE <> DATE.MDY(7,11,2016) ) ) ).
FORMATS Include(F1.0).
EXE.

*Add the MRO decile for each account to analyze AOV.
 * GET FILE = '/usr/spss/userdata/model_files/201605_May_merged_model_file.sav'
   /KEEP account mro_decile.
 * CACHE.
 * EXE.

 * DATASET NAME AF.

 * DATASET ACTIVATE SLS_BY_AZ.

 * MATCH FILES
   /FILE = *
   /TABLE = 'AF'
   /BY account.
 * EXE.

 * DATASET CLOSE AF.
 * DATASET ACTIVATE SLS_BY_AZ.

 * COMPUTE XL_Cust = (mro_decile = 1).
 * FORMATS XL_Cust(F1.0).

 * COMPUTE L_Cust = (mro_decile = 2 OR mro_decile = 3).
 * FORMATS L_Cust(F1.0).

 * COMPUTE M_Cust = (ANY(mro_decile,4,5,6)).
 * FORMATS M_Cust(F1.0).

 * COMPUTE S_Cust = (mro_decile >= 7).
 * FORMATS S_Cust(F1.0).

*Look at the distribution of account's AOV during the testing period.
 * COMPUTE TP_SALES = SUM(WK1_SALES,WK2_SALES,WK3_SALES,WK4_SALES,WK5_SALES).
 * COMPUTE TP_ORDERS = SUM(WK1_ORDERS,WK2_ORDERS,WK3_ORDERS,WK4_ORDERS,WK5_ORDERS).

 * COMPUTE TP_GC_SALES = SUM(GC_WK1_SALES, GC_WK2_SALES,GC_WK3_SALES,GC_WK4_SALES,GC_WK5_SALES).
 * COMPUTE TP_GC_ORDERS = SUM(GC_WK1_ORDERS, GC_WK2_ORDERS,GC_WK3_ORDERS,GC_WK4_ORDERS,GC_WK5_ORDERS).

 * DO IF( TP_ORDERS > 0 ).

 *    COMPUTE TP_AOV = ( TP_SALES / TP_ORDERS ).

 * ELSE.

 *    COMPUTE TP_AOV = 0.

 * END IF.

 * DO IF( TP_GC_ORDERS > 0 ).

 *    COMPUTE TP_GC_AOV = ( TP_GC_SALES / TP_GC_ORDERS ).

 * ELSE.

 *    COMPUTE TP_GC_AOV = 0.

 * END IF.

 * DO IF( WK5_ORDERS > 0 ).

 *    COMPUTE WK5_AOV = ( WK5_SALES / WK5_ORDERS ).

 * ELSE.

 *    COMPUTE WK5_AOV = 0.

 * END IF.

 * DO IF( GC_WK5_ORDERS > 0 ).

 *    COMPUTE WK5_GC_AOV = ( GC_WK5_SALES / GC_WK5_ORDERS ).

 * ELSE.

 *    COMPUTE WK5_GC_AOV = 0.

 * END IF.
 * EXE.

*Save the resulting file.
SAVE OUTFILE = '/usr/spss/userdata/Albrecht/PPC Geo/Weekly Updates/Week 6/GIS and Gcom Sales and Acquisitions by Account.sav'.

*Copy the dataset and select only accounts to include and those with an AOV > 0 during the testing period.
 * DATASET COPY AOV.
 * DATASET ACTIVATE AOV.

 * SELECT IF(Include = 1 AND TP_AOV > 0 AND TP_SALES >= 10).
 * EXE.

 * EXAMINE TP_AOV
   /PLOT HISTOGRAM BOXPLOT
   /PERCENTILES(5,10,25,50,75,90,95,99).

*Examine the distribution for small accounts.
 * FILTER BY S_Cust.

 * EXAMINE TP_AOV
   /PLOT HISTOGRAM BOXPLOT
   /PERCENTILES(5,10,25,50,75,90,95,99).

*Examine the distribution for medium accounts.
 * FILTER BY M_Cust.

 * EXAMINE TP_AOV
   /PLOT HISTOGRAM BOXPLOT
   /PERCENTILES(5,10,25,50,75,90,95,99).

*Examine the distribution for large accounts.
 * FILTER BY L_Cust.

 * EXAMINE TP_AOV
   /PLOT HISTOGRAM BOXPLOT
   /PERCENTILES(5,10,25,50,75,90,95,99).

*Examine the distribution for very large accounts.
 * FILTER BY XL_Cust.

 * EXAMINE TP_AOV
   /PLOT HISTOGRAM BOXPLOT
   /PERCENTILES(5,10,25,50,75,90,95,99).

 * FILTER OFF.

 * COMPUTE TP_AOV_MAX = TP_AOV.
 * IF(TP_AOV > 1000) TP_AOV_MAX = 1000.

*Bin the accounts based on their AOV to compare the distribution of experiment groups.
 * RECODE  TP_AOV_MAX (MISSING=COPY) (LO THRU 50=1) (LO THRU 100=2) (LO THRU 150=3) (LO THRU 200=4) 
    (LO THRU 250=5) (LO THRU 300=6) (LO THRU 350=7) (LO THRU 400=8) (LO THRU 450=9) (LO THRU 500=10) 
    (LO THRU 550=11) (LO THRU 600=12) (LO THRU 650=13) (LO THRU 700=14) (LO THRU 750=15) (LO THRU 
    800=16) (LO THRU 850=17) (LO THRU 900=18) (LO THRU 950=19) (LO THRU HI=20) (ELSE=SYSMIS) INTO 
    TP_AOV_BIN.
 * VARIABLE LEVEL  TP_AOV_BIN (ORDINAL).
 * EXE.

 * MEANS TP_SALES BY Group BY TP_AOV_BIN
   /CELLS SUM COUNT.

*Look at the distribution of AOV only for those accounts which have an AOV higher than $950.
 * DATASET COPY HIGH_AOV.
 * DATASET ACTIVATE HIGH_AOV.

 * SELECT IF(TP_AOV >= 2000).
 * EXE.

 * EXAMINE TP_AOV
   /PLOT HISTOGRAM BOXPLOT
   /PERCENTILES(5,10,25,50,75,90,95,99).

 * EXAMINE TP_ORDERS
   /PLOT HISTOGRAM BOXPLOT
   /PERCENTILES(5,10,25,50,75,90,95,99).

 * SORT CASES BY TP_AOV(D) TP_ORDERS(D).

 * FREQ mro_decile.

*Copy the dataset and select only accounts to include and those with an Gcom AOV > 0 during the testing period.
 * DATASET ACTIVATE SLS_BY_AZ.

 * DATASET COPY GC_AOV.
 * DATASET ACTIVATE GC_AOV.

 * SELECT IF(Include = 1 AND TP_GC_AOV > 0 AND TP_GC_SALES >= 10).
 * EXE.

 * EXAMINE TP_GC_AOV
   /PLOT HISTOGRAM BOXPLOT
   /PERCENTILES(5,10,25,50,75,90,95,99).

*Examine the distribution for small accounts.
 * FILTER BY S_Cust.

 * EXAMINE TP_GC_AOV
   /PLOT HISTOGRAM BOXPLOT
   /PERCENTILES(5,10,25,50,75,90,95,99).

*Examine the distribution for medium accounts.
 * FILTER BY M_Cust.

 * EXAMINE TP_GC_AOV
   /PLOT HISTOGRAM BOXPLOT
   /PERCENTILES(5,10,25,50,75,90,95,99).

*Examine the distribution for large accounts.
 * FILTER BY L_Cust.

 * EXAMINE TP_GC_AOV
   /PLOT HISTOGRAM BOXPLOT
   /PERCENTILES(5,10,25,50,75,90,95,99).

*Examine the distribution for very large accounts.
 * FILTER BY XL_Cust.

 * EXAMINE TP_GC_AOV
   /PLOT HISTOGRAM BOXPLOT
   /PERCENTILES(5,10,25,50,75,90,95,99).

 * FILTER OFF.

 * COMPUTE TP_GC_AOV_MAX = TP_GC_AOV.
 * IF(TP_GC_AOV > 1000) TP_GC_AOV_MAX = 1000.
 * EXE.

*Bin the accounts based on their AOV to compare the distribution of experiment groups.
 * RECODE  TP_GC_AOV_MAX (MISSING=COPY) (LO THRU 50=1) (LO THRU 100=2) (LO THRU 150=3) (LO THRU 200=4) 
    (LO THRU 250=5) (LO THRU 300=6) (LO THRU 350=7) (LO THRU 400=8) (LO THRU 450=9) (LO THRU 500=10) 
    (LO THRU 550=11) (LO THRU 600=12) (LO THRU 650=13) (LO THRU 700=14) (LO THRU 750=15) (LO THRU 
    800=16) (LO THRU 850=17) (LO THRU 900=18) (LO THRU 950=19) (LO THRU HI=20) (ELSE=SYSMIS) INTO 
    TP_GC_AOV_BIN.
 * VARIABLE LEVEL  TP_GC_AOV_BIN (ORDINAL).
 * EXE.

 * MEANS TP_GC_SALES BY Group BY TP_GC_AOV_BIN
   /CELLS SUM COUNT.

*Look at the distribution of AOV only for those accounts which have an AOV higher than $950.
 * DATASET COPY HIGH_GC_AOV.
 * DATASET ACTIVATE HIGH_GC_AOV.

 * SELECT IF(TP_GC_AOV >= 2500 AND XL_Cust = 1).
 * EXE.

 * EXAMINE TP_GC_AOV
   /PLOT HISTOGRAM BOXPLOT
   /PERCENTILES(5,10,25,50,75,90,95,99).

 * EXAMINE TP_GC_ORDERS
   /PLOT HISTOGRAM BOXPLOT
   /PERCENTILES(5,10,25,50,75,90,95,99).

 * SORT CASES BY TP_GC_AOV(D) TP_GC_ORDERS(D).

 * FREQ mro_decile.

 * DATASET CLOSE HIGH_GC_AOV.
 * DATASET CLOSE GC_AOV.
 * DATASET CLOSE HIGH_AOV.
 * DATASET CLOSE AOV.

 * DATASET ACTIVATE SLS_BY_AZ.

 * DATASET COPY OUT_ADJ.
 * DATASET ACTIVATE OUT_ADJ.

*Reset sales for account 0846607042 which experienced $150K in Gcom sales in Week 1 of the test which is 25% higher than any of their total monthly Gcom sales in the last 3 years.
*This was commented out because this is a High Sales Value account which was excluded in the most recent forecast.
 * IF(Customer = '0846607042') WK1_SALES = 17500.
 * IF(Customer = '0846607042') GC_WK1_SALES = 17500.

*Re-calculate high AOV accounts with < 5 orders in the Spend Down and Zero Spend Groups.
*This was commented out because new rules for correcting outliers were implemented in the code immediately following.
 * IF(ANY(CUSTOMER,'0854305455','0870984093','0804985083','0804980407','0862008356')) WK2_SALES = (300 * WK2_ORDERS).
 * IF(ANY(CUSTOMER,'0810662916','0885878304','0848566816','0881163075','0885857249','0884957564')) GC_WK2_SALES = (GC_WK2_ORDERS * 500).
 * EXE.

 * DO IF(TP_AOV >= 9500 AND XL_Cust = 1).

 *    COMPUTE WK1_SALES = (WK1_ORDERS * 4000).
 *    COMPUTE WK2_SALES = (WK2_ORDERS * 4000).

 * ELSE IF(TP_AOV >= 6500 AND L_Cust = 1).

 *    COMPUTE WK1_SALES = (WK1_ORDERS * 2000).
 *    COMPUTE WK2_SALES = (WK2_ORDERS * 2000).

 * ELSE IF(TP_AOV >= 6500 AND M_Cust = 1).

 *    COMPUTE WK1_SALES = (WK1_ORDERS * 2000).
 *    COMPUTE WK2_SALES = (WK2_ORDERS * 2000).

 * ELSE IF(TP_AOV >= 6500 AND S_Cust = 1).

 *    COMPUTE WK1_SALES = (WK1_ORDERS * 2000).
 *    COMPUTE WK2_SALES = (WK2_ORDERS * 2000).

 * END IF.

 * DO IF(TP_GC_AOV >= 5000 AND XL_Cust = 1).

 *    COMPUTE GC_WK1_SALES = (GC_WK1_ORDERS * 2300).
 *    COMPUTE GC_WK2_SALES = (GC_WK2_ORDERS * 2300).

 * ELSE IF(TP_GC_AOV >= 4300 AND L_Cust = 1).

 *    COMPUTE GC_WK1_SALES = (GC_WK1_ORDERS * 1700).
 *    COMPUTE GC_WK2_SALES = (GC_WK2_ORDERS * 1700).

 * ELSE IF(TP_GC_AOV >= 4300 AND M_Cust = 1).

 *    COMPUTE GC_WK1_SALES = (GC_WK1_ORDERS * 1700).
 *    COMPUTE GC_WK2_SALES = (GC_WK2_ORDERS * 1700).

 * ELSE IF(TP_GC_AOV >= 4300 AND S_Cust = 1).

 *    COMPUTE GC_WK1_SALES = (GC_WK1_ORDERS * 1700).
 *    COMPUTE GC_WK2_SALES = (GC_WK2_ORDERS * 1700).

 * END IF.

 * DO IF(WK3_AOV >= 9500 AND XL_Cust = 1).

 *    COMPUTE WK3_SALES = (WK3_ORDERS * 4000).

 * ELSE IF(WK3_AOV >= 6500 AND XL_Cust = 0).

 *    COMPUTE WK3_SALES = (WK3_ORDERS * 2000).

 * END IF.

 * DO IF(WK3_GC_AOV >= 5000 AND XL_Cust = 1).

 *    COMPUTE GC_WK3_SALES = (GC_WK3_ORDERS * 2300).

 * ELSE IF(WK3_GC_AOV >= 4300 AND XL_Cust = 0).

 *    COMPUTE GC_WK3_SALES = (GC_WK3_ORDERS * 1700).

 * END IF.
 * EXE.

*Aggregate the data by DMA and group.
FILTER BY Include.

DATASET DECLARE SLS_BY_DMA.

AGGREGATE
   /OUTFILE = 'SLS_BY_DMA'
   /BREAK = DMA Group
   /JUN15_ACQ = SUM(JUN15_ACQ)
   /JUL15_ACQ = SUM(JUL15_ACQ)
   /CP1_ACQ = SUM(CP1_ACQ)
   /CP1_ORDERS = SUM(CP1_ORDERS)
   /CP1_SALES = SUM(CP1_SALES)
   /GC_CP1_ORDERS = SUM(GC_CP1_ORDERS)
   /GC_CP1_SALES = SUM(GC_CP1_SALES)
   /CP2_ACQ = SUM(CP2_ACQ)
   /CP2_ORDERS = SUM(CP2_ORDERS)
   /CP2_SALES = SUM(CP2_SALES)
   /GC_CP2_ORDERS = SUM(GC_CP2_ORDERS)
   /GC_CP2_SALES = SUM(GC_CP2_SALES)
   /WK1_ACQ = SUM(WK1_ACQ)
   /WK1_ORDERS = SUM(WK1_ORDERS)
   /WK1_SALES = SUM(WK1_SALES)
   /GC_WK1_ORDERS = SUM(GC_WK1_ORDERS)
   /GC_WK1_SALES = SUM(GC_WK1_SALES)
   /WK2_ACQ = SUM(WK2_ACQ)
   /WK2_ORDERS = SUM(WK2_ORDERS)
   /WK2_SALES = SUM(WK2_SALES)
   /GC_WK2_ORDERS = SUM(GC_WK2_ORDERS)
   /GC_WK2_SALES = SUM(GC_WK2_SALES)
   /WK3_ACQ = SUM(WK3_ACQ)
   /WK3_ORDERS = SUM(WK3_ORDERS)
   /WK3_SALES = SUM(WK3_SALES)
   /GC_WK3_ORDERS = SUM(GC_WK3_ORDERS)
   /GC_WK3_SALES = SUM(GC_WK3_SALES)
   /WK4_ACQ = SUM(WK4_ACQ)
   /WK4_ORDERS = SUM(WK4_ORDERS)
   /WK4_SALES = SUM(WK4_SALES)
   /GC_WK4_ORDERS = SUM(GC_WK4_ORDERS)
   /GC_WK4_SALES = SUM(GC_WK4_SALES)
   /WK5_ACQ = SUM(WK5_ACQ)
   /WK5_ORDERS = SUM(WK5_ORDERS)
   /WK5_SALES = SUM(WK5_SALES)
   /GC_WK5_ORDERS = SUM(GC_WK5_ORDERS)
   /GC_WK5_SALES = SUM(GC_WK5_SALES)
   /WK6_ACQ = SUM(WK6_ACQ)
   /WK6_ORDERS = SUM(WK6_ORDERS)
   /WK6_SALES = SUM(WK6_SALES)
   /GC_WK6_ORDERS = SUM(GC_WK6_ORDERS)
   /GC_WK6_SALES = SUM(GC_WK6_SALES).

DATASET ACTIVATE SLS_BY_DMA.

SORT CASES BY Group(A) DMA(A).

SELECT IF(Group > 0).
EXE.

***LOOK AT ACQUISITIONS***.

MEANS JUN15_ACQ JUL15_ACQ CP1_ACQ CP2_ACQ WK1_ACQ WK2_ACQ WK3_ACQ WK4_ACQ WK5_ACQ WK6_ACQ BY Group
   /CELLS SUM.

***LOOK AT TOTAL GIS AND GCOM SALES AND ORDERS FOR THE FIRST WEEK OF THE ANALYSIS PERIOD***.

MEANS CP1_SALES GC_CP1_SALES CP2_SALES GC_CP2_SALES WK1_SALES GC_WK1_SALES  WK2_SALES GC_WK2_SALES WK3_SALES GC_WK3_SALES
             WK4_SALES GC_WK4_SALES WK5_SALES GC_WK5_SALES WK6_SALES GC_WK6_SALES BY Group
   /CELLS SUM.

MEANS CP1_ORDERS GC_CP1_ORDERS CP2_ORDERS GC_CP2_ORDERS WK1_ORDERS GC_WK1_ORDERS  WK2_ORDERS GC_WK2_ORDERS WK3_ORDERS 
            GC_WK3_ORDERS WK4_ORDERS GC_WK4_ORDERS WK5_ORDERS GC_WK5_ORDERS WK6_ORDERS GC_WK6_ORDERS BY Group
   /CELLS SUM.

