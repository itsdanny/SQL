-- 1 in QCQ  FOR BATCH 259885

--SELECT		SUM(b.quantity) AS QTY, SUM(b.quantity_free) AS QTYF
select * 
FROM		scheme.stqueam a
INNER JOIN	scheme.stquem b
ON			a.product = b.product
AND			a.warehouse = b.warehouse
AND			a.sequence_number = b.sequence_number
where		a.product ='086053'
--AND			b.batch_number like '164852' --
and			b.lot_number = '164852'

SELECT		SUM(b.quantity) AS QTY, SUM(b.quantity_free) AS QTYF
FROM		scheme.stqueam a
INNER JOIN	scheme.stquem b
ON			a.product = b.product
AND			a.warehouse = b.warehouse
AND			a.sequence_number = b.sequence_number
where		a.product ='014427'
AND			b.batch_number like '%259885' --


/*

UPDATE		b
set			b.quantity = 0, b.quantity_free = 0
FROM		scheme.stqueam a
INNER JOIN	scheme.stquem b
ON			a.product = b.product
AND			a.warehouse = b.warehouse
AND			a.sequence_number = b.sequence_number
where		a.product ='014427'
AND			b.batch_number like '%259885' --
and			b.sequence_number <> 'QINp}7'


UPDATE		b
set			b.quantity = 136, b.quantity_free = 136
FROM		scheme.stqueam a
INNER JOIN	scheme.stquem b
ON			a.product = b.product
AND			a.warehouse = b.warehouse
AND			a.sequence_number = b.sequence_number
where		a.product ='014427'
AND			b.batch_number like '%259885' --
and			b.sequence_number = 'QINp}7'

*/

SELECT scheme.stquem.bin_number, scheme.stquem.lot_number, scheme.stquem.quantity, scheme.stquem.expiry_date, scheme.stquem.sequence_number, scheme.stquem.passed_inspection, scheme.stquem.inspector_code, scheme.stquem.inspection_date, 
ISNULL(scheme.stqueam.stock_held_flag, 'n') AS stock_held_flag, ISNULL(scheme.stqueam.held_reason_code, 'n') AS held_reason_code 
FROM scheme.stquem WITH (NOLOCK) 
LEFT OUTER JOIN  scheme.stqueam WITH (NOLOCK) 
ON scheme.stquem.warehouse = scheme.stqueam.warehouse 
AND scheme.stquem.product = scheme.stqueam.product 
AND scheme.stquem.sequence_number = scheme.stqueam.sequence_number
WHERE (scheme.stquem.lot_number LIKE 'JE20%') 
AND (scheme.stquem.warehouse = 'FG') 
AND (scheme.stquem.product LIKE '005029%') 
AND (scheme.stquem.quantity > 0) ORDER BY scheme.stquem.lot_number


SELECT scheme.stquem.bin_number, scheme.stquem.lot_number, scheme.stquem.quantity, scheme.stquem.expiry_date, scheme.stquem.sequence_number, scheme.stquem.passed_inspection, scheme.stquem.inspector_code, scheme.stquem.inspection_date, 
ISNULL(scheme.stqueam.stock_held_flag, 'n') AS stock_held_flag, ISNULL(scheme.stqueam.held_reason_code, 'n') AS held_reason_code 
FROM scheme.stquem WITH (NOLOCK)
LEFT OUTER JOIN  scheme.stqueam WITH (NOLOCK)
ON scheme.stquem.warehouse = scheme.stqueam.warehouse
AND scheme.stquem.product = scheme.stqueam.product 
AND scheme.stquem.sequence_number = scheme.stqueam.sequence_number 
WHERE (scheme.stquem.lot_number LIKE '259885%') 
AND (scheme.stquem.warehouse = 'FG')
AND (scheme.stquem.product LIKE '014427%') 
AND (scheme.stquem.quantity > 0) 
ORDER BY scheme.stquem.lot_number

use syslive
select * from scheme.stkhstm where product = '002674' AND warehouse ='FG' /*and movement_reference = '2E191505'*/ AND TYPE order by dated desc


SELECT		*
FROM		scheme.stquem WITH (NOLOCK)
LEFT JOIN	scheme.stqueam WITH (NOLOCK)
ON			scheme.stquem.warehouse = scheme.stqueam.warehouse
AND			scheme.stquem.product = scheme.stqueam.product 
AND			scheme.stquem.sequence_number = scheme.stqueam.sequence_number 
WHERE		(scheme.stquem.warehouse = 'FG')
AND			(scheme.stquem.product LIKE '076317%') 
AND			batch_number = '09K0612'
ORDER BY	scheme.stquem.lot_number

select * from scheme.stqueam where pallet_number = 'U3596799AM'
select * from scheme.stqueam where pallet_number = '09K0612'

select * from scheme.stkhstm where product ='086053' and transaction_type in ('RECP','ADJ') AND user_id ='defacto' and lot_number = '164852' order by dated desc
select * from scheme.stkhstm where product ='086053' and lot_number = '164852' order by dated desc