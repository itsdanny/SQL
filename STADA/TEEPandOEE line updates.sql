/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [Line]
      ,[SageRef]
      ,[Shifts]
      ,[Speed]
      ,[OEEMonth]
      ,[OEEValue]
  FROM [StadaFactBook].[dbo].[BottlesOEE]

update [StadaFactBook].[dbo].[BottlesOEE] set SageRef = 'HP03' WHERE SageRef = 'HP10'


/****** Script for SelectTopNRows command from SSMS  ******/
SELECT *  FROM [StadaFactBook].[dbo].[BottlesTEEP]
update [StadaFactBook].[dbo].[BottlesTEEP] set SageRef = 'HP03' WHERE SageRef = 'HP10'
update [StadaFactBook].[dbo].[BottlesTEEP] set SageRef = 'CS02' WHERE SageRef = 'CSO2'
