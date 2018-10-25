SELECT		c.Name, c.Code, p.CCGCode,  i.CurrTerritory as TerritoryOld, i.ActualTerritory TerritoryNow, p.Code, p.Name, Address1, Address2, Address3, Address4, PostCode
FROM		TerritoryPracticeImport i
INNER JOIN	Territory t
ON			t.Territory = i.CurrTerritory
INNER JOIN	Practice p
ON			p.Code = i.PracticeCode
AND			t.Id <> p.TerritoryId
INNER JOIN	CCGLookup c
ON			c.Code = p.CCGCode

SELECT * 
FROM		Practice p
INNER JOIN	CCGLookup c
ON			p.CCGCode = c.Code
WHERE		p.Code IN ('Y04195')


 select * from CCGLookup where Code IN ('07L','00X','RQX')
 select * from PracticeData where PRACTICE in ('Y03813')
 select * from PracticeDataArchive where PRACTICE in ('Y03813')
 select * from ImportDataEnglish where PRACTICE = 'Y04195'

 UPDATE Practice SET CCGCode ='SJ9' where Code  IN('S00084990','S00085009')


  select DISTINCT PCT, PRACTICE from PracticeData where PCT NOT IN(SELECT Code from CCGLookup)
  --select DISTINCT PCT, PRACTICE from ImportDataEnglish where PCT NOT IN(SELECT Code from CCGLookup)



 UPDATE			p
SET				p.CCGCode = a.Code				

SELECT			*
FROM			[GPData].[dbo].[ImportDataEnglish] i
INNER JOIN		Practice p
ON				i.PRACTICE = p.Code
INNER JOIN		CCGLookup a
ON				a.Code = i.PCT
INNER JOIN		CCGLookup b
ON				b.Code = p.CCGCode
WHERE			i.PCT <> p.CCGCode
