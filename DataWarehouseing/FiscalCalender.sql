DECLARE @StartDate DATE = '20160101'
	,@NumberOfYears INT = 10;

-- prevent set or regional settings from interfering with 
-- interpretation of dates / literals
SET DATEFIRST 7;
SET DATEFORMAT mdy;
SET LANGUAGE US_ENGLISH;

DECLARE @CutoffDate DATE = DATEADD(YEAR, @NumberOfYears, @StartDate);

-- this is just a holding table for intermediate calculations:
CREATE TABLE #dim (
	Id INT identity(1, 1) PRIMARY KEY
	,ActualDate DATE
	,DayNumber AS DATEPART(DAY, ActualDate)
	,MonthNumber AS DATEPART(MONTH, ActualDate)
	,FirstOfMonth AS CONVERT(DATE, DATEADD(MONTH, DATEDIFF(MONTH, 0, ActualDate), 0))
	,[MonthName] AS DATENAME(MONTH, ActualDate)
	,WeekNumber AS DATEPART(WEEK, ActualDate)
	,[ISOweek] AS DATEPART(ISO_WEEK, ActualDate)
	,[DayOfWeek] AS DATEPART(WEEKDAY, ActualDate)
	,FiscalQuarter AS DATEPART(QUARTER, ActualDate)
	,YearNumber AS DATEPART(YEAR, ActualDate)
	,FirstOfYear AS CONVERT(DATE, DATEADD(YEAR, DATEDIFF(YEAR, 0, ActualDate), 0))
	,Style112 AS CONVERT(CHAR(8), ActualDate, 112)
	,Style101 AS CONVERT(CHAR(10), ActualDate, 101)
	,FiscalPeriod AS RIGHT('0' + ISNULL(CAST(DATEPART(MONTH, ActualDate) AS VARCHAR), ''), 2) + '.' + CAST(DATEPART(YEAR, ActualDate) AS VARCHAR)
	,MonthYear AS LEFT(DATENAME(MONTH, ActualDate), 3) + CAST(DATEPART(YEAR, ActualDate) AS VARCHAR)
	,YearWeekNumber AS CAST(DATEPART(YEAR, ActualDate) AS VARCHAR) + RIGHT('0' + ISNULL(CAST(DATEPART(WEEK, ActualDate) AS VARCHAR), ''), 2)
	);

-- use the catalog views to generate as many rows as we need
INSERT #dim (ActualDate)
SELECT d
FROM (
	SELECT d = DATEADD(DAY, rn - 1, @StartDate)
	FROM (
		SELECT TOP (DATEDIFF(DAY, @StartDate, @CutoffDate)) rn = ROW_NUMBER() OVER (
				ORDER BY s1.[object_id]
				)
		FROM sys.all_objects AS s1
		CROSS JOIN sys.all_objects AS s2
		-- on my system this would support > 5 million days
		ORDER BY s1.[object_id]
		) AS x
	) AS y;

UPDATE c
SET c.YearWeekNumber = d.YearWeekNumber
FROM #dim d
INNER JOIN Calendar c ON d.ActualDate = c.ActualDate

DROP TABLE #dim