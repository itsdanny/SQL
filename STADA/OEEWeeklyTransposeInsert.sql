-- This script transposes vertically, the matrix table data from Stuart into a normalised table

--	truncate table BottlesOEEWeekly
/*
use StadaFactBook
SELECT * FROM OEEWeeklyImport
  declare @WeekNo as int = 1
  declare @sql as varchar(2500)

  while @WeekNo < 53

  BEGIN
	SET @sql = N'INSERT INTO BottlesOEEWeekly(Line, SageRef, BottlesOEE, WeekNo) (SELECT Line, SageRef, wk' + CAST(@WeekNo AS VARCHAR(2)) +', ' + CAST(@WeekNo AS VARCHAR(2))  +' As WeekNo from OEEWeeklyImport)'
	PRINT @sql
	EXEC (@sql)
	SET @WeekNo = @WeekNo + 1
  END
  
  go
*/

USE syslive
go 
alter  PROCEDURE sp__WeeklyBottlesOEE
@FromDate	DATETIME,
@ToDate		DATETIME
AS

SELECT		completion_date, DATEADD(MONTH, DATEDIFF(MONTH, 0, completion_date), 0) as PeriodMonth, DATENAME(MONTH, completion_date) As OEEMonth, SUM(quantity_finished) AS quantity_finished,
			SUM(quantity_finished*u.spare) AS ActualOEE, 
			d.resource_code INTO #Results
FROM        scheme.bmwohm wo WITH(NOLOCK) 
LEFT JOIN   scheme.wsroutdm d WITH(NOLOCK)	
ON			(wo.warehouse + wo.product_code = d.code) 
INNER JOIN	scheme.stunitdm u
ON			wo.finish_prod_unit = u.unit_code
WHERE		completion_date BETWEEN @FromDate AND @ToDate
--AND			d.resource_code ='CS02'
GROUP BY	completion_date,  d.resource_code, DATENAME(MONTH, completion_date),DATEADD(MONTH, DATEDIFF(MONTH, 0, completion_date), 0)
ORDER BY	resource_code

select * from #Results

--SELECT		PeriodMonth, r.OEEMonth, b.Line, r.resource_code, SUM(b.BottlesOEE) AS BottlesOEE, ActualOEE, (ActualOEE/SUM(b.BottlesOEE))*100 as perc
SELECT		*--PeriodMonth, r.OEEMonth, b.Line, r.resource_code, b.BottlesOEE, ActualOEE
FROM		#Results r 
INNER JOIN	StadaFactBook.dbo.BottlesOEEWeekly b
ON			r.resource_code = b.SageRef
INNER JOIN  StadaFactBook.dbo.WeekNumbers w
ON			w.WeekNumber = b.WeekNo
WHERE		w.WeekStart BETWEEN @FromDate AND @ToDate
AND			w.WeekStart > r.completion_date
AND			b.Line = 'Line 5' 
--GROUP BY	PeriodMonth, r.OEEMonth, b.Line, r.resource_code, ActualOEE
ORDER BY	PeriodMonth
DROP TABLE #Results

go

sp__WeeklyBottlesOEE '2015-01-01' ,'2015-02-21'

select		sum(b.BottlesOEE), w.WeekStart from StadaFactBook.dbo.BottlesOEEWeekly b
INNER JOIN  StadaFactBook.dbo.WeekNumbers w
ON			w.WeekNumber = b.WeekNo
WHERE		w.WeekStart BETWEEN '2015-01-01' and '2015-02-21'
AND			b.Line ='Line 5' 
group by w.WeekStart
/*
Jan 5382528
Feb	5382528
select 56068 * 4 -- 224272 
*/