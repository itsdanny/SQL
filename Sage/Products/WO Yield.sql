SELECT		*	
FROM		scheme.bmwohm h WITH(NOLOCK)
INNER JOIN	scheme.stkhstm s WITH(NOLOCK)
ON			h.works_order = s.movement_reference
--WHERE		s.dated BETWEEN @FromDate AND @ToDate
WHERE		s.dated BETWEEN '2014-01-01' AND '2014-12-31'
AND			s.product IN (SELECT DISTINCT IGCode FROM ContDrugsImport)
--AND			s.product  in ('100403')
AND			h.alpha_code = 'HV10'
ORDER BY	h.alpha_code

SELECT		*	
FROM		scheme.bmwohm h WITH(NOLOCK)
INNER JOIN	scheme.stkhstm s WITH(NOLOCK)
ON			h.works_order = s.movement_reference
--WHERE		s.dated BETWEEN @FromDate AND @ToDate
WHERE		s.dated BETWEEN '2014-01-01' AND '2014-12-31'
AND			s.product IN (SELECT DISTINCT BKCode FROM ContDrugsImport)
AND			h.alpha_code = 'HV10'
ORDER BY	h.alpha_code

SELECT		*	
FROM		scheme.bmwohm h WITH(NOLOCK)
INNER JOIN	scheme.stkhstm s WITH(NOLOCK)
ON			h.works_order = s.movement_reference
--WHERE		s.dated BETWEEN @FromDate AND @ToDate
WHERE		s.dated BETWEEN '2014-01-01' AND '2014-12-31'
AND			s.product IN (SELECT DISTINCT FGCode FROM ContDrugsImport)
AND			h.alpha_code = 'HV10'
ORDER BY	h.alpha_code


