SELECT		DISTINCT h.* 
FROM		scheme.poheadm h
INNER JOIN	scheme.podetm d
ON			h.order_no = d.order_no
WHERE		h.status <> 'C'
AND			DATEPART(Year, date_entered) < DATEPART(YEAR,getDate())-2
AND			d.line_type = 'P'
ORDER BY	date_entered

