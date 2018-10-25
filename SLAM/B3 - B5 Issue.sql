SELECT SageRef, Card, Cash, PettyCash, GiftVoucher, CAST(TransactionDate AS DATE) FROM [dbo].[EndOfDays] 
SELECT * FROM [dbo].[EndOfDays] order by TransactionDate


SELECT * FROM [dbo].[EndOfDays] WHERE	SageRef IN ('U1')order by TransactionDate

/*delete FROM [dbo].[EndOfDays] 
dbcc checkident([EndOfDays], reseed, 0)*/


SELECT * FROM ENLocations order by lastAccessed desc
--update enlocations SET	lastAccessed = '2017-01-24 22:20:10.067' WHERE		Id IN (55,65,54,63)

-- B5 THEN B3
SELECT * FROM [dbo].[EndOfDays] WHERE	SageRef IN ('B3','B5') order by TransactionDate
SELECT MIN(Id) [FirstRow], MAX(Id) [LastRow], 
	Col1, Col3, Col8, Col9, col10,sum(CAST(cOL5 AS int)) QTY, SUM(CAST(COL6 AS float)) SALESALUE,SentDateTime
FROM service.servicedata where serviceid = 24 AND	Col1 = 'B3' AND	SentDateTime > '2017-01-07 01:14:48.853'
GROUP BY Col1, Col3, Col8, Col9, col10, SentDateTime
ORDER BY min(Id)

SELECT * FROM service.ServiceData WHERE  Id between  66433 AND 66455


SELECT * FROM service.servicedata where senttoclient = 0


select* FROM 