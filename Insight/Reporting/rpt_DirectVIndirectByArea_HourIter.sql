USE [InsightTest]
GO
/****** Object:  StoredProcedure [dbo].[rpt_DirectVIndirectByArea]    Script Date: 25/06/2014 12:09:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dan McGregor>
-- Create date: <01 March 2014>
-- Description:	<Get labour totals for the area (@AreaId)>
-- =============================================
ALTER PROCEDURE [dbo].[rpt_DirectVIndirectByArea]
@AreaId INT,
@fromDate	DATETIME = NULL,
@toDate		DATETIME = NULL
AS
BEGIN

-- 
	SET NOCOUNT ON;

	DECLARE @TotalLabour int
	DECLARE @DirectLabour int
	DECLARE @Labour Table(TimeHour INT, InDirectEmpCount INT, DirectEmpCount INT)
    
	--INSERT HOURS FOR A DAY
	DECLARE @Iter int = 0

	WHILE @Iter < 24
	BEGIN
		INSERT INTO @Labour(TimeHour, InDirectEmpCount, DirectEmpCount) SELECT @Iter, 5 ,6
		SET @Iter = @Iter +1
	END
	-- FIND OUT THEN THEY LOGGED IN FOR EACH HOUR AND UPDATE EACH ROW IN @Labour UNTIL THEY LOG OUT
	
	SET @Iter = 0

	WHILE @Iter < 24
	BEGIN		
		UPDATE		l 
		SET			l.InDirectEmpCount = (select COUNT(al.Empref)
		FROM		AreaLabourLog  al
		INNER JOIN	Area a
		ON			al.AreaId = a.Id	
		WHERE	    (a.Id = @AreaId)
		AND			(@Iter BETWEEN DATEPART(HOUR, al.StartDateTime)  AND  DATEPART(HOUR, al.FinishDateTime) 
		AND			CAST(al.StartDateTime AS DATE) BETWEEN @fromDate AND @toDate))

	FROM @Labour l
	WHERE L.TimeHour = @Iter   
	SET @Iter = @Iter + 1
	END
	
	--SELECT * 
	--FROM		AreaLabourLog  al
	--	INNER JOIN	Area a
	--	ON			al.AreaId = a.Id	
	--	WHERE	    (a.Id = @AreaId)
	----	AND			@Iter BETWEEN DATEPART(HOUR, al.StartDateTime)  AND  DATEPART(HOUR, al.FinishDateTime) 
	--	AND			CAST(al.StartDateTime AS DATE) BETWEEN @fromDate AND @toDate
	
IF @AreaId = 3 -- MAN LAB
	BEGIN

	SET @Iter = 0
	WHILE @Iter < 24
	BEGIN		
		UPDATE		l 
		SET			l.DirectEmpCount = (select COUNT(al.Empref)
		FROM		ManufacturingJobLog  al
		INNER JOIN	Area a
		ON			al.AreaId = a.Id	
		WHERE	    (a.Id = @AreaId)
		AND			@Iter BETWEEN DATEPART(HOUR, al.StartDateTime)  AND  DATEPART(HOUR, al.FinishDateTime) 
		AND			CAST(al.StartDateTime AS DATE) BETWEEN @fromDate AND @toDate)

	FROM @Labour l
	WHERE L.TimeHour = @Iter   
	SET @Iter = @Iter + 1
	END
		
	
	--select *
	--FROM		ManufacturingJobLog  al
	--	INNER JOIN	Area a
	--	ON			al.AreaId = a.Id	
	--	WHERE	    (a.Id = @AreaId)
	----	AND			@Iter BETWEEN DATEPART(HOUR, al.StartDateTime)  AND  DATEPART(HOUR, al.FinishDateTime) 
	--	AND			CAST(al.StartDateTime AS DATE) BETWEEN @fromDate AND @toDate
	--	order by al.StartDateTime
	SELECT  TimeHour, (InDirectEmpCount - DirectEmpCount) as InDirectEmpCount , DirectEmpCount FROM @Labour
	where (InDirectEmpCount - DirectEmpCount) > 0 or DirectEmpCount > 0
	END	
	ELSE
	BEGIN
		SET @DirectLabour = (SELECT COUNT(DISTINCT wcjlld.EmpRef) AS NumberOfEmp
		FROM		Area a
		INNER JOIN  WorkCentre wc
		ON			a.Id = wc.AreaId
		INNER JOIN	WorkCentreJob wcj
		ON			wc.Id = wcj.WorkCentreId
		INNER JOIN	WorkCentreJobLog wcjl
		ON			wcj.Id = wcjl.WorkCentreJobId
		INNER JOIN  WorkCentreJobLogLabourDetail wcjlld
		ON			wcjl.Id = wcjlld.WorkCentreJobLogId
		WHERE		(a.Id= @AreaId) 
		AND		   (CAST(wcjlld.StartDateTime AS DATE) BETWEEN @fromDate AND @toDate))
	END

END


