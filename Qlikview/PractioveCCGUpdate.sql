SELECT		DISTINCT	p.Code PracticeCode, p.Name, Address1, Address2, Address3, Address4, PostCode, SUM(CAST(i.ITEMS AS	 float)) Items, SUM(CAST(i.ACTCOST AS	float)) Cost,
			SUM(CAST(i.NIC AS	float)) NIC, SUM(CAST(i.QUANTITY AS	float)) AS	Qty	 , p.CCGCode, i.PCT newCCCGcode, a.Name CurrentCCG, b.Name
FROM			[GPData].[dbo].[ImportDataEnglish] i
INNER JOIN		Practice p
ON				LTRIM(RTRIM(i.PRACTICE)) = LTRIM(RTRIM(p.Code))
AND				LTRIM(RTRIM(i.PCT)) <> LTRIM(RTRIM(p.CCGCode))
INNER JOIN		CCGLookup a
ON				LTRIM(RTRIM(a.Code)) = LTRIM(RTRIM(p.CCGCode))
INNER JOIN		CCGLookup b
ON				LTRIM(RTRIM(b.Code)) = LTRIM(RTRIM(i.PCT))
--WHERE		p.Code IN ('Y05367','Y01126','Y01069')
GROUP BY	p.Code, p.Name, Address1, Address2, Address3, Address4, PostCode, p.CCGCode, i.PCT, a.Name , b.Name
ORDER BY	2
RETURN

SELECT		DISTINCT	p.Code PracticeCode, p.Name, Address1, Address2, Address3, Address4, PostCode, p.CCGCode, i.PCT newCCCGcode
FROM			[GPData].[dbo].[ImportDataEnglish] i
INNER JOIN		Practice p
ON				LTRIM(RTRIM(i.PRACTICE)) = LTRIM(RTRIM(p.Code))
AND				LTRIM(RTRIM(i.PCT)) <> LTRIM(RTRIM(p.CCGCode))
INNER JOIN		CCGLookup a
ON				LTRIM(RTRIM(a.Code)) = LTRIM(RTRIM(i.PCT))
--WHERE		p.Code IN ('Y05367','Y01126','Y01069')
ORDER BY	2

SELECT		*
FROM		CCGLookup WHERE		Code ='RL4'
return
UPDATE			p
SET				p.CCGCode = a.Code				
FROM			[GPData].[dbo].[ImportDataEnglish] i
INNER JOIN		Practice p
ON				i.PRACTICE = p.Code
AND				i.PCT <> p.CCGCode
INNER JOIN		CCGLookup a
ON				a.Code = i.PCT
INNER JOIN		CCGLookup b
ON				b.Code = p.CCGCode

SELECT		DISTINCT PCT, PRACTICE
FROM		[GPData].[dbo].[ImportDataEnglish] i
WHERE		PCT NOT IN (SELECT	Code
FROM	CCGLookup)
ORDER BY	1


SELECT	*
FROM		CCGLookup WHERE		Name LIKE	'%NEWCA%'

SELECT	*
FROM		ImportDataEnglish WHERE		PRACTICE ='Y03110'