SELECT		* 
FROM		syslive.scheme.stkhstm
WHERE		 product like  '073091'
AND	dated > GETDATE()-2
AND		transaction_type ='RECP'



SELECT		* 
FROM		syslive.scheme.stquem
WHERE		prod_code ='073091'
AND		warehouse = 'IG'
--	8217010001
--UPDATE syslive.scheme.stkhstm
--SET comments = '078146 supplier T4993'--, lot_number = '11'+lot_number
--WHERE		 product like  '073091'
--AND	dated > GETDATE()-2
--AND		transaction_type ='RECP'


SELECT		* 
FROM		syslive.scheme.stkhstm
WHERE		 product = '078034'
AND	dated > GETDATE()-14
AND		transaction_type ='RECP'


SELECT		* 
FROM		syslive.scheme.stquem
WHERE		prod_code ='078034'
AND		warehouse = 'IG'