DECLARE @dt VARCHAR(10) = '2017-10-15'

--INSERT INTO [VapeConnectTest].[dbo].IMPDailySalesInformation
SELECT		BranchCode, TransactionDate, DailyDiscountValue, DailyCardValue, DailyCashValue, DailyPettyCashValue, ProductCode, Quantity, Value, LineDiscount, 0, null
FROM		[VapeConnect].[dbo].IMPDailySalesInformation
WHERE		TransactionDate = @dt
AND			BranchCode ='B1'

--INSERT INTO [VapeConnectTest].[dbo].[IMPDailyRefundExchanges]
SELECT		BranchCode, TransactionDate, DailyDiscountValue, ProductCode, Quantity, Value, TransactionType, ReasonCode, LineDiscount, 0, null
FROM		[VapeConnect].[dbo].[IMPDailyRefundExchanges]
WHERE		TransactionDate = @dt
AND			BranchCode ='B1'



SELECT	*
FROM		[VapeConnect].[dbo].IMPDailySalesInformation WHERE		TransactionDate ='2017-09-21'
AND	BranchCode ='A1'
union
SELECT	*
FROM		[VapeConnectTest].[dbo].IMPDailySalesInformation WHERE		TransactionDate ='2017-09-21'
AND	BranchCode ='A1'
ORDER BY	8

UPDATE 	[VapeConnectTest].[dbo].IMPDailySalesInformation
SET Processed = 0, ProcessedDateTime = NULL
 WHERE		TransactionDate ='2017-09-21' 
AND	BranchCode ='B1'
 
 UPDATE 	SYSTaskSchedule SET Active = 0 WHERE		ServiceId >80 AND	Active = 0