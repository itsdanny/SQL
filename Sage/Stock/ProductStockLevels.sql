SELECT		s.warehouse, s.product, s.description, s.unit_code, q.lot_number, q.batch_number,
			SUM(q.quantity) AS TotalFree, SUM(q.quantity_free) AS QuanityFree 
FROM		syslive.scheme.stockm s
INNER JOIN 	syslive.scheme.stquem q
ON			s.warehouse = q.warehouse
AND			s.product = q.prod_code
WHERE		((s.product between '100071' AND '138842') 
	OR		(s.product between '200008' AND	'500667')
	OR		(s.product between '001015' AND '098108'))
AND			s.warehouse IN ('IG','FG')
AND			q.quantity_free > 0
GROUP BY	s.warehouse, s.product, s.description, s.unit_code, q.lot_number, q.batch_number