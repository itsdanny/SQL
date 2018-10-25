ALTER PROCEDURE sp_WorkCentreJobData
@FromDate		DATETIME,
@ToDate			DATETIME,
@WorkCentreId	INT

AS
SELECT		a.Name AS AreaName, 
			w.Name WorkCentreName, 
			w.SageRef, j.WorkOrderNumber, 
			j.Description, 
			j.WorkCrewe, 			
			l.StartDateTime, 
			l.FinishDateTime, 
			s.Name,
			dbo.fn_IntToTime(l.StandardRuntime) as [Standard], 
			dbo.fn_IntToTime(l.StageRuntime) As StageTime, 			
			--dbo.fn_IntToTime((l.StageRuntime - ISNULL((SELECT sum(d.TotalNumberOfMinutes) FROM WorkCentreJobEventLog d WHERE d.WorkCentreJobId = j.Id AND d.WorkCentreEventId = 12) ,0))) as JobMinusPaused,
			J.WorkCentreJobBatchSize as [BatchSize],
			l.BPM,
			ISNULL((SELECT COUNT(DISTINCT d.EmpRef)	FROM WorkCentreJobLogLabourDetail d WHERE d.WorkCentreJobLogId = l.Id) ,0) AS ActualCrewe,
			dbo.fn_IntToTime(ISNULL((SELECT sum(d.TotalNumberOfMinutes) FROM WorkCentreJobEventLog d WHERE d.WorkCentreJobId = j.Id AND d.WorkCentreEventId = 2) ,0)) AS BreakDown,
			dbo.fn_IntToTime(ISNULL((SELECT sum(d.TotalNumberOfMinutes) FROM WorkCentreJobEventLog d WHERE d.WorkCentreJobId = j.Id AND d.WorkCentreEventId = 3) ,0)) AS Waiting,
			dbo.fn_IntToTime(ISNULL((SELECT sum(d.TotalNumberOfMinutes) FROM WorkCentreJobEventLog d WHERE d.WorkCentreJobId = j.Id AND d.WorkCentreEventId = 12) ,0)) AS Paused
FROM		WorkCentre w
INNER JOIN	Area a
ON			w.AreaId = a.Id
INNER JOIN	WorkCentreJob j
ON			w.Id = j.WorkCentreId
INNER JOIN	WorkCentreJobLog l
ON			j.Id = l.WorkCentreJobId
INNER JOIN	WorkCentreStage s
ON			l.WorkCentreStageId = s.Id
WHERE		w.Id = @WorkCentreId
AND			l.StartDateTime BETWEEN @FromDate and @ToDate
ORDER BY	l.StartDateTime
GO

exec sp_WorkCentreJobData '2014-06-01','2014-09-02', 22


select * from WorkCentre where AreaId = 2