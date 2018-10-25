
SELECT DISTINCT RepName, Territory from CCGImport -- 31 Terrs; 29 RepNames; 240 CCGS; 2842 Bricks 
ORDER BY Territory

SELECT * FROM Territory
SELECT * FROM TerritoryBrick 
SELECT * FROM TerritoryCCGs
SELECT * FROM TerritoryRep

SELECT		* from Countries
FROM		Territory t
INNER JOIN	TerritoryBrick tb
ON			t.Id = tb.TerritoryId

UPDATE		pd
SET			pd.PracticeId = p.Id
FROM		Practice p
INNER JOIN	PracticeData pd
ON			p.Code = pd.PRACTICE
WHERE		pd.PracticeId IS NULL


SELECT		* 
FROM		Countries c
INNER JOIN	Territory t
ON			c.Id = t.CountryId
INNER JOIN	TerritoryCCGs tc
ON			t.Id = tc.TerritoryId
INNER JOIN	TerritoryRep r
ON			t.Id = r.TerritoryId
INNER JOIN	Practice p
ON			tc.Id = p.CCGId
INNER JOIN	PracticeData pd
ON			p.Id = pd.PracticeId

insert into CCGBricks
SELECT		distinct c.Id, i.Brick 
FROM		TerritoryCCGs c
INNER JOIN	CCGImport i
ON			UPPER(c.CCGName) = UPPER(i.CCG)

UPDATE Practice SET BrickId = NULL

DELETE FROM CCGBricks 

DBCC CHECKIDENT (CCGBricks, reseed, 0)