SELECT		*
FROM		VapeConnect.dbo.[IMPDailySalesInformation]  i
LEFT join	slam.scheme.opheadm h WITH(NOLOCK)
ON			'1'+i.BranchCode = h.customer
AND			TransactionDate  = date_received 
AND			order_no LIKE 'SB%'
WHERE		TransactionDate >= CAST(GETDATE()-30  AS DATE)
AND			h.customer IS NULL
ORDER BY	3, 2, 1


--SELECT	*
--FROM		VapeConnectTest.dbo.[IMPDailySalesInformation]  i
--WHERE		BranchCode = 'C1'
--AND	ProcessedDateTime > GETDATE()
--ORDER BY	3

--SELECT	*
--FROM 	demo.scheme.opheadm h WITH(NOLOCK)
--WHERE		customer ='1H7' AND	date_received >= CAST(GETDATE()-30  AS DATE)
--AND			order_no LIKE 'SB%'
--ORDER BY	date_received


--UPDATE 	VapeConnectTest.dbo.[IMPDailySalesInformation]   SET Processed = 1 WHERE		Processed = 0
--WHERE		Processed =0 ORDER BY	TransactionDate

--begin tran
--UPDATE 		i	
--SET			i.Processed = 0, ProcessedDateTime = NULL
--FROM		VapeConnectTest.dbo.[IMPDailySalesInformation]  i
--LEFT join	demo.scheme.opheadm h WITH(NOLOCK)
--ON			'1'+i.BranchCode = h.customer
--AND			TransactionDate  = date_received 
--AND			order_no LIKE 'SB%'
--WHERE		TransactionDate >= CAST(GETDATE()-30  AS DATE)
--AND			h.customer IS NULL

--rollback

SELECT		h.date_entered, h.order_no, h.customer, h.address1, 
			CASE h.status WHEN '3' THEN 'Credit Stop/Back Order' WHEN '4' THEN 'Back Order' ELSE h.status END  AS OrderStatus,
			COUNT(d.product) AS TotalLines, 
			SUM(d.order_qty*d.list_price) AS TotalOrderValue, 			
			SUM(CASE d.order_line_status WHEN 'B' THEN 1 ELSE 0  END) AS LinesOnBackOrder,
			SUM(CASE d.order_line_status WHEN 'B' THEN d.order_qty ELSE 0  END) AS BackOrderQty,
			SUM(CASE d.order_line_status WHEN 'B' THEN d.order_qty*d.list_price ELSE 0  END) AS BackOrderPrice		
FROM		slam.scheme.opheadm h WITH(NOLOCK) 
INNER JOIN 	slam.scheme.opdetm d WITH(NOLOCK)
ON			h.order_no = d.order_no
WHERE		h.status < 5
AND			d.order_no LIKE 'SB%'
GROUP BY	h.date_entered, h.order_no, h.customer, h.address1, 	CASE h.status WHEN '3' THEN 'Credit Stop/Back Order' WHEN '4' THEN 'Back Order' ELSE h.status END  


SELECT	*
FROM		slam.scheme.opdetm WITH(NOLOCK) 
WHERE		order_no = 'SB015544'