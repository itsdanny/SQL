/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [uid]
      ,[description]
      ,[datasource]
      ,[sqltext]
      ,[objectlist]
  FROM [Forms].[dbo].[dataquery]


use Forms
USE [Forms]
GO

SELECT *  FROM [dbo].[datasources]
GO


select * from dataquerypreupdate 
select * from dataquery 

update dataquery set datasource = 2 where datasource = 4
update dataquery set datasource = 2 where datasource = 4 and uid < 28