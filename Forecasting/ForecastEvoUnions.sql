--select * from Period 

DECLARE @MAXDATE DATE = (SELECT DATEADD(MONTH, -3, CAST(MAX(SnapShotDate) AS DATE)) FROM [Forecasting].[dbo].[ForecastEvolution])
DECLARE @Mnth INT = DATEPART(MONTH, @MAXDATE)

IF @Mnth = 12
BEGIN
	SELECT		DISTINCT f.SnapShotDate, f.ProductCode, 
				P12 AS ForecastQty, p.Period, f.ForecastTypeId 						
	FROM		ForecastEvolution f, 
				Period  p
	WHERE		CAST(SnapShotDate AS DATE) = @MAXDATE	
	AND			p.Period = @Mnth
	AND			p.Year = DATEPART(YEAR, @MAXDATE)
	UNION ALL
	SELECT		DISTINCT SnapShotDate, ProductCode, 
				P1 AS ForecastQty, 
				p.Period, f.ForecastTypeId 						
	FROM		ForecastEvolution f, 
				Period  p
	WHERE		CAST(SnapShotDate AS DATE) = DATEADD(MONTH, 1, @MAXDATE)
	AND			p.Period = 1	
	AND			p.Year = DATEPART(YEAR, DATEADD(MONTH, 1, @MAXDATE))
	UNION ALL
	SELECT		DISTINCT f.SnapShotDate, ProductCode, 
				P2 AS ForecastQty, p.Period, f.ForecastTypeId 						
	FROM		ForecastEvolution f, 
				Period  p
	WHERE		CAST(SnapShotDate AS DATE) = DATEADD(MONTH, 2, @MAXDATE)
	AND			p.Period = 2
	AND			p.Year = DATEPART(YEAR, DATEADD(MONTH, 2, @MAXDATE))
	ORDER BY	ProductCode, f.ForecastTypeId, SnapShotDate
END


