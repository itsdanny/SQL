/****** Script for SelectTopNRows command from SSMS  ******/
SELECT  [BNF_CODE]
      ,[BNF_Name]
      
  FROM [GPData].[dbo].[BNFProducts] with (NOLOCK)

 Group by BNF_CODE,[BNF_Name]
  Having COUNT(BNF_CODE) > 1