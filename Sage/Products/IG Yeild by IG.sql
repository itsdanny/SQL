SELECT		DISTINCT s.dated, a.alpha_code, works_order, s.product, product_code, c.FGProductDescription, batch_size, quantity_required, quantity_finished, quantity_rejected,IGCode, BKCode, FGCode, Mass, g_lt, Base_g, WOType,
			ROUND(scheme.fn_GetStockQuantity(c.IGCode, s.warehouse, s.dated), 5) * 1000 AS IGOpeningStock 
FROM		scheme.bmwohm a WITH(NOLOCK)
INNER JOIN	scheme.stkhstm s WITH(NOLOCK)
ON			a.works_order = s.movement_reference
INNER JOIN	ContDrugsImport c
ON			s.product = c.IGCode
AND			(a.product_code = c.BKCode or a.product_code = c.FGCode)
WHERE		s.dated BETWEEN '2014-01-01' AND '2014-12-31'
AND			s.product = '105065'
--AND			s.product  in ('105588','100063','113130')
order by	dated, works_order