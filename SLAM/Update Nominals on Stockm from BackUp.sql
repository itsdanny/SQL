SELECT		*
FROM		DANSSLAM.scheme.stockm as d WITH(NOLOCK) 
INNER JOIN	slam.scheme.stockm as s WITH(NOLOCK) 
ON			d.product = s.product
and			d.warehouse = s.warehouse

UPDATE		s 
SET			s.nominal_key = d.nominal_key			
FROM		DANSSLAM.scheme.stockm as d WITH(NOLOCK) 
INNER JOIN	slam.scheme.stockm as s WITH(NOLOCK) 
ON			d.product = s.product
and			d.warehouse = s.warehouse