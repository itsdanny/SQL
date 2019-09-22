DECLARE @Refunds TABLE(BranchCode VARCHAR(20), TransactionDate DATE, DailyDiscountValue FLOAT, ProductCode VARCHAR(30), Quantity INT, SUMQuantity INT, SalesValue FLOAT, SUMSalesValue FLOAT, TransactionType VARCHAR(50), ReasonCode VARCHAR(2000), LineDiscount FLOAT)

INSERT INTO @Refunds
SELECT	   BranchCode, TransactionDate, DailyDiscountValue, ProductCode, AVG(Quantity), SUM(Quantity) AS SUMQuantity, AVG(Value), SUM(Value), TransactionType, ReasonCode, LineDiscount
FROM		VapeConnect.dbo.IMPDailyRefundExchanges
WHERE		TransactionDate = '2019-08-05' 
--AND			BranchCode = 'G1'
GROUP BY	BranchCode, TransactionDate, DailyDiscountValue, ProductCode, TransactionType, ReasonCode, LineDiscount
ORDER BY	ProductCode 


SELECT	*
FROM		@Refunds
WHERE		Quantity <> SUMQuantity
ORDER BY	TransactionDate , BranchCode  

SELECT	BranchCode, TransactionDate, DailyDiscountValue, ProductCode, Quantity, Value,  TransactionType, ReasonCode, LineDiscount, ProcessedDateTime
FROM		VapeConnect.dbo.IMPDailyRefundExchanges
WHERE		TransactionDate = '2019-08-05' 
--AND			BranchCode = 'G1'
ORDER BY	 BranchCode, ProductCode 