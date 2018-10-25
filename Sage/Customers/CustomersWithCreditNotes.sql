----2A192467 B575133    
--select * from scheme.opheadm where customer in ('T262425') and datepart(year, date_entered) = 2016

  
--select * from scheme.opheadm where order_no ='2A147813'
--select * from scheme.opdetm where order_no ='2A147813' AND line_type = 'P'  

DECLARE @Custs TABLE(Customer VARCHAR(15))
INSERT INTO @Custs
-- with credit notes
SELECT		distinct h.customer
FROM		scheme.slitemm s WITH(NOLOCK)
INNER JOIN	scheme.opheadm h WITH(NOLOCK)
ON			h.invoice_no = s.item_no
INNER JOIN	scheme.opdetm d WITH(NOLOCK)
ON			h.order_no = d.order_no
WHERE		sl_year = 15
AND			d.line_type = 'P'
AND			UPPER(s.open_indicator) in ('O','C')
AND			s.amount < 0
--AND			h.customer in ('T262425')

SELECT		h.customer, cs.name, cs.address1, cs.address2, cs.address6, 
			ISNULL(SUM(CASE WHEN amount > 0 THEN s.amount END), 0 ) as TotalValue, 
			SUM(CASE WHEN s.amount < 0 THEN amount END) as TotalDeduction
--select *
FROM		scheme.slitemm s WITH(NOLOCK)
INNER JOIN	scheme.opheadm h WITH(NOLOCK)
ON			h.invoice_no = s.item_no
INNER JOIN	scheme.slcustm cs WITH(NOLOCK)
ON			cs.customer = h.customer
INNER JOIN  @Custs c
ON			h.customer = c.Customer
WHERE		sl_year = 15
AND			UPPER(s.open_indicator) in ('O','C')
--AND			d.line_type = 'P'
GROUP BY	h.customer, cs.name, cs.address1, cs.address2, cs.address6
ORDER BY	h.customer
