SELECT * from Log where LogFile in ('StockAdjust5915286_20140909213607.xml','StockAdjust5915289_20140909213607.xml','StockAdjust5915291_20140909213607.xml') order by LogDateTime
SELECT * from Log where LogFile like '%StockAdjust5915286_20140909213607%' or LogFile like '%StockAdjust5915289_20140909213607%' or LogFile like'%StockAdjust5915291_20140909213607%' order by LogDateTime

select * from Log where LogDateTime between '2014-09-09 21:43:09.757' and '2014-09-09 21:55:09.757'
select * from Errors order by ErrorDateTime desc
select * from Log order by LogDateTime desc

SELECT		h.DateProcessed, h.OrderNumber, c.*, l.*
FROM		SalesOrderHeader h
INNER JOIN	SalesOrderLine l
ON			h.Id = l.SalesOrderHeaderId
LEFT JOIN   CustomerShelfLife c
ON			h.CustomerAccountNumber = c.CustomerCode
AND			l.ProductCode = c.ProductCode 
ORDER BY	DateProcessed desc


update h
set Processed = 1
FROM		SalesOrderHeader h
INNER JOIN	SalesOrderLine l
ON			h.Id = l.SalesOrderHeaderId
WHERE		h.Processed is null
and h.Id < 1570


SELECT * 
FROM		SalesOrderHeader h
INNER JOIN	SalesOrderLine l
ON			h.Id = l.SalesOrderHeaderId
WHERE		h.Processed is null




select * from scheme.stockm where product  IN ('024384','016306') and warehouse = 'FG'
select * from scheme.stquem where product ='024384' and lot_number like 'JD03%' AND bin_number = 'UDG01'
select * from scheme.stquem where product ='016357' and lot_number like 'JD04%'
select * from scheme.stquem where product ='008575' and lot_number like 'HL%'
select * from scheme.stockm where product = '076902'
select * from scheme.stunitdm 
SELECT * 
FROM		scheme.poheadm h
INNER JOIN	scheme.podetm d
ON			h.order_no = d.order_no
where		h.order_no ='051362'
