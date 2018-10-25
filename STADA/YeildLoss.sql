DECLARE @LastMonthStart DateTime 
DECLARE @LastMonthEnd DateTime 
SELECT	@LastMonthStart = CAST(DATEPART(YEAR, DATEADD(MONTH, -1, GETDATE())) AS VARCHAR) + '-' + CAST(DATEPART(MONTH, DATEADD(MONTH, -1, GETDATE())) AS VARCHAR) + '-01 00:00:00'
SELECT	@LastMonthEnd = DATEADD(DAY, -1, DATEADD(MONTH, 1, @LastMonthStart))

SELECT	warehouse, product_code, SUM(quantity_required) AS quantity_required, SUM(quantity_finished) AS quantity_finished
FROM	scheme.bmwohm 
WHERE	completion_date between @LastMonthStart and @LastMonthEnd
GROUP BY warehouse, product_code

SELECT * 
FROM	scheme.bmwodm
WHERE	 between @LastMonthStart and @LastMonthEnd
GROUP BY warehouse, product_code
