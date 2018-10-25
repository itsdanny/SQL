/*WITH FillingCapacity_CTE (Groups, TotalHours, TRCap, StadaCap)
AS
-- Define the CTE query.
(
	SELECT        StadaFactFGGroups.Groups, SUM(ROUND(StadaFactBudgetSKU.Qty / scheme.wsroutdm.batch_size * scheme.wsroutdm.time_per_batchsize, 0)) 
                         / 60 AS TotalHours, MAX(TRCap) AS TRCap, MAX(StadaCap) AS StadaCap
	FROM            StadaFactBudgetSKU WITH(NOLOCK) INNER JOIN
								scheme.wsroutdm WITH(NOLOCK) ON 'FG' + StadaFactBudgetSKU.ProductCode = scheme.wsroutdm.code INNER JOIN
								StadaFactFGGroups WITH(NOLOCK) ON LEFT(scheme.wsroutdm.resource_code, 4) = LEFT(StadaFactFGGroups.Line, 4)
	WHERE        (scheme.wsroutdm.operation_name = 'Filling')
	GROUP BY StadaFactFGGroups.Groups, scheme.wsroutdm.code
	UNION
		SELECT        StadaFactBKGroups.Groups, SUM(StadaFactBKBudgetBySku.Total) / SUM(scheme.wsroutdm.batch_size) * SUM(scheme.wsroutdm.time_per_batchsize) 
							 / 60 AS TotalHours, MAX(StadaFactBKGroups.TRCap) AS TRCap, MAX(StadaFactBKGroups.StadaCap) AS StadaCap
	FROM            scheme.wsroutdm INNER JOIN
							 StadaFactBKBudgetBySku ON scheme.wsroutdm.code = 'BK' + StadaFactBKBudgetBySku.ProductCode INNER JOIN
							 StadaFactBKGroups ON LEFT(scheme.wsroutdm.resource_code, 4) = LEFT(StadaFactBKGroups.Line, 4)
	WHERE        (scheme.wsroutdm.operation_name IN ('Filling'))
	GROUP BY StadaFactBKGroups.Groups, scheme.wsroutdm.code
)

*/

WITH FGCapacity_CTE (Groups, BudgetQuantity, ActualQuantity, Period)
AS
	(SELECT      StadaFactFGGroups.Groups, 				
				MAX(b.Quantity),				
				MAX(wo.quantity_finished),
				b.BudgetPeriod
				-- SELECT *
	FROM        scheme.wsroutdm d WITH(NOLOCK)
	INNER JOIN	StadaFactBook.dbo.Budgets b
	ON			d.code = b.Warehouse + b.Product
	INNER JOIN	StadaFactFGGroups 
	ON			LEFT(d.resource_code, 4) = LEFT(StadaFactFGGroups.Line, 4)
	INNER JOIN  scheme.bmwohm wo WITH(NOLOCK) 
	ON			(wo.warehouse + wo.product_code = d.code) 
	WHERE		(d.operation_name IN ('Filling'))
	AND			b.BudgetPeriod between StadaFactBook.dbo.fn_StartOfYear() and StadaFactBook.dbo.fn_StartOfLastMonth()
	AND			wo.completion_date >= StadaFactBook.dbo.fn_StartOfYear()
	GROUP BY	StadaFactFGGroups.Groups, d.code,b.BudgetPeriod
	UNION
	SELECT      StadaFactBKGroups.Groups, 				
				MAX(b.Quantity),				
				MAX(wo.quantity_finished),
				b.BudgetPeriod
				--SELECT *
	FROM        scheme.wsroutdm d WITH(NOLOCK)
	INNER JOIN	StadaFactBook.dbo.Budgets b
	ON			d.code = b.Warehouse + b.Product
	INNER JOIN	StadaFactBKGroups 
	ON			LEFT(d.resource_code, 4) = LEFT(StadaFactBKGroups.Line, 4)
	INNER JOIN  scheme.bmwohm wo WITH(NOLOCK) 
	ON			(wo.warehouse + wo.product_code = d.code) 
	WHERE		(d.operation_name IN ('Filling'))
	AND			b.BudgetPeriod between StadaFactBook.dbo.fn_StartOfYear() and StadaFactBook.dbo.fn_StartOfLastMonth()
	AND			wo.completion_date >= StadaFactBook.dbo.fn_StartOfYear()
	GROUP BY	StadaFactBKGroups.Groups, d.code,b.BudgetPeriod
	)
SELECT Groups, SUM(BudgetQuantity) As BudgetQuantity, SUM(ActualQuantity) AS ActualQuantity,Period
FROM FGCapacity_CTE 
GROUP BY Groups, Period

