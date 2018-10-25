-- Integrate and Pre-Advice to UDG
/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [Id]
      ,[Warehouse]
      ,[Product]
      ,[PONumber]
      ,[LineId]
      ,[Description]
      ,[Qty]
      ,[UOM]
      ,[Processed]
      ,[DateProcessed]
      ,[CutOverStock]
  FROM [Integrate].[dbo].[ThirdPartyPurchaseOrder]
  where PONumber = '057550'
  
  select * from scheme.podetm where order_no = '057550'