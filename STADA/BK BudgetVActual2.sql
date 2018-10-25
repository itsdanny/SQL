USE	syslive
DROP TABLE #Results 
CREATE TABLE #Results (Period DateTime, Quantity int, Product varchar(12), Operation varchar(12), Groups varchar(15), KGs FLOAT default (0))

INSERT INTO #Results(Period, Quantity, Product, Operation, Groups)	
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
	AND			wo.completion_date BETWEEN StadaFactBook.dbo.fn_StartOfYear() AND StadaFactBook.dbo.fn_EndOfLastMonth()
	
UPDATE		r
SET			r.KGs = round(CASE component_unit WHEN 'g' THEN r.Quantity*(usage_quantity/1000) ELSE r.Quantity*usage_quantity END, 0)
FROM		#Results r
INNER JOIN	syslive.scheme.bmassdm b
ON			r.Product = b.product_code

 
FROM		syslive.scheme.bmassdm b
INNER JOIN	#Results p
ON			p.Product = b.product_code
WHERE		b.component_whouse = 'BK'

INSERT INTO #Results(Product, Groups, KGs, Period)
SELECT		b.component_code, 
			Groups,
			SUM(ROUND(CASE component_unit WHEN 'g' THEN p.Quantity*(b.usage_quantity/1000) ELSE p.Quantity*b.usage_quantity END, 0)),			
			p.Period
FROM		syslive.scheme.bmassdm b
INNER JOIN	#Results p
ON			p.Product = b.product_code
WHERE		b.component_whouse = 'BK' 
GROUP BY	component_code, Groups, Period

SELECT		Groups, SUM(b.Quantity) AS KGBudget, SUM(r.KGs ) as KGFinished, Period
FROM		#Results r
INNER JOIN	StadaFactBook.dbo.Budgets b
ON			r.Product = b.Product
WHERE		b.Warehouse = 'BK'
AND			b.BudgetPeriod = r.Period
GROUP BY	Groups, Period
ORDER BY	Groups

--UPDATE		p
--SET			p.KGs = p.KGs + round(CASE component_unit WHEN 'g' THEN p.Quantity*(usage_quantity/1000) ELSE p.Quantity*usage_quantity END, 0),
--			p.lvlThreeBK = b.component_code
--FROM		syslive.scheme.bmassdm b
--INNER JOIN	#BKProducts p
--ON			p.lvlTwoBK = b.product_code
--WHERE		b.component_whouse = 'BK' 
--AND			p.lvlTwoBK IS NOT NULL

--UPDATE		p
--SET			p.KGs = p.KGs + round(CASE component_unit WHEN 'g' THEN p.Quantity*(usage_quantity/1000) ELSE p.Quantity*usage_quantity END, 0),
--			p.lvlFourBK = b.component_code
--FROM		syslive.scheme.bmassdm b
--INNER JOIN	#BKProducts p
--ON			p.lvlThreeBK = b.product_code
--WHERE		b.component_whouse = 'BK' 
--AND			p.lvlThreeBK IS NOT NULL

select * from StadaFactBook.dbo.Budgets where Product NOT IN(SELECT Product FROM #Results) AND	Warehouse = 'BK'
SELECT *  FROM scheme.stquem where date_received < '2008-01-01'