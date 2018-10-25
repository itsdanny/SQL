	DECLARE @Results TABLE(JobId INT, WorkCentreId INT, LogStartTime datetime, StandardRuntime INT, EventStartTime datetime, EventFinishTime datetime)
	INSERT INTO @Results
	SELECT		j.Id AS JobId, j.WorkCentreId, l.StartDateTime AS LogStartTime, l.StandardRuntime, e.StartDateTime, e.FinishDateTime
	FROM		WorkCentreJob j
	INNER JOIN 	WorkCentreJobLog l
	ON			j.Id = l.WorkCentreJobId
	INNER JOIN 	WorkCentreJobEventLog e
	ON			e.WorkCentreJobId = j.Id
	ORDER BY	2,1


	DECLARE @WorkCentreId INT, @JobId INT
	DECLARE @LogStartTime datetime, @StandardRuntime INT, @EventStartTime datetime, @EventFinishTime datetime
	DECLARE @Row INT = 1, @Rows INT	
	SET @Rows = (SELECT COUNT(1) FROM @Results)
	
	WHILE @Row <= @Rows
	BEGIN
		
	
	SET @Row = @Row + 1
	END
	


	SELECT	*
	FROM		WorkCentreJobEventLog a
	INNER JOIN 	WorkCentreJobEventLog b
	ON			a.WorkCentreJobId = b.WorkCentreJobId
	WHERE		a.WorkCentreEventId = 1
	AND			b.FinishDateTime > a.FinishDateTime
	AND			b.WorkCentreEventId <> 1 