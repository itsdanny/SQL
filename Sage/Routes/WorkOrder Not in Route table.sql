DEClare @WO varchar(5) = 'KZ15'
SELECT		COALESCE(r.machine_group, '') As Line, 
			wo.warehouse, 
			product_code, 
			r.works_order, 
			wo.description, 
			wo.quantity_required,
			--Ceiling(COALESCE(CAST((ro.time_per_batchsize/wo.batch_size)*wo.quantity_required AS FLOAT), 0)) As StandardRunTime,
			Ceiling(COALESCE(CAST((ro.time_per_batchsize/ro.batch_size)*wo.quantity_required AS FLOAT), 0)) As StandardRunTime,
			COALESCE(r.run_skill_needed,'0') AS operator_code
			--CAST(ISNULL(mpr.PlanStandard, 0) AS INT) AS MinBPM, 
			--CAST(ISNULL(mpr.IdealStandard, 0) AS INT) AS MaxBPM
FROM		syslive.scheme.bmwohm wo WITH(NOLOCK)  
LEFT JOIN	syslive.scheme.wswopm r WITH(NOLOCK)  
ON			(wo.works_order = r.works_order) 
LEFT JOIN	syslive.scheme.wsroutdm ro WITH(NOLOCK)  
ON			(wo.warehouse + wo.product_code = ro.code) 
LEFT JOIN	MachineTracker.dbo.Product mp WITH(NOLOCK) 
ON			wo.product_code = mp.ProductCode COLLATE Latin1_General_CI_AS
LEFT JOIN	MachineTracker.dbo.Process mpr WITH(NOLOCK) 
ON			mp.ID = mpr.ProductID 
AND			mpr.operation_code = 30
AND			mpr.line_number not like '%A' -- Alternate Route
AND			(mpr.IsCosting = 1 or mpr.IsCurrent = 1)
WHERE		(r.works_order = @WO) 
AND			ro.operation_code = r.op_lookup_key

GROUP BY	wo.warehouse, product_code, r.works_order, wo.description, r.batch_size, r.run_skill_needed, r.machine_group,wo.quantity_required,time_per_batchsize, ro.batch_size--, mpr.PlanStandard, mpr.IdealStandard  

select * from scheme.bmwohm WHERE works_order = @WO
select * from scheme.wswopm WHERE works_order = @WO
select * from scheme.wsroutdm WHERE code LIKE 'BK127298' AND resource_code LIKE 'HP%'


SELECT	works_order, warehouse, product_code, alpha_code, description, order_date, due_date, security_reference, quantity_required 
FROM	scheme.bmwohm WHERE warehouse+product_code not in
(SELECT code FROM scheme.wsroutdm)
AND		order_date > GETDATE()
AND		LEN(alpha_code) < 6

SELECT  * FROM scheme.bmassdm bm WITH(NOLOCK) WHERE component_code = '127298' and component_whouse = 'BK'
SELECT  * FROM scheme.bmassdm bm WITH(NOLOCK) WHERE product_code = '127298' and component_whouse = 'BK'
