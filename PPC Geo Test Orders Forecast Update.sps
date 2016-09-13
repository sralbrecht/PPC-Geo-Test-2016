*Get the zipcode from the customer table in Teradata.
GET DATA 
  /TYPE=ODBC 
  /CONNECT='DSN=Teradata;DB=PRD_DWH_VIEW;PORT=1025;DBCNL=10.4.165.29;UID=spss;PWD=$-<~*x#N3@!/-!!+'
  /SQL='SELECT DISTINCT CU.CUSTOMER, CU.ZZIPCD5 ZIPCODE '+
           'FROM PRD_DWH_VIEW.Customer_V CU '.
CACHE.
EXE.

DATASET NAME ACCTS.
DATASET ACTIVATE ACCTS.

RENAME VARIABLES CUSTOMER = account.

ALTER TYPE account(F10.0).

SORT CASES BY account(A).

*Select only valid accounts.
SELECT IF(account > 800000000).
EXE.

*Open the model file from May 2013 to get the 24 months of transactions prior to June 2013.
GET FILE = '/usr/spss/userdata/model_files/201305_May_merged_model_file.sav'
   /KEEP account TRANS24 TRANS23 TRANS22 TRANS21 TRANS20 TRANS19 TRANS18 TRANS17 TRANS16 TRANS15 TRANS14 TRANS13 TRANS12 TRANS11 TRANS10 
              TRANS09 TRANS08 TRANS07 TRANS06 TRANS05 TRANS04 TRANS03 TRANS02 TRANS01
   /RENAME TRANS24 = TRNS_0611 TRANS23 = TRNS_0711 TRANS22 = TRNS_0811 TRANS21 = TRNS_0911 TRANS20 = TRNS_1011 TRANS19 = TRNS_1111
                   TRANS18 = TRNS_1211 TRANS17 = TRNS_0112 TRANS16 = TRNS_0212 TRANS15 = TRNS_0312 TRANS14 = TRNS_0412 TRANS13 = TRNS_0512
                   TRANS12 = TRNS_0612 TRANS11 = TRNS_0712 TRANS10 = TRNS_0812 TRANS09 = TRNS_0912 TRANS08 = TRNS_1012 TRANS07 = TRNS_1112
                   TRANS06 = TRNS_1212 TRANS05 = TRNS_0113 TRANS04 = TRNS_0213 TRANS03 = TRNS_0313 TRANS02 = TRNS_0413 TRANS01 = TRNS_0513.
CACHE.
EXE.

DATASET NAME TRANS1.

*Open the current model file to get the list of accounts and their zip codes.
GET FILE = '/usr/spss/userdata/model_files/201605_May_merged_model_file.sav'
   /KEEP account TRANS36 TRANS35 TRANS34 TRANS33 TRANS32 TRANS31 TRANS30 TRANS29 TRANS28 TRANS27 TRANS26 TRANS25
              TRANS24 TRANS23 TRANS22 TRANS21 TRANS20 TRANS19 TRANS18 TRANS17 TRANS16 TRANS15 TRANS14 TRANS13 TRANS12 TRANS11 TRANS10 
              TRANS09 TRANS08 TRANS07 TRANS06 TRANS05 TRANS04 TRANS03 TRANS02 TRANS01
   /RENAME TRANS36 = TRNS_0613 TRANS35 = TRNS_0713 TRANS34 = TRNS_0813 TRANS33 = TRNS_0913 TRANS32 = TRNS_1013 TRANS31 = TRNS_1113 
                   TRANS30 = TRNS_1213 TRANS29 = TRNS_0114 TRANS28 = TRNS_0214 TRANS27 = TRNS_0314 TRANS26 = TRNS_0414 TRANS25 = TRNS_0514
                   TRANS24 = TRNS_0614 TRANS23 = TRNS_0714 TRANS22 = TRNS_0814 TRANS21 = TRNS_0914 TRANS20 = TRNS_1014 TRANS19 = TRNS_1114 
                   TRANS18 = TRNS_1214 TRANS17 = TRNS_0115 TRANS16 = TRNS_0215 TRANS15 = TRNS_0315 TRANS14 = TRNS_0415 TRANS13 = TRNS_0515 
                   TRANS12 = TRNS_0615 TRANS11 = TRNS_0715 TRANS10 = TRNS_0815 TRANS09 = TRNS_0915 TRANS08 = TRNS_1015 TRANS07 = TRNS_1115 
                   TRANS06 = TRNS_1215 TRANS05 = TRNS_0116 TRANS04 = TRNS_0216 TRANS03 = TRNS_0316 TRANS02 = TRNS_0416 TRANS01 = TRNS_0516.
CACHE.
EXE.

DATASET NAME TRANS2.

DATASET ACTIVATE ACCTS.

MATCH FILES
   /FILE = *
   /TABLE = 'TRANS1'
   /TABLE = 'TRANS2'
   /BY account.
EXE.

DATASET CLOSE TRANS1.
DATASET CLOSE TRANS2.

DATASET ACTIVATE ACCTS.

*Open the ecomm ops file from Dec 2012 to get Gcom order history.
GET FILE = '/usr/spss/userdata/ecomm_files/archives/201412.ecomm.ops.sav'
   /KEEP Account Gcom_Orders_0112 TO Gcom_Orders_1214.
CACHE.
EXE.

DATASET NAME GC1.

*Open the ecomm ops file from May 2016 to get Gcom order history.
GET FILE = '/usr/spss/userdata/ecomm_files/201607.ecomm.ops.sav'
   /KEEP Account Gcom_Orders_0115 TO Gcom_Orders_0516. 
CACHE.
EXE.

DATASET NAME GC2.

DATASET ACTIVATE ACCTS.

MATCH FILES
   /FILE = *
   /TABLE = 'GC1'
   /TABLE = 'GC2'
   /BY account.
EXE.

DATASET CLOSE GC1.
DATASET CLOSE GC2.

DATASET ACTIVATE ACCTS.

*Get the guest checkout orders aligning the sales to the ship to zipcode.
GET DATA
  /TYPE=ODBC
  /CONNECT='DSN=Teradata;DB=PRD_DWH_VIEW;PORT=1025;DBCNL=10.4.165.66;UID=spss;PWD=$-0N)K#N?s-#!-!+'
  /SQL= 'SELECT SOLD_TO, BILL_DATE, ZSHIPZIP, COUNT(DISTINCT S_ORD_NUM) ORDERS ' +
            'FROM PRD_DWH_VIEW.Sales_Invoice_Summary_V ' +
            'WHERE BILL_DATE >= {d ''2011-06-01''} AND ' +
                          'BILL_DATE <= {d ''2016-05-31''} AND ' +
                          'SALES_OFF = ''E01'' AND ' +
                          'SOLD_TO = ''0222222226'' AND ' +
                          'ZZCOMFLG = ''Y'' ' +
            'GROUP BY 1,2,3 '.
CACHE.
EXE.

DATASET NAME GUEST.
DATASET ACTIVATE GUEST.

*Get the month from the billing date.
COMPUTE BM = XDATE.MONTH(BILL_DATE).
COMPUTE BYR = XDATE.YEAR(BILL_DATE).
EXE.

ALTER TYPE BM(A2) BYR(A4).

COMPUTE #cl = CHAR.LENGTH(LTRIM(BM)).

STRING BILL_MY(A6).

DO IF(#cl = 1).

   COMPUTE BILL_MY = CONCAT(BYR,'0',LTRIM(BM)).

ELSE.

   COMPUTE BILL_MY = CONCAT(BYR,BM).

END IF.

STRING ZIPCODE(A5).
COMPUTE ZIPCODE=SUBSTR(ZSHIPZIP,1,5).
EXE.

ALTER TYPE BILL_MY(F6.0).

DELETE VARIABLES BM BYR ZSHIPZIP.

*Aggregate the sales and orders by zipcode and the billing month.
DATASET DECLARE GUEST_BY_MZ.

AGGREGATE
   /OUTFILE = 'GUEST_BY_MZ'
   /BREAK = SOLD_TO BILL_MY ZIPCODE
   /ORDERS = SUM(ORDERS).

DATASET ACTIVATE GUEST_BY_MZ.

DATASET DECLARE AG_ZIPS.

AGGREGATE
   /OUTFILE = 'AG_ZIPS'
   /BREAK = SOLD_TO ZIPCODE
   /Num_Records = N.

DATASET ACTIVATE GUEST_BY_MZ.

*Change the layout from row wise to column wise.
DATASET COPY JUN11.
DATASET COPY JUL11.
DATASET COPY AUG11.
DATASET COPY SEP11.
DATASET COPY OCT11.
DATASET COPY NOV11.
DATASET COPY DEC11.

*June 2011.
DATASET ACTIVATE JUN11.

SELECT IF(BILL_MY = 201106).
EXE.

RENAME VARIABLES ORDERS = TRNS_0611.

*July 2011.
DATASET ACTIVATE JUL11.

SELECT IF(BILL_MY = 201107).
EXE.

RENAME VARIABLES ORDERS = TRNS_0711.

*July 2011.
DATASET ACTIVATE AUG11.

SELECT IF(BILL_MY = 201108).
EXE.

RENAME VARIABLES ORDERS = TRNS_0811.

*Sept 2011.
DATASET ACTIVATE SEP11.

SELECT IF(BILL_MY = 201109).
EXE.

RENAME VARIABLES ORDERS = TRNS_0911.

*Oct 2011.
DATASET ACTIVATE OCT11.

SELECT IF(BILL_MY = 201110).
EXE.

RENAME VARIABLES ORDERS = TRNS_1011.

*Nov 2011.
DATASET ACTIVATE NOV11.

SELECT IF(BILL_MY = 201111).
EXE.

RENAME VARIABLES ORDERS = TRNS_1111.

*December 2011.
DATASET ACTIVATE DEC11.

SELECT IF(BILL_MY = 201112).
EXE.

RENAME VARIABLES ORDERS = TRNS_1211.

DATASET ACTIVATE AG_ZIPS.

DELETE VARIABLES Num_Records.

MATCH FILES
   /FILE = *
   /TABLE = 'JUN11'
   /TABLE = 'JUL11'
   /TABLE = 'AUG11'
   /TABLE = 'SEP11'
   /TABLE = 'OCT11'
   /TABLE = 'NOV11'
   /TABLE = 'DEC11'
   /BY SOLD_TO ZIPCODE.
EXE.

DATASET CLOSE JUN11.
DATASET CLOSE JUL11.
DATASET CLOSE AUG11.
DATASET CLOSE SEP11.
DATASET CLOSE OCT11.
DATASET CLOSE NOV11.
DATASET CLOSE DEC11.

DATASET ACTIVATE GUEST_BY_MZ.

DATASET COPY JAN12.
DATASET COPY FEB12.
DATASET COPY MAR12.
DATASET COPY APR12.
DATASET COPY MAY12.
DATASET COPY JUN12.
DATASET COPY JUL12.
DATASET COPY AUG12.
DATASET COPY SEP12.
DATASET COPY OCT12.
DATASET COPY NOV12.
DATASET COPY DEC12.

*January 2012.
DATASET ACTIVATE JAN12.

SELECT IF(BILL_MY = 201201).
EXE.

RENAME VARIABLES ORDERS = TRNS_0112.

*February 2012.
DATASET ACTIVATE FEB12.

SELECT IF(BILL_MY = 201202).
EXE.

RENAME VARIABLES ORDERS = TRNS_0212.

*March 2012.
DATASET ACTIVATE MAR12.

SELECT IF(BILL_MY = 201203).
EXE.

RENAME VARIABLES ORDERS = TRNS_0312.

*April 2012.
DATASET ACTIVATE APR12.

SELECT IF(BILL_MY = 201204).
EXE.

RENAME VARIABLES ORDERS = TRNS_0412.

*May 2012.
DATASET ACTIVATE MAY12.

SELECT IF(BILL_MY = 201205).
EXE.

RENAME VARIABLES ORDERS = TRNS_0512.

*June 2012.
DATASET ACTIVATE JUN12.

SELECT IF(BILL_MY = 201206).
EXE.

RENAME VARIABLES ORDERS = TRNS_0612.

*July 2012.
DATASET ACTIVATE JUL12.

SELECT IF(BILL_MY = 201207).
EXE.

RENAME VARIABLES ORDERS = TRNS_0712.

*July 2012.
DATASET ACTIVATE AUG12.

SELECT IF(BILL_MY = 201208).
EXE.

RENAME VARIABLES ORDERS = TRNS_0812.

*Sept 2012.
DATASET ACTIVATE SEP12.

SELECT IF(BILL_MY = 201209).
EXE.

RENAME VARIABLES ORDERS = TRNS_0912.

*Oct 2012.
DATASET ACTIVATE OCT12.

SELECT IF(BILL_MY = 201210).
EXE.

RENAME VARIABLES ORDERS = TRNS_1012.

*Nov 2012.
DATASET ACTIVATE NOV12.

SELECT IF(BILL_MY = 201211).
EXE.

RENAME VARIABLES ORDERS = TRNS_1112.

*December 2012.
DATASET ACTIVATE DEC12.

SELECT IF(BILL_MY = 201212).
EXE.

RENAME VARIABLES ORDERS = TRNS_1212.

DATASET ACTIVATE AG_ZIPS.

MATCH FILES
   /FILE = *
   /TABLE = 'JAN12'
   /TABLE = 'FEB12'
   /TABLE = 'MAR12'
   /TABLE = 'APR12'
   /TABLE = 'MAY12'
   /TABLE = 'JUN12'
   /TABLE = 'JUL12'
   /TABLE = 'AUG12'
   /TABLE = 'SEP12'
   /TABLE = 'OCT12'
   /TABLE = 'NOV12'
   /TABLE = 'DEC12'
   /BY SOLD_TO ZIPCODE.
EXE.

DATASET CLOSE JAN12.
DATASET CLOSE FEB12.
DATASET CLOSE MAR12.
DATASET CLOSE APR12.
DATASET CLOSE MAY12.
DATASET CLOSE JUN12.
DATASET CLOSE JUL12.
DATASET CLOSE AUG12.
DATASET CLOSE SEP12.
DATASET CLOSE OCT12.
DATASET CLOSE NOV12.
DATASET CLOSE DEC12.

DATASET ACTIVATE GUEST_BY_MZ.

DATASET COPY JAN13.
DATASET COPY FEB13.
DATASET COPY MAR13.
DATASET COPY APR13.
DATASET COPY MAY13.
DATASET COPY JUN13.
DATASET COPY JUL13.
DATASET COPY AUG13.
DATASET COPY SEP13.
DATASET COPY OCT13.
DATASET COPY NOV13.
DATASET COPY DEC13.

*January 2013.
DATASET ACTIVATE JAN13.

SELECT IF(BILL_MY = 201301).
EXE.

RENAME VARIABLES ORDERS = TRNS_0113.

*February 2013.
DATASET ACTIVATE FEB13.

SELECT IF(BILL_MY = 201302).
EXE.

RENAME VARIABLES ORDERS = TRNS_0213.

*March 2013.
DATASET ACTIVATE MAR13.

SELECT IF(BILL_MY = 201303).
EXE.

RENAME VARIABLES ORDERS = TRNS_0313.

*April 2013.
DATASET ACTIVATE APR13.

SELECT IF(BILL_MY = 201304).
EXE.

RENAME VARIABLES ORDERS = TRNS_0413.

*May 2013.
DATASET ACTIVATE MAY13.

SELECT IF(BILL_MY = 201305).
EXE.

RENAME VARIABLES ORDERS = TRNS_0513.

*June 2013.
DATASET ACTIVATE JUN13.

SELECT IF(BILL_MY = 201306).
EXE.

RENAME VARIABLES ORDERS = TRNS_0613.

*July 2013.
DATASET ACTIVATE JUL13.

SELECT IF(BILL_MY = 201307).
EXE.

RENAME VARIABLES ORDERS = TRNS_0713.

*July 2013.
DATASET ACTIVATE AUG13.

SELECT IF(BILL_MY = 201308).
EXE.

RENAME VARIABLES ORDERS = TRNS_0813.

*Sept 2013.
DATASET ACTIVATE SEP13.

SELECT IF(BILL_MY = 201309).
EXE.

RENAME VARIABLES ORDERS = TRNS_0913.

*Oct 2013.
DATASET ACTIVATE OCT13.

SELECT IF(BILL_MY = 201310).
EXE.

RENAME VARIABLES ORDERS = TRNS_1013.

*Nov 2013.
DATASET ACTIVATE NOV13.

SELECT IF(BILL_MY = 201311).
EXE.

RENAME VARIABLES ORDERS = TRNS_1113.

*December 2013.
DATASET ACTIVATE DEC13.

SELECT IF(BILL_MY = 201312).
EXE.

RENAME VARIABLES ORDERS = TRNS_1213.

DATASET ACTIVATE AG_ZIPS.

MATCH FILES
   /FILE = *
   /TABLE = 'JAN13'
   /TABLE = 'FEB13'
   /TABLE = 'MAR13'
   /TABLE = 'APR13'
   /TABLE = 'MAY13'
   /TABLE = 'JUN13'
   /TABLE = 'JUL13'
   /TABLE = 'AUG13'
   /TABLE = 'SEP13'
   /TABLE = 'OCT13'
   /TABLE = 'NOV13'
   /TABLE = 'DEC13'
   /BY SOLD_TO ZIPCODE.
EXE.

DATASET CLOSE JAN13.
DATASET CLOSE FEB13.
DATASET CLOSE MAR13.
DATASET CLOSE APR13.
DATASET CLOSE MAY13.
DATASET CLOSE JUN13.
DATASET CLOSE JUL13.
DATASET CLOSE AUG13.
DATASET CLOSE SEP13.
DATASET CLOSE OCT13.
DATASET CLOSE NOV13.
DATASET CLOSE DEC13.

DATASET ACTIVATE GUEST_BY_MZ.

DATASET COPY JAN14.
DATASET COPY FEB14.
DATASET COPY MAR14.
DATASET COPY APR14.
DATASET COPY MAY14.
DATASET COPY JUN14.
DATASET COPY JUL14.
DATASET COPY AUG14.
DATASET COPY SEP14.
DATASET COPY OCT14.
DATASET COPY NOV14.
DATASET COPY DEC14.

*January 2014.
DATASET ACTIVATE JAN14.

SELECT IF(BILL_MY = 201401).
EXE.

RENAME VARIABLES ORDERS = TRNS_0114.

*February 2014.
DATASET ACTIVATE FEB14.

SELECT IF(BILL_MY = 201402).
EXE.

RENAME VARIABLES ORDERS = TRNS_0214.

*March 2014.
DATASET ACTIVATE MAR14.

SELECT IF(BILL_MY = 201403).
EXE.

RENAME VARIABLES ORDERS = TRNS_0314.

*April 2014.
DATASET ACTIVATE APR14.

SELECT IF(BILL_MY = 201404).
EXE.

RENAME VARIABLES ORDERS = TRNS_0414.

*May 2014.
DATASET ACTIVATE MAY14.

SELECT IF(BILL_MY = 201405).
EXE.

RENAME VARIABLES ORDERS = TRNS_0514.

*June 2014.
DATASET ACTIVATE JUN14.

SELECT IF(BILL_MY = 201406).
EXE.

RENAME VARIABLES ORDERS = TRNS_0614.

*July 2014.
DATASET ACTIVATE JUL14.

SELECT IF(BILL_MY = 201407).
EXE.

RENAME VARIABLES ORDERS = TRNS_0714.

*July 2014.
DATASET ACTIVATE AUG14.

SELECT IF(BILL_MY = 201408).
EXE.

RENAME VARIABLES ORDERS = TRNS_0814.

*Sept 2014.
DATASET ACTIVATE SEP14.

SELECT IF(BILL_MY = 201409).
EXE.

RENAME VARIABLES ORDERS = TRNS_0914.

*Oct 2014.
DATASET ACTIVATE OCT14.

SELECT IF(BILL_MY = 201410).
EXE.

RENAME VARIABLES ORDERS = TRNS_1014.

*Nov 2014.
DATASET ACTIVATE NOV14.

SELECT IF(BILL_MY = 201411).
EXE.

RENAME VARIABLES ORDERS = TRNS_1114.

*December 2014.
DATASET ACTIVATE DEC14.

SELECT IF(BILL_MY = 201412).
EXE.

RENAME VARIABLES ORDERS = TRNS_1214.

DATASET ACTIVATE AG_ZIPS.

MATCH FILES
   /FILE = *
   /TABLE = 'JAN14'
   /TABLE = 'FEB14'
   /TABLE = 'MAR14'
   /TABLE = 'APR14'
   /TABLE = 'MAY14'
   /TABLE = 'JUN14'
   /TABLE = 'JUL14'
   /TABLE = 'AUG14'
   /TABLE = 'SEP14'
   /TABLE = 'OCT14'
   /TABLE = 'NOV14'
   /TABLE = 'DEC14'
   /BY SOLD_TO ZIPCODE.
EXE.

DATASET CLOSE JAN14.
DATASET CLOSE FEB14.
DATASET CLOSE MAR14.
DATASET CLOSE APR14.
DATASET CLOSE MAY14.
DATASET CLOSE JUN14.
DATASET CLOSE JUL14.
DATASET CLOSE AUG14.
DATASET CLOSE SEP14.
DATASET CLOSE OCT14.
DATASET CLOSE NOV14.
DATASET CLOSE DEC14.

DATASET ACTIVATE GUEST_BY_MZ.

DATASET COPY JAN15.
DATASET COPY FEB15.
DATASET COPY MAR15.
DATASET COPY APR15.
DATASET COPY MAY15.
DATASET COPY JUN15.
DATASET COPY JUL15.
DATASET COPY AUG15.
DATASET COPY SEP15.
DATASET COPY OCT15.
DATASET COPY NOV15.
DATASET COPY DEC15.

*January 2015.
DATASET ACTIVATE JAN15.

SELECT IF(BILL_MY = 201501).
EXE.

RENAME VARIABLES ORDERS = TRNS_0115.

*February 2015.
DATASET ACTIVATE FEB15.

SELECT IF(BILL_MY = 201502).
EXE.

RENAME VARIABLES ORDERS = TRNS_0215.

*March 2015.
DATASET ACTIVATE MAR15.

SELECT IF(BILL_MY = 201503).
EXE.

RENAME VARIABLES ORDERS = TRNS_0315.

*April 2015.
DATASET ACTIVATE APR15.

SELECT IF(BILL_MY = 201504).
EXE.

RENAME VARIABLES ORDERS = TRNS_0415.

*May 2015.
DATASET ACTIVATE MAY15.

SELECT IF(BILL_MY = 201505).
EXE.

RENAME VARIABLES ORDERS = TRNS_0515.

*June 2015.
DATASET ACTIVATE JUN15.

SELECT IF(BILL_MY = 201506).
EXE.

RENAME VARIABLES ORDERS = TRNS_0615.

*July 2015.
DATASET ACTIVATE JUL15.

SELECT IF(BILL_MY = 201507).
EXE.

RENAME VARIABLES ORDERS = TRNS_0715.

*July 2015.
DATASET ACTIVATE AUG15.

SELECT IF(BILL_MY = 201508).
EXE.

RENAME VARIABLES ORDERS = TRNS_0815.

*Sept 2015.
DATASET ACTIVATE SEP15.

SELECT IF(BILL_MY = 201509).
EXE.

RENAME VARIABLES ORDERS = TRNS_0915.

*Oct 2015.
DATASET ACTIVATE OCT15.

SELECT IF(BILL_MY = 201510).
EXE.

RENAME VARIABLES ORDERS = TRNS_1015.

*Nov 2015.
DATASET ACTIVATE NOV15.

SELECT IF(BILL_MY = 201511).
EXE.

RENAME VARIABLES ORDERS = TRNS_1115.

*December 2015.
DATASET ACTIVATE DEC15.

SELECT IF(BILL_MY = 201512).
EXE.

RENAME VARIABLES ORDERS = TRNS_1215.

DATASET ACTIVATE AG_ZIPS.

MATCH FILES
   /FILE = *
   /TABLE = 'JAN15'
   /TABLE = 'FEB15'
   /TABLE = 'MAR15'
   /TABLE = 'APR15'
   /TABLE = 'MAY15'
   /TABLE = 'JUN15'
   /TABLE = 'JUL15'
   /TABLE = 'AUG15'
   /TABLE = 'SEP15'
   /TABLE = 'OCT15'
   /TABLE = 'NOV15'
   /TABLE = 'DEC15'
   /BY SOLD_TO ZIPCODE.
EXE.

DATASET CLOSE JAN15.
DATASET CLOSE FEB15.
DATASET CLOSE MAR15.
DATASET CLOSE APR15.
DATASET CLOSE MAY15.
DATASET CLOSE JUN15.
DATASET CLOSE JUL15.
DATASET CLOSE AUG15.
DATASET CLOSE SEP15.
DATASET CLOSE OCT15.
DATASET CLOSE NOV15.
DATASET CLOSE DEC15.

DATASET ACTIVATE GUEST_BY_MZ.

DATASET COPY JAN16.
DATASET COPY FEB16.
DATASET COPY MAR16.
DATASET COPY APR16.
DATASET COPY MAY16.

*January 2016.
DATASET ACTIVATE JAN16.

SELECT IF(BILL_MY = 201601).
EXE.

RENAME VARIABLES ORDERS = TRNS_0116.

*February 2016.
DATASET ACTIVATE FEB16.

SELECT IF(BILL_MY = 201602).
EXE.

RENAME VARIABLES ORDERS = TRNS_0216.

*March 2016.
DATASET ACTIVATE MAR16.

SELECT IF(BILL_MY = 201603).
EXE.

RENAME VARIABLES ORDERS = TRNS_0316.

*April 2016.
DATASET ACTIVATE APR16.

SELECT IF(BILL_MY = 201604).
EXE.

RENAME VARIABLES ORDERS = TRNS_0416.

*May 2016.
DATASET ACTIVATE MAY16.

SELECT IF(BILL_MY = 201605).
EXE.

RENAME VARIABLES ORDERS = TRNS_0516.

DATASET ACTIVATE AG_ZIPS.

MATCH FILES
   /FILE = *
   /TABLE = 'JAN16'
   /TABLE = 'FEB16'
   /TABLE = 'MAR16'
   /TABLE = 'APR16'
   /TABLE = 'MAY16'
   /BY SOLD_TO ZIPCODE.
EXE.

DATASET CLOSE JAN16.
DATASET CLOSE FEB16.
DATASET CLOSE MAR16.
DATASET CLOSE APR16.
DATASET CLOSE MAY16.
DATASET CLOSE GUEST_BY_MZ.

DATASET ACTIVATE AG_ZIPS.

DELETE VARIABLES BILL_MY.

*Recode missing values to 0.
VECTOR GS = TRNS_0611 TO TRNS_0516.

LOOP #m = 1 TO 60.

   IF(MISSING(GS(#m))) GS(#m) = 0.

END LOOP.

*Create Gcom variables with the same value as the overall transaction variables.
COMPUTE Gcom_Orders_0112 = TRNS_0112.
COMPUTE Gcom_Orders_0212 = TRNS_0212.
COMPUTE Gcom_Orders_0312 = TRNS_0312.
COMPUTE Gcom_Orders_0412 = TRNS_0412.
COMPUTE Gcom_Orders_0512 = TRNS_0512.
COMPUTE Gcom_Orders_0612 = TRNS_0612.
COMPUTE Gcom_Orders_0712 = TRNS_0712.
COMPUTE Gcom_Orders_0812 = TRNS_0812.
COMPUTE Gcom_Orders_0912 = TRNS_0912.
COMPUTE Gcom_Orders_1012 = TRNS_1012.
COMPUTE Gcom_Orders_1112 = TRNS_1112.
COMPUTE Gcom_Orders_1212 = TRNS_1212.
COMPUTE Gcom_Orders_0113 = TRNS_0113.
COMPUTE Gcom_Orders_0213 = TRNS_0213.
COMPUTE Gcom_Orders_0313 = TRNS_0313.
COMPUTE Gcom_Orders_0413 = TRNS_0413.
COMPUTE Gcom_Orders_0513 = TRNS_0513.
COMPUTE Gcom_Orders_0613 = TRNS_0613.
COMPUTE Gcom_Orders_0713 = TRNS_0713.
COMPUTE Gcom_Orders_0813 = TRNS_0813.
COMPUTE Gcom_Orders_0913 = TRNS_0913.
COMPUTE Gcom_Orders_1013 = TRNS_1013.
COMPUTE Gcom_Orders_1113 = TRNS_1113.
COMPUTE Gcom_Orders_1213 = TRNS_1213.
COMPUTE Gcom_Orders_0114 = TRNS_0114.
COMPUTE Gcom_Orders_0214 = TRNS_0214.
COMPUTE Gcom_Orders_0314 = TRNS_0314.
COMPUTE Gcom_Orders_0414 = TRNS_0414.
COMPUTE Gcom_Orders_0514 = TRNS_0514.
COMPUTE Gcom_Orders_0614 = TRNS_0614.
COMPUTE Gcom_Orders_0714 = TRNS_0714.
COMPUTE Gcom_Orders_0814 = TRNS_0814.
COMPUTE Gcom_Orders_0914 = TRNS_0914.
COMPUTE Gcom_Orders_1014 = TRNS_1014.
COMPUTE Gcom_Orders_1114 = TRNS_1114.
COMPUTE Gcom_Orders_1214 = TRNS_1214.
COMPUTE Gcom_Orders_0115 = TRNS_0115.
COMPUTE Gcom_Orders_0215 = TRNS_0215.
COMPUTE Gcom_Orders_0315 = TRNS_0315.
COMPUTE Gcom_Orders_0415 = TRNS_0415.
COMPUTE Gcom_Orders_0515 = TRNS_0515.
COMPUTE Gcom_Orders_0615 = TRNS_0615.
COMPUTE Gcom_Orders_0715 = TRNS_0715.
COMPUTE Gcom_Orders_0815 = TRNS_0815.
COMPUTE Gcom_Orders_0915 = TRNS_0915.
COMPUTE Gcom_Orders_1015 = TRNS_1015.
COMPUTE Gcom_Orders_1115 = TRNS_1115.
COMPUTE Gcom_Orders_1215 = TRNS_1215.
COMPUTE Gcom_Orders_0116 = TRNS_0116.
COMPUTE Gcom_Orders_0216 = TRNS_0216.
COMPUTE Gcom_Orders_0316 = TRNS_0316.
COMPUTE Gcom_Orders_0416 = TRNS_0416.
COMPUTE Gcom_Orders_0516 = TRNS_0516.
EXE.

RENAME VARIABLES SOLD_TO = account.

ALTER TYPE account(F10.0).

*Add the records to the order history for all other accounts.
DATASET ACTIVATE ACCTS.

ADD FILES
   /FILE = *
   /FILE = 'AG_ZIPS'.
EXE.

DATASET CLOSE GUEST.
DATASET CLOSE AG_ZIPS.

DATASET ACTIVATE ACCTS.

*Open the sales days files to standardize sales for the number of sales days.
GET FILE = '/usr/spss/userdata/sales_days/2014-12-03 sales days thru 2022.sav'.
CACHE.
EXE.

DATASET NAME SD.
DATASET ACTIVATE SD.

*Select only the date range we need.
SELECT IF(month >= 201106 AND month <= 201605).
EXE.

*Transpose the records.
FLIP VARIABLES=slsdays
  /NEWNAMES=month.

DATASET NAME SALES_DAYS.
DATASET CLOSE SD.
DATASET ACTIVATE ACCTS.

STRING CASE_LBL(A7).

COMPUTE CASE_LBL = 'slsdays'.
EXE.

MATCH FILES
   /FILE = *
   /TABLE = 'SALES_DAYS'
   /BY CASE_LBL.
EXE.

DATASET CLOSE SALES_DAYS.
DATASET ACTIVATE ACCTS.

DELETE VARIABLES CASE_LBL.

VECTOR MT = TRNS_0611 TO TRNS_0516.
VECTOR SD = K_201106 TO K_201605.

VECTOR ADT(60).

LOOP #i = 1 TO 60.

   DO IF(SD(#i) > 0).

      COMPUTE ADT(#i) = MT(#i) / SD(#i).

   END IF.

END LOOP.

VECTOR GCT = Gcom_Orders_0112 TO Gcom_Orders_0516.
VECTOR SD2 = K_201201 TO K_201605.

VECTOR ADGCT(60).

LOOP #j = 1 TO 60.

   DO IF(#j < 8).

      COMPUTE ADGCT(#j) = $SYSMIS.

   ELSE IF(#j >= 8 AND SD2(#j - 7) > 0).

      COMPUTE ADGCT(#j) = GCT(#j - 7) / SD2(#j - 7).

   END IF.

END LOOP.

*Flag accounts who have sales in at least 1 month in the time period at which we are looking.
VECTOR TOT_TRANS = TRNS_0611 TO TRNS_0516.

COMPUTE Has_Trans = 0.
FORMATS Has_Trans(F1.0).

LOOP #k = 1 TO 60.

   IF(TOT_TRANS(#k) > 0) Has_Trans = 1.

END LOOP.
EXE.

FREQ Has_Trans.

DELETE VARIABLES K_201106 TO K_201605.

*Add in the DMA using the zip code of the account.
SORT CASES BY ZIPCODE(A).

*Open the file containing the Zipcode to DMA mapping.
GET FILE = '/usr/spss/userdata/LWhately/Media/2015 Media Test/dma_zip_xref_mine.sav'
   /KEEP ZipCode DMA.
CACHE.
EXE.

DATASET NAME DMA.
DATASET ACTIVATE DMA.

SORT CASES BY ZIPCODE(A).

DATASET ACTIVATE ACCTS.

MATCH FILES
   /FILE = *
   /TABLE = 'DMA'
   /BY ZIPCODE.
EXE.

DATASET CLOSE DMA.
DATASET ACTIVATE ACCTS.

SORT CASES BY account(A).

COMPUTE Group = 0.
IF(ANY(DMA,'ERIE','PEORIA - BLOOMINGTON','BIRMINGHAM (ANN & TUSC)','KNOXVILLE','FARGO - VALLEY CITY','LAS VEGAS')) Group = 1.
IF(ANY(DMA, 'AUGUSTA - AIKEN','SPRINGFIELD - HOLYOKE','FRESNO - VISALIA','LEXINGTON','JACKSON, MS','MADISON')) Group = 2.
IF(ANY(DMA,'BLUEFIELD - BECKLEY - OAK HILL','FT- SMITH - FAY - SPRNGDL - RG','RICHMOND - PETERSBURG', 
                    'GREENSBORO - H- POINT - W- SAL','LA CROSSE - EAU CLAIRE','TUCSON (SIERRA VISTA)')) Group = 3.
IF(ANY(DMA, 'DAVENPORT - R- ISLAND - MOLINE','YOUNGSTOWN','LANSING','GREENVLL - SPART - ASHEVLL - A','OMAHA','SIOUX CITY')) Group = 4.
FORMATS Group(F1.0).

*Compute the natural log of avg monthly orders over the 5 year history used for the forecast.
DO IF(Has_Trans = 1).

   COMPUTE ORD_PM = (SUM(TRNS_0611 TO TRNS_0516) / 60).
   COMPUTE ORD_PM_LN = LN(ORD_PM).

   *Compute the natural log of the monthly standard deviation of avg daily orders over the last 5 years.
   COMPUTE ORD_SD = SD(ADT1 TO ADT60).
   COMPUTE ORD_SD_LN = LN(ORD_SD).

END IF.

*Flag the accounts whose LN of Orders per Month is > 6.
COMPUTE Order_Outlier = (ORD_PM_LN > 6).
FORMATS Order_Outlier(F1.0).

*Flag the accounts whose LN of std deviation is >= 1.5.
COMPUTE Stable_Order_Outlier = (ORD_SD_LN >= 1.5).
FORMATS Stable_Order_Outlier(F1.0).
EXE.

*Save the resulting file.
SAVE OUTFILE = '/usr/spss/userdata/Albrecht/PPC Geo/Weekly Updates/Five Year Orders through May16 by Account for Target Markets.sav'.

*Remove records that do not have sales as well as an Amazon account which location is aligned to both Seattle and Lexington.
COMPUTE Include = (Has_Trans = 1 AND account <> 855313060 AND Order_Outlier = 0 AND Stable_Order_Outlier = 0).
FORMATS Include(F1.0).
EXE.

FILTER BY Include.

*Aggregate the average daily transactions by group.
DATASET DECLARE ADT.

AGGREGATE
  /OUTFILE='ADT'
  /BREAK=Group
  /ADT1=SUM(ADT1) 
  /ADT2=SUM(ADT2) 
  /ADT3=SUM(ADT3) 
  /ADT4=SUM(ADT4) 
  /ADT5=SUM(ADT5) 
  /ADT6=SUM(ADT6) 
  /ADT7=SUM(ADT7) 
  /ADT8=SUM(ADT8) 
  /ADT9=SUM(ADT9) 
  /ADT10=SUM(ADT10) 
  /ADT11=SUM(ADT11) 
  /ADT12=SUM(ADT12) 
  /ADT13=SUM(ADT13) 
  /ADT14=SUM(ADT14) 
  /ADT15=SUM(ADT15) 
  /ADT16=SUM(ADT16) 
  /ADT17=SUM(ADT17) 
  /ADT18=SUM(ADT18) 
  /ADT19=SUM(ADT19) 
  /ADT20=SUM(ADT20) 
  /ADT21=SUM(ADT21) 
  /ADT22=SUM(ADT22) 
  /ADT23=SUM(ADT23) 
  /ADT24=SUM(ADT24) 
  /ADT25=SUM(ADT25) 
  /ADT26=SUM(ADT26) 
  /ADT27=SUM(ADT27) 
  /ADT28=SUM(ADT28) 
  /ADT29=SUM(ADT29) 
  /ADT30=SUM(ADT30) 
  /ADT31=SUM(ADT31) 
  /ADT32=SUM(ADT32) 
  /ADT33=SUM(ADT33) 
  /ADT34=SUM(ADT34) 
  /ADT35=SUM(ADT35) 
  /ADT36=SUM(ADT36) 
  /ADT37=SUM(ADT37) 
  /ADT38=SUM(ADT38) 
  /ADT39=SUM(ADT39) 
  /ADT40=SUM(ADT40) 
  /ADT41=SUM(ADT41) 
  /ADT42=SUM(ADT42) 
  /ADT43=SUM(ADT43) 
  /ADT44=SUM(ADT44) 
  /ADT45=SUM(ADT45) 
  /ADT46=SUM(ADT46) 
  /ADT47=SUM(ADT47) 
  /ADT48=SUM(ADT48) 
  /ADT49=SUM(ADT49) 
  /ADT50=SUM(ADT50) 
  /ADT51=SUM(ADT51) 
  /ADT52=SUM(ADT52) 
  /ADT53=SUM(ADT53) 
  /ADT54=SUM(ADT54) 
  /ADT55=SUM(ADT55) 
  /ADT56=SUM(ADT56) 
  /ADT57=SUM(ADT57) 
  /ADT58=SUM(ADT58) 
  /ADT59=SUM(ADT59) 
  /ADT60=SUM(ADT60)
  /N_BREAK=N.

DATASET ACTIVATE ADT.

*Create variables for forecast values.
COMPUTE ADT61 = 0.
COMPUTE ADT62 = 0.
COMPUTE ADT63 = 0.
COMPUTE ADT64 = 0.
COMPUTE ADT65 = 0.
COMPUTE ADT66 = 0.
COMPUTE ADT67 = 0.
COMPUTE ADT68 = 0.
COMPUTE ADT69 = 0.
COMPUTE ADT70 = 0.
COMPUTE ADT71 = 0.
COMPUTE ADT72 = 0.
EXE.

FLIP VARIABLES=ADT1 ADT2 ADT3 ADT4 ADT5 ADT6 ADT7 ADT8 ADT9 ADT10 ADT11 ADT12 ADT13 ADT14 ADT15 
    ADT16 ADT17 ADT18 ADT19 ADT20 ADT21 ADT22 ADT23 ADT24 ADT25 ADT26 ADT27 ADT28 ADT29 ADT30 ADT31 
    ADT32 ADT33 ADT34 ADT35 ADT36 ADT37 ADT38 ADT39 ADT40 ADT41 ADT42 ADT43 ADT44 ADT45 ADT46 ADT47 
    ADT48 ADT49 ADT50 ADT51 ADT52 ADT53 ADT54 ADT55 ADT56 ADT57 ADT58 ADT59 ADT60 ADT61 ADT62 ADT63
    ADT64 ADT65 ADT66 ADT67 ADT68 ADT69 ADT70 ADT71 ADT72
  /NEWNAMES=Group.

DATASET NAME DT_TS.
DATASET ACTIVATE DT_TS.

RENAME VARIABLES K_1 = Group1 K_2 = Group2 K_3 = Group3 K_4 = Group4.

DATE M 6 12 Y 2011.

*Group 1 Forecast.
USE year 2011 month 6 THRU year 2016 month 5.

PREDICT THRU END.

TSMODEL
   /MODELSUMMARY  PRINT=[MODELFIT]
   /MODELSTATISTICS  DISPLAY=YES MODELFIT=[ SRSQUARE RSQUARE]
   /SERIESPLOT OBSERVED FORECAST FIT FORECASTCI FITCI
   /OUTPUTFILTER DISPLAY=ALLMODELS
   /SAVE  PREDICTED(Predicted) LCL(LCL) UCL(UCL) NRESIDUAL(NResidual)
   /AUXILIARY  CILEVEL=80 MAXACFLAGS=24
   /MISSING USERMISSING=EXCLUDE
   /MODEL DEPENDENT=Group1
      PREFIX='Model'
   /EXSMOOTH TYPE=WINTERSADDITIVE  TRANSFORM=NONE.

*Group 2 Forecast.
USE year 2011 month 6 THRU year 2016 month 5.

PREDICT THRU END.

 * TSMODEL
   /MODELSUMMARY  PRINT=[MODELFIT]
   /MODELSTATISTICS  DISPLAY=YES MODELFIT=[ SRSQUARE RSQUARE]
   /SERIESPLOT OBSERVED FORECAST FORECASTCI
   /OUTPUTFILTER DISPLAY=ALLMODELS
   /SAVE  PREDICTED(Predicted) LCL(LCL) UCL(UCL) NRESIDUAL(NResidual)
   /AUXILIARY  CILEVEL=90 MAXACFLAGS=24
   /MISSING USERMISSING=EXCLUDE
   /MODEL DEPENDENT=Group2
   /EXPERTMODELER TYPE=[ARIMA EXSMOOTH] TRYSEASONAL=YES
   /AUTOOUTLIER  DETECT=OFF.

TSMODEL
   /MODELSUMMARY  PRINT=[MODELFIT]
   /MODELSTATISTICS  DISPLAY=YES MODELFIT=[ SRSQUARE RSQUARE]
   /SERIESPLOT OBSERVED FORECAST FIT FORECASTCI FITCI
   /OUTPUTFILTER DISPLAY=ALLMODELS
   /SAVE  PREDICTED(Predicted) LCL(LCL) UCL(UCL) NRESIDUAL(NResidual)
   /AUXILIARY  CILEVEL=80 MAXACFLAGS=24
   /MISSING USERMISSING=EXCLUDE
   /MODEL DEPENDENT=Group2
      PREFIX='Model'
   /EXSMOOTH TYPE=WINTERSADDITIVE  TRANSFORM=NONE.

*Group 3 Forecast.
USE year 2011 month 6 THRU year 2016 month 5.

PREDICT THRU END.

TSMODEL
   /MODELSUMMARY  PRINT=[MODELFIT]
   /MODELSTATISTICS  DISPLAY=YES MODELFIT=[ SRSQUARE RSQUARE]
   /SERIESPLOT OBSERVED FORECAST FORECASTCI
   /OUTPUTFILTER DISPLAY=ALLMODELS
   /SAVE  PREDICTED(Predicted) LCL(LCL) UCL(UCL) NRESIDUAL(NResidual)
   /AUXILIARY  CILEVEL=80 MAXACFLAGS=24
   /MISSING USERMISSING=EXCLUDE
   /MODEL DEPENDENT=Group3 INDEPENDENT=YEAR_ MONTH_
   /EXPERTMODELER TYPE=[ARIMA EXSMOOTH] TRYSEASONAL=YES
   /AUTOOUTLIER  DETECT=OFF.

*Group 4 Forecast.
USE year 2011 month 6 THRU year 2016 month 5.

PREDICT THRU END.

TSMODEL
   /MODELSUMMARY  PRINT=[MODELFIT]
   /MODELSTATISTICS  DISPLAY=YES MODELFIT=[ SRSQUARE RSQUARE]
   /SERIESPLOT OBSERVED FORECAST FORECASTCI
   /OUTPUTFILTER DISPLAY=ALLMODELS
   /SAVE  PREDICTED(Predicted) LCL(LCL) UCL(UCL) NRESIDUAL(NResidual)
   /AUXILIARY  CILEVEL=80 MAXACFLAGS=24
   /MISSING USERMISSING=EXCLUDE
   /MODEL DEPENDENT=Group4 INDEPENDENT=YEAR_ MONTH_
      PREFIX='Model'
   /EXPERTMODELER TYPE=[ARIMA EXSMOOTH] TRYSEASONAL=YES
   /AUTOOUTLIER  DETECT=OFF.

DATASET CLOSE DT_TS.
DATASET CLOSE ADT.

*Aggregate the average daily Gcom sales by group.
DATASET ACTIVATE ACCTS.

DATASET DECLARE AD_GCT.

AGGREGATE
  /OUTFILE='AD_GCT'
  /BREAK=Group
  /ADGCT1=SUM(ADGCT1) 
  /ADGCT2=SUM(ADGCT2) 
  /ADGCT3=SUM(ADGCT3) 
  /ADGCT4=SUM(ADGCT4) 
  /ADGCT5=SUM(ADGCT5) 
  /ADGCT6=SUM(ADGCT6) 
  /ADGCT7=SUM(ADGCT7) 
  /ADGCT8=SUM(ADGCT8) 
  /ADGCT9=SUM(ADGCT9) 
  /ADGCT10=SUM(ADGCT10) 
  /ADGCT11=SUM(ADGCT11) 
  /ADGCT12=SUM(ADGCT12) 
  /ADGCT13=SUM(ADGCT13) 
  /ADGCT14=SUM(ADGCT14) 
  /ADGCT15=SUM(ADGCT15) 
  /ADGCT16=SUM(ADGCT16) 
  /ADGCT17=SUM(ADGCT17) 
  /ADGCT18=SUM(ADGCT18) 
  /ADGCT19=SUM(ADGCT19) 
  /ADGCT20=SUM(ADGCT20) 
  /ADGCT21=SUM(ADGCT21) 
  /ADGCT22=SUM(ADGCT22) 
  /ADGCT23=SUM(ADGCT23) 
  /ADGCT24=SUM(ADGCT24) 
  /ADGCT25=SUM(ADGCT25) 
  /ADGCT26=SUM(ADGCT26) 
  /ADGCT27=SUM(ADGCT27) 
  /ADGCT28=SUM(ADGCT28) 
  /ADGCT29=SUM(ADGCT29) 
  /ADGCT30=SUM(ADGCT30) 
  /ADGCT31=SUM(ADGCT31) 
  /ADGCT32=SUM(ADGCT32) 
  /ADGCT33=SUM(ADGCT33) 
  /ADGCT34=SUM(ADGCT34) 
  /ADGCT35=SUM(ADGCT35) 
  /ADGCT36=SUM(ADGCT36) 
  /ADGCT37=SUM(ADGCT37) 
  /ADGCT38=SUM(ADGCT38) 
  /ADGCT39=SUM(ADGCT39) 
  /ADGCT40=SUM(ADGCT40) 
  /ADGCT41=SUM(ADGCT41) 
  /ADGCT42=SUM(ADGCT42) 
  /ADGCT43=SUM(ADGCT43) 
  /ADGCT44=SUM(ADGCT44) 
  /ADGCT45=SUM(ADGCT45) 
  /ADGCT46=SUM(ADGCT46) 
  /ADGCT47=SUM(ADGCT47) 
  /ADGCT48=SUM(ADGCT48) 
  /ADGCT49=SUM(ADGCT49) 
  /ADGCT50=SUM(ADGCT50) 
  /ADGCT51=SUM(ADGCT51) 
  /ADGCT52=SUM(ADGCT52) 
  /ADGCT53=SUM(ADGCT53) 
  /ADGCT54=SUM(ADGCT54) 
  /ADGCT55=SUM(ADGCT55) 
  /ADGCT56=SUM(ADGCT56) 
  /ADGCT57=SUM(ADGCT57) 
  /ADGCT58=SUM(ADGCT58) 
  /ADGCT59=SUM(ADGCT59) 
  /ADGCT60=SUM(ADGCT60)
  /N_BREAK=N.

DATASET ACTIVATE AD_GCT.

*Create variables for forecast values.
COMPUTE ADGCT61 = 0.
COMPUTE ADGCT62 = 0.
COMPUTE ADGCT63 = 0.
COMPUTE ADGCT64 = 0.
COMPUTE ADGCT65 = 0.
COMPUTE ADGCT66 = 0.
COMPUTE ADGCT67 = 0.
COMPUTE ADGCT68 = 0.
COMPUTE ADGCT69 = 0.
COMPUTE ADGCT70 = 0.
COMPUTE ADGCT71 = 0.
COMPUTE ADGCT72 = 0.
EXE.

FLIP VARIABLES=ADGCT1 ADGCT2 ADGCT3 ADGCT4 ADGCT5 ADGCT6 ADGCT7 ADGCT8 ADGCT9 ADGCT10 ADGCT11 ADGCT12 ADGCT13 ADGCT14 ADGCT15 
    ADGCT16 ADGCT17 ADGCT18 ADGCT19 ADGCT20 ADGCT21 ADGCT22 ADGCT23 ADGCT24 ADGCT25 ADGCT26 ADGCT27 ADGCT28 ADGCT29 ADGCT30 ADGCT31 
    ADGCT32 ADGCT33 ADGCT34 ADGCT35 ADGCT36 ADGCT37 ADGCT38 ADGCT39 ADGCT40 ADGCT41 ADGCT42 ADGCT43 ADGCT44 ADGCT45 ADGCT46 ADGCT47 
    ADGCT48 ADGCT49 ADGCT50 ADGCT51 ADGCT52 ADGCT53 ADGCT54 ADGCT55 ADGCT56 ADGCT57 ADGCT58 ADGCT59 ADGCT60 ADGCT61 ADGCT62 ADGCT63
    ADGCT64 ADGCT65 ADGCT66 ADGCT67 ADGCT68 ADGCT69 ADGCT70 ADGCT71 ADGCT72
  /NEWNAMES=Group.

DATASET NAME DGCT_TS.
DATASET ACTIVATE DGCT_TS.

RENAME VARIABLES K_1 = Group1 K_2 = Group2 K_3 = Group3 K_4 = Group4.

DATE M 6 12 Y 2011.

*Group 1 Forecast.
USE year 2012 month 1 THRU year 2016 month 5.

PREDICT THRU END.

TSMODEL
   /MODELSUMMARY  PRINT=[MODELFIT]
   /MODELSTATISTICS  DISPLAY=YES MODELFIT=[ SRSQUARE RSQUARE]
   /SERIESPLOT OBSERVED FORECAST FORECASTCI
   /OUTPUTFILTER DISPLAY=ALLMODELS
   /SAVE  PREDICTED(Predicted) LCL(LCL) UCL(UCL) NRESIDUAL(NResidual)
   /AUXILIARY  CILEVEL=80 MAXACFLAGS=24
   /MISSING USERMISSING=EXCLUDE
   /MODEL DEPENDENT=Group1 INDEPENDENT=YEAR_ MONTH_
      PREFIX='Model'
   /EXPERTMODELER TYPE=[ARIMA EXSMOOTH] TRYSEASONAL=YES
   /AUTOOUTLIER  DETECT=OFF.

*Group 2 Forecast.
USE year 2012 month 1 THRU year 2016 month 5.

PREDICT THRU END.

TSMODEL
   /MODELSUMMARY  PRINT=[MODELFIT]
   /MODELSTATISTICS  DISPLAY=YES MODELFIT=[ SRSQUARE RSQUARE]
   /SERIESPLOT OBSERVED FORECAST FORECASTCI
   /OUTPUTFILTER DISPLAY=ALLMODELS
   /SAVE  PREDICTED(Predicted) LCL(LCL) UCL(UCL) NRESIDUAL(NResidual)
   /AUXILIARY  CILEVEL=80 MAXACFLAGS=24
   /MISSING USERMISSING=EXCLUDE
   /MODEL DEPENDENT=Group2 INDEPENDENT=YEAR_ MONTH_
      PREFIX='Model'
   /EXPERTMODELER TYPE=[ARIMA EXSMOOTH] TRYSEASONAL=YES
   /AUTOOUTLIER  DETECT=OFF.

*Group 3 Forecast.
USE year 2012 month 1 THRU year 2016 month 5.

PREDICT THRU END.

TSMODEL
   /MODELSUMMARY  PRINT=[MODELFIT]
   /MODELSTATISTICS  DISPLAY=YES MODELFIT=[ SRSQUARE RSQUARE]
   /SERIESPLOT OBSERVED FORECAST FORECASTCI
   /OUTPUTFILTER DISPLAY=ALLMODELS
   /SAVE  PREDICTED(Predicted) LCL(LCL) UCL(UCL) NRESIDUAL(NResidual)
   /AUXILIARY  CILEVEL=80 MAXACFLAGS=24
   /MISSING USERMISSING=EXCLUDE
   /MODEL DEPENDENT=Group3 INDEPENDENT=YEAR_ MONTH_
      PREFIX='Model'
   /EXPERTMODELER TYPE=[ARIMA EXSMOOTH] TRYSEASONAL=YES
   /AUTOOUTLIER  DETECT=OFF.

*Group 4 Forecast.
USE year 2012 month 1 THRU year 2016 month 5.

PREDICT THRU END.

TSMODEL
   /MODELSUMMARY  PRINT=[MODELFIT]
   /MODELSTATISTICS  DISPLAY=YES MODELFIT=[ SRSQUARE RSQUARE]
   /SERIESPLOT OBSERVED FORECAST FORECASTCI
   /OUTPUTFILTER DISPLAY=ALLMODELS
   /SAVE  PREDICTED(Predicted) LCL(LCL) UCL(UCL) NRESIDUAL(NResidual)
   /AUXILIARY  CILEVEL=90 MAXACFLAGS=24
   /MISSING USERMISSING=EXCLUDE
   /MODEL DEPENDENT=Group4 INDEPENDENT=YEAR_ MONTH_
      PREFIX='Model'
   /EXPERTMODELER TYPE=[ARIMA EXSMOOTH] TRYSEASONAL=YES
   /AUTOOUTLIER  DETECT=OFF.

DATASET CLOSE DGCT_TS.
DATASET CLOSE AD_GCT.

DATASET ACTIVATE ACCTS.

