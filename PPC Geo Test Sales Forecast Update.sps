*Open the current time series file to get the sales through May 2016.
GET FILE = '/usr/spss/userdata/time_series_data/NEW_Sales_by_account_1993_0516.sav'
   /KEEP account SLS_0611 TO SLS_0516.
CACHE.
EXE.

DATASET NAME TS.

*Select only valid accounts.
SELECT IF(account > 800000000).

*Recode missing values in Dec 2013. 
IF( (MISSING(SLS_1113) = 0) AND MISSING(SLS_1213) ) SLS_1213 = 0.
EXE.

*Open the ecomm ops file from Dec 2013 to get Gcom sales history.
GET FILE = '/usr/spss/userdata/ecomm_files/archives/201312.ecomm.ops.sav'
   /KEEP Account gcom_sales_0611 TO gcom_sales_1213.
CACHE.
EXE.

DATASET NAME GC1.

*Open the ecomm ops file from May 2016 to get Gcom sales history.
GET FILE = '/usr/spss/userdata/ecomm_files/201605.ecomm.ops.sav'
   /KEEP Account Gcom_Sales_0114 TO Gcom_Sales_0516. 
CACHE.
EXE.

DATASET NAME GC2.

*Get the zipcode from the customer table in Teradata.
GET DATA 
  /TYPE=ODBC 
  /CONNECT='DSN=Teradata;DB=PRD_DWH_VIEW;PORT=1025;DBCNL=10.4.165.29;UID=spss;PWD=$-<~*x#N3@!/-!!+'
  /SQL='SELECT DISTINCT CU.CUSTOMER, CU.ZZIPCD5 ZIPCODE '+
           'FROM PRD_DWH_VIEW.Customer_V CU '.
CACHE.
EXE.

DATASET NAME CZIP.
DATASET ACTIVATE CZIP.

RENAME VARIABLES CUSTOMER = account.

ALTER TYPE account(F10.0).

SORT CASES BY account(A).

DATASET ACTIVATE TS.

MATCH FILES
   /FILE = *
   /TABLE = 'CZIP'
   /TABLE = 'GC1'
   /TABLE = 'GC2'
   /BY account.
EXE.

DATASET CLOSE CZIP.
DATASET CLOSE GC1.
DATASET CLOSE GC2.

*Open the file containing the Zipcode to DMA mapping.
GET FILE = '/usr/spss/userdata/LWhately/Media/2015 Media Test/dma_zip_xref_mine.sav'
   /KEEP Zipcode DMA.
CACHE.
EXE.

DATASET NAME ZTD.
DATASET ACTIVATE ZTD.

*Select only the test and control DMAs we would like to use.
SELECT IF(ANY(DMA,'ERIE','PEORIA - BLOOMINGTON','BIRMINGHAM (ANN & TUSC)','KNOXVILLE','FARGO - VALLEY CITY','LAS VEGAS',
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
FORMATS Group(F1.0).
EXE.

DATASET ACTIVATE TS.

SORT CASES BY ZIPCODE(A).

MATCH FILES
   /FILE = *
   /TABLE = 'ZTD'
   /BY ZIPCODE.
EXE.

DATASET CLOSE ZTD.
DATASET ACTIVATE TS.

SELECT IF(Group >= 1).
EXE.

SORT CASES BY account(A).

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
DATASET ACTIVATE TS.

STRING CASE_LBL(A7).

COMPUTE CASE_LBL = 'slsdays'.
EXE.

MATCH FILES
   /FILE = *
   /TABLE = 'SALES_DAYS'
   /BY CASE_LBL.
EXE.

DATASET CLOSE SALES_DAYS.

DATASET ACTIVATE TS.
DELETE VARIABLES CASE_LBL.

VECTOR MS = SLS_0611 TO SLS_0516.
VECTOR GCS = gcom_sales_0611 TO Gcom_Sales_0516.
VECTOR SD = K_201106 TO K_201605.

VECTOR ADS(60).
VECTOR ADGCS(60).

LOOP #i = 1 TO 60.

   DO IF(SD(#i) > 0).

      COMPUTE ADS(#i) = MS(#i) / SD(#i).

      COMPUTE ADGCS(#i) = GCS(#i) / SD(#i).

   END IF.

END LOOP.

*Flag accounts who have sales in at least 1 month in the time period at which we are looking.
VECTOR TOT_SLS = SLS_0611 TO SLS_0516.

COMPUTE Has_Sales = 0.
FORMATS Has_Sales(F1.0).

LOOP #k = 1 TO 60.

   IF(TOT_SLS(#k) > 0) Has_Sales = 1.

END LOOP.

*Compute average monthly sales over the last 2 years.
COMPUTE #AMS = (SUM(SLS_0614 TO SLS_0516) / 24).
COMPUTE HSV = (#AMS > 40000).
FORMATS HSV(F1.0).
EXE.

FREQ Has_Sales.

FILTER BY Has_Sales.

MEANS HSV BY Group
   /CELLS SUM.

FILTER OFF.

DELETE VARIABLES K_201106 TO K_201605.

*Save the resulting file.
SAVE OUTFILE = '/usr/spss/userdata/Albrecht/PPC Geo/Weekly Updates/Five Year Sales through May16 by Account for Target Markets.sav'.

*Remove records that do not have sales as well as an Amazon account which location is aligned to both Seattle and Lexington.
 * COMPUTE Include = (Has_Sales = 1 AND account <> 855313060).
COMPUTE Include = (Has_Sales = 1 AND account <> 855313060 AND HSV = 0).
EXE.

FILTER BY Include.

*Aggregate the average daily sales by group.
DATASET DECLARE ADS.

AGGREGATE
  /OUTFILE='ADS'
  /BREAK=Group
  /ADS1=SUM(ADS1) 
  /ADS2=SUM(ADS2) 
  /ADS3=SUM(ADS3) 
  /ADS4=SUM(ADS4) 
  /ADS5=SUM(ADS5) 
  /ADS6=SUM(ADS6) 
  /ADS7=SUM(ADS7) 
  /ADS8=SUM(ADS8) 
  /ADS9=SUM(ADS9) 
  /ADS10=SUM(ADS10) 
  /ADS11=SUM(ADS11) 
  /ADS12=SUM(ADS12) 
  /ADS13=SUM(ADS13) 
  /ADS14=SUM(ADS14) 
  /ADS15=SUM(ADS15) 
  /ADS16=SUM(ADS16) 
  /ADS17=SUM(ADS17) 
  /ADS18=SUM(ADS18) 
  /ADS19=SUM(ADS19) 
  /ADS20=SUM(ADS20) 
  /ADS21=SUM(ADS21) 
  /ADS22=SUM(ADS22) 
  /ADS23=SUM(ADS23) 
  /ADS24=SUM(ADS24) 
  /ADS25=SUM(ADS25) 
  /ADS26=SUM(ADS26) 
  /ADS27=SUM(ADS27) 
  /ADS28=SUM(ADS28) 
  /ADS29=SUM(ADS29) 
  /ADS30=SUM(ADS30) 
  /ADS31=SUM(ADS31) 
  /ADS32=SUM(ADS32) 
  /ADS33=SUM(ADS33) 
  /ADS34=SUM(ADS34) 
  /ADS35=SUM(ADS35) 
  /ADS36=SUM(ADS36) 
  /ADS37=SUM(ADS37) 
  /ADS38=SUM(ADS38) 
  /ADS39=SUM(ADS39) 
  /ADS40=SUM(ADS40) 
  /ADS41=SUM(ADS41) 
  /ADS42=SUM(ADS42) 
  /ADS43=SUM(ADS43) 
  /ADS44=SUM(ADS44) 
  /ADS45=SUM(ADS45) 
  /ADS46=SUM(ADS46) 
  /ADS47=SUM(ADS47) 
  /ADS48=SUM(ADS48) 
  /ADS49=SUM(ADS49) 
  /ADS50=SUM(ADS50) 
  /ADS51=SUM(ADS51) 
  /ADS52=SUM(ADS52) 
  /ADS53=SUM(ADS53) 
  /ADS54=SUM(ADS54) 
  /ADS55=SUM(ADS55) 
  /ADS56=SUM(ADS56) 
  /ADS57=SUM(ADS57) 
  /ADS58=SUM(ADS58) 
  /ADS59=SUM(ADS59) 
  /ADS60=SUM(ADS60)
  /N_BREAK=N.

DATASET ACTIVATE ADS.

*Create variables for forecast values.
COMPUTE ADS61 = 0.
COMPUTE ADS62 = 0.
COMPUTE ADS63 = 0.
COMPUTE ADS64 = 0.
COMPUTE ADS65 = 0.
COMPUTE ADS66 = 0.
COMPUTE ADS67 = 0.
COMPUTE ADS68 = 0.
COMPUTE ADS69 = 0.
COMPUTE ADS70 = 0.
COMPUTE ADS71 = 0.
COMPUTE ADS72 = 0.
EXE.

FLIP VARIABLES=ADS1 ADS2 ADS3 ADS4 ADS5 ADS6 ADS7 ADS8 ADS9 ADS10 ADS11 ADS12 ADS13 ADS14 ADS15 
    ADS16 ADS17 ADS18 ADS19 ADS20 ADS21 ADS22 ADS23 ADS24 ADS25 ADS26 ADS27 ADS28 ADS29 ADS30 ADS31 
    ADS32 ADS33 ADS34 ADS35 ADS36 ADS37 ADS38 ADS39 ADS40 ADS41 ADS42 ADS43 ADS44 ADS45 ADS46 ADS47 
    ADS48 ADS49 ADS50 ADS51 ADS52 ADS53 ADS54 ADS55 ADS56 ADS57 ADS58 ADS59 ADS60 ADS61 ADS62 ADS63
    ADS64 ADS65 ADS66 ADS67 ADS68 ADS69 ADS70 ADS71 ADS72
  /NEWNAMES=Group.

DATASET NAME DS_TS.
DATASET ACTIVATE DS_TS.

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
   /AUXILIARY  CILEVEL=95 MAXACFLAGS=24
   /MISSING USERMISSING=EXCLUDE
   /MODEL DEPENDENT=Group1
      PREFIX='Model'
   /EXSMOOTH TYPE=WINTERSADDITIVE  TRANSFORM=NONE.

*Group 2 Forecast.
USE year 2011 month 6 THRU year 2016 month 5.

PREDICT THRU END.

TSMODEL
   /MODELSUMMARY  PRINT=[MODELFIT]
   /MODELSTATISTICS  DISPLAY=YES MODELFIT=[ SRSQUARE RSQUARE]
   /SERIESPLOT OBSERVED FORECAST FORECASTCI
   /OUTPUTFILTER DISPLAY=ALLMODELS
   /SAVE  PREDICTED(Predicted) LCL(LCL) UCL(UCL) NRESIDUAL(NResidual)
   /AUXILIARY  CILEVEL=90 MAXACFLAGS=24
   /MISSING USERMISSING=EXCLUDE
   /MODEL DEPENDENT=Group2 INDEPENDENT=YEAR_ MONTH_
      PREFIX='Model'
   /EXPERTMODELER TYPE=[ARIMA EXSMOOTH] TRYSEASONAL=YES
   /AUTOOUTLIER  DETECT=OFF.

*Group 3 Forecast.
USE year 2011 month 6 THRU year 2016 month 5.

PREDICT THRU END.

TSMODEL
   /MODELSUMMARY  PRINT=[MODELFIT]
   /MODELSTATISTICS  DISPLAY=YES MODELFIT=[ SRSQUARE RSQUARE]
   /SERIESPLOT OBSERVED FORECAST FIT FORECASTCI FITCI
   /OUTPUTFILTER DISPLAY=ALLMODELS
   /SAVE  PREDICTED(Predicted) LCL(LCL) UCL(UCL) NRESIDUAL(NResidual)
   /AUXILIARY  CILEVEL=95 MAXACFLAGS=24
   /MISSING USERMISSING=EXCLUDE
   /MODEL DEPENDENT=Group3
      PREFIX='Model'
   /EXSMOOTH TYPE=WINTERSADDITIVE  TRANSFORM=NONE.

*Group 4 Forecast.
USE year 2011 month 6 THRU year 2016 month 5.

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

DATASET CLOSE DS_TS.
DATASET CLOSE ADS.

*Aggregate the average daily Gcom sales by group.
DATASET ACTIVATE TS.

DATASET DECLARE AD_GCS.

AGGREGATE
  /OUTFILE='AD_GCS'
  /BREAK=Group
  /ADGCS1=SUM(ADGCS1) 
  /ADGCS2=SUM(ADGCS2) 
  /ADGCS3=SUM(ADGCS3) 
  /ADGCS4=SUM(ADGCS4) 
  /ADGCS5=SUM(ADGCS5) 
  /ADGCS6=SUM(ADGCS6) 
  /ADGCS7=SUM(ADGCS7) 
  /ADGCS8=SUM(ADGCS8) 
  /ADGCS9=SUM(ADGCS9) 
  /ADGCS10=SUM(ADGCS10) 
  /ADGCS11=SUM(ADGCS11) 
  /ADGCS12=SUM(ADGCS12) 
  /ADGCS13=SUM(ADGCS13) 
  /ADGCS14=SUM(ADGCS14) 
  /ADGCS15=SUM(ADGCS15) 
  /ADGCS16=SUM(ADGCS16) 
  /ADGCS17=SUM(ADGCS17) 
  /ADGCS18=SUM(ADGCS18) 
  /ADGCS19=SUM(ADGCS19) 
  /ADGCS20=SUM(ADGCS20) 
  /ADGCS21=SUM(ADGCS21) 
  /ADGCS22=SUM(ADGCS22) 
  /ADGCS23=SUM(ADGCS23) 
  /ADGCS24=SUM(ADGCS24) 
  /ADGCS25=SUM(ADGCS25) 
  /ADGCS26=SUM(ADGCS26) 
  /ADGCS27=SUM(ADGCS27) 
  /ADGCS28=SUM(ADGCS28) 
  /ADGCS29=SUM(ADGCS29) 
  /ADGCS30=SUM(ADGCS30) 
  /ADGCS31=SUM(ADGCS31) 
  /ADGCS32=SUM(ADGCS32) 
  /ADGCS33=SUM(ADGCS33) 
  /ADGCS34=SUM(ADGCS34) 
  /ADGCS35=SUM(ADGCS35) 
  /ADGCS36=SUM(ADGCS36) 
  /ADGCS37=SUM(ADGCS37) 
  /ADGCS38=SUM(ADGCS38) 
  /ADGCS39=SUM(ADGCS39) 
  /ADGCS40=SUM(ADGCS40) 
  /ADGCS41=SUM(ADGCS41) 
  /ADGCS42=SUM(ADGCS42) 
  /ADGCS43=SUM(ADGCS43) 
  /ADGCS44=SUM(ADGCS44) 
  /ADGCS45=SUM(ADGCS45) 
  /ADGCS46=SUM(ADGCS46) 
  /ADGCS47=SUM(ADGCS47) 
  /ADGCS48=SUM(ADGCS48) 
  /ADGCS49=SUM(ADGCS49) 
  /ADGCS50=SUM(ADGCS50) 
  /ADGCS51=SUM(ADGCS51) 
  /ADGCS52=SUM(ADGCS52) 
  /ADGCS53=SUM(ADGCS53) 
  /ADGCS54=SUM(ADGCS54) 
  /ADGCS55=SUM(ADGCS55) 
  /ADGCS56=SUM(ADGCS56) 
  /ADGCS57=SUM(ADGCS57) 
  /ADGCS58=SUM(ADGCS58) 
  /ADGCS59=SUM(ADGCS59) 
  /ADGCS60=SUM(ADGCS60)
  /N_BREAK=N.

DATASET ACTIVATE AD_GCS.

*Create variables for forecast values.
COMPUTE ADGCS61 = 0.
COMPUTE ADGCS62 = 0.
COMPUTE ADGCS63 = 0.
COMPUTE ADGCS64 = 0.
COMPUTE ADGCS65 = 0.
COMPUTE ADGCS66 = 0.
COMPUTE ADGCS67 = 0.
COMPUTE ADGCS68 = 0.
COMPUTE ADGCS69 = 0.
COMPUTE ADGCS70 = 0.
COMPUTE ADGCS71 = 0.
COMPUTE ADGCS72 = 0.
EXE.

FLIP VARIABLES=ADGCS1 ADGCS2 ADGCS3 ADGCS4 ADGCS5 ADGCS6 ADGCS7 ADGCS8 ADGCS9 ADGCS10 ADGCS11 ADGCS12 ADGCS13 ADGCS14 ADGCS15 
    ADGCS16 ADGCS17 ADGCS18 ADGCS19 ADGCS20 ADGCS21 ADGCS22 ADGCS23 ADGCS24 ADGCS25 ADGCS26 ADGCS27 ADGCS28 ADGCS29 ADGCS30 ADGCS31 
    ADGCS32 ADGCS33 ADGCS34 ADGCS35 ADGCS36 ADGCS37 ADGCS38 ADGCS39 ADGCS40 ADGCS41 ADGCS42 ADGCS43 ADGCS44 ADGCS45 ADGCS46 ADGCS47 
    ADGCS48 ADGCS49 ADGCS50 ADGCS51 ADGCS52 ADGCS53 ADGCS54 ADGCS55 ADGCS56 ADGCS57 ADGCS58 ADGCS59 ADGCS60 ADGCS61 ADGCS62 ADGCS63
    ADGCS64 ADGCS65 ADGCS66 ADGCS67 ADGCS68 ADGCS69 ADGCS70 ADGCS71 ADGCS72
  /NEWNAMES=Group.

DATASET NAME DGCS_TS.
DATASET ACTIVATE DGCS_TS.

RENAME VARIABLES K_1 = Group1 K_2 = Group2 K_3 = Group3 K_4 = Group4.

DATE M 6 12 Y 2011.

*Group 1 Forecast.
USE year 2011 month 6 THRU year 2016 month 5.

PREDICT THRU END.

TSMODEL
   /MODELSUMMARY  PRINT=[MODELFIT]
   /MODELSTATISTICS  DISPLAY=YES MODELFIT=[ SRSQUARE RSQUARE]
   /SERIESPLOT OBSERVED FORECAST FORECASTCI
   /OUTPUTFILTER DISPLAY=ALLMODELS
   /SAVE  PREDICTED(Predicted) LCL(LCL) UCL(UCL) NRESIDUAL(NResidual)
   /AUXILIARY  CILEVEL=90 MAXACFLAGS=24
   /MISSING USERMISSING=EXCLUDE
   /MODEL DEPENDENT=Group1 INDEPENDENT=YEAR_ MONTH_
      PREFIX='Model'
   /EXPERTMODELER TYPE=[ARIMA EXSMOOTH] TRYSEASONAL=YES
   /AUTOOUTLIER  DETECT=OFF.

*Group 2 Forecast.
USE year 2011 month 6 THRU year 2016 month 5.

PREDICT THRU END.

TSMODEL
   /MODELSUMMARY  PRINT=[MODELFIT]
   /MODELSTATISTICS  DISPLAY=YES MODELFIT=[ SRSQUARE RSQUARE]
   /SERIESPLOT OBSERVED FORECAST FORECASTCI
   /OUTPUTFILTER DISPLAY=ALLMODELS
   /SAVE  PREDICTED(Predicted) LCL(LCL) UCL(UCL) NRESIDUAL(NResidual)
   /AUXILIARY  CILEVEL=90 MAXACFLAGS=24
   /MISSING USERMISSING=EXCLUDE
   /MODEL DEPENDENT=Group2 INDEPENDENT=YEAR_ MONTH_
      PREFIX='Model'
   /EXPERTMODELER TYPE=[ARIMA EXSMOOTH] TRYSEASONAL=YES
   /AUTOOUTLIER  DETECT=OFF.

*Group 3 Forecast.
USE year 2011 month 6 THRU year 2016 month 5.

PREDICT THRU END.

TSMODEL
   /MODELSUMMARY  PRINT=[MODELFIT]
   /MODELSTATISTICS  DISPLAY=YES MODELFIT=[ SRSQUARE RSQUARE]
   /SERIESPLOT OBSERVED FORECAST FORECASTCI
   /OUTPUTFILTER DISPLAY=ALLMODELS
   /SAVE  PREDICTED(Predicted) LCL(LCL) UCL(UCL) NRESIDUAL(NResidual)
   /AUXILIARY  CILEVEL=90 MAXACFLAGS=24
   /MISSING USERMISSING=EXCLUDE
   /MODEL DEPENDENT=Group3 INDEPENDENT=YEAR_ MONTH_
      PREFIX='Model'
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
   /AUXILIARY  CILEVEL=90 MAXACFLAGS=24
   /MISSING USERMISSING=EXCLUDE
   /MODEL DEPENDENT=Group4 INDEPENDENT=YEAR_ MONTH_
      PREFIX='Model'
   /EXPERTMODELER TYPE=[ARIMA EXSMOOTH] TRYSEASONAL=YES
   /AUTOOUTLIER  DETECT=OFF.

DATASET CLOSE DGCS_TS.
DATASET CLOSE AD_GCS.

DATASET ACTIVATE TS.

