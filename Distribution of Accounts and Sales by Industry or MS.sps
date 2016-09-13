*Open the file containing the historical metric values we would like to validate.
GET FILE = '/usr/spss/userdata/Albrecht/PPC Geo/Sales and Transaction History by Account.sav'.
CACHE.
EXE.

DATASET NAME ACCTS.
DATASET ACTIVATE ACCTS.

/*LOOK AT THE TOTAL AND DAILY SALES/TRANS TRENDS FOR THE TEST AND CONTROL MARKETS*/.

*Select only accounts with sales history and in the DMAs we have selected for test and control markets.
DATASET COPY SA.
DATASET ACTIVATE SA.

SELECT IF(Has_Sales >= 1 AND ANY(DMA,'ERIE','PEORIA - BLOOMINGTON','BIRMINGHAM (ANN & TUSC)','KNOXVILLE','FARGO - VALLEY CITY','LAS VEGAS',
                                                                  'AUGUSTA - AIKEN','SPRINGFIELD - HOLYOKE','FRESNO - VISALIA','LEXINGTON','JACKSON, MS','MADISON',
                                                                  'BLUEFIELD - BECKLEY - OAK HILL','FT- SMITH - FAY - SPRNGDL - RG','RICHMOND - PETERSBURG', 
                                                                  'GREENSBORO - H- POINT - W- SAL','LA CROSSE - EAU CLAIRE','TUCSON (SIERRA VISTA)',
                                                                  'DAVENPORT - R- ISLAND - MOLINE','YOUNGSTOWN','LANSING','GREENVLL - SPART - ASHEVLL - A','OMAHA','SIOUX CITY')).


*Flag the group to which each account belongs.
COMPUTE Group = 0.
IF(ANY(DMA,'ERIE','PEORIA - BLOOMINGTON','BIRMINGHAM (ANN & TUSC)','KNOXVILLE','FARGO - VALLEY CITY','LAS VEGAS')) Group = 1.
IF(ANY(DMA, 'AUGUSTA - AIKEN','SPRINGFIELD - HOLYOKE','FRESNO - VISALIA','LEXINGTON','JACKSON, MS','MADISON')) Group = 2.
IF(ANY(DMA,'BLUEFIELD - BECKLEY - OAK HILL','FT- SMITH - FAY - SPRNGDL - RG','RICHMOND - PETERSBURG', 
                    'GREENSBORO - H- POINT - W- SAL','LA CROSSE - EAU CLAIRE','TUCSON (SIERRA VISTA)')) Group = 3.
IF(ANY(DMA, 'DAVENPORT - R- ISLAND - MOLINE','YOUNGSTOWN','LANSING','GREENVLL - SPART - ASHEVLL - A','OMAHA','SIOUX CITY')) Group = 4.
FORMATS Group(F1.0).
EXE.

FREQ Group.

*Open the model file to get 12M sales and the market segment.
GET FILE = '/usr/spss/userdata/model_files/201602_Feb_merged_model_file.sav'
   /KEEP account SALES12X market_segment.
CACHE.
EXE.

DATASET NAME AF.

MATCH FILES
   /FILE = *
   /TABLE = 'AF'
   /BY account.
EXE.

MEANS SALES12X BY Group BY market_segment
   /CELLS SUM COUNT.


