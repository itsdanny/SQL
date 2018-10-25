USE syslive
drop table #tmp;
/*
	GROUPS		BUDGETTOTALHOURS	TRCAP	STADACAP	ACTUALHOURS
	Creams		8270.65545904982	15200	18000		0
	Household	337.961636363636	5700	12000		0
	Liquids		8156.93811324537	45600	66000		0
	Suppository	564.453333333333	3800	6000		0
*/

SELECT		j.warehouse+j.Product as ActualCodes, SUM(l.StageRuntime) as ActualTime INTO #tmp
FROM		Insight.dbo.ManufacturingJob j
INNER JOIN	Insight.dbo.ManufacturingJobLog l
ON			j.Id = l.ManufacturingJobId	
WHERE		l.ManufacturingStageId <> 1
GROUP BY	j.warehouse, j.Product;

SELECT * FROM #tmp;

WITH BulkCapacity_CTE (Groups, TRCap, StadaCap, BudgetTotalHours, ActualTime)
AS
(
	SELECT      StadaFactBKGroups.Groups, 
				MAX(StadaFactBKGroups.TRCap) AS TRCap, 
				MAX(StadaFactBKGroups.StadaCap) AS StadaCap,
				SUM(StadaFactBKBudgetBySku.Total)/SUM(r.batch_size) * SUM(r.time_per_batchsize)/60 AS BudgetTotalHours, 				
				SUM(ActualTime) AS ActualTime
	FROM        scheme.wsroutdm r
	INNER JOIN	StadaFactBKBudgetBySku 
	ON			r.code = 'BK' + StadaFactBKBudgetBySku.ProductCode 
	INNER JOIN	StadaFactBKGroups 
	ON			LEFT(r.resource_code, 4) = LEFT(StadaFactBKGroups.Line, 4)	
	LEFT JOIN   #tmp t
	ON			r.code = t.ActualCodes COLLATE Latin1_General_CI_AS
	WHERE		(r.operation_name IN ('Manufacture', 'Transfer', 'Clean Up', 'Set Up'))
	GROUP BY	StadaFactBKGroups.Groups, r.code
)

SELECT		Groups, SUM(BudgetTotalHours) AS BudgetTotalHours, TRCap, StadaCap, Insight.dbo.fn_IntToTime(SUM(ActualTime)) AS ActualTime
FROM		BulkCapacity_CTE
GROUP BY	Groups, TRCap, StadaCap



