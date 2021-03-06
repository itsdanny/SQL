/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [BNF_CODE]
      ,[BNF_Name]
      ,[CountAs]
      ,[Type]
      ,[BNFBrandId]
      ,[NHSPrice]
      ,[ZeroProduct]
      ,[ZeroCompareBNFCode]
      ,[ZeroPercent]
      ,[TROwnProduct]
      ,[SubCategory]
      ,[ZeroCompareBrandId]
  FROM [GPData].[dbo].[BNFProducts] where UPPER(BNF_Name) like '%CALCICHEW%'
  or UPPER(BNF_Name) like '%FORTE%'
  or UPPER(BNF_Name) like '%ADCAL%'
  or UPPER(BNF_Name) like '%CALCEOS%'
  order by BNF_Name
select * from BNFBrand order by Brand

  SELECT BNF_CODE, BNF_NAME, count(1) FROM PracticeData where BNF_CODE in ('0906040G0BNADCD','0906040G0BNACCB','0906040G0BNABCA','0906040G0BNAABY','0906040G0BQAABW','0906040G0BRABBW','0906040G0BRACCC','0906040G0BRAABU','0906040G0CCAACF','0906040G0CCAACM')
  GROUP BY BNF_CODE, BNF_NAME
  
select top 1 * from scheme.stockm where dated < getdate() order by dated desc

update  [GPData].[dbo].[BNFProducts] set Type = 5, BNFBrandId = 355, SubCategory = 'Vitamins'
where UPPER(BNF_Name) like '%FORTE%'
  or UPPER(BNF_Name) like '%FORTE%'
  or UPPER(BNF_Name) like '%ADCAL%'
  or UPPER(BNF_Name) like '%CALCEOS%'
  

