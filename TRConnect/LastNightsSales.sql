
USE TRConnect
GO

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT		*	         
FROM		[TRConnect].[service].[ServiceData]
WHERE		ServiceId in (24,25)
AND			Col2 in ('02/10/2017 00:00:00','03/10/2017 00:00:00','04/10/2017 00:00:00','05/10/2017 00:00:00','0/10/2017 00:00:00')
ORDER BY	1 
/*

UPDATE 		[TRConnect].[service].[ServiceData]
SET SentToClient = 0
WHERE		ServiceId in (24,25)
AND			Col2 in ('02/10/2017 00:00:00','03/10/2017 00:00:00','04/10/2017 00:00:00','05/10/2017 00:00:00','06/10/2017 00:00:00')*/

SELECT	*
FROM		ENLocations ORDER BY	LastAccessed DESC 
UPDATE 	ENLocations SET LastAccessed = '2017-10-19 21:06:49.770' WHERE		iD = 15