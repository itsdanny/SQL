select * from scheme.posinfm where supplier = 'T4993'
SELECT		p.product, p.description, p.long_description, m.product, m.description, m.long_description   
FROM		scheme.podetm p 
INNER JOIN	scheme.stockm m 
ON			p.product = m.product
WHERE		m.warehouse ='IG'
and			p.order_no ='058882'

SELECT		p.product, p.description, p.long_description, m.product, m.description, m.long_description   
FROM		scheme.podetm p 
INNER JOIN	scheme.stockm m 
ON			p.product = m.product
WHERE		m.warehouse ='IG'
and			p.product = '072745'

SELECT		p.product, p.description, p.long_description, m.product, m.description, m.long_description   
FROM		scheme.podetm p 
INNER JOIN	scheme.stockm m 
ON			p.product = m.product
WHERE		m.warehouse ='IG'
AND			p.description <> m.description
AND			p.long_description <> m.long_description 
AND			p.product = '129711'

--056577, 056459, 057107
DECLARE @Order VARCHAR(10) = '057107'
SELECT		p.product, p.description, p.long_description, m.product, m.description, m.long_description   
FROM		scheme.podetm p 
INNER JOIN	scheme.stockm m 
ON			p.product = m.product
where		p.order_no = @Order
and			m.warehouse ='IG'
AND			p.description <> m.description
AND			p.long_description <> m.long_description 

update		p
SET			p.description = m.description, 
			p.long_description = m.long_description 
FROM		scheme.podetm p 
INNER JOIN	scheme.stockm m 
ON			p.product = m.product
WHERE		p.order_no = @Order
AND			m.warehouse ='IG'
AND			p.description <>  m.description
AND			p.long_description <> m.long_description 

select * from scheme.stockm where product in ('072753','044083','002003') and warehouse = 'IG'


