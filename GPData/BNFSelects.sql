/****** Script for SelectTopNRows command from SSMS  ******/
SELECT *  FROM [GPData].[dbo].[BNFProducts] p where ZeroCompareBrandId is not null order by ZeroCompareBrandId
SELECT *  FROM [GPData].[dbo].[BNFProducts] p where BNFBrandId in(SELECT ZeroCompareBrandId FROM [GPData].[dbo].[BNFProducts] p where ZeroCompareBrandId is not null)

SELECT *  FROM [GPData].[dbo].[BNFProducts] p where ZeroCompareBNFCode is not null

SELECT *  FROM [GPData].[dbo].[BNFProducts] p where ZeroCompareBNFCode = BNF_CODE


SELECT *  FROM [GPData].[dbo].[BNFProducts] p where UPPER(BNF_Name) like '%ZERO%'
  /*SELECT *
  FROM [GPData].[dbo].[BNFProducts] p
  INNER JOIN BNFBrand b
  ON		p.BNFBrandId = b.Id
  where Type = 5
  and TROwnProduct = 1


  /****** Script for SelectTopNRows command from SSMS  ******/
update p
	set p.TROwnProduct = null
  FROM [GPData].[dbo].[BNFProducts] p
  INNER JOIN BNFBrand b
  ON		p.BNFBrandId = b.Id
  where Type = 5

  update p
	set p.TROwnProduct = 1
  FROM [GPData].[dbo].[BNFProducts] p
  INNER JOIN BNFBrand b
  ON		p.BNFBrandId = b.Id
  where Type = 5
  and b.Brand in ('Accrete D3 Tablets', 'Fultium D3 Capsule')*/