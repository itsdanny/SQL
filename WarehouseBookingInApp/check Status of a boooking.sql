/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [BookingPOID]
      ,[BookingNumber]
      ,[PurchaseOrder]
  FROM [syslive].[dbo].[WBI_BookingPO]
  where PurchaseOrder in('064359')
  -- 41 pallets arrived
   SELECT * 
  FROM [syslive].[dbo].[WBI_Booking]
  WHERE BookingNumber IN (7516)
  
  -- CHANGE IT BACK TO RED
  UPDATE [syslive].[dbo].[WBI_Booking]
  SET	ArrivalDateTime = SlotStartTime,
		--PalletsArrived = 0,
		--ArrivalTakenBy = 'warehouse',
		BookingArrived = 0		
  WHERE BookingNumber in (7516)
  /*
  UPDATE [syslive].[dbo].[WBI_Booking]
  SET	ArrivalDateTime = '2014-03-31 14:53:00.000',
		PalletsExpected = 0,
		ArrivalTakenBy = 'warehouse',
		BookingArrived = 0		
  WHERE BookingID = 3115*/



  select * from 
  WBI_Booking
  where BookingID in (3965,3974)
  
  SELECT TOP 1000 [BookingPOID]
      ,[BookingNumber]
      ,[PurchaseOrder]
  FROM [syslive].[dbo].[WBI_BookingPO]
  --where PurchaseOrder in('051917','052060')
  where BookingNumber in (3961,3970)