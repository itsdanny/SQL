SELECT DISTINCT s.product, MAX(dated),	LEFT (lot_number, 4), s.catalogue_number, h.comments
FROM		syslive.scheme.stkhstm h
INNER JOIN 	syslive.scheme.stockm s
ON			h.warehouse = s.warehouse 
AND			h.product = s.product 
WHERE		transaction_type IN ('COMP')
AND			s.analysis_a <> 'TPTY'
AND    dated > GETDATE()-30
GROUP BY      s.product, LEFT (lot_number, 4),  s.catalogue_number, h.comments


SELECT	*
FROM		BatchProcessOrders

SELECT	*
FROM		BatchInformation WHERE		1=2