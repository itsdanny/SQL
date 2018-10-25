SELECT		cs.customer, cs.name, cs.address1, cs.address2, cs.address6, s.item_no,
			ISNULL(SUM(CASE WHEN amount > 0 THEN s.amount END), 0 ) as TotalValue, 
			COUNT(cs.customer) Disputes
FROM		scheme.slitemm s WITH(NOLOCK) 
INNER JOIN	scheme.slinvxm r 
ON			s.item_no = r.item_no
INNER JOIN	scheme.slcustm cs WITH(NOLOCK)
ON			cs.customer = s.customer
where		dispute_code = 21
GROUP BY	cs.customer, cs.address1, cs.address2, cs.address6,s.item_no,name
ORDER BY	cs.customer

SELECT		cs.customer, cs.address1, cs.address2, cs.address6, amount,s.item_no
FROM		scheme.slitemm s WITH(NOLOCK) 
INNER JOIN	scheme.slinvxm r 
ON			s.item_no = r.item_no
INNER JOIN	scheme.slcustm cs WITH(NOLOCK)
ON			cs.customer = s.customer
WHERE		dispute_code = 21
ORDER BY	cs.customer