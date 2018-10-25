USE [lcmlive]
SELECT		d.product, 
			REPLACE(d.product_group_a, '-','') AS PipCode, d.long_description,  
			DATEPART(YEAR, h.date_required) as Year, 
			SUM(d.order_qty) as OrderQty, 
			SUM(d.val) as Value
FROM		scheme.opheadm h
INNER JOIN	scheme.opdetm d
ON			h.order_no = d.order_no
WHERE		h.transaction_anals1 = 'T500000'
AND			DATEPART(YEAR, h.date_required) IN (2014, 2015)
GROUP BY	DATEPART(YEAR, h.date_required), REPLACE(d.product_group_a, '-','') , d.product, d.long_description 
ORDER BY	DATEPART(YEAR, h.date_required)


select * from scheme.opdetm