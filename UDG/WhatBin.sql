SELECT		c.product, c.long_description, a.stock_held_flag, a.held_reason_code, b.bin_number, b.inspection_date, b.inspector_code, b.batch_number, b.lot_number, b.expiry_date, b.passed_inspection, b.quantity, b.quantity_free
--SELECT		*
FROM		scheme.stqueam a
INNER JOIN	scheme.stquem b
ON			a.product = b.product
AND			a.warehouse = b.warehouse
AND			a.sequence_number = b.sequence_number
INNER JOIN	scheme.stockm c
ON			a.product = c.product
AND			a.warehouse = c.warehouse
WHERE		a.held_reason_code = 'QCH'
AND			b.bin_number <> 'UDG08'
AND			b.bin_number LIKE 'UDG%'
GROUP BY	c.product, c.long_description, a.stock_held_flag, a.held_reason_code, b.bin_number, b.inspection_date, b.inspector_code, b.batch_number, b.lot_number, b.expiry_date, b.passed_inspection, b.quantity, b.quantity_free
ORDER BY	c.long_description		

select long_description, product, unit_code, drawing_number from syslive.scheme.stockm where warehouse = 'FG' 

select * from syslive.scheme.slt


SELECT		d.*
FROM		scheme.bmwohm h 
INNER JOIN	scheme.bmwodm d
ON			h.works_order = d.works_order
WHERE		d.component_code = '044059' 
AND			alpha_code = 'TPTY052600'
