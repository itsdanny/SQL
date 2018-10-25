--select * from scheme.opsadetm
SELECT		COUNT(DISTINCT h.invoice_no) as Invoices, delivery_method As InvDeliveryMethod, DATEPART(MONTH, d.dated) AS InvMonth, DATEPART(YEAR, d.dated) as InvYear
from		scheme.opheadm h
INNER JOIN	scheme.opsadetm d
ON			h.invoice_no = d.invoice
WHERE		DATEPART(YEAR, d.dated) >= DATEPART(year, getDate())-1
group by	delivery_method, DATEPART(MONTH, d.dated),DATEPART(YEAR, d.dated)
order by	DATEPART(YEAR, d.dated), DATEPART(MONTH, d.dated)

go

SELECT		DATEPART(MONTH, dated) AS InvMonth, DATEPART(YEAR, dated) as InvYear, 
			count(distinct item_no) as Cns, SUM(amount) AS CreditValue
FROM		scheme.slitemm
WHERE		kind ='CRN'
GROUP BY	DATEPART(MONTH, dated), DATEPART(YEAR, dated) 


SELECT *  FROM scheme.slitemm
