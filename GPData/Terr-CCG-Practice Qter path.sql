SELECT DISTINCT [Id]
			,t.[Territory]
FROM		[GPData].[dbo].[Territory] t
INNER JOIN	TerritoryBrick tb
ON			t.Id = tb.TerritoryId
INNER JOIN	[dbo].[Practice] p
ON			LEFT(p.PostCode, LEN(tb.Brick)) = tb.Brick
INNER JOIN  CCGLookup c
ON			c.Code = p.CCGCode
ORDER BY	Territory

30

SELECT DISTINCT c.Code, c.Name 
FROM          Practice p
INNER JOIN    TerritoryBrick tb
ON                   LEFT(p.PostCode, LEN(tb.Brick)) = tb.Brick
INNER JOIN  CCGLookup c
ON                   c.Code = p.CCGCode
WHERE         tb.TerritoryId = 30
ORDER BY      c.Name




SELECT DISTINCT p.Code, 	   
				LTRIM(RTRIM(p.Name) + ' - ' + CASE WHEN tp.Code IS NULL THEN '(NO MATCH)' ELSE '(TARGETED)' END) AS Name
FROM            Practice p
LEFT JOIN       TargetPractices tp
ON	            p.Code = tp.Code
WHERE          [CCGCode] = '04H'
ORDER BY        Name