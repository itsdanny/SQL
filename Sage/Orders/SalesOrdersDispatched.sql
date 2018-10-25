USE syslive
SELECT		d.order_no, d.warehouse, d.product, d.long_description, d.order_qty, d.despatched_qty, h.dated AS MovementDate, h.lot_number, h.movement_quantity, h.transaction_type
FROM		scheme.opdetm d
LEFT JOIN	scheme.stkhstm h
ON			d.warehouse = h.warehouse
AND			d.product = h.product
AND			d.order_no = h.movement_reference
INNER JOIN	scheme.stockm m
ON			h.warehouse = m.warehouse
AND			h.product = m.product
--WHERE		h.movement_reference LIKE '%RYB1091%'
where		h.dated > GETDATE() -7
AND			d.line_type ='P' ORDER BY order_no, d.order_line_no, MovementDate DESC


--	select * from scheme.stkhstm WHERE warehouse ='FG' AND comments = 'Cut Over Stock' AND dated BETWEEN GETDATE()-1 and GETDATE()+1 AND movement_reference ='TA86SQ' ORDER BY movement_reference
	select * from scheme.stkhstm WHERE warehouse ='FG' AND UPPER(comments) LIKE '%TRANSFER%' ORDER BY dated DESC-- AND dated BETWEEN GETDATE()-1 and GETDATE()+1 AND movement_reference ='TA86SQ' ORDER BY movement_reference
	select * from scheme.stkhstm WHERE warehouse ='FG' AND movement_reference LIKE '%RYB1091%'--
	select * from scheme.stkhstm WHERE warehouse ='FG' AND product LIKE '001473' and transaction_type <> 'SALE'
	