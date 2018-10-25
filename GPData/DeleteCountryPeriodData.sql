use GPData
go
select * from ImportDataEnglish  WITH(NOLOCK)
select * from Countries

-- DELETES Scotland and Wales Data (3 & 2) for March 2018 ==============================================================
SELECT		DISTINCT PERIODDATE, count(1)
FROM		PracticeData pd
INNER JOIN	Practice p
ON			p.Code = pd.PRACTICE
INNER JOIN  Countries c
ON			p.CountryId = c.Id
where		c.Id IN (2,3)
AND			pd.PERIODDATE = '2018-05-01'
GROUP BY	PERIODDATE 
ORDER BY	1

delete pd 
FROM		PracticeData pd
INNER JOIN	Practice p
ON			p.Code = pd.PRACTICE
INNER JOIN  Countries c
ON			p.CountryId = c.Id
where		c.Id IN (2,3)
AND			pd.PERIODDATE = '2018-05-01'
rollback
-- =====================================================================================================================


INSERT INTO PracticeData (PRACTICE, BNF_CODE, BNF_NAME, ITEMS, NIC, ACTCOST, QUANTITY, PERIODDATE, PERIOD)
SELECT 'S000'+PRACTICEID, BNFCODE, BNFNAME as BNF_NAME, CAST(ITEMS AS FLOAT) AS ITEMS, 
CAST(NIC AS FLOAT) AS NIC, CAST(ACTCOST AS FLOAT) AS ACTCOST, CAST(QUANTITY AS FLOAT) AS QUANTITY, 
CONVERT(DATETIME,[PERIOD] + '01', 101) AS PERIODDATE, [PERIOD]
FROM ImportDataWelsh

SELECT  'S000'+PRACTICE, len('S000'+PRACTICE) FROM PracticeData WHERE PERIODDATE = '2015-10-01' --1039825
AND PRACTICE NOT IN (SELECT Code FROM Practice)
group by 'S000'+PRACTICE
order by len('S000'+PRACTICE)  desc

UPDATE pd SET pd.PRACTICE = 'S000'+RTRIM(LTRIM(cast(pd.PRACTICE AS VARCHAR(6))))
from PracticeData pd WHERE PERIODDATE = '2015-10-01' --1039825
AND PRACTICE NOT IN (SELECT Code FROM Practice)


SELECT * FROM PracticeData WHERE PRACTICE = '10002'

INSERT INTO PracticeData
SELECT 	c.Code, NULL, 'S000'+RTRIM(LTRIM(PracticeCode)), BNFCode, NULL, 
		CAST(NumberofPaidItems AS FLOAT), 
		CAST(GrossIngredientCost AS FLOAT) AS NIC, 
		CAST(0 AS FLOAT) AS ACTCOST, 
		CAST(0 AS FLOAT) AS QUANTITY, 
		CONVERT(DATETIME,PaidDate + '01', 101) AS PERIODDATE, PaidDate
FROM		ImportDataScottish i
INNER JOIN	CCGLookup c
ON			i.HealthBoardCode = c.BoardCode

SELECT 	c.Code, NULL, PracticeCode, BNFCode, NULL, 
		CAST(NumberofPaidItems AS FLOAT), 
		CAST(GrossIngredientCost AS FLOAT) AS NIC, 
		CAST(0 AS FLOAT) AS ACTCOST, 
		CAST(0 AS FLOAT) AS QUANTITY, 
		CONVERT(DATETIME,PaidDate + '01', 101) AS PERIODDATE, PaidDate
FROM		ImportDataScottish i
INNER JOIN	CCGLookup c
ON			i.HealthBoardCode = c.BoardCode

SELECT * FROM PracticeData WHERE PRACTICE NOT IN(SELECT Code FROM Practice)
AND PERIODDATE  = '2015-10-01 00:00:00.000' OR PERIODDATE = '2015-12-01 00:00:00.000'


delete pd FROM PracticeData pd
LEFT JOIN	Practice p
ON			pd.PRACTICE = p.Code
where		p.Code is null
AND			(PERIODDATE  = '2015-10-01 00:00:00.000' OR PERIODDATE = '2015-12-01 00:00:00.000')


select * from Practice where CountryId = 3
order by TerritoryId