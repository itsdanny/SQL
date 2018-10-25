USE syslive
GO
SELECT	TOP 10000 s.*
FROM		syslive.scheme.stquem s WITH(NOLOCK)
WHERE			product = '001295'

SELECT	TOP 10000 s.*
FROM		syslive.scheme.stquem s WITH(NOLOCK)
WHERE		passed_inspection = 'Y' 
AND			quantity > 0
AND	warehouse = 'FG'

SELECT	s.*, q.*
FROM		syslive.scheme.stquem s WITH(NOLOCK)
INNER JOIN 	syslive.scheme.stqueam q WITH(NOLOCK)
ON			s.product = q.product
AND			s.warehouse = q.warehouse
AND			s.sequence_number = q.sequence_number
INNER JOIN 	syslive.scheme.stockm m
ON			s.product = m.product
AND			s.warehouse = m.warehouse
WHERE		s.warehouse = 'EC' 
AND			s.bin_number = 'EC01'
AND			quantity > 0

UPDATE 		s
SET			s.passed_inspection = 'Y', inspector_code = 'SE', inspection_date = '2017-11-30 00:00:00'
FROM		syslive.scheme.stquem s WITH(NOLOCK)
INNER JOIN 	syslive.scheme.stqueam q WITH(NOLOCK)
ON			s.product = q.product
AND			s.warehouse = q.warehouse
AND			s.sequence_number = q.sequence_number
INNER JOIN 	syslive.scheme.stockm m
ON			s.product = m.product
AND			s.warehouse = m.warehouse
WHERE		s.warehouse = 'EC' 
AND			s.bin_number = 'EC01'
AND			quantity > 0


UPDATE 	m SET	m.uninspected_qty = 0
FROM		syslive.scheme.stquem s WITH(NOLOCK)
INNER JOIN 	syslive.scheme.stqueam q WITH(NOLOCK)
ON			s.product = q.product
AND			s.warehouse = q.warehouse
AND			s.sequence_number = q.sequence_number
INNER JOIN 	syslive.scheme.stockm m
ON			s.product = m.product
AND			s.warehouse = m.warehouse
WHERE		s.warehouse = 'EC' 
AND			s.bin_number = 'EC01'
AND			quantity > 0
