update		j
SET			j.MinBPM = mpr.PlanStandard
FROM		syslive.scheme.bmwohm swo WITH(NOLOCK)  
INNER JOIN	scheme.stunitdm su WITH(NOLOCK)  
ON			su.unit_code = swo.finish_prod_unit
LEFT JOIN	syslive.scheme.wswopm sr WITH(NOLOCK)  
ON			(swo.works_order = sr.works_order) 
LEFT JOIN	MachineTracker.dbo.Product mp WITH(NOLOCK) 
ON			swo.product_code = mp.ProductCode COLLATE Latin1_General_CI_AS
LEFT JOIN	MachineTracker.dbo.Process mpr WITH(NOLOCK) 
ON			mp.ID = mpr.ProductID 
AND			mpr.operation_code IN (1010,2010,3010)
AND			mpr.line_number not like '%A' -- Alternate Route
AND			mpr.IsCosting = 1
AND		    mpr.IsCurrent = 1
INNER JOIN	syslive.scheme.wsskm c 
ON			c.code = left(sr.run_skill_needed,3)+'1'
INNER JOIN 	Insight.dbo.WorkCentreJob j
ON			j.WorkOrderNumber = swo.works_order  COLLATE Latin1_General_CI_AS
WHERE		j.MinBPM <> mpr.PlanStandard

update		j
SET			j.MaxBPM = mpr.IdealStandard
FROM		syslive.scheme.bmwohm swo WITH(NOLOCK)  
INNER JOIN	scheme.stunitdm su WITH(NOLOCK)  
ON			su.unit_code = swo.finish_prod_unit
LEFT JOIN	syslive.scheme.wswopm sr WITH(NOLOCK)  
ON			(swo.works_order = sr.works_order) 
LEFT JOIN	MachineTracker.dbo.Product mp WITH(NOLOCK) 
ON			swo.product_code = mp.ProductCode COLLATE Latin1_General_CI_AS
LEFT JOIN	MachineTracker.dbo.Process mpr WITH(NOLOCK) 
ON			mp.ID = mpr.ProductID 
AND			mpr.operation_code IN (1010,2010,3010)
AND			mpr.line_number not like '%A' -- Alternate Route
AND			mpr.IsCosting = 1
AND		    mpr.IsCurrent = 1
INNER JOIN	syslive.scheme.wsskm c 
ON			c.code = left(sr.run_skill_needed,3)+'1'
INNER JOIN 	Insight.dbo.WorkCentreJob j
ON			j.WorkOrderNumber = swo.works_order  COLLATE Latin1_General_CI_AS
WHERE		j.MaxBPM <> mpr.IdealStandard


SELECT		j.WorkOrderNumber, j.Product,
			mpr.PlanStandard, j.MinBPM, 
			mpr.IdealStandard, j.MaxBPM
FROM		syslive.scheme.bmwohm swo WITH(NOLOCK)  
INNER JOIN	scheme.stunitdm su WITH(NOLOCK)  
ON			su.unit_code = swo.finish_prod_unit
LEFT JOIN	syslive.scheme.wswopm sr WITH(NOLOCK)  
ON			(swo.works_order = sr.works_order) 
LEFT JOIN	MachineTracker.dbo.Product mp WITH(NOLOCK) 
ON			swo.product_code = mp.ProductCode COLLATE Latin1_General_CI_AS
LEFT JOIN	MachineTracker.dbo.Process mpr WITH(NOLOCK) 
ON			mp.ID = mpr.ProductID 
AND			mpr.operation_code IN (1010,2010,3010)
AND			mpr.line_number not like '%A' -- Alternate Route
AND			mpr.IsCosting = 1
AND		    mpr.IsCurrent = 1
INNER JOIN	syslive.scheme.wsskm c 
ON			c.code = left(sr.run_skill_needed,3)+'1'
INNER JOIN 	Insight.dbo.WorkCentreJob j
ON			j.WorkOrderNumber = swo.works_order  COLLATE Latin1_General_CI_AS
WHERE		j.MinBPM <> mpr.PlanStandard
--AND			j.Product ='008575'
ORDER BY	1
RETURN
--008575
/*
 --scheme.[sp_getRouteInfoForInsight_test] 'RR85B'
SELECT		COALESCE(sr.machine_group, '') As Line, 
			swo.warehouse, 
			product_code, 
			sr.works_order, 
			swo.description, 
			swo.quantity_required,
			Ceiling(COALESCE(CAST((sr.run_time/sr.batch_size)*swo.quantity_required AS FLOAT), 0)) As StandardRunTime,
			COALESCE(sr.run_skill_needed,'0') AS operator_code,
			CAST(ISNULL(mpr.PlanStandard, 0) AS INT) AS MinBPM, 
			CAST(ISNULL(mpr.IdealStandard, 0) AS INT) AS MaxBPM,
			su.spare as UOM,
			Max(c.std_labour_rate) as HourlyRate INTO #TMP
FROM		syslive.scheme.bmwohm swo WITH(NOLOCK)  
INNER JOIN	scheme.stunitdm su WITH(NOLOCK)  
ON			su.unit_code = swo.finish_prod_unit
LEFT JOIN	syslive.scheme.wswopm sr WITH(NOLOCK)  
ON			(swo.works_order = sr.works_order) 
LEFT JOIN	MachineTracker.dbo.Product mp WITH(NOLOCK) 
ON			swo.product_code = mp.ProductCode COLLATE Latin1_General_CI_AS
LEFT JOIN	MachineTracker.dbo.Process mpr WITH(NOLOCK) 
ON			mp.ID = mpr.ProductID 
AND			mpr.operation_code IN (1010,2010,3010)
AND			mpr.line_number not like '%A' -- Alternate Route
AND			mpr.IsCosting = 1
AND		    mpr.IsCurrent = 1
INNER JOIN	syslive.scheme.wsskm c 
ON			c.code = left(sr.run_skill_needed,3)+'1'
WHERE		(sr.works_order = @WorkOrderNumber) 
AND			(@Operation  is null or op_lookup_key = @Operation)
GROUP BY	swo.warehouse, product_code, sr.works_order, swo.description, sr.batch_size, sr.run_skill_needed, sr.machine_group,swo.quantity_required, run_time, sr.batch_size, mpr.PlanStandard, mpr.IdealStandard, su.spare, mpr.CostStandard

SELECT @MinBPM = MIN(MinBPM), @MaxBPM = MIN(MaxBPM) from #TMP
/*
drop table  #TMP

SELECT * FROM #TMP
*/
IF @MinBPM = 0 OR @MaxBPM = 0
BEGIN
	-- Get the AVG 
	SELECT	@MinBPM = ISNULL(AVG(PlanStandard), 0), @MaxBPM = ISNULL(AVG(IdealStandard), 0)
	--SELECT		AVG(mpr.PlanStandard),AVG(mpr.IdealStandard)
	FROM		MachineTracker.dbo.Process mpr WITH(NOLOCK) 
	INNER JOIN	MachineTracker.dbo.Product mp WITH(NOLOCK) 
	ON			mp.ID = mpr.ProductID 	
	INNER JOIN  #TMP t
	ON			t.product_code = mp.ProductCode COLLATE Latin1_General_CI_AS	
	WHERE		(mpr.IsCosting = 1 or mpr.IsCurrent = 1)
	AND			mpr.line_number not like '%A' -- Alternate Route
	AND			(t.MaxBPM = 0 or t.MinBPM = 0)
	
	UPDATE #TMP SET MinBPM = @MinBPM WHERE  MinBPM = 0
	UPDATE #TMP SET MaxBPM = @MaxBPM WHERE  MaxBPM = 0		
END

SELECT * FROM #TMP


*/