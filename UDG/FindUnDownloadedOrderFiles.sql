/****** Script for SelectTopNRows command from SSMS  ******/
SELECT prim.[Id]
      ,prim.[LogMessage]
      ,prim.[LogFile]
      ,prim.[LogDateTime]
      ,prim.[ProcessDirection]
      ,prim.[OtherInfo]
  FROM [Integrate].[dbo].[Log] prim
  where prim.LogMessage = 'Retrieving Inbound File: ' and prim.LogFile like 'OrderConfirm%' 
  and ltrim(rtrim(prim.LogFile)) not in
  (select ltrim(rtrim(replace(sec.LogFile,'C:\Integrate\Inbound\',''))) from [Integrate].[dbo].[Log] sec where sec.LogMessage = 'Processing Inbound file: ' and ltrim(rtrim(replace(sec.LogFile,'C:\Integrate\Inbound\',''))) = ltrim(rtrim(prim.LogFile)))