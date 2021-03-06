/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [Period]
      ,[Code]
      ,[CountryId]
      ,[Name]
      ,[Address1]
      ,[Address2]
      ,[Address3]
      ,[Address4]
      ,[PostCode]
      ,[CCGCode]
  FROM [GPData].[dbo].[Practice]
  where CCGCode Is Null or CCGCode not in
  (select Code from CCGLookup)
  order by PostCode