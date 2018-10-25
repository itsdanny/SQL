SELECT TOP 1 scheme.stockm.warehouse, scheme.stockm.product, scheme.stockm.long_description, scheme.stkhstm.dated, scheme.stkhstm.expiry_date, scheme.poheadm.order_no, scheme.poheadm.supplier, 
scheme.plsuppm.name, scheme.stockm.selling_unit, scheme.stkhstm.lot_number, scheme.stockm.drawing_number, scheme.stkhstm.movement_quantity,    
 (SELECT scheme.stockm.product     FROM scheme.stockm WITH (NOLOCK)    WHERE scheme.stockm.warehouse = 'IG' AND     scheme.stockm.product = 
	(SELECT TOP 1 con_ref                              FROM dbo.po_conf_ref WITH (NOLOCK)                             WHERE order_no = LEFT('035672A04', 6))) AS NewProductCode,     
	(SELECT scheme.stockm.drawing_number     FROM scheme.stockm  WITH (NOLOCK)    WHERE scheme.stockm.warehouse = 'IG' AND     scheme.stockm.product = 
	(SELECT TOP 1 con_ref                              FROM dbo.po_conf_ref WITH (NOLOCK)                             WHERE order_no = LEFT('035672A04', 6))) AS NewDrawingNumber  
	FROM scheme.stkhstm WITH (NOLOCK)
	 INNER JOIN scheme.stockm WITH (NOLOCK) 
	 ON scheme.stkhstm.warehouse = scheme.stockm.warehouse 
	 AND scheme.stkhstm.product = scheme.stockm.product 
	INNER JOIN scheme.poheadm WITH (NOLOCK) 
	ON SUBSTRING(scheme.stkhstm.comments, 0, 7) = scheme.poheadm.order_no 
	INNER JOIN scheme.plsuppm WITH (NOLOCK) ON scheme.poheadm.supplier = scheme.plsuppm.supplier WHERE (scheme.stkhstm.batch_number = 
	(SELECT TOP 1 scheme.stquem.batch_number                                 
	FROM scheme.stquem WITH (NOLOCK)                                
	WHERE scheme.stquem.bin_number = '98001' AND                                 
	scheme.stquem.lot_number = '035672A04' 
	ORDER BY scheme.stquem.batch_number DESC, scheme.stquem.prod_code ASC))
	 AND scheme.stkhstm.lot_number = '035672A04' AND (scheme.stkhstm.transaction_type = 'RECP')
	 
	 
	 update dbo.po_conf_ref set con_ref = '24602403' where order_no = LEFT('035672A04', 6)
	 
	 SELECT * FROM dbo.po_conf_ref where order_no = LEFT('035672A04', 6)