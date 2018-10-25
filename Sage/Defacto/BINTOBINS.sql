SELECT '00|SR1|000000|Bin To Bin DEFCAP|' AS FileHeader
--24|1|SL|2|EJ-VAC-12|3|2|4|20/09/17|6||8|Stock Discrepancy CORR|9|M2|16||21||
UNION all
SELECT		'31|1|SL|2|'+rtrim(s.product)+'|3|' + CAST(s.quantity AS VARCHAR(10)) + '|4|01/11/17|5|SL|6||8|' +LTRIM(RTRIM(s.warehouse))+LTRIM(RTRIM(s.product))+'|10|FIRE DAM|12||13|'+RTRIM(bin_number)+'|14||15|bat='+ LTRIM(RTRIM(s.batch_number)) +'|16|QFIRE|17||'
FROM		slam.scheme.stquem s WITH(NOLOCK)
LEFT  JOIN 	slam.scheme.stqueam q WITH(NOLOCK)
ON			s.product = q.product
AND			s.warehouse = q.warehouse
AND			s.sequence_number = q.sequence_number
WHERE		s.warehouse = 'SL' 
AND			quantity > 0
AND			bin_number NOT IN (SELECT	DISTINCT RIGHT(LTRIM(RTRIM(customer)),2)
   			                   FROM		demo.scheme.slcustm WHERE		name LIKE 'RETAIL%')
AND			bin_number NOT IN ('QUAR','QFIRE')
--AND			s.product = 'CA-UK-PL-18'




SELECT	*
FROM		demo.scheme.stquem s WITH(NOLOCK)
WHERE		s.warehouse = 'SL' 
--AND			quantity > 0
AND			bin_number NOT IN (SELECT	DISTINCT RIGHT(LTRIM(RTRIM(customer)),2)
   			                   FROM		demo.scheme.slcustm WHERE		name LIKE 'RETAIL%')
AND			s.product = 'EJ-BA-24'
AND			bin_number NOT IN ('QUAR','QFIRE')

DELETE FROM	Results
INSERT INTO Results
SELECT		from_bin,s.product, qty, to_bin, sum(quantity) AS BinTotal

FROM		VapeConnect.dbo.Returns$ s
INNER JOIN 	slam.scheme.stquem b
ON			s.product = b.product
AND			s.from_bin = b.bin_number
WHERE		b.quantity > 0
--AND			s.product ='EJ-BLU-12'
--AND			s.from_bin = 'W4'
GROUP BY	from_bin, s.product, qty, to_bin

SELECT	*,	CASE WHEN qty > BinTotal THEN BinTotal ELSE qty END
FROM		Results 
WHERE		qty > BinTotal 
SELECT		'00|SR1|000000|Stock Adj|'
union all
SELECT		'24|1|SL|2|'+LTRIM(RTRIM(product))+'|3|'+CAST(SUM(qty - BinTotal) AS VARCHAR(4))+'|4|27/11/2017|6||8|STOCK TIDY|9|'+RIGHT(LTRIM(RTRIM(from_bin)),2)+'|16||21||'
FROM		Results 
WHERE		 qty > BinTotal 
GROUP BY	LTRIM(RTRIM(product)), RIGHT(LTRIM(RTRIM(from_bin)),2)


SELECT '00|SR1|000000|Bin To Bin DEFCAP|' AS FileHeader
--24|1|SL|2|EJ-VAC-12|3|2|4|20/09/17|6||8|Stock Discrepancy CORR|9|M2|16||21||
UNION all
SELECT		'31|1|SL|2|'+rtrim(s.product)+'|3|' + CAST(BinTotal AS VARCHAR(10)) + '|4|27/11/17|5|SL|6||8|' +LTRIM(RTRIM('SL'))+LTRIM(RTRIM(s.product))+'|10|'+CASE LTRIM(RTRIM(to_bin)) WHEN 'QFIRE' THEN 'FIRE DAMAGE' ELSE 'RETURNS' END+'|12||13|'+RTRIM(from_bin)+'|14||15||16|'+ LTRIM(RTRIM(to_bin)) +'|17||'
FROM		Results s
