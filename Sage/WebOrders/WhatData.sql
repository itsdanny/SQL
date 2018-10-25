SELECT	*
FROM	TRConnectTest.service.ServiceData
WHERE	SentToClient IS NULL

DELETE FROM	TRConnect.service.ServiceData
WHERE	SentToClient IS NULL
AND	ServiceId = 28

--truncate TABLE TRConnectTest.service.ServiceData
SELECT		TOP 1000 *
FROM		IMPCustomerSalesOrders
WHERE		OrderOrderDate > GETDATE()-189
WHERE	SentToClient IS NULL
ORDER BY	1 DESC 

SELECT	*
FROM		VapeConnectTest.dbo.SYSTaskSchedule


SELECT	*
FROM		VapeConnectTest.dbo.IMPCustomerSalesOrders
WHERE		