use Integrate
truncate table imp_StockAdjustments
DBCC CHECKIDENT (imp_StockAdjustments, reseed, 1)

INSERT INTO imp_StockAdjustments(ProductCode, LotNumber, Quantity, BatchID, StockStatus,StockStatusReason, Line_Number, UOMQty, Processed, Bin)
SELECT		Product, 
			c.LotNumber AS LotNumber, 
			Qty AS Quantity, 
			c.LotNumber AS BatchID, 
			CASE b.Q_status WHEN 'NI' THEN 'n' ELSE 'y' END AS StockStatus, 						
			b.Stock_Status 
			StockStatusReason,
			1 as LineNumber,
			0 as UOMQty, 
			0 as Processed,
			COALESCE(b.UDGBINLocation, 'UDG01') AS Bin
FROM		syslive.scheme.stockm a
INNER JOIN	Integrate.dbo.imp_MissingBatches c
ON			a.product = c.Product	
LEFT JOIN	imp_status_bins b
ON			c.Reason = b.Stock_Status
and			CASE b.Q_status WHEN 'NI' THEN 'N' ELSE 'Y' END = c.Inspected
WHERE		a.warehouse = 'FG'		
--AND		a.product ='076384'
GROUP BY	Qty, Product, b.Stock_Status, b.UDGBINLocation, c.LotNumber, b.Q_status


-- CONVERT TO OUR CODES
update imp_StockAdjustments SET StockStatus = 'n' where StockStatus = 'NI'

update imp_StockAdjustments SET StockStatus = 'y' where StockStatus = 'I'
update imp_StockAdjustments SET Processed = 0

-- CONVERT TO UOM
UPDATE		i
SET			i.UOMQty = i.Quantity
FROM		imp_StockAdjustments i
INNER JOIN	syslive.scheme.stockm s
ON			i.ProductCode = s.product
INNER JOIN	syslive.scheme.stunitdm u
ON			s.unit_code = u.unit_code
WHERE		s.warehouse = 'FG'


SELECT * 
FROM		imp_StockAdjustments i
LEFT JOIN	syslive.scheme.stockm s
ON			i.ProductCode = s.product
left JOIN	syslive.scheme.stunitdm u
ON			s.unit_code = u.unit_code
WHERE		s.warehouse = 'FG'

SELECT * 
FROM		imp_StockAdjustments i
left join	imp_MissingBatches a
ON			i.ProductCode = a.Product
and			i.BatchID = a.LotNumber