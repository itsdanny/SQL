SELECT TOP 10 * FROM PracticeData
SELECT TOP 10 * FROM PracticeData WHERE NIC IS NULL
SELECT TOP 10 * FROM PracticeData WHERE ACTCOST IS NULL

INSERT INTO PracticeData(PracticeId, BNFCodeId, ITEMS, NIC, ACTCOST, PERIODDATE) 
SELECT		pr.Id, p.Id, n.TotalItems, n.NIC, n.ActualCost, n.PeriodDate
FROM		ImportDataNI n
INNER JOIN	BNFProducts p
ON			n.BNFCode = p.BNF_CODE
INNER JOIN	Practice pr
ON			pr.Code = n.PracticeId

DECLARE @AlreadyImported AS INT = 0
SELECT		TOP 1 @AlreadyImported = CAST(1 AS INT)
FROM		Practice p
INNER JOIN	PracticeData pd
ON			p.Id = pd.PracticeId
WHERE		p.CountryId =  4
AND			pd.PERIODDATE in (SELECT TOP 1 PeriodDate FROM ImportDataNI)
SELECT @AlreadyImported AS AlreadyImported

SELECT * FROM ImportDataNI


create table ProcessedFiles (Id int identity(1,1), CountryId int, Period DateTime, NumberOfRows int, StartDateTime DateTime, FinishDateTime DateTime)