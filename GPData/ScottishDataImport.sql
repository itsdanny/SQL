
DECLARE @ScottishPractice TABLE (
	Period varchar(10) NULL,
	Code varchar(10) NOT NULL,
	CountryId int,
	Name varchar(75),
	Address1 varchar(75),
	Address2 varchar(75),
	Address3 varchar(75),
	Address4 varchar(75),
	PostCode varchar(75),
	CCG  varchar(75))

INSERT INTO @ScottishPractice (Period, Code, CountryId, Name, Address1, Address2, Address3, Address4, PostCode, CCG)
SELECT		MAX(cast(PYear AS VARCHAR(4)) + RIGHT('00' + CAST(PMonth AS VARCHAR(2)), 2)) AS Period, 
			'S000'+PracticeID AS PracticeID, 3 AS CountryId, MAX(PracticeName), MAX(Address1), MAX(Address2), MAX(Address3), MAX(Address4), MAX(PostCode), MAX(Board)
FROM		ImportScottishData 
WHERE		'S000'+PracticeID NOT IN (SELECT DISTINCT Code FROM dbo.Practice WHERE CountryId = 3)
GROUP BY		'S000'+PracticeID


-- Insert new practices
begin tran
INSERT INTO Practice (Period, Code, CountryId, Name, Address1, Address2, Address3, Address4, PostCode, CCGCode)
SELECT		distinct Period, s.Code, CountryId, s.Name, Address1, Address2, Address3, Address4, PostCode, c.Code
FROM		@ScottishPractice s
INNER JOIN  CCGLookup c 
ON			s.CCG = c.Name
WHERE		s.Code not in (SELECT DISTINCT Code from dbo.Practice WHERE CountryId = 3)
ORDER BY	s.Code
rollback
UPDATE		p	
SET			p.Name =	 imp.Name,
			p.Address1 = imp.Address1,
			p.Address2 = imp.Address2,
			p.Address3 = imp.Address3,
			p.Address4 = imp.Address4,
			p.PostCode = imp.PostCode,
			p.Period = imp.Period
FROM		Practice p
INNER JOIN	@ScottishPractice imp
ON			p.Code = imp.Code
WHERE		p.Period <> imp.Period
AND			(p.Name <> imp.Name
OR			p.Address1 <> imp.Address1
OR			p.Address2 <> imp.Address2
OR			p.Address3 <> imp.Address3
OR			p.Address4 <> imp.Address4
OR			p.PostCode <> imp.PostCode)
AND			p.CountryId = 3

SELECT * FROM Practice w where CountryId = 3

INSERT INTO BNFProducts(BNF_CODE, BNF_Name, CountAs)
SELECT DISTINCT BNFCode, BNFName, 'Unassigned' FROM ImportScottishData WHERE BNFCode NOT IN (SELECT BNF_CODE FROM BNFProducts)


INSERT INTO PracticeData (PRACTICE, BNF_CODE, BNF_NAME, ITEMS, NIC, ACTCOST, QUANTITY, PERIODDATE, PERIOD)
SELECT		'S000'+PracticeID, BNFCode, BNFName as BNF_NAME, CAST(Items AS FLOAT) AS ITEMS, 
CAST(NIC AS FLOAT) AS NIC, NIC AS ACTCOST, CAST(Items AS FLOAT) AS QUANTITY, 
CONVERT(DATETIME, cast(PYear AS VARCHAR(4)) + '-' +RIGHT('00' + CAST(PMonth AS VARCHAR(2)), 2) + '-01', 101) AS PERIODDATE, cast(PYear AS VARCHAR(4)) + RIGHT('00' + CAST(PMonth AS VARCHAR(2)), 2)
FROM ImportScottishData
 where PracticeID = '10002' and PMonth = '10' and PYear = '2012' and BNFCode = '130201000BBBAAL'
SELECT * from PracticeData where PRACTICE like 'S000%'

 DELETE from PracticeData where PRACTICE like 'S000%'
 DBCC CHECKIDENT (PracticeData, RESEED, 23405769) 
 select max(Id) from PracticeData



INSERT INTO PracticeData (PRACTICE, BNF_CODE, BNF_NAME, ITEMS, NIC, ACTCOST, QUANTITY, PERIODDATE, PERIOD)
SELECT		'S000'+PracticeID, BNFCode, MAX(BNFName) as BNF_NAME, SUM(CAST(Items AS FLOAT)) AS ITEMS, 
			 SUM(CAST(NIC AS FLOAT)) AS NIC, SUM(NIC) AS ACTCOST, SUM(CAST(Items AS FLOAT)) AS QUANTITY, 
CONVERT(DATETIME, cast(PYear AS VARCHAR(4)) + '-' +RIGHT('00' + CAST(PMonth AS VARCHAR(2)), 2) + '-01', 101) AS PERIODDATE, cast(PYear AS VARCHAR(4)) + RIGHT('00' + CAST(PMonth AS VARCHAR(2)), 2)
FROM ImportScottishData
-- where PracticeID = '10002' and PMonth = '10' and PYear = '2012' and BNFCode = '130201000BBBAAL'
GROUP BY PracticeID, cast(PYear AS VARCHAR(4)) + RIGHT('00' + CAST(PMonth AS VARCHAR(2)), 2), BNFCode, CONVERT(DATETIME, cast(PYear AS VARCHAR(4)) + '-' +RIGHT('00' + CAST(PMonth AS VARCHAR(2)), 2) + '-01', 101)