-- Samples where not in EA
SELECT *
FROM		SalesOrderHeader h
INNER JOIN [dbo].[SalesOrderLine] d
ON			h.Id = d.SalesOrderHeaderId
WHERE		h.SaleOrderTypeId = 8
AND			d.UOM <> 'EA'


SELECT *
FROM		SalesOrderHeader h
INNER JOIN [dbo].[SalesOrderLine] d
ON			h.Id = d.SalesOrderHeaderId
WHERE		h.SaleOrderTypeId = 1
AND			(d.ShelfLifeDays > 365
or			h.Id = 10111)
ORDER BY	h.DateProcessed desc

SELECT * FROM SalesOrderLine WHERE SalesOrderHeaderId = 10111    


-- RETURNS
SELECT		*
FROM		SalesOrderHeader h
INNER JOIN [dbo].[SalesOrderLine] d
ON			h.Id = d.SalesOrderHeaderId
WHERE		h.SaleOrderTypeId = 3
AND			h.CustomerAccountNumber = 'T470510'


SELECT		*
FROM		SalesOrderHeader h
INNER JOIN [dbo].[SalesOrderLine] d
ON			h.Id = d.SalesOrderHeaderId
WHERE		(h.OrderNumber like '%CN021901%')
