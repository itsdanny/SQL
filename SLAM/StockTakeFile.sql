SELECT		m.product as ArticleCode,
			--m.description as [Product Name], 
			m.long_description as [Product Description], 			
			m.drawing_number as Barcode,
			analysis_a as CategoryName, 
			analysis_d AS SubCategory,
			--analysis_b as BrandName, 			
			LTRIM(RTRIM(analysis_c)) + CASE WHEN LEN(LTRIM(RTRIM(analysis_e))) > 0 THEN ' (' + LOWER(LTRIM(RTRIM(analysis_e)))+')' ELSE '' END AS [Strength (size)],			 
			CAST(m.price AS money) as RRP
FROM		scheme.stockm m
LEFT JOIN	scheme.stockxpgm g
ON			m.product = g.product
AND			m.warehouse = g.warehouse
WHERE		m.warehouse = 'SL'
AND			g.analysis_f NOT LIKE 'DIS%'
AND			m.analysis_a NOT IN ('SUNDRIES')
order by	analysis_a,analysis_d, m.long_description