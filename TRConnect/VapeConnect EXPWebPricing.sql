SELECT order_no, product, description, bin_number, order_qty, list_price, net_price, val FROM slam.scheme.opdetm WHERE		order_no LIKE	'CN%' 
AND	net_price > 0 AND	bin_number <> 'SL001'

SELECT * FROM EXPWebPricing WHERE		ProductCode IN ('AC-BDC-COIL, SLIM-COIL-22, SSBVC-CO')