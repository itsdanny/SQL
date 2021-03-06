/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [BookingID]
      ,[BookingNumber]
      ,[BookingDateTime]
      ,[BookingTakenBy]
      ,[SlotStartTime]
      ,[SupplierNumber]
      ,[SupplierName]
      ,[SupplierAlpha]
      ,[PalletsExpected]
      ,[PalletsArrived]
      ,[ArrivalDateTime]
      ,[ArrivalTakenBy]
      ,[BookingArrived]
      ,[StatusID]
      ,[Comments]
      ,[TypeID]
      ,[Location]
      ,[Spare1]
      ,[Spare2]
      ,[Spare3]
      ,[Spare4]
      ,[Spare5]
  FROM [syslive].[dbo].[WBI_Booking]
   where SupplierName like 'IMCD%'
  order by SupplierName
  
  -- BookingDateTime > '2014-09-17 00:00:00' and BookingDateTime < '2014-09-21 00:00:00'