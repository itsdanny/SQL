USE [Insight]
GO
/****** Object:  StoredProcedure [dbo].[sp_WorkCentreJobData]    Script Date: 27/04/2016 11:09:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp_WorkCentreJobData]
@FromDate		DATETIME,
@ToDate			DATETIME,
@WorkCentreId	INT = NULL,
@AreaId			INT
--		[sp_WorkCentreJobData] '2015-02-05','2015-06-05', 21, 1
AS
-- select * from WorkCentre where AreaId in(1,2)

IF @WorkCentreId = 0
BEGIN
	SET @WorkCentreId = NULL
END;

SELECT		j.Id AS JobId,
			a.Name AS AreaName, 
			w.Name AS WorkCentreName, 
			w.SageRef, 
			j.WorkOrderNumber, 
			j.Description,
			j.Product, 
			j.WorkCrewe, 						
			s.Id AS Stage,
			s.Name AS StageName,
			(l.StandardRuntime) AS [Standard], 
			--(l.StageRuntime) AS StageTime, -- THIS IS GETTING RECORDED WRONG IT SEEMS
			DATEDIFF(MINUTE,l.StartDateTime,l.FinishDateTime) AS StageTime, 
			J.WorkCentreJobBatchSize AS [BatchSize],
			--FLOOR(CASE WHEN StageRuntime > 0 THEN (wo.quantity_finished*uom.spare)/l.StageRuntime END) AS BPM,
			ISNULL((SELECT COUNT(DISTINCT d.EmpRef)	FROM WorkCentreJobLogLabourDetail d WHERE d.WorkCentreJobLogId = l.Id) ,0) AS ActualCrewe,
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

--ORDER BY	l.StartDateTime

SELECT * FROM(
SELECT		r.JobId, 
			r.AreaName, 
			WorkCentreName, 
			SageRef, 
			r.WorkOrderNumber, 
			r.Description, 
			j.Product,
			r.WorkCrewe, 			
			MIN(StartDateTime) AS StartDateTime,
			MAX(FinishDateTime) AS FinishDateTime,
			Stage,
			StageName,
			[Standard], 
			SUM(StageTime) AS StageTime,
			MAX(QTY) AS BatchSize,			
			SUM(BreakDown) AS BreakDown,
			SUM(Waiting) AS Waiting,
			SUM(Paused) AS Paused,
			SUM(StageTime - (BreakDown + Waiting + Paused)) AS ActualRuntime,
			CEILING(MAX(QTY*r.UOM)/SUM(StageTime - (BreakDown + Waiting + Paused))) AS BPM
FROM		#Results r
INNER JOIN	WorkCentreJob J
ON			r.JobId = j.Id
INNER JOIN	WorkCentreJobLog l
ON			l.WorkCentreJobId = j.Id
WHERE		(CAST(l.StartDateTime AS DATE) BETWEEN @FromDate AND @ToDate
OR			CAST(l.FinishDateTime AS DATE) BETWEEN @FromDate AND @ToDate)
GROUP BY	r.JobId,AreaName, WorkCentreName, SageRef, r.WorkOrderNumber, r.Description, j.Product, r.WorkCrewe, Stage, StageName, [Standard], [BatchSize]  	
HAVING		SUM(StageTime - (BreakDown + Waiting + Paused)) > 0
UNION ALL
SELECT		j.Id AS JobId,
			a.Name AS AreaName, 
			w.Name AS WorkCentreName, 
			w.SageRef, 
			j.WorkOrderNumber, 
			j.Description,
			j.Product, 
			j.WorkCrewe, 						
			l.StartDateTime,
			l.FinishDateTime,
			s.Id AS Stage,
			s.Name AS StageName,
			(l.StandardRuntime) AS [Standard], 
			(l.StageRuntime) AS StageTime, 
			0 AS [BatchSize],			
			--0 AS ActualCrewe,			
			(ISNULL((SELECT sum(d.TotalNumberOfMinutes) FROM WorkCentreJobEventLog d WHERE d.WorkCentreJobId = j.Id AND d.WorkCentreEventId = 2) ,0)) AS BreakDown,
			(ISNULL((SELECT sum(d.TotalNumberOfMinutes) FROM WorkCentreJobEventLog d WHERE d.WorkCentreJobId = j.Id AND d.WorkCentreEventId = 3) ,0)) AS Waiting,
			(ISNULL((SELECT sum(d.TotalNumberOfMinutes) FROM WorkCentreJobEventLog d WHERE d.WorkCentreJobId = j.Id AND d.WorkCentreEventId = 12) ,0)) AS Paused,
			l.StageRuntime - (ISNULL((SELECT SUM(d.TotalNumberOfMinutes) FROM WorkCentreJobEventLog d WHERE d.WorkCentreJobId = j.Id AND d.WorkCentreEventId in (2,3,12)), 0)) AS ActualRuntime,
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
AND			(l.WorkCentreStageId <> 1)) AS res
ORDER BY    StartDateTime
GO

SELECT DIFFERENCE(DATEDIFF(MINUTE, StartDateTime, FinishDateTime), StageRuntime),  DATEDIFF(MINUTE, StartDateTime, FinishDateTime),  StageRuntime FROM WorkCentreJobLog 
WHERE DIFFERENCE(DATEDIFF(MINUTE, StartDateTime, FinishDateTime), StageRuntime) <> 4
AND StartDateTime > '2015-01-01'

UPDATE WorkCentreJobLog SET StageRuntime =  DATEDIFF(MINUTE, StartDateTime, FinishDateTime) 
WHERE DIFFERENCE(DATEDIFF(MINUTE, StartDateTime, FinishDateTime), StageRuntime) <> 4
AND StartDateTime > '2015-01-01'


SELECT * FROM WorkCentreJobLog WHERE StageRuntime > 0 AND FinishDateTime IS NULL

SELECT * FROM WorkCentreJob WHERE ID = 19873