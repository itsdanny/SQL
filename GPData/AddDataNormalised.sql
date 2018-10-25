CREATE PROCEDURE sp__AddNewBNFProducts
as

SELECT [BNF CODE] as BNF_CODE, [BNF NAME] AS BNF_NAME into #NewBNFProducts FROM ImportDataEnglish WHERE [BNF CODE] NOT IN (SELECT BNF_CODE FROM BNFProducts)

DECLARE @newRows as int = (select count(1) from #NewBNFProducts)

INSERT INTO BNFProducts(BNF_CODE, BNF_Name)


select		*
FROM		CCGBricks c 
INNER JOIN	Practice p
ON			UPPER(c.Brick) = UPPER(LEFT(p.PostCode, 4))
WHERE		LEN(p.PostCode) = 8
AND			p.BrickId IS NULL

select		*
FROM		CCGBricks c 
INNER JOIN	Practice p
ON			UPPER(c.Brick) = UPPER(LEFT(p.PostCode, 3))
WHERE		LEN(p.PostCode) = 7
AND			p.BrickId IS NULL

select		*
FROM		CCGBricks c 
INNER JOIN	Practice p
ON			UPPER(c.Brick) = UPPER(LEFT(p.PostCode, 2))
WHERE		LEN(p.PostCode) = 6
AND			p.BrickId IS NULL


UPDATE		p
SET			p.BrickId = c.Id 
FROM		CCGBricks c 
INNER JOIN	Practice p
ON			UPPER(c.Brick) = UPPER(LEFT(p.PostCode, 4))
WHERE		LEN(p.PostCode) = 8
AND			p.BrickId IS NULL

UPDATE		p
SET			p.BrickId = c.Id 
FROM		CCGBricks c 
INNER JOIN	Practice p
ON			UPPER(c.Brick) = UPPER(LEFT(p.PostCode, 3))
WHERE		LEN(p.PostCode) = 7
AND			p.BrickId IS NULL

UPDATE		p
SET			p.BrickId = c.Id 
FROM		CCGBricks c 
INNER JOIN	Practice p
ON			UPPER(c.Brick) = UPPER(LEFT(p.PostCode, 2))
WHERE		LEN(p.PostCode) = 6
AND			p.BrickId IS NULL

select * from Practice where BrickId IS NULL

select * from Countries c
INNER JOIN Territory t
ON		c.Id = t.CountryId
inner join CCG g
ON			t.Id = g.TerritoryId
where c.Id = 4

SELECT TOP 1 * FROM PracticeData
SELECT TOP 1 * FROM PracticeData


update		p 
SET			p.CCGId = c.Id
FROM		CCGImport ci
INNER JOIN	Practice p
ON			UPPER(ci.Brick) = UPPER(LEFT(p.PostCode, 4))
INNER JOIN	CCG c
ON			c.CCGName = ci.CCG
WHERE		LEN(p.PostCode) = 8
AND			p.CCGId IS NULL

update		p 
SET			p.CCGId = c.Id
FROM		CCGImport ci
INNER JOIN	Practice p
ON			UPPER(ci.Brick) = UPPER(LEFT(p.PostCode, 3))
INNER JOIN	CCG c
ON			c.CCGName = ci.CCG
WHERE		LEN(p.PostCode) = 7
AND			p.CCGId IS NULL

update		p 
SET			p.CCGId = c.Id
FROM		CCGImport ci
INNER JOIN	Practice p
ON			UPPER(ci.Brick) = UPPER(LEFT(p.PostCode, 2))
INNER JOIN	CCG c
ON			c.CCGName = ci.CCG
WHERE		LEN(p.PostCode) = 6
AND			p.CCGId IS NULL


SELECT * 
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

SELECT * FROM BNFProducts
Alter Table PracticeData
ADD FOREIGN KEY (BNFCodeId)
REFERENCES BNFProducts(Id)

Alter Table PracticeData
ADD FOREIGN KEY (PracticeId)
REFERENCES Practice(Id)


SELECT * 
UPDATE		pd
SET			pd.PracticeId = p.Id
FROM		Practice p
INNER JOIN	PracticeData pd
ON			p.Code = pd.PRACTICE
where		pd.PracticeId IS NULL

select *
FROM		BNFProducts p
INNER JOIN	PracticeData pd
ON			pd.BNF_CODE = p.BNF_CODE
where		pd.BNF_CODE IS NULL
and			pd.PERIOD = '201409'


UPDATE		pd
SET			pd.BNFCodeId = p.Id
FROM		BNFProducts p
INNER JOIN	PracticeData pd
ON			pd.BNF_CODE = p.BNF_CODE
where		pd.BNF_CODE IS NULL

