SELECT		 product, date_received, sum(quantity)  AS Qty
FROM		slam.scheme.stquem WITH(NOLOCK)
WHERE		bin_number = '01' 
AND			quantity > 0
AND			date_received ='2017-01-27 00:00:00.000'
GROUP BY	product, date_received

SELECT		 product, date_received, sum(quantity)  AS Qty
FROM		slam.scheme.stquem
WHERE		bin_number = '17' 
AND			quantity > 0
GROUP BY	product, date_received
