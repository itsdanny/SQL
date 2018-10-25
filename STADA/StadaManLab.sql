select * from SafetyStockExclude

	SELECT      StadaFactBKGroups.Groups, 
				MAX(StadaFactBKGroups.TRCap) AS TRCap, 
				MAX(StadaFactBKGroups.StadaCap) AS StadaCap,
				SUM(StadaFactBKBudgetBySku.Total)/SUM(r.batch_size) * SUM(r.time_per_batchsize)/60 AS BudgetTotalHours
				,SUM(l.StageRunTime) as ActualHours				
	FROM        scheme.wsroutdm r
	INNER JOIN	StadaFactBKBudgetBySku 
	ON			r.code = 'BK' + StadaFactBKBudgetBySku.ProductCode 
	INNER JOIN	StadaFactBKGroups 
	ON			LEFT(r.resource_code, 4) = LEFT(StadaFactBKGroups.Line, 4)
	LEFT JOIN  Insight.dbo.ManufacturingJob j
	ON			j.Warehouse+j.Product = r.code COLLATE Latin1_General_BIN
	LEFT JOIN	Insight.dbo.ManufacturingJobLog l
	ON			j.Id = l.ManufacturingJobId	
	WHERE		(r.operation_name IN ('Manufacture', 'Transfer', 'Clean Up', 'Set Up'))
	AND			l.ManufacturingStageId <> 1
	GROUP BY	StadaFactBKGroups.Groups, r.code
	ORDER BY	StadaFactBKGroups.Groups