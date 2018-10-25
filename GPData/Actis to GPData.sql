
SELECT DISTINCT Territory, a.GeogCode FROM ACTISPracticeStaffData a 
LEFT JOIN	
(SELECT		DISTINCT b.Territory, a.GeogCode
FROM		GPData.dbo.ACTISPracticeStaffData a 
INNER JOIN	TerritoryBrick b
ON			a.GeogCode = b.Brick
WHERE		LEN(b.Brick) = 4
UNION
SELECT		DISTINCT b.Territory, a.GeogCode
FROM		GPData.dbo.ACTISPracticeStaffData a 
INNER JOIN	TerritoryBrick b
ON			REPLACE(a.GeogCode, '0', '') = b.Brick
WHERE		LEN(b.Brick) = 3) r
ON			a.GeogCode = r.GeogCode
WHERE		r.GeogCode IS NOT NULL

/*
	DROP TABLE GPData.dbo.ACTISPracticeStaffData
	SELECT COUNT (1) FROM GPData.dbo.ACTISPracticeStaffData
*/


SELECT		*
FROM		GPData.dbo.ACTISPracticeStaffData a 
left join	Practice p
on			a.PostCode = p.PostCode
WHERE		p.PostCode is null