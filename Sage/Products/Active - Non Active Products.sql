-- get none active and then...
select a.product, a.long_description
from scheme.stockm a
 where product like '1%'
AND warehouse = 'IG'
AND analysis_a NOT LIKE 'ZZ%'
and a.product not in(select a.product
from scheme.stockm a
LEFT join scheme.stockxpgm b
ON		a.product = b.product
and		a.warehouse = b.warehouse
 where a.product like '1%'
AND a.warehouse = 'IG'
AND analysis_f = 'ACTIVE'
)
--... active
select a.product, a.long_description
from scheme.stockm a
LEFT join scheme.stockxpgm b
ON		a.product = b.product
and		a.warehouse = b.warehouse
 where a.product like '1%'
AND a.warehouse = 'IG'
AND analysis_f = 'ACTIVE'





-----------------------------------------------
--- tidied up
use syslive
go

-- get none active and then...
SELECT	a.product, a.long_description
FROM	scheme.stockm a
WHERE	product like '1%'
AND		warehouse = 'IG'
AND		analysis_a NOT IN ('ZZZZ','TPTYBULK')
AND		a.product NOT IN(SELECT		a.product
					 FROM		scheme.stockm a
					 LEFT JOIN	scheme.stockxpgm b
					 ON			a.product = b.product
					 AND		a.warehouse = b.warehouse
					 WHERE		a.product like '1%'
					 AND		a.warehouse = 'IG'
					 AND		analysis_f = 'ACTIVE')
--... active
select a.product, a.long_description
from scheme.stockm a
LEFT join scheme.stockxpgm b
ON		a.product = b.product
and		a.warehouse = b.warehouse
 where a.product like '1%'
AND a.warehouse = 'IG'
AND analysis_f = 'ACTIVE'
AND analysis_a NOT IN ('ZZZZ','TPTYBULK')