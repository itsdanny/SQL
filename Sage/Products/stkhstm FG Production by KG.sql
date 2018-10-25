/* This sort of work, but fails big time on the second bit	*/
SELECT		s.product, s.long_description, s.alpha, s.unit_code,
			LEFT(h.lot_number,4) as Lot,
			ISNULL(sum(h.movement_quantity),0) AS Packs,
			ISNULL(sum(h.movement_quantity),0) * u.spare as Units
			INTO #Tmp
from		scheme.stockm s WITH(NOLOCK)
INNER JOIN	scheme.stkhstm h WITH(NOLOCK)
ON			s.product = h.product
AND			s.warehouse = h.warehouse
INNER JOIN	scheme.stunitdm u WITH(NOLOCK)
ON			s.unit_code = u.unit_code
WHERE		h.dated BETWEEN '2013-01-01' AND '2013-06-30' 
AND			h.transaction_type = 'COMP' 
and			h.product = '002682'
AND			h.warehouse = 'FG'
GROUP BY	h.warehouse, s.product, s.long_description, s.alpha, s.unit_code, left(h.lot_number,4), u.spare 


SELECT		t.product, t.long_description, t.alpha, t.unit_code, 
			SUM(t.Packs) AS Packs, 
			SUM(t.Units) AS Units,
			(SELECT		SUM(h.movement_quantity)
			FROM		scheme.stockm s WITH(NOLOCK)
			INNER JOIN	scheme.stkhstm h WITH(NOLOCK)
			ON			s.product = h.product
			AND			s.warehouse = h.warehouse
			where		LEFT(h.lot_number,4) = t.Lot
			and			h.dated BETWEEN '2013-01-01' AND '2013-06-30' 
			AND			h.transaction_type = 'COMP' 
			AND			h.warehouse = 'BK'
			GROUP BY	LEFT(h.lot_number,4)) as KGs,
			(SELECT		MAX(s.analysis_c)
			FROM		scheme.stockm s WITH(NOLOCK)
			INNER JOIN	scheme.stkhstm h WITH(NOLOCK)
			ON			s.product = h.product
			AND			s.warehouse = h.warehouse
			where		LEFT(h.lot_number,4) = t.Lot
			and			h.dated BETWEEN '2013-01-01' AND '2013-06-30' 
			AND			h.transaction_type = 'COMP' 
			AND			h.warehouse = 'BK'
			GROUP BY	LEFT(h.lot_number,4)) as Line INTO #Another
FROM		#Tmp t
GROUP BY	t.product, t.long_description, t.alpha, t.unit_code, t.Lot


SELECT		Line, product, long_description, alpha, unit_code, 
			SUM(Packs) AS Packs, 
			SUM(Units) AS Units, 
			SUM(KGs) AS KGs 
FROM		#Another
where		KGs is not null
GROUP BY	Line, product, long_description, alpha, unit_code
/*
DROP TABLE #Tmp
DROP TABLE #Another 
*/
--select * from scheme.stkhstm where product ='001619' and transaction_type = 'COMP' AND dated BETWEEN '2013-01-01' AND '2013-06-30' 