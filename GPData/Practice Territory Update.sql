SELECT	*
FROM		[AgreedStructure2] WHERE		Territory LIKE	'G10%'
ORDER BY	Territory, [CCG/Health Board 2013]


SELECT		p.* , a.Territory YourNewTerr, b.Id, t.Territory CurrentTerr
FROM		[AgreedStructure2] a
INNER JOIN 	Practice p
ON			LEFT(LTRIM(RTRIM(p.PostCode)), 4) = a.Postcode
INNER JOIN 	Territory t
ON			p.TerritoryId = t.Id
INNER JOIN 	Territory b
ON			a.Territory = b.Territory
WHERE		len(a.Postcode) = 4
AND			len(replace(p.PostCode, ' ', '')) = 7
AND			a.Territory <> t.Territory
union all
SELECT		p.* , a.Territory YourNewTerr, b.Id, t.Territory CurrentTerr
FROM		[AgreedStructure2] a
INNER JOIN 	Practice p
ON			LEFT(LTRIM(RTRIM(p.PostCode)), 3) = a.Postcode
INNER JOIN 	Territory t
ON			p.TerritoryId = t.Id
INNER JOIN 	Territory b
ON			a.Territory = b.Territory
WHERE		len(a.Postcode) = 3
AND			len(replace(p.PostCode, ' ', '')) = 6
AND			a.Territory <> t.Territory
return

begin tran

UPDATE		p
			SET	p.TerritoryId = b.Id
FROM		[AgreedStructure2] a
INNER JOIN 	Practice p
ON			LEFT(LTRIM(RTRIM(p.PostCode)), 4) = a.Postcode
INNER JOIN 	Territory t
ON			p.TerritoryId = t.Id
INNER JOIN 	Territory b
ON			a.Territory = b.Territory
WHERE		len(a.Postcode) = 4
AND			len(replace(p.PostCode, ' ', '')) = 7
AND			a.Territory <> t.Territory

UPDATE		p
			SET	p.TerritoryId = b.Id
FROM		[AgreedStructure2] a
INNER JOIN 	Practice p
ON			LEFT(LTRIM(RTRIM(p.PostCode)), 3) = a.Postcode
INNER JOIN 	Territory t
ON			p.TerritoryId = t.Id
INNER JOIN 	Territory b
ON			a.Territory = b.Territory
WHERE		len(a.Postcode) = 3
AND			len(replace(p.PostCode, ' ', '')) = 6
AND			a.Territory <> t.Territory

SELECT		p.* , t.Territory
FROM		Practice p
INNER JOIN 	Territory t
ON			p.TerritoryId = t.Id
rollback


SELECT * FROM		[AgreedStructure] a WHERE		LEN(a.Postcode) = 3

SELECT		*
FROM		CCGTerritoryUpdate
WHERE		[CCG Code] ='01K'
GROUP BY	[CCG/Health Board 2013], [CCG Code], LAT, Territory


SELECT	*
FROM		CCGLookup WHERE			Code ='01K' Territory IN ('G103','G107')


SELECT		p.*, a.Territory, t.[CCG Code], t.Territory
FROM		Practice p
INNER JOIN 	CCGTerritoryUpdate t
ON			t.[CCG Code] = p.CCGCode
INNER JOIN 	Territory a
ON			p.TerritoryId = a.Id
WHERE		CCGCode ='01K'
AND			PostCode LIKE 'LA%'

SELECT	*
FROM		Territory