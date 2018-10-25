SELECT * FROM  service.servicedata  where SentDateTime > '2017-02-04' AND	Col1 IN ('S4','D5')
SELECT * FROM  service.servicedata  where SentToClient is null AND	Col1 IN ('S4','D5')
SELECT * FROM  service.servicedata  where ServiceId = 28  AND	Col1 ='LAN-GR-112'	SentDateTime ='2017-02-10 15:01:01.997'
GROUP BY COL1


SELECT * FROM service.ServiceColumnMappings WHERE		ServiceId = 28
update service.servicedata SET	SentToClient = 0 where ServiceId IN (28)  AND	SentDateTime ='2017-02-10 15:01:01.997'
update service.servicedata SET	SentToClient = 0 WHERE		Id in(
SELECT MAX(Id) FROM  service.servicedata  where ServiceId = 28  AND	SentDateTime ='2017-02-14 13:57:15.383' GROUP BY COL1)

SELECT TOP 100 * FROM  service.servicedata  Order By id desc

SELECT * FROM Log order by Id desc

SELECT * FROM  service.servicedata  where ServiceId = 28, Col11 = 99  AND	COL1 IN ('AC-BDC-COIL', 'SLIM-COIL-22', 'SSBVC-CO') 

SELECT TOP 1000 * FROM service.servicedata where  SentToClient IS NULL order by Id desc
SELECT * FROM service.servicedata where SentToClient IS NULL -- 96366
SELECT * FROM service.servicedata where serviceid = 28 AND	Col1 = 'C5' AND	cOL2 = '02/02/2017 00:00:00' AND	SentToClient IS NULL 
--DELETE FROM service.servicedata where serviceid = 25 AND	Col1 = 'U1' AND	cOL2 <> '24/01/2017 00:00:00' AND	SentToClient IS NULL 

--	94815 to 96407


SELECT * FROM service.servicedata where Col1 ='LAN-GR-112' AND	Col1 ='C1' AND	ServiceId = 25
--update service.servicedata SET	SentToClient = 1, SentDateTime = '2000-01-01 00:00:00' where SentToClient IS NULL -- 96366

--	update service.servicedata SET	SentToClient = NULL WHERE	Id = 139324 (
(SELECT Min(id), Col1, Col3 FROM service.servicedata where Col2 ='25/01/2017 00:00:00' AND	Col3 <> '0' 
group by Col1,Col3
order by Col1)

SELECT * FROM ENLocations WHERE		SageRef LIKE	'C%' order by lastaccessed 


SELECT ServiceId,  sum(CAST(Col5 AS FLOAT)), sum(CAST(col6 AS FLOAT)) FROM service.servicedata where Col2 ='02/02/2017 00:00:00' AND	Col1 ='C1'
group by ServiceId



