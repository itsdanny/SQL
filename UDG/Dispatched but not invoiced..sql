use syslive
DROP TABLE #TMP
SELECT        LTRIM(RTRIM(scheme.opheadm.order_no))+LTRIM(RTRIM(scheme.opsadetm.product)) as orderprod into #TMP
FROM            UDGSalesOrders INNER JOIN
                         scheme.opheadm with(nolock) ON UDGSalesOrders.ReferenceID = scheme.opheadm.order_no INNER JOIN
                         scheme.opsadetm with(nolock) ON scheme.opheadm.invoice_no = scheme.opsadetm.invoice
GROUP BY scheme.opheadm.order_no, scheme.opsadetm.product

select * 
FROM            UDGSalesOrders where ReferenceID+SKUID not in
(select * from #TMP)
AND (UDGSalesOrders.ReferenceID LIKE '3%' OR UDGSalesOrders.ReferenceID LIKE '2%' OR UDGSalesOrders.ReferenceID LIKE 'CD%' OR UDGSalesOrders.ReferenceID LIKE 'CB%')

SELECT * FROM scheme.stquem where batch_number = '54805'
RETURN
SELECT * FROM scheme.opheadm h with(nolock) INNER JOIN scheme.opsadetm d with(nolock) 
ON			h.invoice_no = d.invoice
where		h.order_no = '2E188407'
and			d.product in ('055026',
'044245',
'055018',
'055026',
'044083',
'044199',
'030236',
'044245',
'044245')