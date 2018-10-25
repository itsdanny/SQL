-- MAN LAB
DECLARE @StartDate DateTime = (getDate()+4)
DECLARE @EndDate DateTime = (@StartDate +6)

	--SELECT		*
	--FROM		scheme.wsroutdm d WITH(NOLOCK) 
	----INNER JOIN	scheme.bmassdm bm WITH(NOLOCK) 
	----ON			d.code = bm.assembly_warehouse +bm.product_code
	--INNER JOIN	scheme.bmwohm w WITH(NOLOCK) 
	--ON			d.code = w.warehouse + w.product_code
	--AND			w.order_date  between @StartDate and @EndDate
	----AND			d.code = 'FG030023'
	----AND			bm.component_whouse = 'BK'
	--AND			d.resource_code LIKE ('M%')
	
/* SSMSBoost
Event: DocumentExecuted
Event date: 2015-04-09 11:21:26
Connection: trsagev3d2.master (WinAuth)
*/

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

SELECT		Stage, CAST(@StartDate AS VARCHAR(12)) AS WeekCommencing, CAST(@EndDate AS VARCHAR(12)) WeekEnding,	
			WorkCentreGroup,  
			SUM(WorkTime) AS LabourMins,
			Insight.dbo.fn_IntToTime(sum(WorkTime)) AS LabourHoursMins 
FROM 
	(SELECT		2 as Stage, g.WorkCentreGroup as WorkCentreGroup, sum(Mins*Crew) as WorkTime FROM cte_results r
	INNER JOIN	syslive.dbo.GroupedWorkCentre g
	ON			r.Line = g.WorkCentre Collate Latin1_General_CI_AS
	GROUP BY	g.WorkCentreGroup
UNION
	SELECT		2 as Stage, 'HPD1' as WorkCentreGroup, sum((d.time_per_batchsize * CAST(RIGHT(LTRIM(RTRIM(d.operator_code)), 1) AS INT))) AS WorkTime
	--SELECT		order_date, d.time_per_batchsize, d.operator_code, RIGHT(LTRIM(RTRIM(d.operator_code)), 1) AS Crewe, (d.time_per_batchsize * CAST(RIGHT(LTRIM(RTRIM(d.operator_code)), 1) AS INT)) AS Mins
	--SELECT		*
	FROM		scheme.wsroutdm d WITH(NOLOCK) 
	INNER JOIN	scheme.bmassdm bm WITH(NOLOCK) 
	ON			d.code = bm.assembly_warehouse +bm.product_code
	INNER JOIN	scheme.bmwohm w WITH(NOLOCK) 
	ON			d.code = w.warehouse + w.product_code
	AND			w.order_date  between @StartDate and @EndDate
	--AND			d.code = 'FG030023'
	AND			bm.component_whouse = 'BK'
	AND			d.resource_code in ('HP01','HP02','HP03')
	UNION
	SELECT		1 as Stage, 'MAN LAB' as WorkCentreGroup, sum((d.time_per_batchsize * CAST(RIGHT(LTRIM(RTRIM(d.operator_code)), 1) AS INT))) AS WorkTime
	--SELECT		order_date, d.time_per_batchsize, d.operator_code, RIGHT(LTRIM(RTRIM(d.operator_code)), 1) AS Crewe, (d.time_per_batchsize * CAST(RIGHT(LTRIM(RTRIM(d.operator_code)), 1) AS INT)) AS Mins
	--SELECT		*
	FROM		scheme.wsroutdm d WITH(NOLOCK) 
	--INNER JOIN	scheme.bmassdm bm WITH(NOLOCK) 
	--ON			d.code = bm.assembly_warehouse +bm.product_code
	INNER JOIN	scheme.bmwohm w WITH(NOLOCK) 
	ON			d.code = w.warehouse + w.product_code
	AND			w.order_date  between @StartDate and @EndDate
	--AND			d.code = 'FG030023'
	--AND			bm.component_whouse = 'BK'
	AND			d.resource_code LIKE ('MN%')
)	x
group by	Stage, WorkCentreGroup
order by	Stage



--DECLARE @StartDate DateTime = '2015-04-21 00:00:00'--(getDate()+4)
--DECLARE @StartDate DateTime =  (getDate()+4)
--DECLARE @EndDate DateTime = (@StartDate + 6)

SELECT		Stage, CAST(@StartDate AS VARCHAR(12)) AS WeekCommencing, CAST(@EndDate AS VARCHAR(12)) WeekEnding,  WorkCentreGroup,  Insight.dbo.fn_IntToTime(SUM(WorkTime)) AS WorkHours 
FROM	(
SELECT		2 AS Stage,	g.WorkCentreGroup, SUM(ws.run_time *  CAST(RIGHT(LTRIM(RTRIM(ws.run_skill_needed)), 1) AS INT)) AS WorkTime
FROM		scheme.wswopm ws WITH(NOLOCK) 
INNER JOIN	scheme.bmwohm wo WITH(NOLOCK) 
ON			ws.works_order = wo.works_order
INNER JOIN	syslive.dbo.GroupedWorkCentre g WITH(NOLOCK) 
ON			ws.machine_group = g.WorkCentre 
WHERE		(wo.order_date BETWEEN CAST(@StartDate AS DATE) AND CAST(@EndDate AS DATE))
AND			ws.machine_group NOT LIKE ('MN%')
AND			ws.machine_group NOT IN ('HP01','HP02','HP03','HP52','HP51')
--AND			ws.works_order IN ('KZ02','KZ03','KZ04','KZ05','KZ06','KZ07')
GROUP BY	g.WorkCentreGroup
UNION ALL
SELECT		2 AS Stage, 'HPD1' AS WorkCentreGroup,  sum((ws.run_time * CAST(RIGHT(LTRIM(RTRIM(ws.run_skill_needed)), 1) AS INT))) AS WorkTime	
FROM		scheme.wswopm ws WITH(NOLOCK) 
INNER JOIN	scheme.bmwohm wo WITH(NOLOCK) 
ON			ws.works_order = wo.works_order
AND			wo.order_date BETWEEN CAST(@StartDate AS DATE) AND CAST(@EndDate AS DATE)
--AND			ws.works_order IN ('KZ02','KZ03','KZ04','KZ05','KZ06','KZ07')
AND			ws.machine_group in ('HP01','HP02','HP03','HP52','HP51')
UNION ALL
SELECT		1 AS Stage, 'MAN LAB' AS WorkCentreGroup, sum((ws.run_time * CAST(RIGHT(LTRIM(RTRIM(ws.run_skill_needed)), 1) AS INT))) AS WorkTime
FROM		scheme.wswopm ws WITH(NOLOCK) 
INNER JOIN	scheme.bmwohm wo WITH(NOLOCK) 
ON			ws.works_order = wo.works_order
WHERE		wo.order_date BETWEEN CAST(@StartDate AS DATE) AND CAST(@EndDate AS DATE)
AND			ws.machine_group LIKE ('MN%')) r
GROUP		BY Stage, WorkCentreGroup 
ORDER		by Stage
RETURN
--SELECT		2 AS Stage,	g.WorkCentreGroup, SUM(ws.run_time *  CAST(RIGHT(LTRIM(RTRIM(ws.run_skill_needed)), 1) AS INT)) AS WorkTime
--FROM		scheme.wswopm ws WITH(NOLOCK) 
--INNER JOIN	scheme.bmwohm wo WITH(NOLOCK) 
--ON			ws.works_order = wo.works_order
--INNER JOIN	syslive.dbo.GroupedWorkCentre g WITH(NOLOCK) 
--ON			ws.machine_group = g.WorkCentre 
--WHERE		(wo.order_date BETWEEN CAST(@StartDate AS DATE) AND CAST(@EndDate AS DATE)) 
--AND			wo.works_order = 'KV22A'
--GROUP BY	g.WorkCentreGroup

--SELECT * 
--FROM		scheme.wswopm ws WITH(NOLOCK) 
--INNER JOIN	scheme.bmwohm wo WITH(NOLOCK) 
--ON			ws.works_order = wo.works_order
--INNER JOIN	syslive.dbo.GroupedWorkCentre g WITH(NOLOCK) 
--ON			ws.machine_group = g.WorkCentre 
--WHERE		(wo.order_date  between @StartDate  and @EndDate)
--AND			wo.works_order = 'KV22A'
--GROUP BY	g.WorkCentreGroup


--SELECT		*
--FROM		scheme.wswopm ws WITH(NOLOCK) 
--INNER JOIN	scheme.bmwohm wo WITH(NOLOCK) 
--ON			ws.works_order = wo.works_order
--WHERE		wo.order_date  between @StartDate and @EndDate
----AND			ws.machine_group in ('HP01','HP02','HP03')
--ORDER BY	wo.works_order



----SELECT		g.WorkCentreGroup,	ws.works_order, name, ws.description, ws.batch_size, wo.batch_size, quantity_required, run_time, machine_group, run_skill_needed as crew, quantity_expected, warehouse
--SELECT		@StartDate, @EndDate, wo.works_order, order_date, run_time, machine_group, run_skill_needed as crew, ws.description
--FROM		scheme.wswopm ws WITH(NOLOCK) 
--INNER JOIN	scheme.bmwohm wo WITH(NOLOCK) 
--ON			ws.works_order = wo.works_order
--AND			ws.machine_group in ('HP01','HP02','HP03','HP52','HP51')
----AND			bm.component_whouse  ='BK'
--AND			ws.works_order IN ('KZ02','KZ03','KZ04','KZ05','KZ06','KZ07')
--ORDER BY	wo.works_order

SELECT *
FROM		scheme.wswopm ws WITH(NOLOCK) 
INNER JOIN	scheme.bmwohm wo WITH(NOLOCK) 
ON			ws.works_order = wo.works_order
WHERE		wo.order_date  BETWEEN CAST(@StartDate AS DATE) AND CAST(@EndDate AS DATE)
AND			ws.works_order IN ('KZ02','KZ03','KZ04','KZ05','KZ06','KZ07')
--and			ws.machine_group in ('HP01','HP02','HP03','HP52','HP51')

--select distinct UPPER(machine_name), machine_group from scheme.wswopm where UPPER(machine_name) like 'ZOFLORA%'
select Insight.dbo.fn_IntToTime(3113)

