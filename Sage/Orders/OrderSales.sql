-- Sales by order for when ever
SELECT		h.order_no,
			h.date_despatched,
			Sum(h.gross_value) as Gross,
			Sum(h.nett_value) as Net
FROM		scheme.opheadm  h WITH (nolock)
WHERE		(h.status IN (1, 5, 6, 7, 8)) 
AND			(h.customer < 'T000001' OR h.customer > 'T009999') 
AND			h.sl_year = '14'
AND			h.sl_period = '02' 
GROUP BY	h.order_no, h.date_despatched
ORDER BY 	h.order_no, h.date_despatched	


-- What's on a Sales Order
SELECT		*
FROM		scheme.opheadm  h WITH (nolock)
INNER JOIN	scheme.opdetm d WITH (nolock)
ON			h.order_no = d.order_no
WHERE		(h.order_no = '2E196130') 



