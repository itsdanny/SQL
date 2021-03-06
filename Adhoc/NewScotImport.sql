SELECT * FROM CCGLookup WHERE Territory = 'G102' -- SA9

SELECT * FROM Practice WHERE Code  in('S00025898','S00061644')
SELECT COUNT(1), PERIODDATE, PCT FROM	PracticeData where PCT in ('SA9','SC02','SJ9','SL9')
GROUP BY PERIODDATE, PCT
ORDER BY PERIODDATE, PCT


SELECT COUNT(1), PERIODDATE, PCT FROM PracticeData where PRACTICE IN (SELECT Code FROM Practice WHERE CCGCode = 'SA9')
GROUP BY PERIODDATE, PCT
ORDER BY PERIODDATE, PCT



SELECT * FROM Countries

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT REPLACE('123','1','X')
UPDATE csvdata SET BNFDescription = REPLACE(BNFDescription, '"','')

SELECT * FROM csvdata c

SELECT		distinct c.BNFCode, c.BNFDescription 
FROM		csvdata c
LEFT JOIN	BNFProducts p
ON			c.BNFCode = p.[BNF_CODE] 
WHERE		p.BNF_CODE IS NOT NULL
order by BNFDescription

select top 5 * from ImportDataScottish
DELETE FROM ImportDataScottish
WHERE   (NOT ( [BNFCode]  IN
(SELECT  [BNFCode] 
FROM     ImportDataScottish
WHERE	([BNFCode] LIKE '130201%') 
OR		([BNFCode] LIKE '2122%') 
OR		([BNFCode] = '1301010D0AAAAAA') 
OR		([BNFCode] LIKE '2380%')
OR		([BNFCode] LIKE '0606020%')
OR		([BNFCode] LIKE '130900%')
OR		([BNFCode] LIKE '1902055%')
OR		([BNFCode] LIKE  '1003020%')
OR		([BNFCode] LIKE  '090604%')   
OR		([BNFCode] LIKE  'NI%')   
GROUP BY [BNFCode])))



UPDATE  ImportDataScottish
SET		PaidDate = LEFT(PaidDate, 6)
WHERE	LEN(PaidDate) > 6


SELECT * FROM Practice



INSERT INTO BNFProducts(BNF_CODE, BNF_Name, CountAs)
SELECT DISTINCT BNFCode, BNFDescription, 'Unassigned' FROM ImportDataScottish WHERE BNFCode NOT IN (SELECT BNF_CODE FROM BNFProducts)


SELECT * FROM ImportDataScottish
SELECT TOP 5 * FROM PracticeData
INSERT INTO PracticeData
SELECT	SHA, 
		PCT, 
		pR, [BNF CODE] as BNF_CODE, [BNF NAME] as BNF_NAME, CAST(ITEMS AS FLOAT) AS ITEMS, 
		CAST(NIC AS FLOAT) AS NIC, CAST(ACTCOST AS FLOAT) AS ACTCOST, CAST(QUANTITY AS FLOAT) AS QUANTITY, 
		CONVERT(DATETIME,[PERIOD] + '01', 101) AS PERIODDATE, 
		PaidDate
FROM	ImportDataScottish


SELECT * FROM csvdata WHERE BNFDescription LIKE 'COLECAL%'
select * from BNFProducts where BNF_CODE like 'S%'


TRUNCATE TABLE ImportPractice
select TOP 100 * from [Practice] where CountryId = 1
select * from [Practice] where CountryId = 3


INSERT INTO [dbo].[Practice] (Period, Code, CountryId, Name, Address1, Address2, Address3, Address4, PostCode, Dispensing, CCGCode)
SELECT		DISTINCT Period, PracticeID, 3 AS CountryId, Pr, Address1, Address2, Address3, Address4, PostCode,  
			CASE UPPER(Dispensing) WHEN 'Y' THEN 1 WHEN 'YES'THEN 1 WHEN 'N' THEN 0 WHEN 'NO' THEN 0 ELSE 0 END 
FROM		ImportPractice i
LEFT JOIN	CCGLookup c

WHERE PracticeID not in (SELECT DISTINCT Code from [dbo].[Practice])

select distinct Period, PracticeID, 3 AS CountryId,Name, Address1, Address2, Address3, Address4, PostCode,  CASE UPPER(Dispensing) WHEN 'Y' THEN 1 WHEN 'YES'THEN 1 WHEN 'N' THEN 0 WHEN 'NO' THEN 0 ELSE 0 END FROM ImportPractice 
WHERE PracticeID not in (SELECT DISTINCT Code from [dbo].[Practice])


UPDATE  p 
SET   p.Name =  imp.Name,
   p.Address1 = imp.Address1,
   p.Address2 = imp.Address2,
   p.Address3 = imp.Address3,
   p.Address4 = imp.Address4,
   p.PostCode = imp.PostCode,
   p.Period =   imp.Period,
   p.Dispensing = CASE UPPER(imp.Dispensing) WHEN 'Y' THEN 1 WHEN 'YES'THEN 1 WHEN 'N' THEN 0 WHEN 'NO' THEN 0 ELSE 0 END
FROM  Practice p
INNER JOIN ImportPractice imp
ON   p.Code = imp.PracticeID
WHERE  CAST(p.Period AS INT) <CAST(imp.Period AS INT)
AND   (p.Name <> imp.Name
OR   p.Address1 <> imp.Address1
OR   p.Address2 <> imp.Address2
OR   p.Address3 <> imp.Address3
OR   p.Address4 <> imp.Address4
OR   p.PostCode <> imp.PostCode
OR	p.Dispensing <> CASE UPPER(imp.Dispensing) WHEN 'Y' THEN 1 WHEN 'YES'THEN 1 WHEN 'N' THEN 0 WHEN 'NO' THEN 0 ELSE 0 END)


SELECT * FROM PracticeData WHERE QUANTITY IS NULL OR QUANTITY = 0
SELECT * FROM PracticeData WHERE ACTCOST IS NULL OR ACTCOST = 0

SELECT TOP 5 * FROM ImportDataScottish
SELECT TOP 5 * FROM PracticeData
begin tran
--insert into PracticeData
SELECT 	c.Code, NULL, PracticeCode, BNFCode, NULL, 
		CAST(NumberofPaidItems AS FLOAT), 
		CAST(GrossIngredientCost AS FLOAT) AS NIC, 
		CAST(0 AS FLOAT) AS ACTCOST, 
		CAST(0 AS FLOAT) AS QUANTITY, 
		CONVERT(DATETIME,PaidDate + '01', 101) AS PERIODDATE, PaidDate
FROM		ImportDataScottish i
INNER JOIN	CCGLookup c
ON			i.HealthBoardCode = c.BoardCode
rollback
select * from CCGLookup where BoardCode is not null order by BoardCode
S08000001
S08000001

select * from Practice where Code LIKE '%80005'

select * from PracticeData where PRACTICE   LIKE '%80005'

select * from PracticeData where PCT = 'SA9'
AND  PERIODDATE > '2015-09-01 00:00:00.000'

select * from PracticeData where PERIODDATE > '2015-09-01 00:00:00.000'
order by PERIODDATE desc

select * from PracticeData where SHA IS NOT NULL 
AND PCT is null and LEFT(PRACTICE, 4) = 'S000'
and PERIODDATE > '2015-09-01 00:00:00.000'


UPDATE		PracticeData 
SET			PCT = SHA
WHERE		SHA IS NOT NULL 
AND			PCT IS NULL 
AND			LEFT(PRACTICE, 4) = 'S000'
AND			PERIODDATE > '2015-09-01 00:00:00.000'

select * from ImportDataScottish where HealthBoardCode ='S08000001'
select * from CCGLookup where BoardCode = 'S08000001'
select * from PracticeData where PRACTICE like '%80908' AND			PERIODDATE > '2015-09-01 00:00:00.000'


INSERT INTO PracticeData
SELECT 	NULL, c.Code, 'S000'+RTRIM(LTRIM(PracticeCode)), BNFCode, NULL, 
		CAST(NumberofPaidItems AS FLOAT), 
		CAST(GrossIngredientCost AS FLOAT) AS NIC, 
		CAST(0 AS FLOAT) AS ACTCOST, 
		CAST(0 AS FLOAT) AS QUANTITY, 
		CONVERT(DATETIME,PaidDate + '01', 101) AS PERIODDATE, PaidDate
FROM		ImportDataScottish i
INNER JOIN	CCGLookup c
ON			i.HealthBoardCode = c.BoardCode