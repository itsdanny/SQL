alter procedure sp_MAT_Mape
@BrandManagerId	INT = NULL,
@BrandId		INT = NULL
as

WITH ForecastData (BrandManager, Brand, ProductName, ProductCode, ForecastTypeId, Qty, Year, Period)
AS
(
       SELECT       BrandManager.Name, Brand.Name, Product.Description, Forecast.ProductCode, Forecast.ForecastTypeId, Forecast.Qty, Period.Year, Period.Period
       FROM         Forecast 
	   INNER JOIN   Period 
	   ON			Forecast.PeriodId = Period.Id
	   INNER JOIN   BrandProduct 
	   ON			Forecast.ProductCode = BrandProduct.ProductCode
	   INNER JOIN   Brand
	   ON			Brand.Id = BrandProduct.BrandId
	   INNER JOIN   Product 
	   ON			Forecast.ProductCode = Product.ProductCode
	   INNER JOIN   BrandManagerProduct 
	   ON			BrandManagerProduct.ProductCode = Forecast.ProductCode
	   INNER JOIN   BrandManager
	   ON			BrandManager.Id = BrandManagerProduct.BrandManagerId
       WHERE        (Forecast.ForecastTypeId = 1)
	   AND			Period.Id in (SELECT TOP 3 Id FROM Period WHERE Year = DATEPART(YEAR, GETDATE()) AND Period < DATEPART(MONTH, GETDATE()) ORDER BY Id DESC)
	   AND			(@BrandManagerId IS NULL OR BrandManager.Id = @BrandManagerId)
	   AND			(@BrandId IS NULL OR Brand.Id = @BrandId)
),
SalesData (BrandManager, Brand, ProductName, ProductCode, ForecastTypeId, Qty, Year, Period)
AS
(
       SELECT       BrandManager.Name,Brand.Name, Product.Description, Forecast.ProductCode, Forecast.ForecastTypeId, Forecast.Qty, Period.Year, Period.Period
       FROM         Forecast 
	   INNER JOIN   Period 
	   ON			Forecast.PeriodId = Period.Id
	   INNER JOIN   BrandProduct 
	   ON			Forecast.ProductCode = BrandProduct.ProductCode
	   INNER JOIN   Brand
	   ON			Brand.Id = BrandProduct.BrandId
	   INNER JOIN   Product 
	   ON			Forecast.ProductCode = Product.ProductCode
	   INNER JOIN   BrandManagerProduct 
	   ON			BrandManagerProduct.ProductCode = Forecast.ProductCode
	   INNER JOIN   BrandManager
	   ON			BrandManager.Id = BrandManagerProduct.BrandManagerId
       WHERE        (Forecast.ForecastTypeId = 3)
	   AND			Period.Id in (SELECT TOP 3 Id FROM Period WHERE Year = DATEPART(YEAR, GETDATE()) AND Period < DATEPART(MONTH, GETDATE()) ORDER BY Id DESC)
   	   AND			(@BrandManagerId IS NULL OR BrandManager.Id = @BrandManagerId)
	   AND			(@BrandId IS NULL OR Brand.Id = @BrandId)
)

SELECT 	ForecastData.BrandManager,
		ForecastData.Brand,
		ForecastData.ProductName,
        ForecastData.ProductCode,
        ForecastData.Year, 
	    ForecastData.Period,
        SalesData.Qty AS SalesQty, 
	    ForecastData.Qty AS ForecastQty,
	    ROUND(CASE	WHEN SalesData.Qty = 0 AND ForecastData.Qty > 0 THEN -1.0
					WHEN SalesData.Qty < 0 AND ForecastData.Qty > 0 THEN  (CAST(SalesData.Qty AS MONEY)-ForecastData.Qty)/ForecastData.Qty
					WHEN SalesData.Qty > 0 AND ForecastData.Qty = 0 THEN  1.0
					WHEN SalesData.Qty > 0 AND ForecastData.Qty > 0 THEN  (CAST(SalesData.Qty AS MONEY)-ForecastData.Qty)/ForecastData.Qty
			END, 3) as Variance INTO #Results
FROM		ForecastData 
INNER JOIN	SalesData 
ON			ForecastData.ProductCode = SalesData.ProductCode 
AND			ForecastData.Year = SalesData.Year 
AND			ForecastData.Period = SalesData.Period
ORDER by	ForecastData.ProductCode, ForecastData.Year

--select * from #Results

SELECT		BrandManager, Brand, ProductName, a.ProductCode, a.ForecastQty, a.SalesQty, a.Variance, 
			DATENAME(MONTH, CONVERT(DateTime, '2012-' + cast(Period as varchar)+'-01')) AS [MonthName], 
			a.Period,
			CASE WHEN a.ForecastQty = 0 THEN 'DISCONTINUED?' WHEN a.SalesQty = 0 THEN 'OUT OF STOCK?' END AS StockIssue,			
			CASE WHEN a.ForecastQty > 0 OR  a.SalesQty > 0 THEN ROUND((SELECT AVG(CASE WHEN b.Variance < 0 THEN b.Variance *-1 ELSE b.Variance END) FROM #Results b WHERE a.ProductCode = b.ProductCode GROUP BY b.ProductCode), 3) ELSE 1 END AS SKUMAPE  
FROM		#Results a 
GROUP BY	BrandManager, Brand, ProductName, a.ProductCode, a.ForecastQty, a.SalesQty, a.period, a.Year, a.Variance
ORDER BY	BrandManager, Brand, a.ProductCode, Period

go

--
exec sp_MAT_Mape null, 3

