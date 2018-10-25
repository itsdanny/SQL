DECLARE @StartDate datetime = (select CONVERT(datetime, cast(DATEPART(year, getdate()) as varchar)+ '-0' + CAST(DATEPART(MONTH, DATEADD(month, -22, GETDATE())) AS VARCHAR) + '-01 00:00:00'))
DECLARE @EndDate  datetime = (select CONVERT(datetime, cast(DATEPART(year, getdate()) as varchar)+ '-0' + CAST(DATEPART(MONTH, DATEADD(month, -17, GETDATE())) AS VARCHAR) + '-01 00:00:00'))
PRINT @StartDate
PRINT @EndDate
SELECT			(SELECT	tb.Territory 
					   FROM		dbo.TerritoryBrick tb WITH(NOLOCK)
-					   WHERE	p. = tb.Brick) AS TERRITORY,
				COALESCE(SUM(CAST(ITEMS AS FLOAT)), 0) as ITEMS,
				COALESCE(SUM(CAST(NIC AS FLOAT)), 0) as NIC 
FROM        dbo.PracticeData pd WITH(NOLOCK)
INNER JOIN  dbo.Practice p WITH(NOLOCK)
ON			pd.PRACTICE = p.Code
LEFT JOIN	TargetPractices tp WITH(NOLOCK)
ON			p.Code = tp.Code
LEFT JOIN	dbo.CCGLookup c WITH(NOLOCK)
ON			p.CCGCode = c.Code	
INNER JOIN	BNFProducts bp
ON			pd.BNF_CODE = bp.BNF_CODE
WHERE       pd.PERIODDATE between  @StartDate and @EndDate
AND			bp.CountAs like 'Cetraben%'
AND			p.CountryId = 1
--GROUP BY     PRACTICE, p.Address1, p.Address2, p.Address3, PostCode, CountAs, p.Name--, tp.Code, c.Name

-- all joins 15165

-- min joins + (all excl TB) 5370589


				--COALESCE(c.Name, ') AS CCG, 
				--PRACTICE, p.Name As PracticeName, p.Address1, p.Address2, p.Address3, PostCode, CountAs, 
				--CASE WHEN tp.Code IS NULL THEN 'No Match' ELSE 'Target' END AS Targeted, 
---					   WHERE	LEFT(p.PostCode, LEN(tb.Brick)) = tb.Brick, 'NO TERRITORY') AS TERRITORY,
--

select * from Territory
select * from TerritoryBrick
select * from CCGTerritory
