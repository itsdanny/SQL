/****** Script for SelectTopNRows command from SSMS  ******/
SELECT SUM(NIC)  FROM [GPData].[dbo].[PracticeDataArchive] where BNF_CODE in(select BNF_CODE from [dbo].[BNFProducts] WHERE BNF_CODE LIKE '130201%')
and DATEPART(YEAR, PERIODDATE) = 2011



SELECT SUM(NIC)  FROM [GPData].[dbo].[PracticeDataArchive] where BNF_CODE in(select BNF_CODE from [dbo].[BNFProducts] WHERE upper(BNF_Name) like 'CETRABEN%')
and DATEPART(YEAR, PERIODDATE) = 2011

  -- cetreban
  -- emoliants

  select * from [dbo].[BNFProducts] WHERE BNF_CODE LIKE '130201%'
  

  select * from [dbo].[BNFProducts] WHERE upper(BNF_Name) like 'CETRABEN%'
