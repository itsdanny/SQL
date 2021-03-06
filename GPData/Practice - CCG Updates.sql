SELECT * FROM CCG
drop table TerritoryCCGs 
SELECT  * FROM TerritoryCCG
SELECT distinct t.Id as TerritoryId, UPPER(CCG) AS CCGName into TerritoryCCGs  FROM CCGImport i inner join Territory t on t.Territory = i.Territory

SELECT * FROM Territory ORDER BY Territory
SELECT * FROM TerritoryBrick
SELECT * FROM CCGLookup
SELECT * FROM CCGTerritory



SELECT * FROM CCGLookup where Code in ('6A5','7A3')

SELECT * FROM CCGImport  where Brick in ('SA10','SA1','CF31','SA2')
select * from Practice where Code in ('6A5','7A3')
select * from Practice where CCGCode in ('6A5','7A3')
select top 10 * from PracticeData

SELECT		COUNT(1), PERIODDATE from Practice p
INNER JOIN	PracticeData pd
ON			p.Code = pd.PRACTICE
where		p.CountryId = 2
group by	PERIODDATE
order by	PERIODDATE

select * from Practice where Code not in(
SELECT		p.Code
FROM		CCGImport c
INNER JOIN	Practice p
ON			c.Brick = LEFT(p.PostCode, 4)
WHERE		LEN(p.PostCode) = 8
UNION ALL
SELECT		p.Code
FROM		CCGImport c
INNER JOIN	Practice p
ON			c.Brick = LEFT(p.PostCode, 3)
WHERE		LEN(p.PostCode) = 7
UNION ALL
SELECT		p.Code
FROM		CCGImport c
INNER JOIN	Practice p
ON			c.Brick = LEFT(p.PostCode, 2)
WHERE		LEN(p.PostCode) = 6)
order by Period


SELECT		p.CCGId, c.Id
FROM		CCGImport ci
INNER JOIN	Practice p
ON			UPPER(ci.Brick) = UPPER(LEFT(p.PostCode, 4))
INNER JOIN	CCG c
ON			c.CCGName = ci.CCG
WHERE		LEN(p.PostCode) = 8
UNION ALL
SELECT		p.CCGId, c.Id
FROM		CCGImport ci
INNER JOIN	Practice p
ON			UPPER(ci.Brick) = UPPER(LEFT(p.PostCode, 3))
INNER JOIN	CCG c
ON			c.CCGName = ci.CCG
WHERE		LEN(p.PostCode) = 7
UNION ALL
SELECT		p.CCGId, c.Id
FROM		CCGImport ci
INNER JOIN	Practice p
ON			UPPER(ci.Brick) = UPPER(LEFT(p.PostCode, 2))
INNER JOIN	CCG c
ON			c.CCGName = ci.CCG
WHERE		LEN(p.PostCode) = 6
order by p.Code 


select * from PracticeData  where BNFCodeId is null
select count(1) from PracticeData  where BNFCodeId is not null

UPDATE		d 
SET			d.BNFCodeId = p.Id
FROM		GPData.dbo.PracticeData l 
INNER JOIN  BNFProducts p
ON			l.BNF_CODE = p.BNF_CODE
INNER JOIN	PracticeData d 
ON			l.Id =  d.Id

select  *
FROM		GPData.dbo.PracticeData l 
--INNER JOIN  BNFProducts p
--ON			l.BNF_CODE = p.BNF_CODE
INNER JOIN	PracticeData d 
ON			l.Id =  d.Id
where		d.BNFCodeId is null

alter table PracticeData
drop column PRACTICE
go

alter table PracticeData
add BNF_CODE VARCHAR(40)
go

alter table PracticeData
drop column BNF_CODE
go

alter table PracticeData
drop column BNF_NAME
go

DROP INDEX IX_PracticeData_Practice
on	PracticeData

select * from BNFProducts  where ZeroCompareBrandId = BNF_CODE

select * from BNFProducts where BNF_CODE = ZeroCompareBNFCode
select * from GPData.dbo.BNFProducts where BNF_CODE in ('1302010J0AAABAB','130201100AAAJAJ','0906040G0AAASAS','0906040G0CHAJCT','1302010N0AAADAD','0906040G0BWAFCN')

select  DATEADD(MONTH, DATEDIFF(MONTH, '20500131', DATEADD(MONTH, -1, GETDATE())), '20500131')

sELECT	*
FROM		Practice p 
 where CountryId = 4 

INNER JOIN	ImportPractice i
ON			p.Code = i.PracticeID
INNER JOIN	CCG c
ON			i.CCGName = c.CCGName
 where CountryId = 4 


update		p 
SET			p.BrickId = b.Id
FROM		Practice p
INNER JOIN  Brick b
ON			UPPER(b.Brick) = UPPER(LEFT(p.PostCode, 4))
WHERE		LEN(p.PostCode) = 8
AND			p.BrickId IS NULL

update		p 
SET			p.BrickId = b.Id
FROM		Practice p
INNER JOIN  Brick b
ON			UPPER(b.Brick) = UPPER(LEFT(p.PostCode, 3))
WHERE		LEN(p.PostCode) = 7
AND			p.BrickId IS NULL

update		p 
SET			p.BrickId = b.Id
FROM		Practice p
INNER JOIN  Brick b
ON			UPPER(b.Brick) = UPPER(LEFT(p.PostCode, 2))
WHERE		LEN(p.PostCode) = 6
AND			p.BrickId IS NULL

update ImportDataNI 
set	PeriodDate = CONVERT(DATETIME, Year + '-' + Month + '-01 00:00:00')

select datediff(DAY, CONVERT(DATETIME, '2014' + '-' + '11' + '-01 00:00:00'), getDate())


DELETE FROM ImportDataNI
WHERE        (NOT (BNFCode IN
                    (SELECT       BNFCode
                    FROM            ImportDataNI AS RawDataFile_1
                    WHERE	(BNFCode LIKE '130201%') 
					OR		(BNFCode LIKE '2122%') 
					OR		(BNFCode = '1301010D0AAAAAA') 
					OR		(BNFCode LIKE  '1003020%')
					OR		(BNFCode LIKE  '0906040G0%')   
GROUP BY BNFCode)))