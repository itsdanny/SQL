SELECT		h.date_entered, h.customer, d.*
FROM		slam.scheme.opheadm h WITH(NOLOCK)
INNER JOIN 	slam.scheme.opdetm d WITH(NOLOCK)
ON			h.order_no = d.order_no
WHERE		h.date_entered > GETDATE()-7
ORDER BY	 h.date_entered, h.customer, h.order_no, d.product