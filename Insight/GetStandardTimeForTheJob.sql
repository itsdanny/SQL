USE [syslive]
GO
/****** Object:  StoredProcedure [scheme].[sp_getRouteInfoForInsight]    Script Date: 27/11/2014 11:09:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER   procedure [scheme].[sp_getRouteInfoForInsight]
@WorkOrderNumber varchar(5)
as
-- OLD WAY
--SELECT		COALESCE(r.resource_code, '') As Line, 
--			warehouse, 
--			product_code, 
--			works_order, 
--			wo.description, 
--			quantity_required, 
--			COALESCE(CAST(SUM(time_per_batchsize/wo.quantity_required)*quantity_required AS INT), 0) As StandardRunTime, 
--			COALESCE(r.operator_code,'0') AS operator_code
--FROM		syslive.scheme.bmwohm wo WITH(NOLOCK)  
--LEFT JOIN	syslive.scheme.wsroutdm r 
--ON			(wo.warehouse + wo.product_code = r.code) 
--WHERE		(works_order = @WorkOrderNumber) 
--group by	warehouse, product_code, works_order, wo.description, quantity_required, operator_code, r.resource_code

--	select * from Insight.dbo.Test
--insert into Insight.dbo.Test(Stamp, msg) values (GETDATE(), @WorkOrderNumber)

--SELECT		COALESCE(r.machine_group, '') As Line, 
--			warehouse, 
--			product_code, 
--			r.works_order, 
--			wo.description, 
--			wo.quantity_required,
--			COALESCE(CAST(SUM(time_per_batchsize/wo.quantity_required)*quantity_required AS INT), 0) As StandardRunTime, 
--			COALESCE(r.run_skill_needed,'0') AS operator_code 
--FROM		syslive.scheme.bmwohm wo WITH(NOLOCK)  
--LEFT JOIN	syslive.scheme.wswopm r WITH(NOLOCK)  
--ON			(wo.works_order = r.works_order) 
--LEFT JOIN	syslive.scheme.wsroutdm ro WITH(NOLOCK)  
--ON			(wo.warehouse + wo.product_code = ro.code) 
--WHERE		(r.works_order = @WorkOrderNumber) 
--GROUP BY	warehouse, product_code, r.works_order, wo.description, r.batch_size, r.run_skill_needed, r.machine_group,wo.quantity_required

SELECT		COALESCE(r.machine_group, '') As Line, 
			warehouse, 
			product_code, 
			r.works_order, 
			wo.description, 
			wo.quantity_required,
			Ceiling(COALESCE(CAST((ro.time_per_batchsize/wo.batch_size)*wo.quantity_required AS FLOAT), 0)) As StandardRunTime,
			COALESCE(r.run_skill_needed,'0') AS operator_code 
FROM		syslive.scheme.bmwohm wo WITH(NOLOCK)  
LEFT JOIN	syslive.scheme.wswopm r WITH(NOLOCK)  
ON			(wo.works_order = r.works_order) 
LEFT JOIN	syslive.scheme.wsroutdm ro WITH(NOLOCK)  
ON			(wo.warehouse + wo.product_code = ro.code) 
WHERE		(r.works_order = @WorkOrderNumber) 
AND			ro.operation_code = r.op_lookup_key
GROUP BY	warehouse, product_code, r.works_order, wo.description, r.batch_size, r.run_skill_needed, r.machine_group, wo.quantity_required, time_per_batchsize, wo.batch_size
