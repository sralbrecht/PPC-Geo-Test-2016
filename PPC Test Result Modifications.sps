/*LOOK AT THE AOV FROM THE 12 MONTHS PRIOR TO THE START OF THE TEST TO SEE IF THERE IS A DIFFERENCE BETWEEN GROUPS*/.

*Open the file containing total sales for each account in the target DMAs.
GET FILE = '/usr/spss/userdata/Albrecht/PPC Geo/Weekly Updates/Five Year Sales through May16 by Account for Target Markets.sav'.
CACHE.
EXE.

DATASET NAME SLS.
DATASET ACTIVATE SLS.

RECODE HSV(MISSING = 0).
EXE.

DATASET COPY SLS2.
DATASET ACTIVATE SLS2.

DELETE VARIABLES ADS1 TO ADGCS60.

SELECT IF(Has_Sales = 1).
EXE.

*Open the file containing total orders for each account in the target DMAs.
GET FILE = '/usr/spss/userdata/Albrecht/PPC Geo/Weekly Updates/Five Year Orders through May16 by Account for Target Markets.sav'.
CACHE.
EXE.

DATASET NAME ORD.
DATASET ACTIVATE ORD.

DATASET COPY ORD2.
DATASET ACTIVATE ORD2.

DELETE VARIABLES DMA Group ADT1 TO ADGCT60.

*Merge the datasets together.
DATASET ACTIVATE SLS2.

MATCH FILES
   /FILE = *
   /TABLE = 'ORD2'
   /BY account ZIPCODE.
EXE.

DATASET CLOSE ORD2.
DATASET ACTIVATE SLS2.

*Compute AOV over the last 12 months.
COMPUTE GIS_SLS = SUM(SLS_0615 TO SLS_0516).
COMPUTE GIS_TRNS = SUM(TRNS_0615 TO TRNS_0516).

COMPUTE GCOM_SLS = SUM(Gcom_Sales_0615 TO Gcom_Sales_0516).
COMPUTE GCOM_TRNS = SUM(Gcom_Orders_0615 TO Gcom_Orders_0516).

DO IF(GIS_TRNS > 0).

   COMPUTE GIS_AOV = ( GIS_SLS / GIS_TRNS ).

ELSE.

   COMPUTE GIS_AOV = 0.

END IF.

DO IF(GCOM_TRNS > 0).

   COMPUTE GCOM_AOV = ( GCOM_SLS / GCOM_TRNS ).

ELSE.

   COMPUTE GCOM_AOV = 0.

END IF.

COMPUTE MIN_REQ = (GIS_SLS > 0 AND GIS_TRNS >= 1 AND HSV = 0).
COMPUTE MIN_GC_REQ = (GCOM_SLS > 0 AND GCOM_TRNS >= 1 AND HSV = 0).

COMPUTE GIS_Grp1 = (Group = 1 AND MIN_REQ = 1).
FORMATS GIS_Grp1(F1.0).

COMPUTE GIS_Grp2 = (Group = 2 AND MIN_REQ = 1).
FORMATS GIS_Grp2(F1.0).

COMPUTE GIS_Grp3 = (Group = 3 AND MIN_REQ = 1).
FORMATS GIS_Grp3(F1.0).

COMPUTE GIS_Grp4 = (Group = 4 AND MIN_REQ = 1).
FORMATS GIS_Grp4(F1.0).

COMPUTE GC_Grp1 = (Group = 1 AND MIN_GC_REQ = 1).
FORMATS GC_Grp1(F1.0).

COMPUTE GC_Grp2 = (Group = 2 AND MIN_GC_REQ = 1).
FORMATS GC_Grp2(F1.0).

COMPUTE GC_Grp3 = (Group = 3 AND MIN_GC_REQ = 1).
FORMATS GC_Grp3(F1.0).

COMPUTE GC_Grp4 = (Group = 4 AND MIN_GC_REQ = 1).
FORMATS GC_Grp4(F1.0).
EXE.

*Examine the distribution for Group 1.
FILTER BY GIS_Grp1.

EXAMINE GIS_AOV
   /PLOT NONE
   /PERCENTILES(5,10,25,50,75,90,95,99).

*Examine the distribution for Group 2.
FILTER BY GIS_Grp2.

EXAMINE GIS_AOV
   /PLOT NONE
   /PERCENTILES(5,10,25,50,75,90,95,99).

*Examine the distribution for Group 3.
FILTER BY GIS_Grp3.

EXAMINE GIS_AOV
   /PLOT NONE
   /PERCENTILES(5,10,25,50,75,90,95,99).

*Examine the distribution for Group 4.
FILTER BY GIS_Grp4.

EXAMINE GIS_AOV
   /PLOT NONE
   /PERCENTILES(5,10,25,50,75,90,95,99).

*Examine the Gcom distribution for Group 1.
FILTER BY GC_Grp1.

EXAMINE GCOM_AOV
   /PLOT NONE
   /PERCENTILES(5,10,25,50,75,90,95,99).

*Examine the Gcom distribution for Group 2.
FILTER BY GC_Grp2.

EXAMINE GCOM_AOV
   /PLOT NONE
   /PERCENTILES(5,10,25,50,75,90,95,99).

*Examine the Gcom distribution for Group 3.
FILTER BY GC_Grp3.

EXAMINE GCOM_AOV
   /PLOT NONE
   /PERCENTILES(5,10,25,50,75,90,95,99).

*Examine the Gcom distribution for Group 4.
FILTER BY GC_Grp4.

EXAMINE GCOM_AOV
   /PLOT NONE
   /PERCENTILES(5,10,25,50,75,90,95,99).

*Aggregate the GIS data by group.
FILTER BY MIN_REQ.

DATASET DECLARE GIS_ACT_BG.

AGGREGATE
   /OUTFILE = 'GIS_ACT_BG'
   /BREAK = Group
   /GIS_SLS = SUM(GIS_SLS)
   /GIS_TRNS = SUM(GIS_TRNS)
   /Num_Accts = N.

DATASET ACTIVATE GIS_ACT_BG.

*Aggregate the Gcom data by group.
DATASET ACTIVATE SLS2.

FILTER BY MIN_GC_REQ.

DATASET DECLARE GC_ACT_BG.

AGGREGATE
   /OUTFILE = 'GC_ACT_BG'
   /BREAK = Group
   /GCOM_SLS = SUM(GCOM_SLS)
   /GCOM_TRNS = SUM(GCOM_TRNS)
   /Num_Accts = N.

DATASET ACTIVATE GC_ACT_BG.

/*LOOK AT THE YOY V%

DATASET ACTIVATE SLS2.

FILTER OFF.

COMPUTE Include = (HSV = 0).
FORMATS Include(F1.0).
EXE.

FILTER BY Include.

*Aggregate GIS and Gcom sales and orders from June and July 2015 by each individual DMA.
DATASET DECLARE PY_ACT.

AGGREGATE
   /OUTFILE = 'PY_ACT'
   /BREAK = Group DMA
   /GIS_JUN_SLS = SUM(SLS_0615)
   /GIS_JUN_ORD = SUM(TRNS_0615)
   /GIS_JUL_SLS = SUM(SLS_0715)
   /GIS_JUL_ORD = SUM(TRNS_0715)
   /GC_JUN_SLS = SUM(Gcom_Sales_0615)
   /GC_JUN_ORD = SUM(Gcom_Orders_0615)
   /GC_JUL_SLS = SUM(Gcom_Sales_0715)
   /GC_JUL_ORD = SUM(Gcom_Orders_0715)
   /Num_Accts = N.

DATASET ACTIVATE PY_ACT.

*Now open the file containing the results from the testing period.
GET FILE = '/usr/spss/userdata/Albrecht/PPC Geo/Weekly Updates/Week 4/GIS and Gcom Sales and Acquisitions by Account.sav'.
CACHE.
EXE.

DATASET NAME WK4_RES.

DATASET ACTIVATE SLS.

DATASET COPY HSV.
DATASET ACTIVATE HSV.

DELETE VARIABLES DMA TO Has_Sales.

DATASET ACTIVATE WK4_RES.

MATCH FILES
   /FILE = *
   /TABLE = 'HSV'
   /BY account ZIPCODE.
EXE.

DATASET CLOSE HSV.
DATASET ACTIVATE WK4_RES.

COMPUTE Include2 = (Include = 1 AND HSV = 0).
FORMATS Include2(F1.0).
EXE.

FILTER BY Include2.

DATASET DECLARE TP_RES.

AGGREGATE
   /OUTFILE = 'TP_RES'
   /BREAK = Group DMA
   /TP_SALES = SUM(TP_SALES)
   /TP_ORDERS = SUM(TP_ORDERS)
   /TP_GC_SALES = SUM(TP_GC_SALES)
   /TP_GC_ORDERS = SUM(TP_GC_ORDERS).

DATASET ACTIVATE TP_RES.

/*LOOK AT THE DISTRIBUTION OF SALES AND ORDERS ACROSS CLUSTERS FOR EACH OF THE TEST GROUPS*/.

DATASET ACTIVATE SLS.

DATASET COPY SLS_CLUS.
DATASET ACTIVATE SLS_CLUS.
.
COMPUTE TOT_SLS = SUM(SLS_0611 TO SLS_0516).
COMPUTE TOT_GC_SLS = SUM(Gcom_Sales_0611 TO Gcom_Sales_0516).
EXE.

DELETE VARIABLES SLS_0611 TO ADGCS60.

DATASET ACTIVATE ORD.

DATASET COPY ORD_CLUS.
DATASET ACTIVATE ORD_CLUS.

COMPUTE TOT_TRNS = SUM(TRNS_0611 TO TRNS_0516).
COMPUTE TOT_GC_TRNS = SUM(Gcom_Orders_0112 TO Gcom_Orders_0516).
EXE.

DELETE VARIABLES DMA Group TRNS_0611 TO ADGCT60. 

DATASET ACTIVATE SLS_CLUS.

MATCH FILES
   /FILE = *
   /TABLE = 'ORD_CLUS'
   /BY account ZIPCODE.
EXE.

DATASET CLOSE ORD_CLUS.
DATASET ACTIVATE SLS_CLUS.

SORT CASES BY DMA(A).

*Open the file containing the list of Grainger DMAs.
GET FILE = '/usr/spss/userdata/Albrecht/PPC Geo/DMA_Clusters_Final.sav'
   /KEEP DMA_imputed final_cluster
   /RENAME DMA_imputed = DMA.
CACHE.
EXE.

DATASET NAME DMA.
DATASET ACTIVATE DMA.

SORT CASES BY DMA(A).

DATASET ACTIVATE SLS_CLUS.

MATCH FILES
   /FILE = *
   /TABLE = 'DMA'
   /BY DMA.
EXE.

DATASET CLOSE DMA.
DATASET ACTIVATE SLS_CLUS.

COMPUTE Include = (Has_Sales = 1 AND HSV = 0).
EXE.

FILTER BY Include.

DATASET DECLARE ACT_BY_CLUS.

AGGREGATE
   /OUTFILE = 'ACT_BY_CLUS'
   /BREAK = Group final_cluster
   /TOT_SLS = SUM(TOT_SLS)
   /TOT_GC_SLS = SUM(TOT_GC_SLS)
   /TOT_TRNS = SUM(TOT_TRNS)
   /TOT_GC_TRNS = SUM(TOT_GC_TRNS).

DATASET ACTIVATE ACT_BY_CLUS.

/*LOOK FOR OUTLIERS IN ORDER ACTIVITY*/.

DATASET ACTIVATE ORD.

DATASET COPY ORD_ACT.
DATASET ACTIVATE ORD_ACT.

*Look at orders per month over the 5 year history.
COMPUTE ORD_PM = (SUM(TRNS_0611 TO TRNS_0516) / 60).

*Look at the standard deviation of daily orders over the last 5 years.
COMPUTE ORD_SD = SD(ADT1 TO ADT60).
EXE.

DELETE VARIABLES TRNS_0611 TO Gcom_Orders_0516.

*Remove accounts without an order.
SELECT IF(Has_Trans = 1).
EXE.

*Examine GIS Orders per Month.
EXAMINE ORD_PM
   /PLOT HISTOGRAM BOXPLOT
   /PERCENTILES(5,10,25,50,75,90,95,99).

*Take the natural log of orders per month.
COMPUTE ORD_PM_LN = LN(ORD_PM).
EXE.

*Examine LN GIS Orders per Month.
EXAMINE ORD_PM_LN
   /PLOT HISTOGRAM BOXPLOT
   /PERCENTILES(5,10,25,50,75,90,95,99).

*Flag the accounts whose LN of Orders per Month is > 6.
COMPUTE Order_Outlier = (ORD_PM_LN > 6).
FORMATS Order_Outlier(F1.0).
EXE.

MEANS account BY Group BY Order_Outlier
   /CELLS COUNT.

*Look at the standard deviation of month to month daily orders for each account.
EXAMINE ORD_SD
   /PLOT HISTOGRAM BOXPLOT
   /PERCENTILES(5,10,25,50,75,90,95,99).

*Take the natural log of the standard deviation.
COMPUTE ORD_SD_LN = LN(ORD_SD).
EXE.

*Look at the LN of the standard deviation of month to month daily orders for each account.
EXAMINE ORD_SD_LN
   /PLOT HISTOGRAM BOXPLOT
   /PERCENTILES(5,10,25,50,75,90,95,99).

*Flag the accounts whose LN of std deviation is >= 1.5.
COMPUTE Stable_Order_Outlier = (ORD_SD_LN >= 1.5).
FORMATS Stable_Order_Outlier(F1.0).
EXE.

MEANS account BY Group BY Stable_Order_Outlier
   /CELLS COUNT.

MEANS account BY Group BY Order_Outlier BY Stable_Order_Outlier
   /CELLS COUNT.

