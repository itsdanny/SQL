USE [InsightTest]
GO
/****** Object:  StoredProcedure [dbo].[rpt_DirectVIndirectByArea]    Script Date: 30/07/2015 13:07:20 ******/
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
--[rpt_DirectVIndirectByArea] 3,'2014-06-03 00:00:00','2014-06-04 00:00:00'
AS
BEGIN
-- Clear the time...
SET @fromDate = CAST(@fromDate AS Date)
SET @toDate = CAST(@toDate AS Date)
-- 
	SET NOCOUNT ON;

	DECLARE @TotalLabour int
	DECLARE @DirectLabour int
	DECLARE @Labour Table(TimeHour DateTime, InDirectEmpCount INT, DirectEmpCount INT)
    
	--INSERT HOURS FOR A DAY
	-- SHIFT = 06:00 - (Day+1) 06:00 (SO WE'LL START DATA READINGS AT 05:30, TO CATCH ANY EARLY LOGGER INNERS
	DECLARE @t TIME = '06:00:00'					
	DECLARE @DayStart DATETIME =(SELECT DATEADD(SECOND, DATEPART(HOUR,@t) * 3600 + DATEPART(MINUTE,@t) * 60 + DATEPART(SECOND,@t), @fromDate))	

	SET @t = '06:00:00'					
	SET	@toDate  = (SELECT DATEADD(SECOND, DATEPART(HOUR,@t) * 3600 + DATEPART(MINUTE,@t) * 60 + DATEPART(SECOND,@t), @toDate))	
	
	-- Create a table for each hour
	WHILE @DayStart <  DateAdd(Hour, 1, @toDate)
	BEGIN	
		--PRINT @DayStart 
		INSERT INTO @Labour(TimeHour, InDirectEmpCount, DirectEmpCount) SELECT @DayStart, 0, 0
		SET @DayStart = DATEADD(HOUR,  1, @DayStart)
	END
		
	-- FIND OUT THEN THEY LOGGED IN FOR EACH HOUR AND UPDATE EACH ROW IN @Labour UNTIL THEY LOG OUT	
	SET @DayStart =(SELECT DATEADD(SECOND, DATEPART(HOUR,@t) * 3600 + DATEPART(MINUTE,@t) * 60 + DATEPART(SECOND,@t), @fromDate))	

	WHILE @DayStart <=  DateAdd(Hour, 1, @toDate)
	BEGIN
	--select @DayStart
		UPDATE		l 
		SET			l.InDirectEmpCount = (SELECT COUNT(DISTINCT l.Empref)
										FROM		AreaLabourLog  l
										INNER JOIN	Area a
										ON			l.AreaId = a.Id	
										WHERE	    (a.Id = @AreaId)										
										AND			(@DayStart BETWEEN l.StartDateTime AND  l.FinishDateTime))

		FROM @Labour l
		WHERE L.TimeHour = @DayStart   
	
		SET @DayStart = DATEADD(HOUR,  1, @DayStart)

	END
IF		@AreaId = 3 -- MAN LAB
BEGIN	
	SET		@DayStart = CAST(@fromDate AS DATE)
	WHILE	@DayStart <= DateAdd(Hour, 1, @toDate)
	BEGIN		
		UPDATE		l 
		SET			l.DirectEmpCount = (SELECT COUNT(DISTINCT l.Empref)
		--select	(SELECT COUNT(DISTINCT l.Empref)

										FROM		ManufacturingJobLog  l
										INNER JOIN	Area a
										ON			l.AreaId = a.Id	
										WHERE	    (a.Id = @AreaId)
										AND			(@DayStart BETWEEN l.StartDateTime AND l.FinishDateTime))							

		FROM @Labour l
		WHERE L.TimeHour = @DayStart   			

		SET @DayStart = DATEADD(HOUR,  1, @DayStart)
	END				
END	
ELSE IF @AreaId <> 3 -- PFD/HPF
BEGIN
	SET @DayStart = CAST(@fromDate AS DATE)
	
	 WHILE @DayStart <= DATEADD(HOUR, 1, @toDate)
		BEGIN		
			UPDATE		l 
			SET			l.DirectEmpCount = (SELECT COUNT(DISTINCT wcjlld.EmpRef) AS NumberOfEmp
			--SELECT		(SELECT COUNT(DISTINCT wcjlld.EmpRef) AS NumberOfEmp
			--SELECT		wcjlld.*--COUNT(DISTINCT wcjlld.EmpRef) AS NumberOfEmp
			FROM		Area a
			INNER JOIN  WorkCentre wc
			ON			a.Id = wc.AreaId
			INNER JOIN	WorkCentreJob wcj
			ON			wc.Id = wcj.WorkCentreId
			INNER JOIN	WorkCentreJobLog wcjl
			ON			wcj.Id = wcjl.WorkCentreJobId
			INNER JOIN  WorkCentreJobLogLabourDetail wcjlld
			ON			wcjl.Id = wcjlld.WorkCentreJobLogId
			WHERE		(a.Id = @AreaId) 
			AND		   @DayStart BETWEEN wcjlld.StartDateTime AND wcjlld.FinishDateTime)
			FROM		@Labour l
			WHERE		l.TimeHour = @DayStart   
			
			SET @DayStart = DATEADD(HOUR,  1, @DayStart)
		END	
   END
END

SELECT		TimeHour AS ActualDate, 
			CAST(DATEPART(HOUR, TimeHour) AS VARCHAR(2)) AS TimeHour,
			InDirectEmpCount as AllEmps,
			DirectEmpCount, 
			(InDirectEmpCount - DirectEmpCount) AS InDirectEmpCount
--SELECT		*
FROM		@Labour
ORDER BY	ActualDate	

