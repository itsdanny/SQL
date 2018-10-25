SELECT		DISTINCT h.date_entered, h.*, b.quantity, b.quantity_free
FROM		slam.scheme.opheadm h WITH(NOLOCK)
INNER JOIN	slam.scheme.opdetm d WITH(NOLOCK)
ON			h.order_no = d.order_no
INNER JOIN 	slam.scheme.stquem b WITH(NOLOCK)
ON			d.product = b.product
WHERE		h.order_no like ('%/%')
AND			b.quantity_free = 0
ORDER BY	1