SELECT * FROM CCGLookup WHERE Code LIKE 'S%'
--UPDATE CCGLookup SET Name = 'NHS ' + REPLACE(Name, 'HB', '') WHERE Code LIKE 'S%'

SELECT * FROM CCGLookup WHERE Code LIKE 'S%'
SELECT * FROM ImportScottishData
SELECT * FROM Practice p WHERE p.CountryId = 3
SELECT * FROM Practice p WHERE Code = 'S00063419'

select * from Practice p
INNER JOIN PracticeData pd
ON		p.Code = pd.PRACTICE
where	 p.CountryId = 3

select * from Practice p where p.Code not in (select distinct PRACTICE from PracticeData)
select * from PracticeData p where PRACTICE not in (select distinct Code from Practice)

SELECT * FROM ImportScottishData
SELECT * FROM Practice p WHERE p.CountryId = 3
SELECT * FROM Practice p WHERE Code = 'S00063419'

select * from Practice p
INNER JOIN PracticeData pd
ON		p.Code = pd.PRACTICE
where	 p.CountryId = 3

SELECT * FROM Practice p where p.Code not in (select distinct PRACTICE from PracticeData)
SELECT * FROM PracticeData p where PRACTICE not in (select distinct Code from Practice)

SELECT * into ImportScottishData FROM GPData.dbo.ImportScottishData s INNER JOIN CCGLookup c on s.Board = c.Name

SELECT * FROM CCGLookup
SELECT DISTINCT s.Board FROM ImportScottishData s WHERE s.Board NOT IN (SELECT c.Name FROM CCGLookup c)

select pd.PRACTICE, pd.PERIOD, pd.BNF_CODE from Practice p
INNER JOIN PracticeData pd
ON		p.Code = pd.PRACTICE
where	 p.CountryId = 3
GROUP BY pd.PRACTICE, pd.PERIOD, pd.BNF_CODE
having count (pd.BNF_CODE) > 1


SELECT * FROM ImportScottishData WHERE PracticeID = '32707' and PMonth = '04' and PYear = '2014' and BNFCode = '1003020AABDAAAB' -- in once
GO
SELECT * FROM PracticeData WHERE PRACTICE = 'S00032707' and PERIOD = '201404' and BNF_CODE = '1003020AABDAAAB'
GO



select * from ImportScottishData where  PracticeID = '32707' and PMonth = '04' and PYear = '2014' and BNFCode = '1003020AABDAAAB' -- in once
GO
SELECT * FROM PracticeData where PRACTICE = 'S00032707' and PERIOD = '201404' and BNF_CODE = '1003020AABDAAAB'

INSERT INTO PracticeData (PRACTICE, BNF_CODE, BNF_NAME, ITEMS, NIC, ACTCOST, QUANTITY, PERIODDATE, PERIOD)
SELECT		'S000'+PracticeID, BNFCode, MAX(BNFName) as BNF_NAME, SUM(CAST(Items AS FLOAT)) AS ITEMS, 
			 SUM(CAST(NIC AS FLOAT)) AS NIC, SUM(NIC) AS ACTCOST, SUM(CAST(Items AS FLOAT)) AS QUANTITY, 
CONVERT(DATETIME, cast(PYear AS VARCHAR(4)) + '-' +RIGHT('00' + CAST(PMonth AS VARCHAR(2)), 2) + '-01', 101) AS PERIODDATE, cast(PYear AS VARCHAR(4)) + RIGHT('00' + CAST(PMonth AS VARCHAR(2)), 2)
FROM ImportScottishData
--where PracticeID = '10002' and PMonth = '10' and PYear = '2012' and BNFCode = '130201000BBBAAL'
GROUP BY PracticeID, cast(PYear AS VARCHAR(4)) + RIGHT('00' + CAST(PMonth AS VARCHAR(2)), 2), BNFCode, CONVERT(DATETIME, cast(PYear AS VARCHAR(4)) + '-' +RIGHT('00' + CAST(PMonth AS VARCHAR(2)), 2) + '-01', 101)


select		pd.*
FROM		Practice p
INNER JOIN	PracticeData pd
ON			p.Code = pd.PRACTICE
where		p.CountryId = 3
and			pd.PERIODDATE is null

select * from PracticeData where
	PRACTICE =	'S00010002' and BNF_CODE =	'21220000100'
	order by PERIODDATE