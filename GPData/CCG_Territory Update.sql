/****** Script for SelectTopNRows command from SSMS  ******/
SELECT  * FROM CCGImport where CCG like '%BRIGHTON%'
SELECT * FROM CCGLookup  where Territory is null

SELECT * 
FROM		CCGImport i
INNER JOIN	CCGLookup l
ON			UPPER(i.Territory) = UPPER(l.Territory)
AND			UPPER(i.CCG) = UPPER(l.Name)

SELECT	DISTINCT	UPPER(i.RepName) as NewRep, l.Rep As OldRep, i.Territory, CCG 
FROM		CCGImport i
INNER JOIN	CCGLookup l
ON			UPPER(i.CCG) = UPPER(l.Name)
order by	NewRep

SELECT	DISTINCT	UPPER(i.RepName) as NewRep, l.Rep As OldRep, i.Territory, CCG 
FROM		CCGImport i
INNER JOIN	CCGLookup l
ON			UPPER(i.CCG) = UPPER(l.Name)
ORDER BY	i.Territory

INSERT INTo CCGLookup(Name, ShortName, Rep, Territory)
SELECT		DISTINCT	UPPER(i.CCG),UPPER(i.CCG), UPPER(i.RepName) as NewRep, upper(i.Territory)
FROM		CCGImport i
LEFT JOIN	CCGLookup l
ON			UPPER(i.CCG) = UPPER(l.Name)
WHERE		l.Rep IS NULL
ORDER BY	i.Territory


UPDATE		l
SET			l.Territory = i.Territory,
			l.Rep = i.RepName
FROM		CCGImport i
LEFT JOIN	CCGLookup l
ON			UPPER(i.CCG) = UPPER(l.Name)
ORDER BY	i.Territory