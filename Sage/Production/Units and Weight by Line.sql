select		*
FROM		[archivesyslive].scheme.bmwohm h
INNER JOIN  [archivesyslive].scheme.stockm m
ON			h.warehouse = m.warehouse
AND			h.product_code = m.product
INNER JOIN	[archivesyslive].scheme.bmwodm d
ON			h.works_order = d.works_order
INNER JOIN	scheme.stunitdm u
ON			h.finish_prod_unit = u.unit_code
INNER JOIN	[archivesyslive].scheme.wswopm r
ON			h.works_order = r.works_order
WHERE		completion_date between '2013-01-01' and '2013-06-30'
AND			h.warehouse = 'FG'
AND			m.analysis_a NOT IN ('TPTY')
and			d.stage = 'BULK'
AND			h.status = 'C'
and			m.product ='002682'

select		* 
FROM		scheme.bmwohm h
INNER JOIN  scheme.stockm m
ON			h.warehouse = m.warehouse
AND			h.product_code = m.product
INNER JOIN	scheme.bmwodm d
ON			h.works_order = d.works_order
INNER JOIN	scheme.stunitdm u
ON			h.finish_prod_unit = u.unit_code
INNER JOIN	syslive.scheme.wswopm r
ON			h.works_order = r.works_order
WHERE		completion_date between '2015-01-01' and '2015-06-30'
AND			h.warehouse = 'FG'
AND			m.analysis_a NOT IN ('TPTY')
and			d.stage = 'BULK'
AND			h.status = 'C'
and			m.product ='002682'


SELECT	    DATEPART(YEAR, completion_date) AS ProductionYear, r.machine_group as Line, m.product, m.long_description, u.unit_code AS UnitCode, u.spare as UOM, m.alpha, 
			SUM(h.quantity_finished) as Packs, 
			SUM(u.spare*h.quantity_finished) as Units, 									
			SUM(d.quantity_issued) AS KG						
FROM		[archivesyslive].scheme.bmwohm h
INNER JOIN  [archivesyslive].scheme.stockm m
ON			h.warehouse = m.warehouse
AND			h.product_code = m.product
INNER JOIN	[archivesyslive].scheme.bmwodm d
ON			h.works_order = d.works_order
INNER JOIN	scheme.stunitdm u
ON			h.finish_prod_unit = u.unit_code
INNER JOIN	[archivesyslive].scheme.wswopm r
ON			h.works_order = r.works_order
WHERE		completion_date between '2013-01-01' and '2013-06-30'
AND			h.warehouse = 'FG'
AND			m.analysis_a NOT IN ('TPTY')
and			d.stage = 'BULK'
AND			h.status = 'C'
--and			m.product ='002682'
GROUP BY	DATEPART(YEAR, completion_date), r.machine_group , m.product, m.long_description, u.unit_code, m.weight, m.alpha, u.spare
ORDER BY	r.machine_group , m.product


SELECT	    DATEPART(YEAR, completion_date) AS ProductionYear , r.machine_group as Line, 
			m.product, m.long_description, u.unit_code AS UnitCode, 
			u.spare as UOM, m.alpha, 
			SUM(h.quantity_finished) as Packs, 
			SUM(u.spare*h.quantity_finished) as Units, 						
			SUM(d.quantity_issued) AS KG
FROM		scheme.bmwohm h
INNER JOIN  scheme.stockm m
ON			h.warehouse = m.warehouse
AND			h.product_code = m.product
INNER JOIN	scheme.bmwodm d
ON			h.works_order = d.works_order
INNER JOIN	scheme.stunitdm u
ON			h.finish_prod_unit = u.unit_code
INNER JOIN	syslive.scheme.wswopm r
ON			h.works_order = r.works_order
WHERE		completion_date between '2015-01-01' and '2015-06-30'
AND			h.warehouse = 'FG'
AND			m.analysis_a NOT IN ('TPTY')
and			d.stage = 'BULK'
AND			h.status = 'C'
--and			m.product ='002682'
GROUP BY	DATEPART(YEAR, completion_date), r.machine_group , m.product, m.long_description, u.unit_code, m.weight, m.alpha, u.spare
ORDER BY	r.machine_group , m.product