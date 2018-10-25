/*
select * from scheme.stockm where warehouse ='SL'
select * from scheme.stkpgm -- GROUPS MASTER (MAIN LIST)
select * from scheme.stkpgtxm -- GROUPS MASTER (SMALLER LIST)

select		DISTINCT g1.product_group as ParentAnalysis , g1.dsc as ParentLongGroup, g2.product_group as ChildAnalysis , g2.dsc as ChildGroup
--			, s.product, s.long_description
FROM		scheme.stkpgm g1
INNER JOIN	scheme.stockm s
ON			s.analysis_a = g1.product_group
INNER JOIN	scheme.stockxpgm pg
ON			s.product = pg.product
and			s.warehouse = pg.warehouse
INNER JOIN	scheme.stkpgm g2
ON			pg.analysis_d= g2.product_group
WHERE		s.warehouse = 'SL'

select * DELETE from [dbo].[SlamProductFile] WHERE Category LIKE 'SUB%'
*/


SELECT		m.description as [Product Name], 
			m.long_description as [Product Description], 
			CAST(m.current_cost AS money), 
			m.price, 
			m.price, 
			'' as PopUpNotes, 
			21 as TaxPercentage, 
			21 as 'Eat Out Tax Percentage', 
			analysis_a as CategoryName, 
			analysis_b as BrandName, 
			'' as UnitofSale, 
			1 as VolumeOfSale,
			m.drawing_number as Barcode,
			'' AS Supplier,
			'' aS OrderCode,
			--m.price as RRP,
			n.PriceInVAT as RRP,
			null as ProductType,
			m.product as ArticleCode,
			m.weight,
			'' as ButtonColour,
			'' [Multiple Choice Note Name],
			'' [Till Order],
			m.product as SKU,
			'y' as [Sell On Till],
			'n' as [Sell On Web]
FROM		scheme.stockm m
INNER JOIN	scheme.stockxpgm g
ON			m.product = g.product
AND			m.warehouse = g.warehouse
INNER JOIN	demo.[dbo].[NLFile] n
ON			m.product = [SKU]
WHERE		m.warehouse = 'SL'
--AND			g.analysis_f ='LIVE'
AND			m.analysis_a NOT IN ('SUNDRIES')
--AND			m.product NOT LIKE 'FV-%'
--select * from scheme.stockm where drawing_number like '%+%'



SELECT		m.product as ArticleCode,
			m.description as [Product Name], 
			m.long_description as [Product Description], 
			CAST(m.current_cost AS money) AS CostPrice, 		
			CAST(m.price AS money) as RRP,
			analysis_a as CategoryName, 
			analysis_b as BrandName, 			
			m.drawing_number as Barcode,
			g.analysis_f AS ProductStatus			
FROM		scheme.stockm m
LEFT JOIN	scheme.stockxpgm g
ON			m.product = g.product
AND			m.warehouse = g.warehouse
LEFT JOIN	demo.[dbo].[NLFile] n
ON			m.product = [SKU]
WHERE		m.warehouse = 'SL'
--AND			g.analysis_f ='LIVE'
AND			m.analysis_a NOT IN ('SUNDRIES')
