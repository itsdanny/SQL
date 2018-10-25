ALTER PROCEDURE sp__BottlesOEE 

@StartDate DATETIME,
@EndDate DATETIME

AS
SET @StartDate = (SELECT  DATEADD(DAY, -DATEPART(WEEKDAY, @StartDate), @StartDate))
declare @datediff int  = -DATEPART(WEEKDAY, @StartDate)
PRINT @datediff 
PRINT @StartDate
DECLARE @WeekLines TABLE(SageRef VARCHAR(6), Line VARCHAR(25), WeekNo INT, WeekStart DATETIME, WeekEnd DATETIME)

INSERT INTO @WeekLines
SELECT		b.SageRef, b.Line, b.WeekNo, w.WeekStart, w.WeekStart+6 AS WeekEnd 
FROM		StadaFactBook.dbo.BottlesOEEWeekly b
INNER JOIN	StadaFactBook.dbo.WeekNumbers w
ON			b.WeekNo = w.WeekNumber
WHERE		w.WeekStart BETWEEN (@StartDate) AND  @EndDate

DECLARE @Results Table (SageRef VARCHAR(6), QtyFinished INT, Units INT, CompletionDate DATETIME, WeekNo INT, WeekStart DATETIME)

-- LOOP #WeekLines for each week
DECLARE @StartWeekno INT = (SELECT MIN(WeekNo) FROM @WeekLines)
DECLARE @EndWeekno INT = (SELECT MAX(WeekNo) FROM @WeekLines)
DECLARE @LoopStartWeekno DATETIME
DECLARE @LoopEndWeekno DATETIME

WHILE @StartWeekno <= @EndWeekno
BEGIN
	SELECT @LoopStartWeekno = WeekStart, @LoopEndWeekno = WeekEnd FROM @WeekLines WHERE WeekNo = @StartWeekno

	INSERT INTO @Results(SageRef, QtyFinished, Units, CompletionDate, WeekNo, WeekStart)
	SELECT		d.resource_code,
				SUM(quantity_finished) AS quantity_finished,
				SUM(quantity_finished*u.spare) AS ActualTEEP, 
				completion_date,
				@StartWeekno,
				@LoopStartWeekno				
	FROM        scheme.bmwohm wo WITH(NOLOCK) 
	INNER JOIN  scheme.wsroutdm d WITH(NOLOCK)	
	ON			(wo.warehouse + wo.product_code = d.code) 
	INNER JOIN	scheme.stunitdm u
	ON			wo.finish_prod_unit = u.unit_code
	WHERE		wo.completion_date between @LoopStartWeekno and @LoopEndWeekno
	GROUP BY	d.resource_code, DATENAME(MONTH, completion_date), completion_date
	ORDER BY	resource_code

	SET @StartWeekno = @StartWeekno + 1
END

SELECT		r.SageRef + ' (' + b.Line + ')' AS SageRef, r.WeekNo, r.WeekStart, b.BottlesOEE, SUM(r.QtyFinished) AS FinishedQty--,	(CAST(b.BottlesOEE AS FLOAT)-CAST(SUM(r.QtyFinished) AS FLOAT))/b.BottlesOEE * -1 AS OEEVariance
FROM		StadaFactBook.dbo.BottlesOEEWeekly b
INNER JOIN	@Results r 
ON			r.SageRef = b.SageRef
AND			r.WeekNo = b.WeekNo
GROUP BY	r.SageRef, b.Line, r.WeekStart, b.BottlesOEE, r.WeekNo 
ORDER BY	r.WeekStart, r.SageRef, b.BottlesOEE

--SELECT 'LLL' AS fgrrrrrrr
GO

EXEC sp__BottlesOEE '2015-03-11 00:00:00', '2015-03-17 00:00:00'

