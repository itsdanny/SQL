--SELECT * INTO [demo].scheme.ITCR10043 FROM		[demo].[dbo].[ABCUpdates] a


SELECT a.*, s.abc_category AS CurrentABC

FROM		[demo].scheme.ITCR10043 a
INNER JOIN 	syslive.scheme.stockm s WITH(NOLOCK)
ON			a.product = s.product
WHERE		s.warehouse = 'FG'

UPDATE		s
SET			s.abc_category = a.abc_category
FROM		[demo].[dbo].[ABCUpdates] a
INNER JOIN 	syslive.scheme.stockm s WITH(NOLOCK)
ON			a.product = s.product
WHERE		s.warehouse = 'FG'

-- AND	BACK AGAIN...
SELECT		a.*
FROM		demo.scheme.ITCR10043 a
INNER JOIN 	syslive.scheme.stockm s WITH(NOLOCK)
ON			a.product = s.product
WHERE		s.warehouse = 'FG'

UPDATE		s
SET			s.abc_category = a.abc_category
FROM		[demo].scheme.ITCR10043 a
INNER JOIN 	syslive.scheme.stockm s WITH(NOLOCK)
ON			a.product = s.product
WHERE		s.warehouse = 'FG'

SELECT * FROM [demo].scheme.ITCR10043