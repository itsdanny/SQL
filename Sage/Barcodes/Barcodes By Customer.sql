SELECT		distinct m.product, m.long_description,  unit_code,
			CASE LTRIM(RTRIM(t.text01)) WHEN 'PIP CODE' THEN t.text02 ELSE t.text01 END AS pipcode,
			t2.text03 as Barcode1, t2.text04 as Barcode2, t2.text05 as Barcode3
FROM		syslive.scheme.stockm m WITH(NOLOCK) 
INNER JOIN	syslive.scheme.sttechm  t WITH(NOLOCK) 
ON			m.warehouse = t.warehouse
AND			m.product = t.product
INNER JOIN	syslive.scheme.sttechm t2 WITH(NOLOCK) 
ON			m.warehouse = t2.warehouse
AND			m.product = t2.product
INNER JOIN	scheme.opdetm d WITH(NOLOCK) 
ON			m.warehouse = d.warehouse
AND			m.product = d.product	
INNER JOIN	scheme.opheadm h WITH(NOLOCK) 
ON			h.order_no = d.order_no
WHERE		t.page_number = 24 
AND			m.warehouse = 'FG'
AND			t2.page_number = 26
AND			h.customer ='T480126'
order by	m.long_description

--select * from syslive.scheme.sttechm where warehouse ='FG'

--select top 10 * from scheme.opheadm h