--- USE THIS TO FIND WHO CREATED SAMPLE SALES ORDERS
SELECT * 
FROM		Log l
INNER JOIN	SalesOrderHeader o
ON			l.LogFile = o.Id
INNER JOIN	SalesOrderLine d
ON			o.Id = d.SalesOrderHeaderId
WHERE		UPPER(LogMessage) LIKE '%SAMPLE%'
AND			CAST(LogDateTime  as date) = '2014-11-10'
AND			o.SaleOrderTypeId = 8