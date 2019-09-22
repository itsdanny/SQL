SELECT		TOP 10 s.product, q.long_description, batch_number, date_received, s.bin_number, passed_inspection, inspection_date/*, DATEADD(YEAR, 3, s.date_received)*/, expiry_date, quantity, s.best_before_date, s.best_date_key, s.expiry_date_key, s.sellby_date_key
FROM		slam.scheme.stquem s WITH(NOLOCK)
LEFT JOIN 	slam.scheme.stockm q WITH(NOLOCK)
ON			s.product = q.product
AND			s.warehouse = q.warehouse
WHERE		quantity > 0
AND			s.bin_number <> 'OOD'
AND			s.expiry_date IS NOT NULL
union all 
SELECT		TOP 10 s.product, q.long_description, batch_number, date_received, s.bin_number, passed_inspection, inspection_date/*, DATEADD(YEAR, 3, s.date_received) AS nEW*/, expiry_date, quantity,s.best_before_date, s.best_date_key, s.expiry_date_key, s.sellby_date_key
FROM		slam.scheme.stquem s WITH(NOLOCK)
LEFT JOIN 	slam.scheme.stockm q WITH(NOLOCK)
ON			s.product = q.product
AND			s.warehouse = q.warehouse
WHERE		quantity > 0
AND			s.expiry_date IS NULL

RETURN 
/*
UPDATE 		b
SET			b.expiry_date = DATEADD(YEAR, 3, b.inspection_date)
FROM		slam.scheme.stquem b
LEFT JOIN 	slam.scheme.stockm q 
ON			s.product = q.product
AND			s.warehouse = q.warehouse
WHERE		quantity > 0
AND			s.expiry_date IS NULL
AND			1 = 2
*/