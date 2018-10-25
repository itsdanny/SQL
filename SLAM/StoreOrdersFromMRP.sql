DECLARE @BRA VARCHAR(2) = 'W4'
-- rows imported
SELECT COUNT(1), SUM(QtyPicked) FROM MRPStockRequirements m
WHERE		ToBin = @BRA
-- imported IN stock
SELECT COUNT(1), SUM(QtyPicked) FROM MRPStockRequirements m
INNER JOIN		slam.scheme.stockm s
ON				m.SageProductCode = s.product
WHERE		ToBin = @BRA
AND			physical_qty > 0
--HIT SAGE
SELECT COUNT(1), SUM(movement_quantity) FROM slam.scheme.stkhstm WITH(NOLOCK) WHERE	movement_date = '2017-01-12 00:00:00.000' AND	transaction_type = 'BINT' AND	to_bin_number = @BRA


SELECT m.*, s.physical_qty FROM MRPStockRequirements m
INNER  JOIN		slam.scheme.stockm s
ON				m.SageProductCode = s.product
WHERE	SageProductCode NOT in
(SELECT DISTINCT product FROM slam.scheme.stkhstm WITH(NOLOCK) WHERE	movement_date = '2017-01-12 00:00:00.000' AND	transaction_type = 'BINT')
AND	ToBin = @BRA

return
SELECT m.* FROM MRPStockRequirements m
LEFT JOIN		slam.scheme.stockm s
ON				m.SageProductCode = s.product
WHERE		ToBin = @BRA
--AND			physical_qty = 0



SELECT m.* FROM MRPStockRequirements m
INNER JOIN		slam.scheme.stockm s
ON				m.SageProductCode = s.product
WHERE		ToBin = @BRA
AND			physical_qty > 0


SELECT m.* FROM MRPStockRequirements m
LEFT JOIN		slam.scheme.stockm s
ON				m.SageProductCode = s.product
WHERE		ToBin = @BRA
AND			m.QtyToOrder = 10
