/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [EMPREF]
      ,[CLKDT]
      ,[CLKTYPE]
      ,[UNIQUEKEY]
      ,[USED]
      ,[CLKDATE]
      ,[CLKTIME]
      ,[DIR]
      ,[LATITUDE]
      ,[LONGITUDE]
      ,[ORIGINAL]
      ,[PARAMS]
      ,[QUAL]
      ,[RESTRICTED]
      ,[TERMNO]
  FROM [mfdata].[dbo].[TMSCLK]
  where EMPREF ='0598'
  and CLKDT > '2014-06-19 17:16:18.583'
  --	2014-06-20 17:16:18.583	
  --	2014-06-23 13:19:46.970