USE	syslive

DROP TABLE #Results 
CREATE TABLE #Results (CompletionDate DateTime, quantity_finished int, Product varchar(12), Operation varchar(12), Groups varchar(15))

INSERT INTO #Results(CompletionDate, quantity_finished, Product, Operation, Groups)	
SELECT			DATEADD(MONTH, DATEDIFF(MONTH, 0, completion_date), 0),
				wo.quantity_finished,
				wo.product_code,
				d.operation_name,
				StadaFactBKGroups.Groups
	FROM        scheme.bmwohm wo WITH(NOLOCK) 
	LEFT JOIN   scheme.wsroutdm d WITH(NOLOCK)	
	ON			(wo.warehouse + wo.product_code = d.code) 
	INNER JOIN	StadaFactBKGroups 
	ON			LEFT(d.resource_code, 4) = LEFT(StadaFactBKGroups.Line, 4)	
	WHERE		(d.operation_name IN ('Manufacture', 'Transfer', 'Clean Up', 'Set Up'))
	and			wo.completion_date BETWEEN StadaFactBook.dbo.fn_StartOfYear() AND StadaFactBook.dbo.fn_EndOfLastMonth()
	
	--GROUP BY	StadaFactBKGroups.Groups,  b.BudgetPeriod, b.Quantity

SELECT		Groups, CompletionDate, SUM(b.Quantity) As BudgetQuantity, SUM(quantity_finished) AS ActualQuantity
FROM		#Results r
INNER JOIN	StadaFactBook.dbo.Budgets b
ON			r.Product = b.Product
WHERE		r.CompletionDate = b.BudgetPeriod
GROUP BY	Groups, CompletionDate
ORDER BY	CompletionDate, Groups