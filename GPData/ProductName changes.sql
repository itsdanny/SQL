select * from BNFProducts
SELECT			COALESCE(max(tb.Territory), '''') as Territory, 
				COALESCE(c.Name, '''') AS CCG, PRACTICE, p.Name As PracticeName, p.Address1, p.Address2, p.Address3, PostCode, BNF_NAME, 
				CASE WHEN tp.Code IS NULL THEN 'No Match' ELSE 'Target' END AS Targeted, 
				COALESCE(SUM(CAST(NIC AS FLOAT)), 0) as NIC 
FROM        dbo.PracticeData pd WITH(NOLOCK)
INNER JOIN  dbo.Practice p WITH(NOLOCK)
ON			pd.PRACTICE = p.Code
LEFT JOIN	TargetPractices tp WITH(NOLOCK)
ON			p.Code = tp.Code
LEFT JOIN	dbo.CCGLookup c WITH(NOLOCK)
ON			p.CCGCode = c.Code
INNER JOIN	dbo.TerritoryBrick tb WITH(NOLOCK)
ON			LEFT(p.PostCode, LEN(tb.Brick)) = tb.Brick		
WHERE       pd.PERIODDATE between  DATEADD(month, -22, GETDATE()) and DATEADD(month, -16, GETDATE())
GROUP BY    PRACTICE, p.Address1, p.Address2, p.Address3, PostCode, BNF_NAME, tp.Code, c.Name,p.Name


SELECT			COALESCE(max(tb.Territory), '''') as Territory, 
				COALESCE(c.Name, '''') AS CCG, PRACTICE, p.Name As PracticeName, p.Address1, p.Address2, p.Address3, PostCode, BNF_NAME, 
				CASE WHEN tp.Code IS NULL THEN 'No Match' ELSE 'Target' END AS Targeted, 
				COALESCE(SUM(CAST(NIC AS FLOAT)), 0) as NIC 
FROM        dbo.PracticeData pd WITH(NOLOCK)
INNER JOIN  dbo.Practice p WITH(NOLOCK)
ON			pd.PRACTICE = p.Code
LEFT JOIN	TargetPractices tp WITH(NOLOCK)
ON			p.Code = tp.Code
LEFT JOIN	dbo.CCGLookup c WITH(NOLOCK)
ON			p.CCGCode = c.Code
INNER JOIN	dbo.TerritoryBrick tb WITH(NOLOCK)
ON			LEFT(p.PostCode, LEN(tb.Brick)) = tb.Brick		
WHERE       pd.PERIODDATE between  DATEADD(month, -10, GETDATE()) and DATEADD(month, -4, GETDATE())
GROUP BY    PRACTICE, p.Address1, p.Address2, p.Address3, PostCode, BNF_NAME, tp.Code, c.Name,p.Name

update	b
SET			b.CountAs = u.CountAs
FROM		Updates u
INNER JOIN	BNFProducts b
ON			u.BNF_CODE = b.BNF_CODE
WHERE		u.CountAs <> b.CountAs


update		a
SET			a.BNF_Name = b.BNF_NAME
FROM		BNFProducts a
INNER JOIN	PracticeData b
ON			a.BNF_CODE = b.BNF_CODE
WHERE		a.BNF_Name <> b.BNF_NAME