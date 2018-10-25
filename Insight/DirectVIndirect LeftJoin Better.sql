USE [InsightTest]
GO
/****** Object:  StoredProcedure [dbo].[rpt_DirectVIndirectByArea_lj]    Script Date: 30/07/2015 13:16:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[rpt_DirectVIndirectByArea]
@AreaId INT,
@fromDate	DATETIME = NULL,
@toDate		DATETIME = NULL
AS
BEGIN
	SET NOCOUNT ON;

SET @fromDate = CAST(@fromDate AS Date)
SET @toDate = CAST(@toDate AS Date)

DECLARE @Labour		TABLE(ActualDate DATETIME, LabourCount INT, DirectLabourCount INT DEFAULT 0)
DECLARE @AllEmps	INT = 0
DECLARE @Direct		INT = 0    
DECLARE @t			TIME = '06:00:00'					
DECLARE @WorkHour	DATETIME = (SELECT DATEADD(SECOND, DATEPART(HOUR,@t) * 3600 + DATEPART(MINUTE,@t) * 60 + DATEPART(SECOND,@t), @fromDate))	

--INSERT HOURS FOR A DAY
-- SHIFT = 06:00 - (Day+1) 06:00 (SO WE'LL START DATA READINGS AT 05:30, TO CATCH ANY EARLY LOGGER INNERS
SET	@toDate  = (SELECT DATEADD(SECOND, DATEPART(HOUR,@t) * 3600 + DATEPART(MINUTE,@t) * 60 + DATEPART(SECOND,@t), @toDate))	
	
-- Add data for each hour
WHILE @WorkHour <= @toDate
BEGIN	 
	--PRINT @WorkHour 
	INSERT	INTO @Labour(ActualDate, LabourCount, DirectLabourCount) SELECT @WorkHour, 0, 0
	SET		@WorkHour = DATEADD(HOUR,  1, @WorkHour)
END
	
-- FIND OUT THEN THEY LOGGED IN FOR EACH HOUR AND UPDATE EACH ROW IN @Labour UNTIL THEY LOG OUT	
SET @WorkHour = (SELECT DATEADD(SECOND, DATEPART(HOUR,@t) * 3600 + DATEPART(MINUTE,@t) * 60 + DATEPART(SECOND,@t), @fromDate))	

WHILE @WorkHour <= @toDate
BEGIN
	IF	@AreaId = 3
	/*BEGIN
		SELECT		@AllEmps = COUNT(DISTINCT l.Empref),  
					@Direct = (COUNT(DISTINCT d.EmpRef))
		FROM		AreaLabourLog  l		
		LEFT JOIN	ManufacturingJobLog  d
		ON			l.EmpRef = d.EmpRef
		AND			(@WorkHour		BETWEEN d.StartDateTime AND d.FinishDateTime)
		OR			(d.StartDateTime < @WorkHour AND d.FinishDateTime IS NULL)
		WHERE	    (l.AreaId = @AreaId)
		AND			(@WorkHour		BETWEEN l.StartDateTime AND l.FinishDateTime)
		OR			(l.StartDateTime < @WorkHour AND l.FinishDateTime IS NULL)
	END
	ELSE IF	@AreaId <> 3
	BEGIN
		SELECT		@AllEmps = COUNT(DISTINCT l.Empref), 
					@Direct = (COUNT(DISTINCT d.EmpRef))
		FROM		AreaLabourLog  l
		INNER JOIN	Area a
		ON			l.AreaId = a.Id	
		LEFT JOIN	WorkCentreJobLogLabourDetail d
		ON			l.EmpRef = d.EmpRef
		AND			(@WorkHour BETWEEN d.StartDateTime AND d.FinishDateTime)
		OR			(d.StartDateTime < @WorkHour AND d.FinishDateTime IS NULL)
		WHERE	    (a.Id = @AreaId)										
		AND			(@WorkHour BETWEEN l.StartDateTime AND l.FinishDateTime)
		OR			(l.StartDateTime < @WorkHour AND l.FinishDateTime IS NULL)
	END*/
	
	
--	STRIP OFF THE MINS... DOESN'T WORK.
	BEGIN
		SELECT		@AllEmps = COUNT(DISTINCT l.Empref),  
					@Direct = (COUNT(DISTINCT d.EmpRef))		
		FROM		AreaLabourLog  l		
		LEFT JOIN	ManufacturingJobLog  d
		ON			l.EmpRef = d.EmpRef
		AND			((@WorkHour	BETWEEN  DATEADD(HOUR, DATEDIFF(HOUR, 0, d.StartDateTime), 0) AND DATEADD(HOUR, DATEDIFF(HOUR, 0, d.FinishDateTime), 0))
		OR			(DATEADD(HOUR, DATEDIFF(HOUR, 0, d.StartDateTime), 0) <= @WorkHour AND d.FinishDateTime IS NULL))
		WHERE	    (l.AreaId = @AreaId)
		AND			((@WorkHour		BETWEEN DATEADD(HOUR, DATEDIFF(HOUR, 0, l.StartDateTime), 0) AND  DATEADD(HOUR, DATEDIFF(HOUR, 0, l.FinishDateTime), 0))
		OR			(DATEADD(HOUR, DATEDIFF(HOUR, 0, l.StartDateTime), 0) <= @WorkHour AND l.FinishDateTime IS NULL))
	END
	ELSE IF	@AreaId <> 3
	BEGIN
		SELECT		@AllEmps = COUNT(DISTINCT l.Empref), 
					@Direct = (COUNT(DISTINCT d.EmpRef))
		FROM		AreaLabourLog  l
		INNER JOIN	Area a
		ON			l.AreaId = a.Id	
		LEFT JOIN	WorkCentreJobLogLabourDetail d
		ON			l.EmpRef = d.EmpRef
		AND			((@WorkHour BETWEEN DATEADD(HOUR, DATEDIFF(HOUR, 0, d.StartDateTime), 0) AND DATEADD(HOUR, DATEDIFF(HOUR, 0, d.FinishDateTime), 0))
		OR			(DATEADD(HOUR, DATEDIFF(HOUR, 0, d.StartDateTime), 0) <= @WorkHour AND d.FinishDateTime IS NULL))
		WHERE	    (a.Id = @AreaId)										
		AND			((@WorkHour BETWEEN DATEADD(HOUR, DATEDIFF(HOUR, 0, l.StartDateTime), 0) AND DATEADD(HOUR, DATEDIFF(HOUR, 0, l.FinishDateTime), 0))
		OR			(DATEADD(HOUR, DATEDIFF(HOUR, 0, l.StartDateTime), 0) <= @WorkHour AND l.FinishDateTime IS NULL))
	END
		
	UPDATE		l 
	SET			l.LabourCount		=	ISNULL(@AllEmps, 0), 
				DirectLabourCount	=	ISNULL(@Direct, 0)
	FROM		@Labour l
	WHERE		l.ActualDate	=	@WorkHour   
	
	SET @WorkHour = DATEADD(HOUR,  1, @WorkHour)

END


SELECT 
		ActualDate,
		DATEPART(HOUR, ActualDate) AS TimeHour,
		LabourCount As AllEmps, 
		DirectLabourCount AS DirectEmpCount,
		(LabourCount - DirectLabourCount) AS InDirectEmpCount 
FROM	@Labour

END
GO

EXEC rpt_DirectVIndirectByArea_lj 1, '2015-07-29','2015-07-30'
GO

EXEC rpt_DirectVIndirectByArea 1, '2015-07-29','2015-07-30'


