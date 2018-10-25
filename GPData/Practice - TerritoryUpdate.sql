-- current but wrong territory
begin tran
UPDATE		p
SET			p.TerritoryId = t.Id
FROM		TerritoryPracticeImport i
INNER JOIN	Territory t
ON			t.Territory = i.CurrTerritory
INNER JOIN	Practice p
ON			p.Code = i.PracticeCode
AND			t.Id <> p.TerritoryId
rollback
SELECT		COUNT(1)
FROM		TerritoryPracticeImport i
INNER JOIN	Territory t
ON			t.Territory = i.ActualTerritory
INNER JOIN	Practice p
ON			p.Code = i.PracticeCode
AND			t.Id <> p.TerritoryId


UPDATE		p
SET			p.TerritoryId = t.Id
FROM		TerritoryPracticeImport i
INNER JOIN	Territory t
ON			t.Territory = i.ActualTerritory
INNER JOIN	Practice p
ON			p.Code = i.PracticeCode
AND			t.Id <> p.TerritoryId


select 179 +69 