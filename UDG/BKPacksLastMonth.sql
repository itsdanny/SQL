	/*
	select * from scheme.bmwodm
	select * from StadaFactBook.dbo.Budgets  where Warehouse = 'BK' ORDER BY BudgetPeriod, Product
	select * from StadaFactBook.dbo.Budgets  where Warehouse = 'BK' AND Product = '121559' ORDER BY BudgetPeriod
	*/

USE syslive;
WITH BulkCapacity_CTE (Groups, BudgetQuantity, ActualQuantity, Period)
AS
(
	SELECT      StadaFactBKGroups.Groups, 				
				(b.Quantity),				
				(wo.quantity_finished),
				b.BudgetPeriod			
	FROM        scheme.wsroutdm d WITH(NOLOCK)
	INNER JOIN	StadaFactBook.dbo.Budgets b
	ON			d.code = b.Warehouse + b.Product
	INNER JOIN	StadaFactBKGroups 
	ON			LEFT(d.resource_code, 4) = LEFT(StadaFactBKGroups.Line, 4)
	INNER JOIN  scheme.bmwohm wo WITH(NOLOCK) 
	ON			(wo.warehouse + wo.product_code = d.code) 	
	WHERE		(d.operation_name IN ('Manufacture', 'Transfer', 'Clean Up', 'Set Up'))
	AND			b.BudgetPeriod >= StadaFactBook.dbo.fn_StartOfYear()
	AND			wo.completion_date >= b.BudgetPeriod 
	AND			b.BudgetPeriod <= StadaFactBook.dbo.fn_EndOfLastMonth()
	--AND			b.Product = '121559'
	--GROUP BY	StadaFactBKGroups.Groups,  b.BudgetPeriod, b.Quantity
)

SELECT Groups, sum(BudgetQuantity) As BudgetQuantity, SUM(ActualQuantity) AS ActualQuantity,Period
FROM BulkCapacity_CTE
GROUP BY Groups, Period
ORDER BY Period, Groups
