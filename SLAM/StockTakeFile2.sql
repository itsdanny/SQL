SELECT		CAST(m.price AS money) as RRP,
			m.product as ArticleCode,
			--m.description as [Product Name], 
			analysis_a as CategoryName, 
			analysis_b,
			analysis_d AS SubCategory,			
			LTRIM(RTRIM(analysis_c)) + CASE WHEN LEN(LTRIM(RTRIM(analysis_e))) > 0 THEN ' (' + LOWER(LTRIM(RTRIM(analysis_e)))+')' ELSE '' END AS [Strength (size)],			
			analysis_f,
			m.drawing_number as Barcode,
			LTRIM(RTRIM(m.long_description)) as [Product Description],
			'' AS [Stock Count]			
FROM		scheme.stockm m
LEFT JOIN	scheme.stockxpgm g
ON			m.product = g.product
AND			m.warehouse = g.warehouse
WHERE		m.warehouse = 'SL'
AND			g.analysis_f NOT LIKE 'DIS%'
AND			m.analysis_a NOT IN ('SUNDRIES')
order by	analysis_a, analysis_d, m.long_description, analysis_c,analysis_e