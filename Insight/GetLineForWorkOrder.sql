select * from syslive.scheme.bmwohm where works_order not in (select distinct works_order from syslive.scheme.wswopm) and quantity_finished = 0 and order_date > getDate() and alpha_code not like 'TPTY%' and alpha_code not like '%TEST%'
select * from syslive.scheme.wswopm where works_order like 'LH55B'
select * from syslive.scheme.bmwohm where works_order like 'LH55B'

UPDATE syslive.scheme.bmwohm set status = 'I' where works_order like 'LH55B'



SELECT		r.resource_code, 
			warehouse, product_code, works_order, wo.description, quantity_required, 
			SUM(time_per_batchsize) As StandardRunTime,r.operator_code as operator_code, 
			SUM(wo.batch_size) as BatchSize
--			select wo.batch_size
FROM		syslive.scheme.bmwohm wo WITH(NOLOCK) 
INNER JOIN	syslive.scheme.wsroutdm r 
ON			(wo.warehouse + wo.product_code = r.code) 
WHERE		(works_order LIKE 'KV47%') 
group by	r.resource_code, warehouse, product_code, works_order, wo.description, quantity_required, r.operator_code  
order by StandardRunTime desc

USE syslive
exec scheme.sp_getRouteInfoForInsight 'KT43B'

SELECT		ro.resource_code As Line, 
			wo.warehouse, 
			product_code, 
			wo.works_order, 
			wo.description, 
			wo.quantity_required,
			CEILING(COALESCE(CAST((ro.time_per_batchsize/wo.batch_size)*wo.quantity_required AS FLOAT), 0)) AS StandardRunTime,			
			--COALESCE(r.run_skill_needed,'0') AS operator_code,
			CAST(ISNULL(mpr.PlanStandard, 0) AS INT) AS MinBPM, 
			CAST(ISNULL(mpr.IdealStandard, 0) AS INT) AS MaxBPM
FROM		syslive.scheme.bmwohm wo WITH(NOLOCK)  
LEFT JOIN	syslive.scheme.wsroutdm ro WITH(NOLOCK)  
ON			(wo.warehouse + wo.product_code = ro.code) 
--LEFT JOIN	syslive.scheme.wswopm r WITH(NOLOCK)  
--ON			(wo.works_order = r.works_order) 
LEFT JOIN	MachineTracker.dbo.Product mp WITH(NOLOCK) 
ON			wo.product_code = mp.ProductCode COLLATE Latin1_General_CI_AS
LEFT JOIN	MachineTracker.dbo.Process mpr WITH(NOLOCK) 
ON			mp.ID = mpr.ProductID 
AND			mpr.operation_code = 30
AND			mpr.line_number not like '%A' -- Alternate Route
AND			(mpr.IsCosting = 1 or mpr.IsCurrent = 1)
WHERE		(wo.works_order = 'KS08B') 
--AND			ro.operation_code = r.op_lookup_key

select * from MachineTracker.dbo.Product mp
LEFT JOIN	MachineTracker.dbo.Process mpr WITH(NOLOCK) 
ON			mp.ID = mpr.ProductID  where ProductCode = '019690'
AND			mpr.operation_code = 30
AND			mpr.line_number not like '%A' -- Alternate Route
AND			(mpr.IsCosting = 1 or mpr.IsCurrent = 1)

select * from syslive.scheme.wswopm where works_order = 'KS08B'

SELECT TOP 1000 *
  FROM [syslive].[scheme].[bmwohm] woB   with (NOLOCK) inner join 
  [syslive].[scheme].[bmwohm] woA  with (NOLOCK)  on woA.works_order = LEFT(woB.works_order,4) + 'A' 
 
  inner join
  syslive.scheme.stkhstm hist with (NOLOCK) on woA.product_code = hist.product and hist.transaction_type = 'W/O' and movement_reference = woB.works_order
  where woB.works_order like '%B'  and woB.quantity_finished = 0
  order by woB.order_date desc

