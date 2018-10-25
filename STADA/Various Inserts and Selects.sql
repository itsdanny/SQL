--select * from Period where Year = DATEPART(YEAR, getdate())
--select * from ForecastType ft
/*--INSERT INTO [dbo].[BudgetImport](Type, Product, Value, Quantity, BudgetPeriod)
SELECT		'FG' AS Warehouse,'FEX' AS Type, p.ProductCode, 0 as Value, MAX(f.Qty) AS Qty, CAST(CAST(Year AS varchar) + '-' + CAST(pd.Period AS varchar) + '-01' AS datetime) AS BudgetPeriod
FROM		Product p
INNER JOIN	Forecast f
ON			p.ProductCode = f.ProductCode
INNER JOIN	ForecastType ft
ON			f.ForecastTypeId = ft.Id
INNER JOIN  Period pd
ON			pd.Id = f.PeriodId
WHERE		ft.Id in (4)
AND			Year = DATEPART(YEAR, getdate())
GROUP BY	pd.Period,p.ProductCode, CAST(CAST(Year AS varchar) + '-' + CAST(pd.Period AS varchar) + '-01' AS datetime) 
union all
SELECT		'FG' AS Warehouse,'FUK' AS Type, p.ProductCode, 0 as Value, MAX(f.Qty) AS Qty, CAST(CAST(Year AS varchar) + '-' + CAST(pd.Period AS varchar) + '-01' AS datetime) AS BudgetPeriod
FROM		Product p
INNER JOIN	Forecast f
ON			p.ProductCode = f.ProductCode
INNER JOIN	ForecastType ft
ON			f.ForecastTypeId = ft.Id
INNER JOIN  Period pd
ON			pd.Id = f.PeriodId
WHERE		ft.Id in (1)
AND			Year = DATEPART(YEAR, getdate())
AND			Qty > 0
GROUP BY	pd.Period,p.ProductCode, CAST(CAST(Year AS varchar) + '-' + CAST(pd.Period AS varchar) + '-01' AS datetime) 
--ORDER BY	pd.Period
*/
SELECT * FROM Product

select * from  scheme.stunitdm
select * from scheme.bmassdm 
select * from scheme.bmassdm where assembly_warehouse = 'BK'
select * from scheme.bmassdm where component_whouse= 'BK'

select * from scheme.stockm where product = '030015' and warehouse = 'BK'
select * from scheme.stockm where product = '030996' and warehouse = 'FG'
SELECT	* FROM scheme.bmassdm WHERE product_code = '002089'
select * from scheme.bmassdm where component_whouse= 'BK' and component_code = '128995'
select * from scheme.bmassdm where assembly_warehouse = 'BK' and product_code = '129053'
select * from scheme.bmassdm where component_code IN ('128634','127816')

select distinct * from scheme.bmassdm where component_unit = 'EA' and component_whouse = 'BK' 

select distinct * from scheme.bmassdm where product_code in ('030015') and component_whouse = 'BK' 
select distinct * from scheme.bmassdm where product_code in ('127263') and component_whouse = 'BK'
select distinct * from scheme.bmassdm where product_code in ('115923') and component_whouse = 'BK'
select distinct * from scheme.bmassdm where product_code in ('128707','127263','127271') and component_whouse = 'BK'
              
select * from scheme.bmassdm where component_code in ('115923')

SELECT * 
FROM		Budgets b
INNER JOIN	BudgetForecastingImport f
ON			b.Product = f.Product
AND			b.BudgetPeriod = f.BudgetPeriod
WHERE		b.Quantity = 0
AND			'F'+b.BudgetType = f.BudgetType

-- UPDATE UK BUDGETS FROM FORECASTING
-- VALUES
UPDATE		b
SET			b.Value = f.Value
FROM		Budgets b
INNER JOIN	BudgetForecastingImport f
ON			b.Product = f.Product
AND			b.BudgetPeriod = f.BudgetPeriod
WHERE		b.Quantity = 0
AND			'F'+b.BudgetType = f.BudgetType

-- GET EXPORT FORECASTS
INSERT INTO Budgets(BudgetPeriod, BudgetType, Product,Quantity, Value, Warehouse)
SELECT	BudgetPeriod, BudgetType, Product, Quantity, Value, Warehouse from BudgetForecastingImport 
WHERE BudgetType = 'FEX'

select Product, sum(Value) AS VALUE, sum(Quantity) as Quantity from StadaFactBook.dbo.Budgets where Warehouse = 'FG'
AND		Quantity < 1 AND Value > 0
GROUP BY Product -- 32

SELECT * FROM syslive.dbo.StadaFactBKBudgetBySku WHERE ProductCode not in (select Product from StadaFactBook.dbo.Budgets where Warehouse = 'BK')
SELECT * FROM syslive.dbo.StadaFactBudgetSKU  WHERE ProductCode not in (select Product from StadaFactBook.dbo.Budgets where Warehouse = 'FG' AND Quantity = 0)

select * from StadaFactBook.dbo.Budgets where Warehouse = 'BK'

SELECT * FROM dbo.StadaFactBKBudgetBySku
--SELECT * FROM dbo.StadaFactBKGroups
SELECT * FROM dbo.StadaFactBudgetSKU 
where ProductCode in ('001406','040231')--SELECT * FROM dbo.StadaFactFGGroups





