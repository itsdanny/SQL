--select * from BaseDrugValues

SELECT		fg.product_code,
			--, m.description,  bk.product_code, bk.component_code, ig.product_code, 
			ig.component_code, 
			--fg.usage_quantity, ig.usage_quantity, 
			(fg.usage_quantity * ig.usage_quantity) as Usage, 
			v.base_g,
			--ig.component_unit,
			CASE UPPER(ig.component_unit) WHEN 'G' THEN (fg.usage_quantity * ig.usage_quantity) ELSE (fg.usage_quantity * ig.usage_quantity)*v.base_g*1000 END as Base_g_Per_Pack
FROM		scheme.bmassdm fg WITH(NOLOCK)
INNER JOIN	scheme.bmassdm bk WITH(NOLOCK)
ON			fg.component_code = bk.product_code
AND			fg.component_whouse= bk.assembly_warehouse 
INNER JOIN	scheme.bmassdm ig WITH(NOLOCK)
ON			bk.component_code = ig.component_code
AND			bk.product_code = ig.product_code
AND			bk.component_whouse = ig.component_whouse
AND			bk.assembly_warehouse = ig.assembly_warehouse
INNER JOIN	BaseDrugValues v
ON			bk.component_code = v.prod_code
INNER JOIN	scheme.stockm m
ON			fg.product_code = m.product
AND			fg.assembly_warehouse = m.warehouse
WHERE		v.warehouse ='IG'
union
SELECT		fg.product_code,
			--, m.description,  bk.product_code, bk.component_code, ig.product_code, 
			ig.component_code, 
			--fg.usage_quantity, ig.usage_quantity, 
			(fg.usage_quantity * ig.usage_quantity) as Usage, 
			v.base_g,
			--ig.component_unit,
			CASE UPPER(ig.component_unit) WHEN 'G' THEN (fg.usage_quantity * ig.usage_quantity) ELSE (fg.usage_quantity * ig.usage_quantity)*v.base_g*1000 END as Base_g_Per_Pack
FROM		scheme.bmassdm fg WITH(NOLOCK)
INNER JOIN	scheme.bmassdm ig WITH(NOLOCK)
ON			fg.component_code = ig.product_code
AND			fg.component_whouse= ig.assembly_warehouse 
INNER JOIN	BaseDrugValues v
ON			ig.component_code = v.prod_code
INNER JOIN	scheme.stockm m
ON			fg.product_code = m.product
AND			fg.assembly_warehouse = m.warehouse
--WHERE		v.warehouse ='FG'
order by	v.prod_code


SELECT * FROM scheme.stockm WITH(NOLOCK) WHERE product IN ('024708','024716','024724') and analysis_a NOT LIKE 'Z%'

SELECT assembly_warehouse, product_code, component_whouse, component_code, component_unit, description, usage_quantity, unit_weight FROM scheme.bmassdm BK WITH(NOLOCK) WHERE product_code IN ('014796') and component_code = '130132'
SELECT assembly_warehouse, product_code, component_whouse, component_code, component_unit, description, usage_quantity, unit_weight FROM scheme.bmassdm BK WITH(NOLOCK) WHERE product_code IN ('130132') and component_code = '105588'
SELECT assembly_warehouse, product_code, component_whouse, component_code, component_unit, description, usage_quantity, unit_weight FROM scheme.bmassdm IG WITH(NOLOCK) WHERE product_code IN ('100349')

SELECT * 
FROM		BaseDrugValues v
INNER JOIN	scheme.bmassdm fg
ON			v.prod_code = fg.product_code

SELECT		distinct v.prod_code, fg.component_code, fg.usage_quantity, v.base_g, fg.component_unit 
FROM		BaseDrugValues v
INNER JOIN	scheme.bmassdm fg
ON			v.prod_code = fg.component_code

select * from scheme.stockm where UPPER(description) like '%BUPREN%' 

select * from scheme.stockm where  product = '002119' and warehouse ='FG' order by alpha
SELECT  * FROM scheme.bmassdm bm WITH(NOLOCK) WHERE product_code = '002119' and component_whouse = 'BK'

select 200*12

SELECT		fg.product_code, fg.usage_quantity, bk.product_code, bk.component_code, ig.product_code, ig.component_code,  fg.usage_quantity,  ig.usage_quantity, 
			(fg.usage_quantity * ig.usage_quantity) as Usage, 
			(fg.usage_quantity * ig.usage_quantity)*v.base_g*1000 as BaseUsage
FROM		scheme.bmassdm fg WITH (NOLOCK)
INNER JOIN	scheme.bmassdm bk WITH(NOLOCK)
ON			fg.component_code = bk.product_code
AND			fg.component_whouse = bk.assembly_warehouse
INNER JOIN	scheme.bmassdm ig WITH(NOLOCK)
ON			bk.component_code=  ig.component_code 
AND			bk.component_whouse = ig.component_whouse
INNER JOIN	BaseDrugValues v
ON			bk.component_code = v.prod_code
WHERE		fg.product_code = '002119'
AND			fg.component_whouse ='BK'
AND			bk.component_whouse ='IG'
AND			ig.component_whouse ='IG'


/*
SELECT  * FROM BaseDrugValues 
select * from scheme.stunitdm

select distinct alpha from scheme.stockm where  product_code = '002461' and warehouse ='FG' order by alpha

SELECT assembly_warehouse, product_code, component_whouse, component_code, component_unit, description, usage_quantity, unit_weight FROM scheme.bmassdm bm WITH(NOLOCK) WHERE product_code = '002461' and component_whouse = 'BK'
SELECT assembly_warehouse, product_code, component_whouse, component_code, component_unit, description, usage_quantity, unit_weight FROM scheme.bmassdm bm WITH(NOLOCK) WHERE product_code = '117489' and component_code = '100349'
SELECT assembly_warehouse, product_code, component_whouse, component_code, component_unit, description, usage_quantity, unit_weight FROM scheme.bmassdm bmc WITH(NOLOCK) WHERE component_code = '100349' AND product_code = '112312'

SELECT assembly_warehouse, product_code, component_whouse, component_code, component_unit, description, usage_quantity, unit_weight FROM scheme.bmassdm FG WITH(NOLOCK) WHERE product_code = '002461' and component_whouse = 'BK'
SELECT assembly_warehouse, product_code, component_whouse, component_code, component_unit, description, usage_quantity, unit_weight FROM scheme.bmassdm BK WITH(NOLOCK) WHERE product_code = '117489'
SELECT assembly_warehouse, product_code, component_whouse, component_code, component_unit, description, usage_quantity, unit_weight FROM scheme.bmassdm IG WITH(NOLOCK) WHERE component_code = '100349'

select ((200*12)*0.0032)*0.74
select (2.52*0.0032)/0.003

*/