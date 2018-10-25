WITH FillingCapacity_CTE (Groups, TotalHours, TRCap, StadaCap)
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


SELECT Groups, SUM(TotalHours) AS TotalHours, TRCap, StadaCap
FROM FillingCapacity_CTE
GROUP BY Groups, TRCap, StadaCap