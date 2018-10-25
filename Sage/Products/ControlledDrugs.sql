sp__Salesoncontrolleddrugs_retail, sp__Salesoncontrolleddrugs_WholeSaler, sp__Salesoncontrolleddrugs_CatchAll

select * from scheme.stockm where  product = '002119' and warehouse ='FG' order by alpha
SELECT  * FROM scheme.bmassdm bm WITH(NOLOCK) WHERE product_code = '002119' and component_whouse = 'BK'
SELECT *  FROM [syslive].[dbo].[ContDrugsImport]

SELECT		fg.product_code, fg.usage_quantity, bk.product_code, bk.component_code, ig.product_code, ig.component_code,  fg.usage_quantity,  ig.usage_quantity, 
			(fg.usage_quantity * ig.usage_quantity) as Usage, 
			(fg.usage_quantity * ig.usage_quantity)*v.Base_g*1000 as BaseUsage
FROM		scheme.bmassdm fg WITH (NOLOCK)
INNER JOIN	scheme.bmassdm bk WITH(NOLOCK)
ON			fg.component_code = bk.product_code
AND			fg.component_whouse = bk.assembly_warehouse
INNER JOIN	scheme.bmassdm ig WITH(NOLOCK)
ON			bk.component_code=  ig.component_code 
AND			bk.component_whouse = ig.component_whouse
INNER JOIN	ContDrugsImport v
ON			fg.product_code = v.FGCode
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

/****** Script for SelectTop*/
SELECT		i.Base_g*g_lt*fg.usage_quantity, *
FROM [syslive].[dbo].n i
left	JOIN	scheme.bmassdm fg
ON			i.FGCode = fg.product_code
AND			i.BKCode = fg.component_code
and			i.BKCode is not null
order by IGCode, BKCode desc, FGCode


SELECT		i.Base_g*g_lt*fg.usage_quantity, *
FROM		[syslive].[dbo].[ContDrugsImport] i
INNER  JOIN	scheme.bmassdm fg
ON			i.FGCode = fg.product_code
AND			i.IGCode = fg.component_code
--and			i.BKCode is not null
order by IGCode, BKCode desc, FGCode


update i
set		i.FGUsage = i.Base_g*g_lt*fg.usage_quantity
FROM [syslive].[dbo].[ContDrugsImport] i
left	JOIN	scheme.bmassdm fg
ON			i.FGCode = fg.product_code
AND			i.BKCode = fg.component_code
and			i.BKCode is not null
WHERE		i.FGUsage is null

SELECT * FROM [syslive].[dbo].[ContDrugsImport] i WHERE UOM ='ea'

SELECT * FROM [syslive].[dbo].[ContDrugsImport] i WHERE FGUsage is null


select 0.0010 * 28

