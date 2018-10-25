  SELECT  sum(cast([NIC] as  numeric(9,2))) as NICTotalFMay2014_Emollient
  FROM [GPData].[dbo].vw_PracticeDataWithCountries
  WHERE CountryId = 1 and [BNF_NAME] like 'Cetraben_Emollient Crm%' and [PERIOD] = '201405'
  
      SELECT  sum(cast([NIC] as  numeric(9,2))) as NICTotalMay2014_Lotion200ml
  FROM [GPData].[dbo].vw_PracticeDataWithCountries
  WHERE CountryId = 1 and [BNF_NAME] like 'Cetraben Lot 200ml%' and [PERIOD] = '201405'
  
      SELECT  sum(cast([NIC] as  numeric(9,2))) as NICTotalMay2014_Lotion500ml
  FROM [GPData].[dbo].vw_PracticeDataWithCountries
  WHERE CountryId = 1 and [BNF_NAME] like 'Cetraben Lot 500ml%' and [PERIOD] = '201405'
  
    SELECT  sum(cast([NIC] as  numeric(9,2))) as NICTotalMay2014_BathOil
  FROM [GPData].[dbo].vw_PracticeDataWithCountries
  WHERE CountryId = 1 and [BNF_NAME] like 'Cetraben_Bath Oil%' and [PERIOD] = '201405'
  
  
      SELECT  sum(cast([NIC] as  numeric(9,2))) as NICTotalMay2014_Paraffin
  FROM [GPData].[dbo].vw_PracticeDataWithCountries
  WHERE CountryId = 1 and [BNF_NAME] = 'Liq Paraf/Wte Soft Paraf_Crm 10.5%/13.2%' and [PERIOD] = '201405'
  
      SELECT  sum(cast([NIC] as  numeric(9,2))) as NICTotalMay2014_AllCetraben
  FROM [GPData].[dbo].vw_PracticeDataWithCountries
  WHERE CountryId = 1 and lower([BNF_NAME]) like 'cetraben%'  and [PERIOD] = '201405'
  
  select distinct(BNF_NAME)
    FROM [GPData].[dbo].vw_PracticeDataWithCountries
  WHERE CountryId = 1 and lower([BNF_NAME]) like 'cetraben%'  and [PERIOD] = '201405'