 CREATE TABLE #Tmp(WorkCentreID INT, JobId INT, WorkOrderNumber VARCHAR(12), [Description] VARCHAR(250), WorkCrewe INT, JobStart DateTime, JobFinish DateTime, StandardRunTime INT, JobRuntime INT, WaitingTime INT, BreakdownTime INT, PausedTime INT, BPM FLOAT)

INSERT INTO #Tmp(WorkCentreID, JobId, WorkOrderNumber, [Description], WorkCrewe, JobStart, JobFinish, StandardRunTime, JobRuntime, BPM)
SELECT		w.Id, j.Id AS JobId, j.WorkOrderNumber, j.Description, j.WorkCrewe, MIN(jl.StartDateTime), MAX(jl.FinishDateTime), max(jl.StandardRuntime), sum(jl.StageRuntime), jl.BPM
FROM		WorkCentreJob j
INNER JOIN	WorkCentre w
ON			j.WorkCentreId = w.Id
INNER JOIN	WorkCentreJobLog jl
ON			j.Id = jl.WorkCentreJobId
WHERE		w.Name in ('SW1')
AND			jl.StartDateTime between'2014-07-06' and '2014-07-09'
GROUP BY	w.Id, j.Id, j.WorkOrderNumber, j.Description, j.WorkCrewe, jl.BPM

-- GET ALL BREAK DOWN TIME
UPDATE t	SET t.BreakdownTime = (SELECT SUM(e.TotalNumberOfMinutes)
FROM		WorkCentreJobEventLog e 
WHERE		e.WorkCentreJobId = t.JobId
and			e.WorkCentreEventId = 2)
FROM #Tmp t

-- GET ALL WAITING TIME
UPDATE t	SET t.WaitingTime = (SELECT SUM(e.TotalNumberOfMinutes)
FROM		WorkCentreJobEventLog e 
WHERE		e.WorkCentreJobId = t.JobId
and			e.WorkCentreEventId = 3)
FROM #Tmp t

-- GET ALL PAUSED TIME
UPDATE t	SET t.PausedTime = COALESCE((SELECT SUM(e.TotalNumberOfMinutes)
FROM		WorkCentreJobEventLog e 
WHERE		e.WorkCentreJobId = t.JobId
and			e.WorkCentreEventId = 12), 0)
FROM #Tmp t


select  t.Description, t.WorkOrderNumber, t.WaitingTime, el.* from WorkCentreJobEventLog el inner join #Tmp t on el.WorkCentreJobId = t.JobId
ORDER BY EL.FinishDateTime

SELECT	JobId, WorkOrderNumber, [Description], JobStart, JobFinish,
		dbo.fn_IntToTime(StandardRunTime) StandardHrs,
		dbo.fn_IntToTime(JobRuntime-PausedTime) JobHours, 
		dbo.fn_IntToTime(WaitingTime) JobWaitingHours, 
		dbo.fn_IntToTime(BreakdownTime) JobBreakDownHours,
		dbo.fn_IntToTime(PausedTime) JobPausedHours, 
		BPM
FROM	#Tmp



DROP TABLE #Tmp