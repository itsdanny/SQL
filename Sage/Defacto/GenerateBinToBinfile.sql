SELECT '00|SR1|000000|Stock Adj|' AS FileHeader
--24|1|SL|2|EJ-VAC-12|3|2|4|20/09/17|6||8|Stock Discrepancy CORR|9|M2|16||21||
UNION all
select '24|1|SL|2|'+rtrim(d.product)+'|3|' +CAST(d.order_qty AS VARCHAR(10))+'|4|20/09/17|6||8|SLAM StockAdj|9|'+RIGHT(rtrim(h.customer),2)+'|16||21||'
 from
		scheme.opheadm h
inner join scheme.opdetm d 
on			h.order_no = d.order_no
where		h.order_no like 'SB%'
AND			h.status < 8
and			d.order_line_status = 'B'

 