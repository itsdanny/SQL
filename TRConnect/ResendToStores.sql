/*
	THIS SCRIPT MARKS SOME SELECTED DATA TO BE SENT TO STORES AGAIN...USE WISLEY!
*/

delete FROM service.ServiceData where ServiceId = 24 AND Col3 = '09/12/2016 00:00:00'
SELECT	* FROM service.ServiceData where ServiceId = 24 AND (SentToClient is null or Col3 = '09/12/2016 00:00:00')
(((
SELECT	Col6, MAX(SentDateTime) AS LastSent FROM service.ServiceData where ServiceId = 26 and Col13 = 'False'
GROUP BY Col6

/*
DECLARE @Updates Table (product varchar(20), dt datetime)
INSERT INTO @Updates
SELECT	Col6, MAX(SentDateTime) AS LastSent FROM service.ServiceData where ServiceId = 26 and Col13 = 'False'
GROUP BY Col6

UPDATE		d
SET			d.SentToClient = NULL
FROM		service.ServiceData d
INNER JOIN	@Updates u
ON			u.product = Col6
AND			SentDateTime = U.dt

*/SELECT * FROM [dbo].[APIImport] a
inner join ENLocations e
on a.LocationId = e.ENLocationId
order by sageref
update e 
set e.APIKeyHash = 'Basic ' + a.APIKey
FROM [dbo].[APIImport] a
inner join ENLocations e
on a.LocationId = e.ENLocationId