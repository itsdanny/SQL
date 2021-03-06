/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [Id]
      ,[BranchCode]
      ,[ParentCategoryCode]
      ,[CategoryCode]
      ,[ProductName]
      ,[ProductDescription]
      ,[ProductCode]
      ,[BarCode]
      ,[UnitPrice]
      ,[CostPrice]
      ,[IsHotProduct]
      ,[VAT]
      ,[PackSize]
      ,[Discontinued]
      ,[Action]
      ,[Processed]
      ,[ProcessedDateTime]
  FROM [VapeConnectTest].[dbo].[EXPProductInformation] 
  where ProductCode in ('EJ-DT-00','EJ-DT-06','EJ-DT-12','EJ-DT-18','EJ-DT-24')
  order by ProcessedDateTime desc


  select * from SYSTaskSchedule