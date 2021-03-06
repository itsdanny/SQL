USE Insight
GO 

alter PROCEDURE rpt_sp_LastBatchPerformance
@AreaId			INT,
@StageId		INT,
@WorkCentreId	INT = NULL

AS
DECLARE @Results AS TABLE (AreaName VARCHAR(10), WorkCentreId INT, WorkCentre VARCHAR(50), WorkCentreJobId INT, StageId INT, Stage VARCHAR(20), WorkCentreJobRuntime INT, StandardRunTime INT)
DECLARE @ResultsToReturn AS TABLE (AreaName VARCHAR(10), WorkCentreId INT, WorkCentre VARCHAR(50), WorkCentreJobId INT, StageId INT, Stage VARCHAR(20), WorkCentreJobRuntime INT, StandardRunTime INT)

INSERT INTO @Results
	SELECT		a.Name,	w.id, w.Name, j.Id, s.Id, s.Name, 
				SUM(WorkCentreJobRuntime) AS StageRuntime, StandardRuntime
	FROM		Insight.dbo.WorkCentreJob j
	INNER JOIN	Insight.dbo.WorkCentreJobLog l
	ON			j.Id = l.WorkCentreJobId
	INNER JOIN	Insight.dbo.WorkCentre w
	ON			j.WorkCentreId = w.Id
	INNER JOIN	Insight.dbo.WorkCentreStage s
	ON			l.WorkCentreStageId = s.Id
	INNER JOIN	Insight.dbo.Area a
	ON			w.AreaId = a.Id
	WHERE		j.Id = l.WorkCentreJobId
	and			(@WorkCentreId IS NULL OR WorkCentreId = @WorkCentreId)
	AND			l.WorkCentreStageId = @StageId
	AND			w.AreaId =	@AreaId
	AND			l.StartDateTime > GETDATE()-7
	AND			l.FinishDateTime IS NOT NULL
	AND			l.StageRuntime > 0	
	GROUP BY	a.Name,	w.id, w.Name, j.Id, s.Id, s.Name, StandardRuntime

	DECLARE @WorkCentres  AS TABLE(Id INT IDENTITY(1,1), WorkCentreId INT)
	DECLARE @wc INT = 1
	DECLARE @Row INT = 1

	INSERT INTO @WorkCentres
	SELECT DISTINCT WorkCentreId FROM @Results
	DECLARE @Rows INT = (select MAX(Id) from @WorkCentres)

	WHILE @Row <= @Rows
	BEGIN
		INSERT INTO @ResultsToReturn 
		
		SELECT TOP 1 r.* 
		FROM		@Results r
		INNER JOIN	@WorkCentres w
		ON			r.WorkCentreId = w.WorkCentreId
		WHERE		w.Id = @Row
		ORDER BY	WorkCentreJobId DESC	

		SET @Row = @Row + 1
	END
	--	select * from @ResultsToReturn

	SELECT	AreaName, WorkCentreId, WorkCentre, StageId,Stage, 
			ROUND((CAST(StandardRunTime AS FLOAT)/WorkCentreJobRuntime),2) * 100 AS Performance
	 FROM	@ResultsToReturn
	 ORDER BY WorkCentreId

	
GO


rpt_sp_LastBatchPerformance @AreaId=1, @StageId=2, @WorkCentreId = 13
go 
rpt_sp_LastBatchPerformance @AreaId=1, @StageId=1--, @WorkCentreId = 13