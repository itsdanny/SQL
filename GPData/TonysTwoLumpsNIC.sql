-- 201409	2014-09-01 00:00:00.000
/*
DECLARE @StartDate datetime = CONVERT(DATETIME, (CAST(datepart(YEAR,(SELECT DATEADD(month, -18, getdate()))) AS varchar(4))) + '-'+CAST(datepart(MONTH,(SELECT DATEADD(month, -18, getdate()))) AS varchar(2)) + '-01 00:00:00:000')
DECLARE @EndDate  datetime = CONVERT(DATETIME, (CAST(datepart(YEAR,(SELECT DATEADD(month, -16, getdate()))) AS varchar(4))) + '-'+CAST(datepart(MONTH,(SELECT DATEADD(month, -16, getdate()))) AS varchar(2)) + '-01 00:00:00:000')
PRINT @StartDate
PRINT @EndDate
set @StartDate  = CONVERT(DATETIME, (CAST(datepart(YEAR,(SELECT DATEADD(month, -6, getdate()))) AS varchar(4))) + '-'+CAST(datepart(MONTH,(SELECT DATEADD(month, -6, getdate()))) AS varchar(2)) + '-01 00:00:00:000')
 set @EndDate   = CONVERT(DATETIME, (CAST(datepart(YEAR,(SELECT DATEADD(month, -4, getdate()))) AS varchar(4))) + '-'+CAST(datepart(MONTH,(SELECT DATEADD(month, -4, getdate()))) AS varchar(2)) + '-01 00:00:00:000')
PRINT @StartDate
PRINT @EndDate
*/
--	FORMAT DATE 
--	SELECT CONVERT(datetime, cast(DATEPART(year, getdate()) as varchar)+ '-0' + CAST(DATEPART(MONTH, DATEADD(month, -22, GETDATE())) AS VARCHAR) + '-01 00:00:00')

use GPData
DECLARE @cols NVARCHAR(MAX) 
DECLARE @query NVARCHAR(MAX) 

SELECT  @cols = STUFF(( SELECT DISTINCT TOP 100 PERCENT 
                                '],[' + REPLACE(CountAs, '''','') FROM PracticeData pd inner join BNFProducts bp on pd.BNF_CODE = bp.BNF_CODE
                        --ORDER BY ' , ' + t.PERIOD
                        FOR XML PATH('') 
                      ), 1, 2, '') + ']' 

-- MAT LAST YEAR
SET @query = N'
DECLARE @StartDate datetime = (select CONVERT(datetime, cast(DATEPART(year, getdate())-1 as varchar)+ ''-0'' + CAST(DATEPART(MONTH, DATEADD(month, -18, GETDATE())) AS VARCHAR) + ''-01 00:00:00''))
DECLARE @EndDate  datetime = (select CONVERT(datetime, cast(DATEPART(year, getdate())-1 as varchar)+ ''-0'' + CAST(DATEPART(MONTH, DATEADD(month, -16, GETDATE())) AS VARCHAR) + ''-01 00:00:00''))
PRINT @StartDate
PRINT @EndDate

SELECT  @StartDate As StartDate, @EndDate As EndDate, * FROM (SELECT COALESCE(max(tb.Territory), '''') as Territory, COALESCE(c.Name, '''') AS CCG, PRACTICE, p.Name As PracticeName, p.Address1, p.Address2, p.Address3, PostCode, CountAs, 
				CASE WHEN tp.Code IS NULL THEN ''No Match'' ELSE ''Target'' END AS Targeted, COALESCE(SUM(CAST(NIC AS FLOAT)), 0) as NIC 
FROM        dbo.PracticeData pd WITH(NOLOCK)
INNER JOIN  dbo.Practice p WITH(NOLOCK)
ON			pd.PRACTICE = p.Code
LEFT JOIN	TargetPractices tp WITH(NOLOCK)
ON			p.Code = tp.Code
LEFT JOIN	dbo.CCGLookup c WITH(NOLOCK)
ON			p.CCGCode = c.Code
INNER JOIN	dbo.TerritoryBrick tb WITH(NOLOCK)
ON			LEFT(p.PostCode, LEN(tb.Brick)) = tb.Brick		
INNER JOIN	BNFProducts bp
ON			pd.BNF_CODE = bp.BNF_CODE
WHERE       pd.PERIODDATE between  @StartDate and @EndDate
GROUP BY     PRACTICE, p.Address1, p.Address2, p.Address3, PostCode, CountAs, tp.Code, c.Name, p.Name)                 
       x PIVOT (
                SUM(NIC) FOR CountAs IN ('+ @cols +') 
                ) p
                GROUP BY PRACTICE, Address1, Address2, Address3, PostCode, Targeted, CCG, Territory, PracticeName,' + @cols +'
				ORDER BY Territory, CCG, PRACTICE'
--print @query
-- EXECUTE(@query)

-- MAT THIS YEAR
SET @query = N'
DECLARE @StartDate datetime = ''2013-07-01 00:00:00''-- (select CONVERT(datetime, cast(DATEPART(year, getdate()) as varchar)+ ''-0'' + CAST(DATEPART(MONTH, DATEADD(month, -6, GETDATE())) AS VARCHAR) + ''-01 00:00:00''))
DECLARE @EndDate  datetime = ''2013-09-01 00:00:00''-- (select CONVERT(datetime, cast(DATEPART(year, getdate()) as varchar)+ ''-0'' + CAST(DATEPART(MONTH, DATEADD(month, -4, GETDATE())) AS VARCHAR) + ''-01 00:00:00''))
PRINT @StartDate
PRINT @EndDate

SELECT  @StartDate As StartDate, @EndDate As EndDate, * FROM (SELECT COALESCE(max(tb.Territory), '''') as Territory, COALESCE(c.Name, '''') AS CCG, PRACTICE, p.Name As PracticeName, p.Address1, p.Address2, p.Address3, PostCode, CountAs, 
				CASE WHEN tp.Code IS NULL THEN ''No Match'' ELSE ''Target'' END AS Targeted, COALESCE(SUM(CAST(NIC AS FLOAT)), 0) as NIC 
FROM        dbo.PracticeData pd WITH(NOLOCK)
INNER JOIN  dbo.Practice p WITH(NOLOCK)
ON			pd.PRACTICE = p.Code
LEFT JOIN	TargetPractices tp WITH(NOLOCK)
ON			p.Code = tp.Code
LEFT JOIN	dbo.CCGLookup c WITH(NOLOCK)
ON			p.CCGCode = c.Code
INNER JOIN	dbo.TerritoryBrick tb WITH(NOLOCK)
ON			LEFT(p.PostCode, LEN(tb.Brick)) = tb.Brick	
INNER JOIN	BNFProducts bp
ON			pd.BNF_CODE = bp.BNF_CODE	
WHERE       pd.PERIODDATE between  @StartDate and @EndDate
GROUP BY     PRACTICE, p.Address1, p.Address2, p.Address3, PostCode, CountAs, tp.Code, c.Name, p.Name)                 
       x PIVOT (
                SUM(NIC) FOR CountAs IN ('+ @cols +') 
                ) p
                GROUP BY PRACTICE, Address1, Address2, Address3, PostCode, Targeted, CCG, Territory, PracticeName,' + @cols +'
				ORDER BY Territory, CCG, PRACTICE'
--print @query
-- EXECUTE(@query)


-- MQT LAST YEAR
SET @query = N'
DECLARE @StartDate datetime = ''2013-07-01 00:00:00''-- CONVERT(DATETIME, (CAST(datepart(YEAR,(SELECT DATEADD(month, -18, getdate()))) AS varchar(4))) + ''-''+CAST(datepart(MONTH,(SELECT DATEADD(month, -18, getdate()))) AS varchar(2)) + ''-01 00:00:00:000'')
DECLARE @EndDate  datetime = ''2013-09-01 00:00:00''-- CONVERT(DATETIME, (CAST(datepart(YEAR,(SELECT DATEADD(month, -16, getdate()))) AS varchar(4))) + ''-''+CAST(datepart(MONTH,(SELECT DATEADD(month, -16, getdate()))) AS varchar(2)) + ''-01 00:00:00:000'')
PRINT @StartDate
PRINT @EndDate
SELECT @StartDate As StartDate, @EndDate As EndDate,  * FROM (SELECT COALESCE(max(tb.Territory), '''') as Territory, COALESCE(c.Name, '''') AS CCG, PRACTICE, p.Name As PracticeName, p.Address1, p.Address2, p.Address3, PostCode, CountAs, 
				CASE WHEN tp.Code IS NULL THEN ''No Match'' ELSE ''Target'' END AS Targeted, COALESCE(SUM(CAST(NIC AS FLOAT)), 0) as NIC 
FROM        dbo.PracticeData pd WITH(NOLOCK)
INNER JOIN  dbo.Practice p WITH(NOLOCK)
ON			pd.PRACTICE = p.Code
LEFT JOIN	TargetPractices tp WITH(NOLOCK)
ON			p.Code = tp.Code
LEFT JOIN	dbo.CCGLookup c WITH(NOLOCK)
ON			p.CCGCode = c.Code\
INNER JOIN	dbo.TerritoryBrick tb WITH(NOLOCK)
ON			LEFT(p.PostCode, LEN(tb.Brick)) = tb.Brick		
INNER JOIN	BNFProducts bp
ON			pd.BNF_CODE = bp.BNF_CODE
WHERE       pd.PERIODDATE between  @StartDate and @EndDate
GROUP BY     PRACTICE, p.Address1, p.Address2, p.Address3, PostCode, CountAs, tp.Code, c.Name, p.Name)                 
       x PIVOT (
                SUM(NIC) FOR CountAs IN ('+ @cols +') 
                ) p
                GROUP BY PRACTICE, Address1, Address2, Address3, PostCode, Targeted, CCG, Territory,PracticeName,' + @cols +'
				ORDER BY Territory, CCG, PRACTICE'
--print @query
EXECUTE(@query)

-- MQT THIS YEAR
SET @query = N'
DECLARE @StartDate datetime = ''2014-07-01 00:00:00''--  CONVERT(DATETIME, (CAST(datepart(YEAR,(SELECT DATEADD(month, -6, getdate()))) AS varchar(4))) + ''-''+CAST(datepart(MONTH,(SELECT DATEADD(month, -6, getdate()))) AS varchar(2)) + ''-01 00:00:00:000'')
DECLARE @EndDate  datetime = ''2014-09-01 00:00:00''--  CONVERT(DATETIME, (CAST(datepart(YEAR,(SELECT DATEADD(month, -4, getdate()))) AS varchar(4))) + ''-''+CAST(datepart(MONTH,(SELECT DATEADD(month, -4, getdate()))) AS varchar(2)) + ''-01 00:00:00:000'')
PRINT @StartDate
PRINT @EndDate
SELECT @StartDate As StartDate, @EndDate As EndDate,  * FROM (SELECT COALESCE(max(tb.Territory), '''') as Territory, COALESCE(c.Name, '''') AS CCG, PRACTICE, p.Name As PracticeName, p.Address1, p.Address2, p.Address3, PostCode, CountAs, 
				CASE WHEN tp.Code IS NULL THEN ''No Match'' ELSE ''Target'' END AS Targeted, COALESCE(SUM(CAST(NIC AS FLOAT)), 0) as NIC 
FROM        dbo.PracticeData pd WITH(NOLOCK)
INNER JOIN  dbo.Practice p WITH(NOLOCK)
ON			pd.PRACTICE = p.Code
LEFT JOIN	TargetPractices tp WITH(NOLOCK)
ON			p.Code = tp.Code
LEFT JOIN	dbo.CCGLookup c WITH(NOLOCK)
ON			p.CCGCode = c.Code
INNER JOIN	dbo.TerritoryBrick tb WITH(NOLOCK)
ON			LEFT(p.PostCode, LEN(tb.Brick)) = tb.Brick		
INNER JOIN	BNFProducts bp
ON			pd.BNF_CODE = bp.BNF_CODE
WHERE       pd.PERIODDATE between  @StartDate and @EndDate

GROUP BY     PRACTICE, p.Address1, p.Address2, p.Address3, PostCode, CountAs, tp.Code, c.Name,p.Name)                 
       x PIVOT (
                SUM(NIC) FOR CountAs IN ('+ @cols +') 
                ) p
                GROUP BY PRACTICE, Address1, Address2, Address3, PostCode, Targeted, CCG, Territory, PracticeName,' + @cols +'
				ORDER BY Territory, CCG, PRACTICE'
--print @query

EXECUTE(@query)

