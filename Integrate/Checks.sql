SELECT	*
FROM		syslive.scheme.fscontq5m ORDER BY	1 
--WHERE		fs_id = '0000'
/*
DELETE
FROM		syslive.scheme.fscontq5m
WHERE		fs_id <> '0000'

update 	syslive.scheme.fscontq5m SET fs_status ='X'
	
*/

	SELECT	*
	FROM		Integrate.dbo.Log 
	WHERE		LogFile LIKE '%StockAdjust18520139_20170721080009%'
	ORDER BY	1 DESC 





SELECT	*
FROM		syslive.scheme.stquem s
INNER JOIN 	syslive.scheme.stqueam h
ON			s.product = h.product
AND			s.warehouse = h.warehouse
AND			s.sequence_number = h.sequence_number
WHERE		s.product = '070912'
AND			s.warehouse = 'FG'
AND			quantity > 0
AND			h.stock_held_flag ='y'
AND			s.bin_number ='UDG01'

UPDATE		h
SET			h.stock_held_flag = 'n', held_reason_code =''
FROM		syslive.scheme.stquem s
INNER JOIN 	syslive.scheme.stqueam h
ON			s.product = h.product
AND			s.warehouse = h.warehouse
AND			s.sequence_number = h.sequence_number
WHERE		s.product = '070912'
AND			s.warehouse = 'FG'
AND			quantity > 0
AND			h.stock_held_flag ='y'
AND			s.bin_number ='UDG01'


