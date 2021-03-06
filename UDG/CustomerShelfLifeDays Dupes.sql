/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [Id]
      ,[ProductCode]
      ,[ProductDescription]
      ,[CustomerCode]
      ,[ShelfLifeMonths]
      ,[warehouse]
  FROM [Integrate].[dbo].[CustomerShelfLife]
  WHERE CustomerCode = 'T074530'
  and ProductCode ='019143'

  select CustomerCode, ProductCode, ProductDescription, CustomerCode, ShelfLifeMonths, warehouse FROM [Integrate].[dbo].[CustomerShelfLife]
  --drop table  #temp
  --select distinct ProductCode, ProductDescription, CustomerCode, ShelfLifeMonths, warehouse into #temp FROM [Integrate].[dbo].[CustomerShelfLife]
  --delete from [CustomerShelfLife]
  --insert into [CustomerShelfLife] select * from #temp

SELECT		CustomerCode, ProductCode, count('v') 
FROM		[Integrate].[dbo].[CustomerShelfLife]
GROUP BY CustomerCode, ProductCode
HAVING count(ProductCode) > 1
ORDER BY CustomerCode, ProductCode



