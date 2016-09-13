*Select GIS sales by account and zipcode for the dates we would like.
GET DATA 
  /TYPE=ODBC 
  /CONNECT='DSN=Teradata;DB=PRD_DWH_VIEW;PORT=1025;DBCNL=10.4.165.29;UID=spss;PWD=$-<~*x#N3@!/-!!+'
  /SQL='SELECT '+
             '  CU.CUSTOMER, CU.ZZIPCD5 ZIPCODE, CU.CREATEDON CREATE_DATE, CPD.FIRST_PURCH_DT FPD, ' +
             '  A.ORDERS CP1_ORDERS, A.SALES CP1_SALES, B.ORDERS CP2_ORDERS, B.SALES CP2_SALES, C.ORDERS WK1_ORDERS, C.SALES WK1_SALES, ' +
             '  D.ORDERS WK2_ORDERS, D.SALES WK2_SALES, E.ORDERS WK3_ORDERS, E.SALES WK3_SALES, F.ORDERS WK4_ORDERS, F.SALES WK4_SALES, ' + 
             '  G.ORDERS WK5_ORDERS, G.SALES WK5_SALES, H.ORDERS WK6_ORDERS, H.SALES WK6_SALES, I.ORDERS WK7_ORDERS, I.SALES WK7_SALES, ' +
             '  J.ORDERS WK8_ORDERS, J.SALES WK8_SALES ' +
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
           'LEFT JOIN (SELECT SII.SOLD_TO CUSTOMER, COUNT(DISTINCT SII.BILL_NUM) ORDERS, SUM(SII.SUBTOTAL_2) SALES '+
                              'FROM PRD_DWH_VIEW.Sales_Invoice_V SII '+
                              'WHERE '+
                                   '  SII.ZZCOMFLG = ''Y'' ' +
                                   '  AND SII.BILL_DATE >= {d ''2016-07-28''} '+
                                   '  AND SII.BILL_DATE <= {d ''2016-08-03''} '+
                               'GROUP BY 1) I ' +
             'ON CU.CUSTOMER = I.CUSTOMER ' +
           'LEFT JOIN (SELECT SIJ.SOLD_TO CUSTOMER, COUNT(DISTINCT SIJ.BILL_NUM) ORDERS, SUM(SIJ.SUBTOTAL_2) SALES '+
                              'FROM PRD_DWH_VIEW.Sales_Invoice_V SIJ '+
                              'WHERE '+
                                   '  SIJ.ZZCOMFLG = ''Y'' ' +
                                   '  AND SIJ.BILL_DATE >= {d ''2016-08-04''} '+
                                   '  AND SIJ.BILL_DATE <= {d ''2016-08-10''} '+
                               'GROUP BY 1) J ' +
             'ON CU.CUSTOMER = J.CUSTOMER ' +
             'WHERE CU.ZZIPCD5 <> '''' AND ' +
                          'CU.ACCNT_GRP = ''0001'' '.
CACHE.
EXE.

DATASET NAME SLS_BY_AZ.
DATASET ACTIVATE SLS_BY_AZ.

SORT CASES BY CUSTOMER(A) ZIPCODE(A).

*Compute a variable to show accounts acquired during the cleansing period as well as those acquired during the weeks of the test.
 * DO IF(MISSING(FPD) = 0).

 *    COMPUTE JUN15_ACQ = ( (CREATE_DATE >= DATE.MDY(6,1,2015) AND CREATE_DATE <= DATE.MDY(6,30,2015)) OR 
                                          (FPD >= DATE.MDY(6,1,2015) AND FPD <= DATE.MDY(6,30,2015)) ).
 *    FORMATS JUN15_ACQ(F1.0).

 *    COMPUTE JUL15_ACQ = ( (CREATE_DATE >= DATE.MDY(7,1,2015) AND CREATE_DATE <= DATE.MDY(7,31,2015)) OR 
                                          (FPD >= DATE.MDY(7,1,2015) AND FPD <= DATE.MDY(7,31,2015)) ).
 *    FORMATS JUL15_ACQ(F1.0).

 *    COMPUTE AUG15_ACQ = ( (CREATE_DATE >= DATE.MDY(8,1,2015) AND CREATE_DATE <= DATE.MDY(8,31,2015)) OR 
                                          (FPD >= DATE.MDY(8,1,2015) AND FPD <= DATE.MDY(8,31,2015)) ).
 *    FORMATS AUG15_ACQ(F1.0). 

 *    COMPUTE CP1_ACQ = ( (CREATE_DATE >= DATE.MDY(6,1,2016) AND CREATE_DATE <= DATE.MDY(6,7,2016)) OR 
                                        (FPD >= DATE.MDY(6,1,2016) AND FPD <= DATE.MDY(6,7,2016)) ).
 *    FORMATS CP1_ACQ(F1.0).

 *    COMPUTE CP2_ACQ = ( (CREATE_DATE >= DATE.MDY(6,8,2016) AND CREATE_DATE <= DATE.MDY(6,14,2016)) OR 
                                        (FPD >= DATE.MDY(6,8,2016) AND FPD <= DATE.MDY(6,14,2016)) ).
 *    FORMATS CP2_ACQ(F1.0).

 *    COMPUTE WK1_ACQ = ( (CREATE_DATE >= DATE.MDY(6,15,2016) AND CREATE_DATE <= DATE.MDY(6,21,2016)) OR 
                                          (FPD >= DATE.MDY(6,15,2016) AND FPD <= DATE.MDY(6,15,2016)) ).
 *    FORMATS WK1_ACQ(F1.0).

 *    COMPUTE WK2_ACQ = ( (CREATE_DATE >= DATE.MDY(6,22,2016) AND CREATE_DATE <= DATE.MDY(6,28,2016)) OR 
                                          (FPD >= DATE.MDY(6,22,2016) AND FPD <= DATE.MDY(6,28,2016)) ).
 *    FORMATS WK2_ACQ(F1.0).

 *    COMPUTE WK3_ACQ = ( (CREATE_DATE >= DATE.MDY(6,29,2016) AND CREATE_DATE <= DATE.MDY(7,6,2016)) OR 
                                          (FPD >= DATE.MDY(6,29,2016) AND FPD <= DATE.MDY(7,6,2016)) ).
 *    FORMATS WK3_ACQ(F1.0).

 *    COMPUTE WK4_ACQ = ( (CREATE_DATE >= DATE.MDY(7,7,2016) AND CREATE_DATE <= DATE.MDY(7,13,2016)) OR 
                                          (FPD >= DATE.MDY(7,7,2016) AND FPD <= DATE.MDY(7,13,2016)) ).
 *    FORMATS WK4_ACQ(F1.0).

 *    COMPUTE WK5_ACQ = ( (CREATE_DATE >= DATE.MDY(7,14,2016) AND CREATE_DATE <= DATE.MDY(7,20,2016)) OR 
                                          (FPD >= DATE.MDY(7,14,2016) AND FPD <= DATE.MDY(7,20,2016)) ).
 *    FORMATS WK5_ACQ(F1.0).

 *    COMPUTE WK6_ACQ = ( (CREATE_DATE >= DATE.MDY(7,21,2016) AND CREATE_DATE <= DATE.MDY(7,28,2016)) OR 
                                          (FPD >= DATE.MDY(7,21,2016) AND FPD <= DATE.MDY(7,27,2016)) ).
 *    FORMATS WK6_ACQ(F1.0).

 *    COMPUTE WK7_ACQ = ( (CREATE_DATE >= DATE.MDY(7,28,2016) AND CREATE_DATE <= DATE.MDY(8,3,2016)) OR 
                                          (FPD >= DATE.MDY(7,28,2016) AND FPD <= DATE.MDY(8,3,2016)) ).
 *    FORMATS WK7_ACQ(F1.0).

 * ELSE.

COMPUTE JUN15_ACQ = ( (CREATE_DATE >= DATE.MDY(6,1,2015) AND CREATE_DATE <= DATE.MDY(6,30,2015)) ).
FORMATS JUN15_ACQ(F1.0).

COMPUTE JUL15_ACQ = ( (CREATE_DATE >= DATE.MDY(7,1,2015) AND CREATE_DATE <= DATE.MDY(7,31,2015)) ).
FORMATS JUL15_ACQ(F1.0).

COMPUTE AUG15_ACQ = ( (CREATE_DATE >= DATE.MDY(8,1,2015) AND CREATE_DATE <= DATE.MDY(8,7,2015)) OR
                                          (CREATE_DATE >= DATE.MDY(8,11,2015) AND CREATE_DATE <= DATE.MDY(8,31,2015)) ).
FORMATS AUG15_ACQ(F1.0).

COMPUTE TP_PY_ACQ = ( (CREATE_DATE >= DATE.MDY(6,15,2015) AND CREATE_DATE <= DATE.MDY(8,7,2015)) ).
FORMATS TP_PY_ACQ(F1.0).

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

COMPUTE WK7_ACQ = ( (CREATE_DATE >= DATE.MDY(7,28,2016) AND CREATE_DATE <= DATE.MDY(8,3,2016)) ).
FORMATS WK7_ACQ(F1.0).

COMPUTE WK8_ACQ = ( (CREATE_DATE >= DATE.MDY(8,4,2016) AND CREATE_DATE <= DATE.MDY(8,10,2016)) ).
FORMATS WK8_ACQ(F1.0).
 * END IF.
EXE.

*Select Gcom sales by account and zipcode for the dates we would like.
GET DATA 
  /TYPE=ODBC 
  /CONNECT='DSN=Teradata;DB=PRD_DWH_VIEW;PORT=1025;DBCNL=10.4.165.29;UID=spss;PWD=$-<~*x#N3@!/-!!+'
  /SQL='SELECT '+
             '  CU.CUSTOMER, ' +
             '  A.ORDERS CP1_ORDERS, A.SALES CP1_SALES, B.ORDERS CP2_ORDERS, B.SALES CP2_SALES, C.ORDERS WK1_ORDERS, C.SALES WK1_SALES, ' +
             '  D.ORDERS WK2_ORDERS, D.SALES WK2_SALES, E.ORDERS WK3_ORDERS, E.SALES WK3_SALES, F.ORDERS WK4_ORDERS, F.SALES WK4_SALES, ' +
             '  G.ORDERS WK5_ORDERS, G.SALES WK5_SALES, H.ORDERS WK6_ORDERS, H.SALES WK6_SALES, I.ORDERS WK7_ORDERS, I.SALES WK7_SALES, ' +
             '  J.ORDERS WK8_ORDERS, J.SALES WK8_SALES ' +
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
           'LEFT JOIN (SELECT SII.SOLD_TO CUSTOMER, COUNT(DISTINCT SII.S_ORD_NUM) ORDERS, SUM(SII.SUBTOTAL_2) SALES '+
                              'FROM PRD_DWH_VIEW.Sales_Invoice_V SII '+
                              'WHERE '+
                                   '  SII.ZZCOMFLG = ''Y'' ' +
                                   '  AND SII.BILL_DATE >= {d ''2016-07-28''} '+
                                   '  AND SII.BILL_DATE <= {d ''2016-08-03''} '+
                                  '  AND SII.SALES_OFF = ''E01'' ' +
                               'GROUP BY 1) I ' +
             'ON CU.CUSTOMER = I.CUSTOMER ' +
           'LEFT JOIN (SELECT SIJ.SOLD_TO CUSTOMER, COUNT(DISTINCT SIJ.S_ORD_NUM) ORDERS, SUM(SIJ.SUBTOTAL_2) SALES '+
                              'FROM PRD_DWH_VIEW.Sales_Invoice_V SIJ '+
                              'WHERE '+
                                   '  SIJ.ZZCOMFLG = ''Y'' ' +
                                   '  AND SIJ.BILL_DATE >= {d ''2016-08-04''} '+
                                   '  AND SIJ.BILL_DATE <= {d ''2016-08-10''} '+
                                  '  AND SIJ.SALES_OFF = ''E01'' ' +
                               'GROUP BY 1) J ' +
             'ON CU.CUSTOMER = J.CUSTOMER ' +
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
   WK6_SALES = GC_WK6_SALES
   WK7_ORDERS = GC_WK7_ORDERS
   WK7_SALES = GC_WK7_SALES
   WK8_ORDERS = GC_WK8_ORDERS
   WK8_SALES = GC_WK8_SALES.

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
             '  G.ORDERS WK5_ORDERS, G.SALES WK5_SALES, H.ORDERS WK6_ORDERS, H.SALES WK6_SALES, I.ORDERS WK7_ORDERS, I.SALES WK7_SALES, ' +
             '  J.ORDERS WK8_ORDERS, J.SALES WK8_SALES '+
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
                 'LEFT JOIN (SELECT SII.SOLD_TO CUSTOMER, SII.ZSHIPZIP, COUNT(DISTINCT SII.S_ORD_NUM) ORDERS, SUM(SII.SUBTOTAL_2) SALES '+
                                   'FROM PRD_DWH_VIEW.Sales_Invoice_V SII '+
                                   'WHERE '+
                                        '  SII.ZZCOMFLG = ''Y'' ' +
                                        '  AND SII.BILL_DATE >= {d ''2016-07-28''} '+
                                        '  AND SII.BILL_DATE <= {d ''2016-08-03''} '+
                                        '  AND SII.SALES_OFF = ''E01'' ' +
                                        '  AND SII.SOLD_TO = ''0222222226'' ' +
                                    'GROUP BY 1,2) I ' +
                 'ON SI.SOLD_TO = I.CUSTOMER AND SI.ZSHIPZIP = I.ZSHIPZIP '+
                 'LEFT JOIN (SELECT SIJ.SOLD_TO CUSTOMER, SIJ.ZSHIPZIP, COUNT(DISTINCT SIJ.S_ORD_NUM) ORDERS, SUM(SIJ.SUBTOTAL_2) SALES '+
                                   'FROM PRD_DWH_VIEW.Sales_Invoice_V SIJ '+
                                   'WHERE '+
                                        '  SIJ.ZZCOMFLG = ''Y'' ' +
                                        '  AND SIJ.BILL_DATE >= {d ''2016-08-04''} '+
                                        '  AND SIJ.BILL_DATE <= {d ''2016-08-10''} '+
                                        '  AND SIJ.SALES_OFF = ''E01'' ' +
                                        '  AND SIJ.SOLD_TO = ''0222222226'' ' +
                                    'GROUP BY 1,2) J ' +
                 'ON SI.SOLD_TO = J.CUSTOMER AND SI.ZSHIPZIP = J.ZSHIPZIP '+
            'WHERE SI.BILL_DATE >= {d ''2016-06-01''}  AND ' +
                          'SI.BILL_DATE <= {d ''2016-08-10''} AND ' +
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
COMPUTE GC_WK7_ORDERS = WK7_ORDERS.
COMPUTE GC_WK7_SALES = WK7_SALES.
COMPUTE GC_WK8_ORDERS = WK8_ORDERS.
COMPUTE GC_WK8_SALES = WK8_SALES.

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

*Save the resulting file.
SAVE OUTFILE = '/usr/spss/userdata/Albrecht/PPC Geo/Weekly Updates/Final Analysis/GIS and Gcom Sales and Acquisitions by Account.sav'.

