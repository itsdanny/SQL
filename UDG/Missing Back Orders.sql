SELECT * FROM UDGSalesOrders  WHERE ReferenceID ='188043'
SELECT * FROM UDGShippedLines WHERE OrderID ='188043'
SELECT       l.*
FROM          scheme.opheadm h with(nolock) 
LEFT JOIN	  scheme.opsadetm d with(nolock) 
ON			  h.invoice_no = d.invoice
INNER JOIN	  UDGShippedLines l
ON			  h.order_no = l.OrderID
AND			  d.product = l.SkuID
WHERE		  d.val = 0
AND			  l.QtyShipped > 0
AND			  h.order_no NOT IN ('2A187073','2A187487','2E188381','2E188335','3A188011','2A187489/1','2A188415','CV188428')
AND			  l.OrderID ='188043'	
--GROUP BY	  d.product, h.order_no
ORDER BY	  h.order_no, d.product


SELECT			u.*
FROM			scheme.opheadm h with(nolock) 
INNER JOIN		UDGSalesOrders u with(nolock) 
ON				h.order_no  = u.ReferenceID 
INNER JOIN		scheme.opsadetm d with(nolock) 
ON				h.invoice_no = d.invoice
WHERE			ReferenceID ='188043'
ORDER BY		h.order_no

SELECT			h.order_no, d.product, Qty, u.ReqBatchID
FROM			scheme.opheadm h with(nolock) 
INNER JOIN		UDGShippedLines u with(nolock) 
ON				h.order_no  = u.OrderID 
INNER JOIN		scheme.opsadetm d with(nolock) 
ON				h.invoice_no = d.invoice
WHERE			d.val = 0
ORDER BY		h.order_no

/*
return
with udg_cte(order_no,product, order_status)
as
(SELECT        scheme.opheadm.order_no, scheme.opsadetm.product, scheme.opheadm.status
FROM           UDGSalesOrders with(nolock) 
INNER JOIN     scheme.opheadm with(nolock) 
ON			   UDGSalesOrders.ReferenceID = scheme.opheadm.order_no 
INNER JOIN	   scheme.opsadetm  with(nolock) 
ON			   scheme.opheadm.invoice_no = scheme.opsadetm.invoice
GROUP BY	   scheme.opheadm.order_no, scheme.opsadetm.product, scheme.opheadm.status)

SELECT		SKUID, BatchID, ReferenceID, UOM, Qty
FROM        UDGSalesOrders o
LEFT JOIN   udg_cte c
ON          o.ReferenceID = c.product
AND         o.SKUID = c.product
AND         c.product is null
WHERE       o.ReferenceID  NOT IN ('2A187073', '2A187487', '2E188381', '2E188335', '3A188011', '2A187489/1', '2A188415', 'CV188428')
--AND			o.ReferenceID = '2A179107'
--GROUP BY	SKUID, BatchID, ReferenceID, UOM	
ORDER BY	o.ReferenceID, SKUID;

*/

SELECT * FROM Integrate.dbo.SalesOrderHeader h inner join Integrate.dbo.SalesOrderLine d on h.Id = d.SalesOrderHeaderId where OrderNumber ='188043'