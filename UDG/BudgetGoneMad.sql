select * from StadaFactBook.dbo.BudgetImport
select * from StadaFactBook.dbo.Budgets

DROP TABLE #Actual
DROP TABLE #Budget
SELECT		DATEADD(MONTH, DATEDIFF(MONTH, 0, completion_date), 0) As PeriodDate, 
			COUNT(distinct wo.works_order) as batches, wo.quantity_finished, (COUNT(distinct wo.works_order) * wo.quantity_finished) as KGs, wo.description, wo.product_code,  
			CASE wo.product_code WHEN '110182' THEN 'Creams' WHEN '112193' THEN 'Creams' WHEN '122784' THEN 'Creams' WHEN '124507' THEN 'Creams' WHEN '126054' THEN 'Creams' ELSE g.Groups END AS groups --INTO #Actual
FROM        scheme.bmwohm wo WITH(NOLOCK) 
LEFT JOIN   scheme.wsroutdm d WITH(NOLOCK)	
ON			(wo.warehouse + wo.product_code = d.code) 
INNER JOIN	syslive.dbo.StadaFactBKGroups g
ON			LEFT(d.resource_code, 4) = LEFT(g.Line, 4)	
where		completion_date between StadaFactBook.dbo.fn_StartOfYear() and StadaFactBook.dbo.fn_EndOfLastMonth()
--and			wo.warehouse ='BK'
group  by	wo.description, wo.product_code, wo.quantity_finished, g.Groups,DATEADD(MONTH, DATEDIFF(MONTH, 0, completion_date), 0)
order by g.Groups, DATEADD(MONTH, DATEDIFF(MONTH, 0, completion_date), 0)

SELECT		b.BudgetPeriod, s.component_code, ROUND(Sum(b.Quantity*f.usage_quantity*s.usage_quantity),0) as KGs INTO #Budget
FROM		StadaFactBook.dbo.FGBKList f
INNER JOIN	scheme.bmassdm s
ON			f.component_code = s.product_code
AND			s.component_whouse ='BK'
INNER JOIN	StadaFactBook.dbo.Budgets b
ON			f.product_code = b.Product
WHERE		f.description LIKE 'ZOF%'
group by  b.BudgetPeriod, s.component_code

INSERT INTO #Budget
SELECT		BudgetPeriod, f.component_code, ROUND(SUM(b.Quantity * usage_quantity), 0) AS kg
FROM		StadaFactBook.dbo.Budgets b 
INNER JOIN  StadaFactBook.dbo.FGBKList f
ON			b.Product = f.product_code
WHERE		f.description not LIKE 'ZOF%'
GROUP BY	BudgetPeriod, f.component_code

-- RESULTS 
-- Budget
drop table #res
SELECT		b.BudgetPeriod,  c.CGroup, SUM(b.KGs) AS kgs into #res
FROM		#Budget b
INNER JOIN	 StadaFactBook.dbo.ComponetGroup c
on			(b.component_code = c.component_code)
GROUP BY	b.BudgetPeriod,  c.CGroup
ORDER BY	c.CGroup
;select * from #res
-- Actual
SELECT PeriodDate, groups, sum(KGs) as KGs from #Actual GROUP by PeriodDate, groups

-- join on period and type, falls on it's arse
SELECT		PeriodDate, sum(a.KGs) AS Actual, max(b.kgs) as Budget, groups
FROM		#res b
INNER JOIN	#Actual a
ON			a.groups = b.CGroup
AND			a.PeriodDate = b.BudgetPeriod
GROUP BY	groups, PeriodDate
ORDER BY	groups, PeriodDate

/*
----SELECT * FROM #Budget

return
SELECT * 
FROM		StadaFactBKGroups a
INNER JOIN	scheme.wsroutdm b
ON			a.Line = b.resource_code
INNER JOIN	StadaFactBook.dbo.FGBKList  c
ON			b.code = 'BK'+ c.component_code


select BudgetPeriod, sum(kg) from #Budget where Groups ='Creams'
group by BudgetPeriod

select * from #TMP
where		product_code = '125597'

select wo.product_code, wo.description FROM        scheme.bmwohm wo WITH(NOLOCK) 
LEFT JOIN   scheme.wsroutdm d WITH(NOLOCK)	
ON			(wo.warehouse + wo.product_code = d.code) 
WHERE		d.resource_code = 'MN03'
and completion_date between StadaFactBook.dbo.fn_StartOfYear() and StadaFactBook.dbo.fn_EndOfLastMonth()
group  by	wo.description, wo.product_code---, wo.quantity_finished, g.Groups,DATEADD(MONTH, DATEDIFF(MONTH, 0, completion_date), 0)

select wo.product_code, wo.description FROM        scheme.bmwohm wo WITH(NOLOCK) 
LEFT JOIN   scheme.wsroutdm d WITH(NOLOCK)	
ON			(wo.warehouse + wo.product_code = d.code) 
WHERE		d.resource_code = 'MN04'
and completion_date between StadaFactBook.dbo.fn_StartOfYear() and StadaFactBook.dbo.fn_EndOfLastMonth()
group  by	wo.description, wo.product_code---, wo.quantity_finished, g.Groups,DATEADD(MONTH, DATEDIFF(MONTH, 0, completion_date), 0)



select wo.product_code, wo.description, d.resource_code, g.Groups--, case wo.product_code when '110182' THEN 'Creams' when '112193' THEN 'Creams' when '122784'THEN 'Creams' when '124507' THEN 'Creams' when '126054' THEN 'Creams'  else g.Groups end as groups
FROM        scheme.bmwohm wo WITH(NOLOCK) 
LEFT JOIN   scheme.wsroutdm d WITH(NOLOCK)	
ON			(wo.warehouse + wo.product_code = d.code) 
INNER JOIN	StadaFactBKGroups g
ON			d.resource_code = g.Line
WHERE		 completion_date between StadaFactBook.dbo.fn_StartOfYear() and StadaFactBook.dbo.fn_EndOfLastMonth()
group  by	wo.product_code, wo.description, d.resource_code,g.Groups
order by g.Groups

SELECT * FROM StadaFactBKGroups
*/