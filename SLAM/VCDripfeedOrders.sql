SELECT	*
FROM		VapeConnect.dbo.SYSTaskSchedule

UPDATE 	VapeConnect.dbo.SYSTaskSchedule SET Active = 1 WHERE		Id = 29

--UPDATE 		i	
--SET			i.Processed = 0, i.ProcessedDateTime = NULL
--FROM		VapeConnect.dbo.[IMPDailySalesInformation]  i
--WHERE		'1'+BranchCode NOT IN (	
--SELECT		customer
--FROM		slam.scheme.opheadm
--WHERE		date_received = '2017-09-22 00:00:00.000'
--AND			order_no LIKE 'SB%')
--AND			TransactionDate = '2017-09-22'

--UPDATE 		i	
--SET			i.Processed = 0, i.ProcessedDateTime = NULL
--FROM		VapeConnect.dbo.[IMPDailySalesInformation]  i
--WHERE		'1'+BranchCode NOT IN (	
--SELECT		customer
--FROM		slam.scheme.opheadm
--WHERE		date_received = '2017-09-23 00:00:00.000'
--AND			order_no LIKE 'SB%')
--AND			TransactionDate = '2017-09-23'

--UPDATE 		i	
--SET			i.Processed = 0, i.ProcessedDateTime = NULL
--FROM		VapeConnect.dbo.[IMPDailySalesInformation]  i
--WHERE		'1'+BranchCode NOT IN (	
--SELECT		customer
--FROM		slam.scheme.opheadm WITH(NOLOCK)
--WHERE		date_received = '2017-09-24 00:00:00.000'
--AND			order_no LIKE 'SB%')
--AND			TransactionDate = '2017-09-24'

--UPDATE 		i	
--SET			i.Processed = 0, i.ProcessedDateTime = NULL
--FROM		VapeConnect.dbo.[IMPDailySalesInformation]  i
--WHERE		'1'+BranchCode NOT IN (	
--SELECT		customer
--FROM		slam.scheme.opheadm WITH(NOLOCK)
--WHERE		date_received = '2017-09-25 00:00:00.000'
--AND			order_no LIKE 'SB%')
--AND			TransactionDate = '2017-09-25'

--UPDATE 		i	
--SET			i.Processed = 0, i.ProcessedDateTime = NULL
--FROM		VapeConnect.dbo.[IMPDailySalesInformation]  i
--WHERE		'1'+BranchCode NOT IN (	
--SELECT		customer
--FROM		slam.scheme.opheadm
--WHERE		date_received = '2017-09-26 00:00:00.000'
--AND			order_no LIKE 'SB%')
--AND			TransactionDate = '2017-09-26'

--UPDATE 		i	
--SET			i.Processed = 0, i.ProcessedDateTime = NULL
--FROM		VapeConnect.dbo.[IMPDailySalesInformation]  i
--WHERE		'1'+BranchCode NOT IN (	
--SELECT		customer
--FROM		slam.scheme.opheadm
--WHERE		date_received = '2017-09-27 00:00:00.000'
--AND			order_no LIKE 'SB%')
--AND			TransactionDate = '2017-09-27'

--UPDATE 		i	
--SET			i.Processed = 0, i.ProcessedDateTime = NULL
--FROM		VapeConnectTest.dbo.[IMPDailySalesInformation]  i
--WHERE		'1'+BranchCode NOT IN (	
--SELECT		customer
--FROM		demo.scheme.opheadm WITH(NOLOCK)
--WHERE		date_received = '2017-09-28 00:00:00.000'
--AND			order_no LIKE 'SB%')
--AND			TransactionDate = '2017-09-28'

UPDATE 		i	
SET			i.Processed = 0, i.ProcessedDateTime = NULL
FROM		VapeConnectTest.[dbo].[IMPDailyRefundExchanges]  i
WHERE		'1'+BranchCode NOT IN (	
SELECT		customer
FROM		demo.scheme.opheadm WITH(NOLOCK)
WHERE		date_received = '2017-09-29 00:00:00.000'
AND			order_no LIKE 'CN%')
AND			TransactionDate = '2017-09-29'

UPDATE 		i	
SET			i.Processed = 0, i.ProcessedDateTime = NULL
FROM		VapeConnectTest.dbo.[IMPDailySalesInformation]  i
WHERE		'1'+BranchCode NOT IN (	
SELECT		customer
FROM		demo.scheme.opheadm WITH(NOLOCK)
WHERE		date_received = '2017-09-29 00:00:00.000'
AND			order_no LIKE 'SB%')
AND			TransactionDate = '2017-09-29'

SELECT		*
FROM		VapeConnectTest.dbo.[IMPDailySalesInformation]  
WHERE		Processed = 0


SELECT	*
FROM		VapeConnect.[dbo].[IMPDailyRefundExchanges]  i
WHERE		Processed = 0
--UPDATE 		i	
--SET			i.Processed = 0, i.ProcessedDateTime = NULL
--FROM		VapeConnectTest.dbo.[IMPDailySalesInformation]  i
--WHERE		'1'+BranchCode NOT IN (	
--SELECT		customer
--FROM		demo.scheme.opheadm WITH(NOLOCK)
--WHERE		date_received = '2017-09-30 00:00:00.000'
--AND			order_no LIKE 'SB%')
--AND			TransactionDate = '2017-09-30'


UPDATE 		i	
SET			i.Processed = 1, i.ProcessedDateTime = '2099-12-31'
FROM		VapeConnectTest.dbo.[IMPDailySalesInformation]  i
WHERE		'1'+BranchCode NOT IN (	
SELECT		customer
FROM		demo.scheme.opheadm WITH(NOLOCK)
WHERE		date_received = '2017-10-01 00:00:00.000'
AND			order_no LIKE 'SB%')
AND			TransactionDate = '2017-10-01'



SELECT		h.customer, LTRIM(RTRIM(h.order_no)) AS OrderNo, h.status, h.date_received, d.*
FROM		demo.scheme.opheadm h WITH(NOLOCK)
INNER JOIN 	demo.scheme.opdetm d WITH(NOLOCK)
ON			h.order_no = d.order_no
WHERE		date_received > '2017-09-21 00:00:00.000'
AND			h.order_no LIKE 'SB%'
--AND			h.status < '7'
AND			d.order_line_status ='B'
--GROUP BY	h.customer, h.order_no, h.status, h.date_received
ORDER BY	2



SELECT		DISTINCT TransactionDate, BranchCode
FROM		VapeConnectTest.dbo.[IMPDailySalesInformation]  i
WHERE		'1'+BranchCode NOT IN (	
SELECT		customer,date_received
FROM		demo.scheme.opheadm WITH(NOLOCK)
WHERE		date_received >= CAST(GETDATE()-8 AS date)
AND			order_no LIKE 'SB%')
AND			TransactionDate >= CAST(GETDATE()-8 AS date)
ORDER BY	1


SELECT		s.product, ISNULL(SUM(quantity_free) ,0) AS StockQty
FROM		demo.scheme.stquem s WITH(NOLOCK)
LEFT JOIN 	demo.scheme.stqueam q WITH(NOLOCK)
ON			s.product = q.product
AND			s.warehouse = q.warehouse
AND			s.sequence_number = q.sequence_number
WHERE		s.warehouse = 'SL' 
AND			bin_number ='I1'
AND			s.passed_inspection ='Y'
--AND			s.product =  'EJ-USA-06'
GROUP BY	s.product
SELECT *
FROM	 slam.scheme.stockm WITH(NOLOCK)
WHERE	product = 'EJ-USA-06'