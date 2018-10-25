
-- UPDATE TO HAVE CURRENT STOCK LEVEL	
BEGIN TRAN
	update		a
	SET			a.physical_qty = (select coalesce(sum(c.QTY_ON_HAND), 0)
	FROM		UDGFlexitolStock c
	WHERE		c.SKU_ID = b.SKUID)
	FROM		syslive.scheme.stockm a
	INNER JOIN	UDGTRProducts b	
	ON			a.product = b.ProductCode
	WHERE		a.warehouse = 'FG'
ROLLBACK