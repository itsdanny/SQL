SELECT		DATEPART(mm, scheme.stkhstm.dated) AS PastMonth, 
			LEFT(DATENAME(MONTH, DATEPART(mm, scheme.stkhstm.dated)), 3) AS PastMonthName, 
			ISNULL(scheme.stkhstm.movement_quantity, 0) * ISNULL(scheme.stockm.weight, 0) AS KG, 
            StadaFactFGGroups.Groups,
			scheme.stockm.weight,scheme.stkhstm.movement_quantity, stockm.*
FROM        scheme.stkhstm WITH (NOLOCK) 
INNER JOIN  scheme.wsroutdm WITH (NOLOCK) 
ON			LTRIM(RTRIM(scheme.stkhstm.warehouse)) + LTRIM(RTRIM(scheme.stkhstm.product))  = scheme.wsroutdm.code 
INNER JOIN	scheme.stockm WITH (NOLOCK) 
ON			scheme.stkhstm.warehouse = scheme.stockm.warehouse 
AND         scheme.stkhstm.product = scheme.stockm.product 
INNER JOIN	StadaFactFGGroups WITH (NOLOCK) 
ON			LEFT(scheme.wsroutdm.resource_code, 4) = LEFT(StadaFactFGGroups.Line, 4)
WHERE       (scheme.stkhstm.transaction_type = 'COMP') 
AND			(scheme.stkhstm.dated 
			BETWEEN CAST(CAST(CAST(DATEPART(yyyy, DATEADD(mm, - 13, GETDATE())) AS char(4)) + '-' + CAST(DATEPART(mm, GETDATE()) AS char(2)) + '-01 00:00:00' AS varchar(19)) AS DATETIME) 
			AND DATEADD(s, - 1, DATEADD(mm, DATEDIFF(m, 0, GETDATE()), 0))) 
AND			(scheme.stkhstm.warehouse = 'FG')


