-- This alters the wrongly set inspected flag to 'Y'  to returns from Alloga
SELECT * 
FROM		scheme.stqueam a WITH(NOLOCK)
INNER JOIN	scheme.stquem b WITH(NOLOCK)
ON			a.warehouse = b.warehouse
AND			a.product = b.product
AND			a.sequence_number = b.sequence_number
WHERE		a.product = '044180'
AND			b.batch_number = 'RLC75'
AND			passed_inspection <> 'Y'

/*

update		b	
SET			passed_inspection  = 'Y'
FROM		scheme.stqueam a
INNER JOIN	scheme.stquem b
ON			a.warehouse = b.warehouse
AND			a.product = b.product
AND			a.sequence_number = b.sequence_number
WHERE		a.product = '044180'
AND			b.batch_number = 'RLC75'
AND			passed_inspection <> 'Y'


*/

SELECT	movement_quantity * 1000 
FROM	scheme.stkhstm WITH(NOLOCK)
WHERE	product = '105065' 
AND		dated = '2014-02-19'