DECLARE @LeadTimeFactor FLOAT= (SELECT ROUND(SQRT(3),4))
DECLARE @LeadTimeDays	INT = 3
DECLARE @Branch			VARCHAR(6) = 'B1'
DECLARE @ServiceLevel	FLOAT = 0.9

DECLARE @Sales TABLE(Id INT IDENTITY(1,1), SKU VARCHAR(20), BranchStock INT DEFAULT(0), Sales21 INT DEFAULT(0), Forecast INT DEFAULT(0), SalesDeviation FLOAT)
INSERT INTO @Sales(SKU, BranchStock, Sales21, SalesDeviation)
SELECT	ProductCode, 
		MAX(StoreStock) AS StoreStock,
		SUM(TotalDaysSales) AS TotalDaysSales,	
		STDEVP(TotalDaysSales) AS TotalDaysSales				
					
FROM	
(SELECT	ProductCode, 
		(dbo.fn_store_stock_level(ProductCode, BranchCode)) AS StoreStock, 
		(Quantity) TotalDaysSales				
FROM	IMPDailySalesInformation l
WHERE	BranchCode = @Branch
AND		CONVERT(date, TransactionDate) > GETDATE()-21
UNION 
SELECT	ProductCode, 
		(dbo.fn_store_stock_level(ProductCode, BranchCode)) AS StoreStock, 
		(Quantity) TotalDaysSales
FROM	VapeConnectTest.dbo.IMPDailySalesInformation l
WHERE	BranchCode = @Branch
AND		CONVERT(date, TransactionDate) > GETDATE()-21
) res
--WHERE		ProductCode = 'AC-CL-CLE-100'
GROUP BY ProductCode


UPDATE		s
SET			s.Forecast = r.TotalDaysSales
FROM		
(SELECT	ProductCode, 		
		AVG(Quantity) TotalDaysSales				
FROM	IMPDailySalesInformation l
WHERE	BranchCode = @Branch
AND		CONVERT(date, TransactionDate) > GETDATE()-7
GROUP BY ProductCode
UNION 
SELECT	ProductCode, 		
		AVG (Quantity) TotalDaysSales
FROM	VapeConnectTest.dbo.IMPDailySalesInformation l
WHERE	BranchCode = @Branch
AND		CONVERT(date, TransactionDate) > GETDATE()-7
GROUP BY ProductCode
) r
INNER JOIN 	@Sales s
ON			r.ProductCode = s.SKU


/*
DECLARE @Row INT = 1, @Rows INT

SET @Rows = (SELECT COUNT(1) FROM @Sales)

WHILE @Row <= @Rows
BEGIN
	

SET @Row = @Row + 1
END
*/
SELECT	SKU, BranchStock, Sales21, Forecast [Avg Last 7 days Sales], 
		CEILING((SalesDeviation+@ServiceLevel+SQRT(@LeadTimeDays))+Forecast) AS PredictatedOrderQty
FROM	@Sales ORDER BY SKU

