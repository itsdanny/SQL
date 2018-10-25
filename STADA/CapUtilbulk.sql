WITH BulkCapacity_CTE (Groups, TotalHours, TRCap, StadaCap)
AS
-- Define the CTE query.
(
	SELECT        StadaFactBKGroups.Groups, SUM(StadaFactBKBudgetBySku.Total) / SUM(scheme.wsroutdm.batch_size) * SUM(scheme.wsroutdm.time_per_batchsize) 
							 / 60 AS TotalHours, MAX(StadaFactBKGroups.TRCap) AS TRCap, MAX(StadaFactBKGroups.StadaCap) AS StadaCap
	FROM            scheme.wsroutdm INNER JOIN
							 StadaFactBKBudgetBySku ON scheme.wsroutdm.code = 'BK' + StadaFactBKBudgetBySku.ProductCode INNER JOIN
							 StadaFactBKGroups ON LEFT(scheme.wsroutdm.resource_code, 4) = LEFT(StadaFactBKGroups.Line, 4)
	WHERE        (scheme.wsroutdm.operation_name IN ('Manufacture', 'Transfer', 'Clean Up', 'Set Up','Filling'))
	GROUP BY StadaFactBKGroups.Groups, scheme.wsroutdm.code
)


SELECT Groups, SUM(TotalHours) AS TotalHours, TRCap, StadaCap
FROM BulkCapacity_CTE
GROUP BY Groups, TRCap, StadaCap