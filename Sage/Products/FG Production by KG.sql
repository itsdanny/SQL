select min(order_date), min(completion_date) from syslive.scheme.bmwohm 
select * from MachineTracker.dbo.Event
select * from scheme.stkhstm where lot_number like 'ET46%'
select * from scheme.stockm where product in ('030015','002682','006696') and warehouse = 'FG'
SELECT	    DATEPART(YEAR, order_date) AS ProductionYear , r.machine_group as Line, m.product, m.long_description, u.unit_code AS UnitCode, u.spare as UOM, m.alpha, SUM(h.quantity_finished) as Packs, 
			SUM(u.spare*h.quantity_finished) as Units, 			
			--sum(case when UPPER(alpha) LIKE '%G' AND UPPER(alpha) NOT LIKE '%L' THEN d.quantity_issued END) as kg,
			--sum(case when UPPER(alpha) LIKE '%L' THEN d.quantity_issued END) as Litres,		
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
WHERE		order_date between '2013-04-01' and '2013-07-31'
AND			h.warehouse = 'FG'
AND			m.analysis_a NOT IN ('TPTY')
and			d.stage = 'BULK'
AND			h.status = 'C'
--AND			h.product_code = '087769'
GROUP BY	DATEPART(YEAR, order_date), r.machine_group , m.product, m.long_description, u.unit_code, m.weight, m.alpha, u.spare
ORDER BY	r.machine_group , m.product

SELECT	    DATEPART(YEAR, order_date) AS ProductionYear , r.machine_group as Line, m.product, m.long_description, u.unit_code AS UnitCode, u.spare as UOM, m.alpha, SUM(h.quantity_finished) as Packs, 
			SUM(u.spare*h.quantity_finished) as Units, 			
			--sum(case when UPPER(alpha) LIKE '%G' AND UPPER(alpha) NOT LIKE '%L' THEN d.quantity_issued END) as kg,
			--sum(case when UPPER(alpha) LIKE '%L' THEN d.quantity_issued END) as Litres,		
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
WHERE		order_date between '2015-04-01' and '2015-07-31'
AND			h.warehouse = 'FG'
AND			m.analysis_a NOT IN ('TPTY')
and			d.stage = 'BULK'
AND			h.status = 'C'
--AND			h.product_code = '087769'
GROUP BY	DATEPART(YEAR, order_date), r.machine_group , m.product, m.long_description, u.unit_code, m.weight, m.alpha, u.spare
ORDER BY	r.machine_group , m.product

-- SX 100G
SELECT * FROM scheme.stockm WHERE product = '014672'
SELECT * FROM scheme.bmwohm WHERE works_order LIKE ('EM57B%') AND product_code ='014672'
SELECT * FROM scheme.bmwodm WHERE works_order LIKE ('EM57B%') AND  stage ='BULK'
select  * from scheme.bmassdm where product_code in('127727','225191')

select  sum(usage_quantity * (CASE WHEN UPPER(component_unit) IN ('G','ML') THEN 1 WHEN UPPER(component_unit) IN ('KG','L') then 1000 END)) from scheme.bmassdm where product_code in('127727','225191')


SELECT d.quantity_required, h.quantity_finished, d.warehouse, h.warehouse, h.product_code
FROM scheme.bmwohm h
INNER JOIN scheme.bmwodm d
ON		h.works_order = d.works_order
WHERE h.works_order LIKE ('EM57B%') 
AND  d.stage ='BULK'



