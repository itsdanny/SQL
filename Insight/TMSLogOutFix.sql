USE Insight
SELECT * FROM InsightErrors ORDER BY 1 DESC
DROP TABLE #tmp
select * from #tmp
SELECT Id As LogId, EmpRef, StartDateTime, FinishDateTime, FinishDateTime as ActualFinish, TotalMinutes, 0 as ActualMins INTO #tmp FROM AreaLabourLog WHERE TotalMinutes < 0 AND StartDateTime > '2015-04-01'-- and  EmpRef = '0749'

DECLARE @RowId	INT 
DECLARE @LastRowId	INT = (SELECT MIN(LogId) -1 FROM #tmp)
DECLARE @Row	INT = 1
DECLARE @MaxRowId	INT = (SELECT Max(LogId) FROM #tmp)
DECLARE @EMP	VARCHAR(4)
DECLARE @StartDate	DATETIME
DECLARE @FinishDate DATETIME
DECLARE @TMSFinishDate DATETIME

WHILE @LastRowId <= @MaxRowId 
BEGIN	
	SELECT	@RowId = NULL, @EMP = NULL, @StartDate = NULL, @FinishDate = NULL

	SELECT TOP 1 * FROM #tmp WHERE LogId >= @LastRowId
	
	SELECT TOP 1 @RowId = LogId, @EMP = EmpRef, @StartDate = StartDateTime FROM #tmp WHERE LogId >= @LastRowId
	
	SELECT TOP 1 * FROM TMSLogs WHERE EMPREF = @EMP AND CLKDT > @StartDate AND DIR = 'O' ORDER BY CLKDT 

	SELECT	TOP 1 @TMSFinishDate = CLKDT FROM TMSLogs WHERE EMPREF = @EMP AND CLKDT > @StartDate AND DIR = 'O' ORDER BY CLKDT 
	
	UPDATE #tmp SET ActualFinish = @TMSFinishDate, ActualMins = DATEDIFF(MINUTE, StartDateTime, @TMSFinishDate)-1 WHERE LogId = @RowId
	--RETURN
	SET @LastRowId = @RowId+1
END

/*
	select * from #tmp where EmpRef = '0749'-- 75390
	select * from TMSLogs where EMPREF = '0749' and  CLKDT > '2015-07-22 00:10:49.000'  ORDER BY CLKDT --0649	O	

UPDATE		a		
SET			a.FinishDateTime = t.ActualFinish, 
			a.TotalMinutes = t.ActualMins
--		SELECT * 
FROM		AreaLabourLog a
INNER JOIN	#tmp t
ON			a.Id = t.LogId
WHERE		ActualMins > 0
*/

SELECT  B.Name, EmpRef, StartDateTime, FinishDateTime, '' Remark FROM AreaLabourLog a INNER JOIN Area b ON A.AreaId = B.Id where StartDateTime > '2015-06-01' and TotalMinutes > 0
UNION
SELECT B.Name, EmpRef, StartDateTime, Null , '*' Remark FROM AreaLabourLog a  INNER JOIN Area b ON A.AreaId = B.Id  where StartDateTime > '2015-06-01' and TotalMinutes < 0

SELECT * FROM	AreaLabourLog a where StartDateTime > '2015-06-01' and TotalMinutes < 0

SELECT * FROM	AreaLabourLog a where TotalMinutes < 0


UPDATE		AreaLabourLog 
SET			FinishDateTime = DATEADD(MINUTE, 456, StartDateTime)
FROM		AreaLabourLog a
WHERE		TotalMinutes < 0

SELECT *
FROM		AreaLabourLog a
WHERE		TotalMinutes < 0

UPDATE		AreaLabourLog 
SET			TotalMinutes = 456
FROM		AreaLabourLog a
WHERE		TotalMinutes < 0


Insight Logging out employee 0608. 
Logged in Date: 

28/07/2015 03:49:33

2015-07-27 22:00:53


