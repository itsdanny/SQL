USE Insight
GO
/****** Object:  StoredProcedure dbo.sp_WorkCentreJobData    Script Date: 18/03/2015 12:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE sp_WorkCentreReportData
@FromDate		DATETIME,
@ToDate			DATETIME,
@WorkCentreId	INT = NULL,
@AreaId			INT
--		
AS
-- select * from WorkCentre where AreaId in(1,2)

IF @WorkCentreId = 0
BEGIN
	SET @WorkCentreId = NULL
END;

SELECT		a.Name AS AreaName, 
			w.Name AS WorkCentreName, 
			w.SageRef, 
			j.WorkOrderNumber, 
			J.Product,
			j.Description, 
			j.WorkCrewe, 						
			s.Id AS Stage,
			s.Name AS StageName,
			(l.StandardRuntime) AS StandardJobTime, 
			(l.StageRuntime) AS StageTime, 
			J.WorkCentreJobBatchSize AS BatchSize,			
			--ISNULL((SELECT COUNT(DISTINCT d.EmpRef)	FROM WorkCentreJobLogLabourDetail d WHERE d.WorkCentreJobLogId = l.Id) ,0) AS ActualCrewe,
			(ISNULL((SELECT sum(d.TotalNumberOfMinutes) FROM WorkCentreJobEventLog d WHERE d.WorkCentreJobId = j.Id AND d.WorkCentreEventId = 2) ,0)) AS BreakDown,
			(ISNULL((SELECT sum(d.TotalNumberOfMinutes) FROM WorkCentreJobEventLog d WHERE d.WorkCentreJobId = j.Id AND d.WorkCentreEventId = 3) ,0)) AS Waiting,
			(ISNULL((SELECT sum(d.TotalNumberOfMinutes) FROM WorkCentreJobEventLog d WHERE d.WorkCentreJobId = j.Id AND d.WorkCentreEventId = 12) ,0)) AS Paused,
			wo.quantity_finished AS QTY,
			uom.spare AS UOM into #Results
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
WHERE		(l.FinishDateTime IS NOT NULL)
AND			(@WorkCentreId IS NULL OR w.Id = @WorkCentreId)
AND			(w.AreaId = @AreaId) 
AND			(CAST(l.StartDateTime AS DATE) BETWEEN @FromDate AND @ToDate
OR			CAST(l.FinishDateTime AS DATE) BETWEEN @FromDate AND @ToDate)
AND			(l.WorkCentreStageId = 1)

SELECT * INTO #RES FROM
(SELECT		j.Id,
			r.WorkOrderNumber, 
			r.Product,
			r.Description, 
			r.WorkCrewe, 		
			--r.ActualCrewe,	
			MIN(StartDateTime) AS StartDateTime,
			MAX(FinishDateTime) AS FinishDateTime,
			Stage,
			StageName,
			StandardJobTime, 
			SUM(StageTime) AS StageTime,
			MAX(QTY) AS BatchSize,			
			SUM(BreakDown) AS BreakDown,
			SUM(Waiting) AS Waiting,
			SUM(Paused) AS Paused,
			SUM(StageTime - (BreakDown + Waiting + Paused)) AS ActualJobTime,
			CEILING(MAX(QTY*UOM)/SUM(StageTime - (BreakDown + Waiting + Paused))) AS BPM
FROM		#Results r
INNER JOIN	WorkCentreJob J
ON			r.WorkOrderNumber = j.WorkOrderNumber
INNER JOIN	WorkCentreJobLog l
ON			l.WorkCentreJobId = j.Id
WHERE		(CAST(l.StartDateTime AS DATE) BETWEEN @FromDate AND @ToDate
OR			CAST(l.FinishDateTime AS DATE) BETWEEN @FromDate AND @ToDate)
GROUP BY	j.id, AreaName, WorkCentreName, SageRef, r.WorkOrderNumber, r.Product, r.Description, r.WorkCrewe, Stage, StageName, StandardJobTime, BatchSize
HAVING		SUM(StageTime - (BreakDown + Waiting + Paused)) > 0
UNION ALL
SELECT		j.Id,
			j.WorkOrderNumber, 
			j.Product,
			j.Description, 
			j.WorkCrewe, 						
			--0 AS ActualCrewe,			
			l.StartDateTime,
			l.FinishDateTime,
			s.Id AS Stage,
			s.Name AS StageName,
			(l.StandardRuntime) AS StandardJobTime, 
			(l.StageRuntime) AS StageTime, 
			0 AS BatchSize,						
			(ISNULL((SELECT sum(d.TotalNumberOfMinutes) FROM WorkCentreJobEventLog d WHERE d.WorkCentreJobId = j.Id AND d.WorkCentreEventId = 2) ,0)) AS BreakDown,
			(ISNULL((SELECT sum(d.TotalNumberOfMinutes) FROM WorkCentreJobEventLog d WHERE d.WorkCentreJobId = j.Id AND d.WorkCentreEventId = 3) ,0)) AS Waiting,
			(ISNULL((SELECT sum(d.TotalNumberOfMinutes) FROM WorkCentreJobEventLog d WHERE d.WorkCentreJobId = j.Id AND d.WorkCentreEventId = 12) ,0)) AS Paused,
			l.StageRuntime - (ISNULL((SELECT SUM(d.TotalNumberOfMinutes) FROM WorkCentreJobEventLog d WHERE d.WorkCentreJobId = j.Id AND d.WorkCentreEventId in (2,3,12)), 0)) AS ActualJobTime,
			0 AS BPM			
FROM		WorkCentre w
INNER JOIN	Area a
ON			w.AreaId = a.Id
INNER JOIN	WorkCentreJob j
ON			w.Id = j.WorkCentreId
INNER JOIN	WorkCentreJobLog l
ON			j.Id = l.WorkCentreJobId
INNER JOIN	WorkCentreStage s
ON			l.WorkCentreStageId = s.Id
WHERE		(l.FinishDateTime is not null)
AND			(@WorkCentreId is null or w.Id = @WorkCentreId)
AND			(w.AreaId = @AreaId) 
AND			(CAST(l.StartDateTime AS DATE) BETWEEN @FromDate AND @ToDate
OR			CAST(l.FinishDateTime AS DATE) BETWEEN @FromDate AND @ToDate)
AND			(l.WorkCentreStageId <> 1)) AS RES
ORDER BY    StartDateTime

-- WITHIN StandardJobTime
SELECT Id, WorkOrderNumber, Product, Description, dbo.fn_IntToTime(StandardJobTime) as StandardJobTime, dbo.fn_IntToTime(ActualJobTime) as ActualJobTime, WorkCrewe, 
	CASE WHEN Paused > 0 THEN 'P:' + dbo.fn_IntToTime(Paused) + ' ' ELSE '' END + 
	CASE WHEN BreakDown > 0 THEN 'B:' + dbo.fn_IntToTime(BreakDown) + ' ' ELSE '' END + 
	CASE WHEN Waiting > 0 THEN 'W: ' + dbo.fn_IntToTime(Waiting) + ' ' ELSE '' END AS Stoppages, 
	Paused, BreakDown, Waiting, 
	Stage, BPM
	FROM #RES WHERE ActualJobTime < StandardJobTime

-- OVER StandardJobTime
SELECT Id, WorkOrderNumber, Product, Description, dbo.fn_IntToTime(StandardJobTime) as StandardJobTime, dbo.fn_IntToTime(ActualJobTime) as ActualJobTime, WorkCrewe, 
	CASE WHEN Paused > 0 THEN 'P:' + dbo.fn_IntToTime(Paused) + ' ' ELSE '' END + 
	CASE WHEN BreakDown > 0 THEN 'B:' + dbo.fn_IntToTime(BreakDown) + ' ' ELSE '' END + 
	CASE WHEN Waiting > 0 THEN 'W: ' + dbo.fn_IntToTime(Waiting) + ' ' ELSE '' END AS Stoppages, 
	Paused, BreakDown, Waiting, 
	Stage, BPM
	FROM #RES WHERE ActualJobTime > StandardJobTime

-- BREAKDOWNS
SELECT Id, WorkOrderNumber, Product, Description, dbo.fn_IntToTime(StandardJobTime) as StandardJobTime, dbo.fn_IntToTime(ActualJobTime) as ActualJobTime, WorkCrewe, 	
	CASE WHEN Paused > 0 THEN 'P:' + dbo.fn_IntToTime(Paused) + ' ' ELSE '' END + 
	CASE WHEN BreakDown > 0 THEN 'B:' + dbo.fn_IntToTime(BreakDown) + ' ' ELSE '' END + 
	CASE WHEN Waiting > 0 THEN 'W: ' + dbo.fn_IntToTime(Waiting) + ' ' ELSE '' END AS Stoppages, 
	BreakDown
	Stage, BPM FROM #RES WHERE BreakDown > 0

-- CHANGEOVERS
SELECT Id, Description, StartDateTime, FinishDateTime, dbo.fn_IntToTime(StandardJobTime) as StandardJobTime, dbo.fn_IntToTime(StageTime) as ActualJobTime, Stage,
		CASE WHEN Paused > 0 THEN 'P:' + dbo.fn_IntToTime(Paused) + ' ' ELSE '' END + 
		CASE WHEN BreakDown > 0 THEN 'B:' + dbo.fn_IntToTime(BreakDown) + ' ' ELSE '' END + 
		CASE WHEN Waiting > 0 THEN 'W: ' + dbo.fn_IntToTime(Waiting) + ' ' ELSE '' END AS Stoppages
FROM #RES WHERE Stage = 2

-- REWORKS
SELECT WorkOrderNumber, Product, Description, StartDateTime, FinishDateTime, BatchSize FROM #RES WHERE Stage = 3

go

sp_WorkCentreReportData '2015-02-01 00:00:00','2015-02-28', 17, 1

