SELECT		a.warehouse, a.product, b.long_description, movement_date, sum(a.movement_quantity) as IncomingQuantity 
FROM		scheme.stkhstm a WITH(NOLOCK)
INNER JOIN	scheme.stockm b WITH(NOLOCK)
ON			a.product = b.product
WHERE		a.transaction_type ='RECP' 
AND			b.warehouse = 'FG' 
AND			a.movement_date BETWEEN '2014-07-01' AND '2014-07-30' 
GROUP BY	a.warehouse, a.product, a.movement_date, b.long_description
ORDER BY	movement_date