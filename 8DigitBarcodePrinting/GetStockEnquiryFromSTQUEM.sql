-- THIS IS THE QUERY WHICH RETURNS "" IF NOTHING FOUND.

SELECT TOP 1	scheme.stockm.warehouse, 
				scheme.stockm.product, 
				scheme.stockm.long_description, 
				scheme.stkhstm.dated, 
				scheme.stkhstm.expiry_date, 
				scheme.poheadm.order_no, 
				scheme.poheadm.supplier, 
				scheme.plsuppm.name, 
				scheme.stockm.selling_unit, 
				scheme.stkhstm.lot_number, 
				scheme.stockm.drawing_number, 
				scheme.stkhstm.movement_quantity,     
				(SELECT scheme.stockm.product 
				FROM	scheme.stockm WITH (NOLOCK) 
				WHERE	scheme.stockm.warehouse = 'IG' 
				AND		scheme.stockm.product = (SELECT TOP 1	conformity_ref	
												 FROM			scheme.stquem WITH (NOLOCK)                    
												 WHERE			bin_number = '40317' 
												 AND			lot_number = '025847A01')) AS NewProductCode,     
				(SELECT scheme.stockm.drawing_number
				FROM	scheme.stockm  WITH (NOLOCK)    
				WHERE	scheme.stockm.warehouse = 'IG' 
				AND     scheme.stockm.product = (SELECT TOP 1	conformity_ref 
												 FROM			scheme.stquem WITH (NOLOCK)                            
												 WHERE			bin_number = '40317'
												 AND			lot_number = '025847A01')) AS NewDrawingNumber 
FROM			scheme.stkhstm WITH (NOLOCK) 
INNER JOIN		scheme.stockm WITH (NOLOCK) 
ON				scheme.stkhstm.warehouse = scheme.stockm.warehouse 
AND				scheme.stkhstm.product = scheme.stockm.product
INNER JOIN		scheme.poheadm WITH (NOLOCK) 
ON				SUBSTRING((SELECT TOP 1 t.comments  
						   FROM		scheme.stkhstm AS t WITH (NOLOCK)   
						   WHERE		t.transaction_type = 'RECP' 
						   AND			t.product = scheme.stockm.product 
						   AND			t.expiry_date = scheme.stkhstm.expiry_date), 0, 7) = scheme.poheadm.order_no 
INNER JOIN		scheme.plsuppm WITH (NOLOCK) 
ON				scheme.poheadm.supplier = scheme.plsuppm.supplier 
WHERE			scheme.stkhstm.lot_number = '025847A01' 
AND				(scheme.stkhstm.batch_number = (SELECT TOP 1  scheme.stquem.batch_number
												FROM		  scheme.stquem WITH (NOLOCK)   
												WHERE		  scheme.stquem.bin_number = '40317' 
												AND			  scheme.stquem.lot_number = '025847A01' 
												ORDER BY	  scheme.stquem.batch_number DESC, scheme.stquem.prod_code ASC)) 
AND				(scheme.stkhstm.product =		(SELECT TOP 1 scheme.stquem.prod_code     
											    FROM		  scheme.stquem WITH (NOLOCK)   
											    WHERE		  scheme.stquem.bin_number = '40317' 
											    AND			  scheme.stquem.lot_number = '025847A01' 
											   ORDER BY		  scheme.stquem.batch_number DESC, scheme.stquem.prod_code ASC))
AND				(scheme.stkhstm.transaction_type = 'DKIT')


SELECT TOP 1	*
FROM			scheme.stquem WITH (NOLOCK)                            
WHERE			bin_number = '40317'
AND			lot_number = '025847A01'

SELECT * FROM scheme.stquem WITH (NOLOCK)WHERE LEN(product) = 8
SELECT * FROM scheme.stkhstm WHERE scheme.stkhstm.product = '242894' AND scheme.stkhstm.batch_number = 'Q59442'  AND (scheme.stkhstm.transaction_type = 'DKIT')
SELECT * FROM scheme.stkhstm WHERE scheme.stkhstm.lot_number = '
01' AND scheme.stkhstm.product = '242894' AND scheme.stkhstm.batch_number = 'Q59442'

select * from 	scheme.plsuppm WITH (NOLOCK)  where 	scheme.plsuppm.supplier = 'T1002'
select * from 	scheme.poheadm h WITH (NOLOCK) 
inner join scheme.podetm d WITH (NOLOCK) 
on	h.order_no = d.order_no
where 	h.supplier = 'T1002'
and product = '242894'



SELECT * 
FROM		  scheme.stquem WITH (NOLOCK)   
WHERE		  scheme.stquem.bin_number = '40317' 
--AND			  scheme.stquem.lot_number = '025847A01' 
order by date_received desc