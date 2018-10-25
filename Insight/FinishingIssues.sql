DECLARE @FinishedJobs TABLE(Id INT identity(1,1),JobId INT, WorkOrderNumber VARCHAR(10), ProcessOrderNumber VARCHAR(20), LogId INT, FirstFinishEventId INT, 
						FirstStartDateTime DATETIME, FirstFinishDateTime DATETIME)
INSERT INTO @FinishedJobs
SELECT		j.Id AS JobId, 
			j.WorkOrderNumber, j.ProcessOrderNumber, 
			MIN(l.Id) AS LogId,
			MIN(E.Id) AS FirstFinishEventId, 
			MIN(e.StartDateTime) AS FirstStartDateTime,
			MIN(e.FinishDateTime) AS FirstFinishDateTime
			
FROM		WorkCentreJobEventLog e
INNER JOIN 	WorkCentreJobLog l
ON			e.WorkCentreJobId = l. WorkCentreJobId
INNER JOIN 	WorkCentreJob j
ON			e.WorkCentreJobId = j.Id
WHERE		e.WorkCentreEventId = 1
AND			l.WorkCentreStageId = 1
AND			l.FinishDateTime IS NULL
/*AND			l.StartDateTime > '2018-01-01'
AND			e.StartDateTime < '2018-04-12'
AND			j.WorkOrderNumber = 'XE85'*/
GROUP BY	j.Id, j.WorkOrderNumber, j.ProcessOrderNumber
ORDER BY	1

SELECT	*
FROM		@FinishedJobs

DECLARE @JobId INT, @WorkOrderNumber VARCHAR(10), @ProcessOrderNumber VARCHAR(20), @LogId INT, @FirstFinishEventId INT, @OtherEventMins INT
DECLARE @FirstStartDateTime DATETIME, @FirstFinishDateTime DATETIME
DECLARE @Row INT = 1, @Rows INT

SET @Rows = (SELECT COUNT(1) FROM @FinishedJobs)
--BEGIN TRAN
WHILE @Row <= @Rows
BEGIN
	SELECT		@JobId = JobId,
				@WorkOrderNumber = WorkOrderNumber,
				@LogId = LogId,
				@FirstFinishEventId = FirstFinishEventId,
				@FirstStartDateTime = FirstStartDateTime,
				@FirstFinishDateTime = FirstFinishDateTime
	FROM		@FinishedJobs
	WHERE		Id = @Row
	
	--print 'pre CHECKS'
	--SELECT		@FirstStartDateTime AS EventStartDateTime, @FirstFinishDateTime AS EventFinishDateTime, *
	--FROM		WorkCentreJobEventLog
	--WHERE		WorkCentreJobId = @JobId
	--AND			FinishDateTime > @FirstFinishDateTime

	--SELECT		@FirstStartDateTime AS EventStartDateTime, @FirstFinishDateTime AS EventFinishDateTime, *
	--FROM		WorkCentreJobLog
	--WHERE		WorkCentreJobId = @JobId
	--AND			Id > @LogId

	--SELECT		@FirstStartDateTime AS EventStartDateTime, @FirstFinishDateTime AS EventFinishDateTime, *
	--FROM		dbo.WorkCentreJobLogLabourDetail
	--WHERE		WorkCentreJobLogId = @LogId
	--AND			FinishDateTime > @FirstFinishDateTime
	
	--SELECT		@FirstStartDateTime AS EventStartDateTime, @FirstFinishDateTime AS EventFinishDateTime, *
	--FROM		dbo.WorkCentreJobLogLabourSummary
	--WHERE		WorkCentreJobLogId = @LogId
	--AND			FinishDateTime > @FirstFinishDateTime

	PRINT 'ACTIONS...'
	PRINT 'DELETE LOGS'
	DELETE		
	FROM		WorkCentreJobLog
	WHERE		WorkCentreJobId = @JobId
	AND			Id > @LogId

	PRINT 'DELETE FROM	WORKCENTREJOBEVENTLOG:'
	DELETE		
	FROM		WorkCentreJobEventLog
	WHERE		WorkCentreJobId = @JobId
	AND			Id > @FirstFinishEventId

	SELECT		@OtherEventMins = SUM(TotalNumberOfMinutes)
	FROM		WorkCentreJobEventLog
	WHERE		WorkCentreJobId = @JobId
	AND			WorkCentreEventId <> 1

	PRINT 'UPDATE WORKCENTREJOBLOG:	STAGERUNTIME, FINSISHED DATETIME'
	UPDATE 		WorkCentreJobLog
	SET			FinishDateTime = @FirstFinishDateTime,
				StageRuntime = DATEDIFF(MINUTE, StartDateTime, @FirstFinishDateTime),
				JobPerformance = StandardRuntime/ DATEDIFF(MINUTE, StartDateTime, @FirstFinishDateTime)
	WHERE		WorkCentreJobId = @JobId
	AND			FinishDateTime IS NULL

	PRINT 'UPDATE WORKCENTREJOB: WORKCENTREJOBRUNTIME, JOBCOST'
	UPDATE 		j
	SET			j.WorkCentreJobRuntime = l.StageRuntime - @OtherEventMins,
				j.JobCost = (j.HourlyRate * (l.StandardRuntime/60.0)) - (j.HourlyRate*( l.StageRuntime - @OtherEventMins)/60.0)
	FROM		WorkCentreJob j
	INNER JOIN 	WorkCentreJobLog l
	ON			j.Id = l.WorkCentreJobId
	WHERE		j.Id = @JobId

	PRINT 'DELETE WorkCentreJobLogLabourDetail:'
	DELETE 
	FROM		dbo.WorkCentreJobLogLabourDetail
	WHERE		WorkCentreJobLogId = @LogId
	AND			(StartDateTime  > @FirstFinishDateTime)
	
	PRINT 'UPDATE WorkCentreJobLogLabourDetail: TOTALMINUTES'
	--UPDATE 		d
	--SET			d.TotalMinutes = DATEDIFF(MINUTE, StartDateTime, @FirstFinishDateTime)
	--FROM		dbo.WorkCentreJobLogLabourDetail d
	--WHERE		WorkCentreJobLogId = @LogId

	PRINT 'DELETE WORKCENTREJOBLOGLABOURSUMMARY:'
	DELETE 
	FROM		dbo.WorkCentreJobLogLabourSummary
	WHERE		WorkCentreJobLogId = @LogId
	AND			(StartDateTime  > @FirstFinishDateTime)
	
	PRINT 'UPDATE WORKCENTREJOBLOGLABOURSUMMARY: TOTALMINUTES'
	UPDATE 		d
	SET			d.TotalNumberOfMinutes = DATEDIFF(MINUTE, StartDateTime, @FirstFinishDateTime)
	FROM		dbo.WorkCentreJobLogLabourSummary d
	WHERE		WorkCentreJobLogId = @LogId


	--PRINT 'POST UPDATE CHECKS...'
	SELECT		@FirstStartDateTime AS EventStartDateTime, @FirstFinishDateTime AS EventFinishDateTime, *
	FROM		WorkCentreJob
	WHERE		Id = @JobId

	SELECT		@FirstStartDateTime AS EventStartDateTime, @FirstFinishDateTime AS EventFinishDateTime, *
	FROM		WorkCentreJobEventLog
	WHERE		WorkCentreJobId = @JobId

	SELECT		@FirstStartDateTime AS EventStartDateTime, @FirstFinishDateTime AS EventFinishDateTime, *
	FROM		WorkCentreJobLog
	WHERE		WorkCentreJobId = @JobId

	SELECT		@FirstStartDateTime AS EventStartDateTime, @FirstFinishDateTime AS EventFinishDateTime, *
	FROM		dbo.WorkCentreJobLogLabourDetail
	WHERE		WorkCentreJobLogId = @LogId
	--RETURN 
	SELECT		@FirstStartDateTime AS EventStartDateTime, @FirstFinishDateTime AS EventFinishDateTime, *
	FROM		dbo.WorkCentreJobLogLabourSummary
	WHERE		WorkCentreJobLogId = @LogId

SET @Row = @Row + 1
END


ROLLBACK--