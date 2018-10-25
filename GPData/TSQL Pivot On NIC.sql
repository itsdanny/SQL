use GPData

DECLARE @PeriodStart DateTime
DECLARE @PeriodEnd Date
DECLARE @cols NVARCHAR(MAX) 
DECLARE @query NVARCHAR(MAX) 

--select @PeriodStart = DATEADD(month, -27, GETDATE()), @PeriodEnd = DATEADD(month, -16, GETDATE())
select @PeriodStart = DATEADD(month, -15, GETDATE()), @PeriodEnd = DATEADD(month, -3, GETDATE())


SELECT  @cols = STUFF(( SELECT DISTINCT TOP 100 PERCENT 
                                '],[' + REPLACE(CountAs, '''','') FROM PracticeData pd inner join BNFProducts bp on pd.BNF_CODE = bp.BNF_CODE
                        --ORDER BY ' , ' + t.PERIOD
                        FOR XML PATH('') 
                      ), 1, 2, '') + ']' 
--	select @cols


SET @query = N'SELECT  * FROM (SELECT COALESCE(tb.Territory, '''') as Territory, COALESCE(c.Name, '''') AS CCG, PRACTICE, p.Name As PracticeName, p.Address1, p.Address2, p.Address3, PostCode, CountAs, 
				CASE WHEN tp.Code IS NULL THEN ''No Match'' ELSE ''Target'' END AS Targeted, COALESCE(SUM(CAST(NIC AS FLOAT)), 0) as NIC 
FROM        dbo.PracticeData pd WITH(NOLOCK)
INNER JOIN  dbo.Practice p WITH(NOLOCK)
ON			pd.PRACTICE = p.Code
INNER JOIN	BNFProducts bp 
ON			pd.BNF_CODE = bp.BNF_CODE
INNER JOIN	dbo.TerritoryBrick tb WITH(NOLOCK)
ON			LEFT(p.PostCode, LEN(tb.Brick)) = tb.Brick		
LEFT JOIN	TargetPractices tp WITH(NOLOCK)
ON			p.Code = tp.Code
LEFT JOIN	dbo.CCGLookup c WITH(NOLOCK)
ON			p.CCGCode = c.Code
WHERE       CAST(pd.PERIODDATE AS DATE) >=  ''' + @PeriodStart + '''
GROUP BY     PRACTICE, tb.Territory, p.Address1, p.Address2, p.Address3, PostCode, CountAs, tp.Code, c.Name,p.Name)                 
       x PIVOT (
                SUM(NIC) FOR CountAs IN ('+ @cols +') 
                ) p
                GROUP BY PRACTICE, Address1, Address2, Address3, PostCode, Targeted,CCG,Territory,PracticeName,' + @cols +'
				ORDER BY Territory, CCG, PRACTICE'

--WHERE       pd.PERIODDATE BETWEEN ''' + CAST(@PeriodStart AS DATETIME) + ''' AND ''' + CAST(@PeriodEnd AS DATETIME) + '''
-- WHERE       pd.PERIODDATE BETWEEN ' + @PeriodStart + ' AND ' + @PeriodEnd + '
EXECUTE(@query)
/*

SET @query = N'SELECT  * FROM (SELECT COALESCE(tb.Territory, '''') as Territory, COALESCE(c.Name, '''') AS CCG, PRACTICE, p.Name As PracticeName, p.Address1, p.Address2, p.Address3, PostCode, CountAs, 
				CASE WHEN tp.Code IS NULL THEN ''No Match'' ELSE ''Target'' END AS Targeted, COALESCE(SUM(CAST(NIC AS FLOAT)), 0) as NIC 
FROM        dbo.PracticeData pd WITH(NOLOCK)
INNER JOIN  dbo.Practice p WITH(NOLOCK)
ON			pd.PRACTICE = p.Code
INNER JOIN	BNFProducts bp 
ON			pd.BNF_CODE = bp.BNF_CODE
INNER JOIN	dbo.TerritoryBrick tb WITH(NOLOCK)
ON			LEFT(p.PostCode, LEN(tb.Brick)) = tb.Brick		
LEFT JOIN	TargetPractices tp WITH(NOLOCK)
ON			p.Code = tp.Code
LEFT JOIN	dbo.CCGLookup c WITH(NOLOCK)
ON			p.CCGCode = c.Code
WHERE       pd.PERIODDATE BETWEEN CAST(DATEADD(month, -27, GETDATE()) AS DATE) AND CAST(DATEADD(month, -16, GETDATE()) AS DATE)  -- may12 apr13,
GROUP BY     PRACTICE, tb.Territory, p.Address1, p.Address2, p.Address3, PostCode, CountAs, tp.Code, c.Name,p.Name)                 
       x PIVOT (
                SUM(NIC) FOR CountAs IN ('+ @cols +') 
                ) p
                GROUP BY PRACTICE, Address1, Address2, Address3, PostCode, Targeted,CCG,Territory,PracticeName,' + @cols +'
				ORDER BY Territory, CCG, PRACTICE'

EXECUTE(@query)

*/