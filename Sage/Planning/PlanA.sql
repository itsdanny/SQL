DECLARE @StartDate DateTime = (getDate()+5)
DECLARE @EndDate DateTime = (@StartDate +6)
--select @StartDate, @EndDate
;
with cte_results(Line, Mins, Crew) as (
SELECT		COALESCE(r.machine_group, '') As Line, 
			Ceiling(COALESCE(CAST((ro.time_per_batchsize/ro.batch_size)*wo.quantity_required AS FLOAT), 0)) As StandardRunTime,
			RIGHT(LTRIM(RTRIM(COALESCE(r.run_skill_needed,'0'))),1) AS operator_code			
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
WHERE		(wo.order_date  between @StartDate  and @EndDate)
AND			ro.operation_code = r.op_lookup_key)


SELECT		g.WorkCentreGroup, Insight.dbo.fn_IntToTime(sum(Mins*Crew)) as WorkTime FROM cte_results r
INNER JOIN	syslive.dbo.GroupedWorkCentre g
ON			r.Line = g.WorkCentre Collate Latin1_General_CI_AS
group by	g.WorkCentreGroup



