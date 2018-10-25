SELECT		h.warehouse, h.product, movement_date, movement_reference, lot_number, SUM(movement_quantity*-1) movement_quantity, movement_cost 
FROM		syslive.scheme.stkhstm h WITH(NOLOCK)
INNER JOIN 	syslive.scheme.stockm m WITH(NOLOCK)
ON			h.product = m.product
AND			h.warehouse = m.warehouse
WHERE		datepart(year, dated) = '2016'
AND			transaction_type LIKE	'W%'
AND			transaction_type NOT  LIKE	'%DEV%'
--AND	movement_reference = 'KB55B'
AND			h.warehouse = 'IG'
AND			m.analysis_a <> 'TPTY'
GROUP BY	h.warehouse, h.product, movement_date, movement_reference, lot_number, movement_cost 
order by movement_date
--SELECT * FROM syslive.scheme.bmwohm WHERE		datepart(year, order_date) = '2016'

-- 62725