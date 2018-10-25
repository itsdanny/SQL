SELECT	*
FROM		TRConnect.service.ServiceData
WHERE		Col2 = '02/10/2018 00:00:00'
ORDER BY	1 DESC 

SELECT		TOP 100 *
FROM		VapeConnect.dbo.SYSProcessLog
ORDER BY	1 DESC 

SELECT	TOP 1000 *
FROM		VapeConnect.dbo.SYSErrors
ORDER BY	1 DESC 

--SELECT	*
--FROM		IMPDailyRefundExchanges
--WHERE		ProcessedDateTime > '2018-09-30 22:23:32.560'
--ORDER BY	1 DESC 

--UPDATE 		IMPDailyRefundExchanges SET Processed = 0
--WHERE		ProcessedDateTime > '2018-09-30 22:23:32.560'
SELECT	*
FROM		SYSTaskSchedule