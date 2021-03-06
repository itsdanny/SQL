/****** Script for SelectTopNRows command from SSMS  ******/
SELECT *
  FROM [mfdata].[dbo].[TMSCLK]
  where EMPREF in ('0727')
  order by CLKDT desc

  -- 7002','7006','3076','7009','0689','0586','7018','7023','0727'
  
  -- 0689 2012-07-23 11:17:28.000
  -- 0586 2014-12-18 13:28:46.000
  -- 0727 2014-12-19 13:36:08.000

  SELECT TOP 1 CLKDT FROM TMSCLK WHERE EMPREF = '0689' AND DIR  = 'O' ORDER BY CLKDT 