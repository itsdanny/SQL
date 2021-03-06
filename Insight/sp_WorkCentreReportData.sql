USE [Insight]
GO
/****** Object:  StoredProcedure [dbo].[sp_WorkCentreReportData]    Script Date: 24/07/2015 12:57:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp_WorkCentreReportData]
@FromDate		DATETIME,
@ToDate			DATETIME,
@WorkCentreId	INT = NULL
--		
AS
-- select * from WorkCentre where AreaId in(1,2)
--	sp_WorkCentreReportData '2015-04-01 00:00:00','2015-04-30 00:00:00', 12
IF @WorkCentreId = 0
BEGIN
	SET @WorkCentreId = NULL
END;

SELECT		a.Name AS AreaName, 
			w.Name AS WorkCentreName, 
			w.SageRef, 
			j.Id,
			j.WorkOrderNumber, 
			J.Product,
			j.Description, 
			j.WorkCrewe, 						
			s.Id AS Stage,
			s.Name AS StageName,
			(l.StandardRuntime) AS StandardJobTime, 
			MAX(j.WorkCentreJobRuntime) AS WorkCentreJobRuntime, 
			J.WorkCentreJobBatchSize AS BatchSize,			
			MIN(StartDateTime) AS StartDateTime,
			MAX(FinishDateTime) AS FinishDateTime,			
			(ISNULL((SELECT sum(d.TotalNumberOfMinutes) FROM WorkCentreJobEventLog d WHERE d.WorkCentreJobId = j.Id AND d.WorkCentreEventId = 2) ,0)) AS BreakDown,
			(ISNULL((SELECT sum(d.TotalNumberOfMinutes) FROM WorkCentreJobEventLog d WHERE d.WorkCentreJobId = j.Id AND d.WorkCentreEventId in (3)) ,0)) AS Waiting,			
			wo.quantity_finished AS QTY,
			uom.spare AS UOM,
			MAX(j.MinBPM) AS StandardBPM,
			MAX(l.BPM) AS ActualBPM,
			0 AS PerformanceHit,
			MAX(j.JobCost) AS CostVariance,
			CAST(AVG(l.JobPerformance) AS FLOAT) AS JobPerformance
			INTO #Results
FROM		WorkCentre w
INNER JOIN	Area a
ON			w.AreaId = a.Id
INNER JOIN	WorkCentreJob j
ON			w.Id = j.WorkCentreId
INNER JOIN	WorkCentreJobLog l
ON			j.Id = l.WorkCentreJobId
INNER JOIN	WorkCentreStage s
ON			l.WorkCentreStageId = s.Id
LEFT JOIN	syslive.scheme.bmwohm wo WITH(NOLOCK) 
ON			j.WorkOrderNumber = wo.works_order COLLATE Latin1_General_BIN
LEFT JOIN	syslive.scheme.stunitdm uom WITH(NOLOCK) 
ON			wo.finish_prod_unit = uom.unit_code
INNER JOIN  syslive.scheme.wsskm c 
ON			a.CostCentreCode = c.code collate Latin1_General_BIN
WHERE		(l.FinishDateTime IS NOT NULL)
AND			(@WorkCentreId IS NULL OR w.Id = @WorkCentreId)
AND			(CAST(l.StartDateTime AS DATE) BETWEEN @FromDate AND @ToDate)
AND			(l.WorkCentreStageId = 1)
GROUP BY	a.Name, w.Name, w.SageRef, j.WorkOrderNumber, j.Product, j.Description, j.WorkCrewe, s.Id, s.Name, WorkCentreJobBatchSize, wo.quantity_finished, wo.quantity_finished, l.StandardRuntime, j.Id, uom.spare, j.WorkCentreJobRuntime, c.std_labour_rate --, l.ActualBPM

SELECT * INTO #RES FROM
(SELECT		r.Id,
			r.WorkOrderNumber, 
			r.Product,
			r.Description, 
			r.WorkCrewe, 					
			StartDateTime AS StartDateTime,
			FinishDateTime AS FinishDateTime,
			Stage,
			StageName,
			StandardJobTime, 
			WorkCentreJobRuntime,
			QTY AS BatchSize,			
			BreakDown AS BreakDown,
			Waiting AS Waiting,			
			r.StandardBPM,
			r.ActualBPM,
			0 as PerformanceHit,
			CostVariance,
			JobPerformance
FROM		#Results r
UNION ALL
SELECT		j.Id,
			j.WorkOrderNumber, 
			j.Product,
			j.Description, 
			j.WorkCrewe, 						
			l.StartDateTime,
			l.FinishDateTime,
			s.Id AS Stage,
			s.Name AS StageName,
			(l.StandardRuntime) AS StandardJobTime, 
			j.WorkCentreJobRuntime AS WorkCentreJobRuntime, 
			0 AS BATCHSIZE,						
			(ISNULL((SELECT sum(d.TotalNumberOfMinutes) FROM WorkCentreJobEventLog d WHERE d.WorkCentreJobId = j.Id AND d.WorkCentreEventId = 2) ,0)) AS BreakDown,
			(ISNULL((SELECT sum(d.TotalNumberOfMinutes) FROM WorkCentreJobEventLog d WHERE d.WorkCentreJobId = j.Id AND d.WorkCentreEventId in (3)) ,0)) AS Waiting,		
			0 as StandardBPM,
			0 AS ActualBPM,			
			0 AS PerformanceHit,
			j.JobCost AS CostVariance,
			l.JobPerformance	
FROM		WorkCentre w
INNER JOIN	Area a
ON			w.AreaId = a.Id
INNER JOIN	WorkCentreJob j
ON			w.Id = j.WorkCentreId
INNER JOIN	WorkCentreJobLog l
ON			j.Id = l.WorkCentreJobId
INNER JOIN	WorkCentreStage s
ON			l.WorkCentreStageId = s.Id
INNER JOIN  syslive.scheme.wsskm c 
ON			a.CostCentreCode = c.code collate Latin1_General_BIN
WHERE		(l.FinishDateTime is not null)
AND			(@WorkCentreId is null or w.Id = @WorkCentreId)
AND			(CAST(l.StartDateTime AS DATE) BETWEEN @FromDate AND @ToDate)
AND			(l.WorkCentreStageId = 2)
AND			 j.WorkCentreJobRuntime > 0
) AS RES
ORDER BY    StartDateTime


-- ALL WORK ORDERS
SELECT		Id, WorkOrderNumber, Product, Description, dbo.fn_IntToTime(StandardJobTime) AS StandardJobTime, dbo.fn_IntToTime(WorkCentreJobRuntime) AS ActualJobTime, 
			CostVariance,
			ROUND((CAST(StandardJobTime AS FLOAT)/WorkCentreJobRuntime), 2) * 100 AS BatchPercent, WorkCrewe, 
			CASE WHEN Waiting > 0 THEN 'W:' + dbo.fn_IntToTime(Waiting) + ' ' ELSE '' END + 
			CASE WHEN BreakDown > 0 THEN 'B:' + dbo.fn_IntToTime(BreakDown) + ' ' ELSE '' END AS Stoppages, 
			BreakDown, Waiting, 
			Stage, StandardBPM, ActualBPM, StartDateTime, FinishDateTime, ROUND(JobPerformance, 2) * 100 AS JobPerformance, 'ALL'
FROM		#RES  
WHERE		Stage = 1
ORDER BY	#RES.StartDateTime


-- WITHIN StandardJobTime
SELECT		Id, WorkOrderNumber, Product, Description, 
			dbo.fn_IntToTime(StandardJobTime) AS StandardJobTime, dbo.fn_IntToTime(WorkCentreJobRuntime) AS ActualJobTime, 
			CostVariance,
			ROUND((CAST(StandardJobTime AS FLOAT)/CAST(WorkCentreJobRuntime AS DECIMAL(8,2))),2)*100 AS BatchPercent,
			WorkCrewe,
			CASE WHEN Waiting > 0 THEN 'W:' + dbo.fn_IntToTime(Waiting) + ' ' ELSE '' END + 
			CASE WHEN BreakDown > 0 THEN 'B:' + dbo.fn_IntToTime(BreakDown) + ' ' ELSE '' END AS Stoppages, 
			BreakDown, Waiting, 
			Stage, StandardBPM, ActualBPM, StartDateTime, FinishDateTime, ROUND(JobPerformance, 2) * 100 AS JobPerformance, '<'
FROM		#RES 
WHERE		ROUND((CAST(StandardJobTime AS FLOAT)/WorkCentreJobRuntime), 2) * 100 >= 95
AND			Stage = 1
ORDER BY	#RES.StartDateTime


-- OVER StandardJobTime
SELECT		Id, WorkOrderNumber, Product, Description, dbo.fn_IntToTime(StandardJobTime) AS StandardJobTime, dbo.fn_IntToTime(WorkCentreJobRuntime) AS ActualJobTime, 
			CostVariance,
			ROUND((CAST(StandardJobTime AS FLOAT)/WorkCentreJobRuntime),2) * 100 AS BatchPercent, WorkCrewe, 
			CASE WHEN Waiting > 0 THEN 'W:' + dbo.fn_IntToTime(Waiting) + ' ' ELSE '' END + 
			CASE WHEN BreakDown > 0 THEN 'B:' + dbo.fn_IntToTime(BreakDown) + ' ' ELSE '' END AS Stoppages, 
			BreakDown, Waiting, 
			Stage, StandardBPM, ActualBPM, StartDateTime, FinishDateTime, ROUND(JobPerformance, 2) * 100 AS JobPerformance, '>'
FROM		#RES 
WHERE		ROUND((CAST(StandardJobTime AS FLOAT)/WorkCentreJobRuntime), 2) * 100 < 95
AND			Stage = 1
ORDER BY	#RES.StartDateTime

-- BREAKDOWNS
SELECT		Id, WorkOrderNumber, Product, Description, dbo.fn_IntToTime(StandardJobTime) AS StandardJobTime, dbo.fn_IntToTime(WorkCentreJobRuntime) AS ActualJobTime, 
			CostVariance,
			ROUND((CAST(StandardJobTime AS FLOAT))/WorkCentreJobRuntime,2)*100  AS BatchPercent, WorkCrewe, 	
			CASE WHEN Waiting > 0 THEN 'W:' + dbo.fn_IntToTime(Waiting) + ' ' ELSE '' END + 
			CASE WHEN BreakDown > 0 THEN 'B:' + dbo.fn_IntToTime(BreakDown) + ' ' ELSE '' END AS Stoppages, 
			BreakDown,
			Stage, StandardBPM, ActualBPM , StartDateTime, FinishDateTime, 	ROUND(JobPerformance, 2) * 100 AS JobPerformance, 'BD'
FROM		#RES 
WHERE		BreakDown > 0
ORDER BY	#RES.StartDateTime

-- CHANGEOVERS
SELECT		Id, WorkOrderNumber, Description, StartDateTime, FinishDateTime, dbo.fn_IntToTime(StandardJobTime) AS StandardJobTime, dbo.fn_IntToTime(WorkCentreJobRuntime) AS ActualJobTime, 
			CostVariance,
			ROUND((CAST(StandardJobTime AS FLOAT)/WorkCentreJobRuntime),2)*100  AS BatchPercent, Stage,
			CASE WHEN Waiting > 0 THEN 'W:' + dbo.fn_IntToTime(Waiting) + ' ' ELSE '' END + 
			CASE WHEN BreakDown > 0 THEN 'B:' + dbo.fn_IntToTime(BreakDown) + ' ' ELSE '' END AS Stoppages, 
			StartDateTime, FinishDateTime, ROUND(JobPerformance, 2) * 100 AS JobPerformance, 'CO'
FROM		#RES 
WHERE		Stage = 2
ORDER BY	#RES.StartDateTime

-- REWORKS
SELECT		WorkOrderNumber, Product, Description, StartDateTime, FinishDateTime, BatchSize, StartDateTime, FinishDateTime, 'RW' FROM #RES WHERE Stage = 3
ORDER BY	Id

--SELECT ROUND(SUM(CASE WHEN WorkCentreJobRuntime < StandardJobTime*.95 THEN 1.00 ELSE 0.00 END)/count(1)*100, 2) AS Performance FROM #RES WHERE Stage IN (1,2)
SELECT AVG(JobPerformance)*100 AS Performance FROM #RES WHERE Stage IN (1,2)

UPDATE #RES SET PerformanceHit = 1 WHERE (WorkCentreJobRuntime* .95) < StandardJobTime 

	-- JOB TIME BY WEEK..., THIS COULD GET NASTY!
	SELECT		StageName, 
				COALESCE(dbo.fn_IntToHours(SUM(ProductionMins)), 0) AS ProductionTime, 
				SUM(ProductionMins) AS ProductionMins, 
				Stage, 
				--CAST(StartDateTime AS DATE) AS StartDateTime, 
				WeekDay, PerformanceHit, 
				@FromDate AS FromDate, 
				@ToDate AS ToDate,
				f.Calendar_Date AS StartDateTime,
				JobPerformance,
				WorkOrderNumber,
				WorkOrderNumber + ' - ' + DateName(Day, f.Calendar_Date) + ' ' + UPPER(LEFT(DateName(MONTH, f.Calendar_Date), 3)) AS JobDate
				--ROUND(JobPerformance, 2) * 100 AS JobPerformance
	FROM		(
	SELECT		StageName, Stage, SUM(WorkCentreJobRuntime) AS ProductionMins, CAST(StartDateTime AS date) AS StartDateTime, DATENAME(WEEKDAY, StartDateTime) AS WeekDay,
				PerformanceHit, JobPerformance, WorkOrderNumber
	FROM		#RES
	WHERE		StageName = 'Production'
	GROUP BY	DATENAME(WEEKDAY, StartDateTime), Stage, StageName, CAST(StartDateTime AS date), PerformanceHit, JobPerformance, WorkOrderNumber
	UNION ALL
	SELECT		'Waiting' AS StageName, Stage,SUM(Waiting) AS ProductionMins, CAST(StartDateTime AS date) AS StartDateTime, DATENAME(WEEKDAY, StartDateTime) AS WeekDay,
				PerformanceHit, JobPerformance, WorkOrderNumber
	FROM		#RES
	WHERE		Waiting > 0
	GROUP BY	DATENAME(WEEKDAY, StartDateTime), Stage, StageName, CAST(StartDateTime AS date), PerformanceHit, JobPerformance, WorkOrderNumber
	UNION ALL
	SELECT		'BreakDown' AS StageName, Stage, SUM(BreakDown) AS ProductionMins, CAST(StartDateTime AS date) AS StartDateTime, DATENAME(WEEKDAY, StartDateTime) AS WeekDay,
				PerformanceHit, JobPerformance, WorkOrderNumber
	FROM		#RES
	WHERE		BreakDown > 0
	GROUP BY	DATENAME(WEEKDAY, StartDateTime), Stage, StageName, CAST(StartDateTime AS date), PerformanceHit, JobPerformance, WorkOrderNumber
	UNION ALL
	SELECT		StageName, Stage,SUM(WorkCentreJobRuntime) AS ProductionMins, CAST(StartDateTime AS date) AS StartDateTime, DATENAME(WEEKDAY, StartDateTime) AS WeekDay,
				PerformanceHit, JobPerformance, WorkOrderNumber
	FROM		#RES
	WHERE		StageName = 'Changeover'
	GROUP BY	DATENAME(WEEKDAY, StartDateTime), Stage, StageName, CAST(StartDateTime AS date), PerformanceHit, JobPerformance, WorkOrderNumber
	UNION ALL
	SELECT		StageName, Stage, SUM(WorkCentreJobRuntime) AS ProductionMins, CAST(StartDateTime AS date) AS StartDateTime, DATENAME(WEEKDAY, StartDateTime) AS WeekDay, PerformanceHit, JobPerformance, WorkOrderNumber
	FROM		#RES
	WHERE		StageName = 'Rework'
	GROUP BY	DATENAME(WEEKDAY, StartDateTime), Stage, StageName, CAST(StartDateTime AS date), PerformanceHit, JobPerformance, WorkOrderNumber
	) C
	right join dbo.fn_MasterCalender(@FromDate, @ToDate) f 
	ON			c.StartDateTime = f.Calendar_Date
	where		C.ProductionMins IS NOT NULL
	GROUP BY	Stage, StageName,  WeekDay, PerformanceHit, f.Calendar_Date, c.JobPerformance, c.WorkOrderNumber				
	ORDER BY	f.Calendar_Date, Stage, StageName--, StartDateTime

	--	select * from dbo.fn_MasterCalender('2015-05-22 00:00:00','2015-06-21 00:00:00')
	--SELECT * FROM #RES
--	select * from WorkCentre

go

sp_WorkCentreReportData '2015-07-29 00:00:00','2015-07-31 00:00:00', 17