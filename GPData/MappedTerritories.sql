SELECT			CCGCode, p.Code AS [Practice Code], p.Name, p.Address1, p.Address2, p.Address3, p.Address4, p.PostCode, ccg.Name AS [CCG Name], ISNULL(c.CountryCode, 'Not Mapped') 
                         AS Country, ISNULL(ccg.Territory, 'Not Mapped') AS Territory, ISNULL(ccg.RBM, 'Not Mapped') AS RBM, ISNULL(ccg.NDM, 'Not Mapped') AS NDM, ISNULL(ccg.RBM, 
                         'Not Mapped') AS Region, REPLACE(p.PostCode, ' ', '') AS PostCode_NoSpaces
FROM            dbo.Practice AS p 
INNER JOIN	dbo.CCGLookup AS ccg 
ON			p.CCGCode = ccg.Code 
INNER JOIN	dbo.Countries AS c 
ON			c.Id = p.CountryId


SELECT *
FROM Practice

SELECT SHA,
	PCT,
	PRACTICE,
	[BNF CODE] AS BNF_CODE,
	[BNF NAME] AS BNF_NAME,
	CAST(ITEMS AS FLOAT) AS ITEMS,
	CAST(NIC AS FLOAT) AS NIC,
	CAST(ACTCOST AS FLOAT) AS ACTCOST,
	CAST(QUANTITY AS FLOAT) AS QUANTITY,
	convert(DATETIME, [PERIOD] + '01', 101) AS PERIODDATE,
	[PERIOD]
FROM ImportDataEnglish

SELECT *
FROM ImportDataWelsh

SELECT *
FROM ImportDataScottish

SELECT *
FROM ImportDataNI