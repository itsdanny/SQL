-- 047786  
SELECT		* 
FROM		scheme.poheadm h 
WHERE		h.order_no like  '%059427%'

SELECT		h.status, m.status, * 
FROM		scheme.poheadm h
INNER JOIN	scheme.podetm m
ON			h.order_no = m.order_no
WHERE		h.order_no like '%059427%'

select * from scheme.poheadm where  order_no IN ('047828','047786')
select * from scheme.podetm where  order_no IN ('047828','047786')

select * from scheme.stockm where warehouse = 'IG' and allocated_qty > 0 AND  product = '103852'

select * from scheme.stkhstm where warehouse = 'IG' 
and (transaction_type in ('ISSU', 'W/O' , 'DKIT')) 
and dated >= '2012-12-01'
 and dated < '2015-01-01'


 sp_ThirdPartySupplierPerformance
 sp__check_sage_for_third_party_purchase_orders

 
 select		SUM(d.qty_received)
 SELECT s.product, s.warehouse, s.description, s.unit_code, SUM(d.qty_received) as PacksReceived
 FROM		scheme.poheadm h
INNER JOIN	scheme.podetm d
ON			h.order_no = d.order_no
inner join	scheme.stockm s
ON			s.product = d.product
and			s.warehouse = d.warehouse
WHERE		DATEPART(YEAR, h.date_required) = 2014
AND			s.analysis_a ='TPTY'
group by s.product, s.warehouse, s.description, s.unit_code,analysis_b
ORDER BY analysis_b