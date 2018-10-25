USE syslive
SELECT		DATEADD(MONTH, DATEDIFF(MONTH, 0, completion_date), 0) as PeriodMonth, DATENAME(MONTH, completion_date) As TEEPMonth, SUM(quantity_finished) AS quantity_finished,
			SUM(quantity_finished*u.spare) AS ActualTEEP, 
			d.resource_code INTO #Results
FROM        scheme.bmwohm wo WITH(NOLOCK) 
INNER JOIN   scheme.wsroutdm d WITH(NOLOCK)	
ON			(wo.warehouse + wo.product_code = d.code) 
INNER JOIN	scheme.stunitdm u
ON			wo.finish_prod_unit = u.unit_code
WHERE		completion_date BETWEEN StadaFactBook.dbo.fn_StartOfYear() AND StadaFactBook.dbo.fn_EndOfLastMonth()
GROUP BY	d.resource_code, DATENAME(MONTH, completion_date),DATEADD(MONTH, DATEDIFF(MONTH, 0, completion_date), 0)
ORDER BY	resource_code

SELECT		PeriodMonth, r.TEEPMonth, b.Line, r.resource_code, Speed, TEEPValue, quantity_finished
FROM		#Results r 
INNER JOIN	StadaFactBook.dbo.BottlesTEEP b
ON			r.TEEPMonth = b.TEEPMonth
AND			r.resource_code = b.SageRef
WHERE		PeriodMonth <= StadaFactBook.dbo.fn_EndOfLastMonth()
ORDER BY	PeriodMonth

DROP TABLE #Results
