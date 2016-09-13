*Open the file containing the list of accounts and their performance during the testing period.
GET FILE = '/usr/spss/userdata/Albrecht/PPC Geo/Weekly Updates/Final Analysis/GIS and Gcom Sales and Acquisitions by Account.sav'
   /KEEP account ZIPCODE Group WK1_ACQ WK2_ACQ WK3_ACQ WK4_ACQ WK5_ACQ WK6_ACQ WK7_ACQ WK8_ACQ
              WK1_ORDERS WK2_ORDERS WK3_ORDERS WK4_ORDERS WK5_ORDERS WK6_ORDERS WK7_ORDERS WK8_ORDERS
              GC_WK1_ORDERS GC_WK2_ORDERS GC_WK3_ORDERS GC_WK4_ORDERS GC_WK5_ORDERS GC_WK6_ORDERS
              GC_WK7_ORDERS GC_WK8_ORDERS Include_Orders.
CACHE.
EXE.

DATASET NAME RES.
DATASET ACTIVATE RES.

SELECT IF(Group > 0 AND Include_Orders = 1).

COMPUTE TP_ACQ = SUM(WK1_ACQ TO WK8_ACQ).
FORMATS TP_ACQ(F1.0).

RECODE TP_ACQ(MISSING = 0).

COMPUTE TP_ORD = SUM(WK1_ORDERS TO WK2_ORDERS).
FORMATS TP_ORD(F5.0).

COMPUTE TP_GC_ORD = SUM(GC_WK1_ORDERS TO GC_WK8_ORDERS).
FORMATS TP_GC_ORD(F5.0).
EXE.

DELETE VARIABLES WK1_ACQ TO GC_WK8_ORDERS.

*Aggregate the data by account and zipcode.
DATASET DECLARE RES2.

AGGREGATE
   /OUTFILE = 'RES2'
   /BREAK = account ZIPCODE Group
   /TP_ACQ = SUM(TP_ACQ)
   /TP_ORD = SUM(TP_ORD)
   /TP_GC_ORD = SUM(TP_GC_ORD).

*Open the data file containing orders for each account from the testing period in the previous year.
GET FILE = '/usr/spss/userdata/Albrecht/PPC Geo/Weekly Updates/Final Analysis/YoY V Pct Metrics by Account.sav'
   /KEEP account ZIPCODE PY_ORDERS PY_GC_ORDERS.
CACHE.
EXE.

DATASET NAME PYO.
DATASET ACTIVATE PYO.

DATASET DECLARE PYO2.

AGGREGATE
   /OUTFILE = 'PYO2'
   /BREAK = account ZIPCODE
   /PY_ORDERS = SUM(PY_ORDERS)
   /PY_GC_ORDERS = SUM(PY_GC_ORDERS).

DATASET ACTIVATE RES2.

MATCH FILES
   /FILE = *
   /TABLE = 'PYO2'
   /BY account ZIPCODE.
EXE.

DATASET CLOSE PYO.
DATASET CLOSE PYO2.

DATASET ACTIVATE RES2.

*Divide into a dataset for those with GIS orders during the testing period and those without an order.
DATASET COPY GIS_RES.
DATASET COPY GCOM_RES.

/*EXAMINE GIS ORDERS*/.

DATASET ACTIVATE GIS_RES.

SELECT IF(TP_ORD > 0).
EXE.

DELETE VARIABLES PY_GC_ORDERS TP_GC_ORD.

*First look at the accounts acquired during the testing period.
DATASET COPY GIS_RES_NA.
DATASET ACTIVATE GIS_RES_NA.

SELECT IF(TP_ACQ = 1).
EXE.

SORT CASES BY TP_ORD(D).

DATASET CLOSE GIS_RES_NA.

*Now examine the change for accounts which were not acquired during the testing period but didn't have sales during the test period in the previous year.
DATASET ACTIVATE GIS_RES.

DATASET COPY GIS_RES_NP.
DATASET ACTIVATE GIS_RES_NP.

SELECT IF(TP_ACQ = 0 AND PY_ORDERS = 0).
EXE.

SORT CASES BY TP_ORD(D).

*Select those accounts with more than 1 order a day (40).
SELECT IF(TP_ORD >= 40).
EXE.

*Get the historical sales from the forecasting period for each account.
GET FILE = '/usr/spss/userdata/Albrecht/PPC Geo/Weekly Updates/Five Year Orders through May16 by Account for Target Markets.sav'
   /KEEP account ZIPCODE TRNS_0611 TO TRNS_0516.
CACHE.
EXE.

DATASET NAME GIS_FC.

DATASET ACTIVATE GIS_RES_NP.

SORT CASES BY account(A) ZIPCODE(A).

MATCH FILES
   /FILE = *
   /TABLE = 'GIS_FC'
   /BY account ZIPCODE.
EXE.

DATASET CLOSE GIS_FC.
DATASET ACTIVATE GIS_RES_NP.

*Two possible outliers identified as they have a large jump in orders.
SELECT IF(account = 886511567 OR account = 886462452).
EXE.

DELETE VARIABLES Group TO TRNS_0516.

COMPUTE Outlier_Type = 1.
FORMATS Outlier_Type(F1.0).
EXE.

*Now examine accounts with sales in the previous year testing period.
DATASET ACTIVATE GIS_RES.

SELECT IF(TP_ACQ = 0 AND PY_ORDERS > 0).
EXE.

*Compute the YoY V Pct.
COMPUTE VPCT = ( (TP_ORD - PY_ORDERS) / PY_ORDERS) * 100.
FORMATS VPCT(PCT5.2).
EXE.

SORT CASES BY TP_ORD(D) VPCT(D).

*No potential outliers identified for accounts with order history.
DATASET CLOSE GIS_RES.

/*EXAMINE GCOM ORDERS*/.

DATASET ACTIVATE GCOM_RES.

SELECT IF(TP_GC_ORD > 0).
EXE.

DELETE VARIABLES PY_ORDERS TP_ORD.

*First look at the accounts acquired during the testing period.
DATASET COPY GC_RES_NA.
DATASET ACTIVATE GC_RES_NA.

SELECT IF(TP_ACQ = 1).
EXE.

SORT CASES BY TP_GC_ORD(D).

DATASET CLOSE GC_RES_NA.

*Now examine the change for accounts which were not acquired during the testing period but didn't have sales during the test period in the previous year.
DATASET ACTIVATE GCOM_RES.

DATASET COPY GC_RES_NP.
DATASET ACTIVATE GC_RES_NP.

SELECT IF(TP_ACQ = 0 AND PY_GC_ORDERS = 0).
EXE.

SORT CASES BY TP_GC_ORD(D).

*Select those accounts with more than 1 order a day (40).
SELECT IF(TP_GC_ORD >= 40).
EXE.

*Get the historical sales from the forecasting period for each account.
GET FILE = '/usr/spss/userdata/Albrecht/PPC Geo/Weekly Updates/Five Year Orders through May16 by Account for Target Markets.sav'
   /KEEP account ZIPCODE Gcom_Orders_0112 TO Gcom_Orders_0516.
CACHE.
EXE.

DATASET NAME GC_FC.

DATASET ACTIVATE GC_RES_NP.

SORT CASES BY account(A) ZIPCODE(A).

MATCH FILES
   /FILE = *
   /TABLE = 'GC_FC'
   /BY account ZIPCODE.
EXE.

DATASET CLOSE GC_FC.
DATASET ACTIVATE GC_RES_NP.

*Four possible outliers identified as they have a large jump in orders.
SELECT IF(account = 800850828 OR account = 808054365 OR account = 818025132 OR account = 886514047 OR account = 886538438).
EXE.

DELETE VARIABLES Group TO Gcom_Orders_0516.

COMPUTE Outlier_Type = 2.
FORMATS Outlier_Type(F1.0).
EXE.

*Now examine accounts with sales in the previous year testing period.
DATASET ACTIVATE GCOM_RES.

SELECT IF(TP_ACQ = 0 AND PY_GC_ORDERS > 0).

*Compute the YoY V Pct.
COMPUTE VPCT = ( (TP_GC_ORD - PY_GC_ORDERS) / PY_GC_ORDERS) * 100.
FORMATS VPCT(PCT5.2).
EXE.

SORT CASES BY TP_GC_ORD(D) VPCT(D).

SELECT IF(TP_GC_ORD >= 50 AND VPCT >= 100).
EXE.

SORT CASES BY account(A) ZIPCODE(A).

MATCH FILES
   /FILE = *
   /TABLE = 'GC_FC'
   /BY account ZIPCODE.
EXE.

SORT CASES BY VPCT(D).

*Compute the average sales over the first 5 months of the year.
RECODE Gcom_Orders_0116(MISSING = 0) / Gcom_Orders_0216(MISSING = 0) / Gcom_Orders_0316(MISSING = 0) / Gcom_Orders_0416(MISSING = 0) / 
              Gcom_Orders_0514(MISSING = 0).

COMPUTE ORD16 = MEAN(Gcom_Orders_0116 TO Gcom_Orders_0516) * 2.
FORMATS ORD16(F6.2).

DO IF(ORD16 > 0).

   COMPUTE VPCT2 = ( (TP_GC_ORD - ORD16) / ORD16) * 100.
   FORMATS VPCT2(PCT5.2).

ELSE.

   COMPUTE VPCT2 = VPCT.

END IF.
EXE.

SORT CASES BY VPCT2(D).

*Select outliers.
SELECT IF(VPCT2 >= 90).
EXE.

*Take the maximum of the previous year orders and orders in the last 5 months to use to replace orders during the test period.
COMPUTE #New_Orders = MAX(PY_GC_ORDERS,ORD16).
COMPUTE PCT_DECR = ( (#New_Orders - TP_GC_ORDERS) / TP_GC_ORDERS) * 100.
FORMATS PCT_DECR(PCT5.2).
EXE.

DELETE VARIABLES Group TO New_Orders.

COMPUTE Outlier_Type = 3.
FORMATS Outlier_Type(F1.0).
EXE.

ADD FILES
   /FILE = *
   /FILE = 'GC_RES_NP'
   /FILE = 'GIS_RES_NP'.
EXE.

DATASET CLOSE GIS_FC.
DATASET CLOSE GC_FC.
DATASET CLOSE GC_RES_NP.
DATASET CLOSE GIS_RES_NP.

DATASET ACTIVATE GCOM_RES.

VALUE LABELS Outlier_Type 1 'Account with no GIS Order in TP Previous Year and High Orders in Test Period'
                                             2 'Account with no Gcom Order in TP Previous Year and High Orders in Test Period'
                                             3 'Account with high variance in Gcom Orders from Forecast Period to Test Period'.

SORT CASES BY account(A) ZIPCODE(A).

SAVE OUTFILE = '/usr/spss/userdata/Albrecht/PPC Geo/Weekly Updates/Final Analysis/GIS and GCOM Order Outliers.sav'.
