alter procedure rpt_ProductOrders
as

SELECT      scheme.opdetm.product, scheme.opheadm.order_no, scheme.opdetm.warehouse, scheme.stockm.description, scheme.stockm.long_description, 
            scheme.stockm.unit_code, (scheme.stockm.shelf_life/365) AS shelf_life, scheme.stockm.economic_reorder_q, SUM(scheme.opdetm.order_qty) AS Order_Qty, 
            scheme.stockm.physical_qty, scheme.bmassdm.component_whouse, scheme.bmassdm.component_code, scheme.bmwohm.works_order, 
             scheme.bmwohm.due_date, scheme.bmwohm.quantity_required, scheme.opheadm.date_required,
			 ISNULL((SELECT   TOP (1) passed_inspection
					FROM      scheme.stquem WITH (NOLOCK)
					WHERE     (product = scheme.opdetm.product) 
					AND (warehouse = scheme.opdetm.warehouse) 
					AND (quantity > 0) 
					AND (source_code = scheme.bmwohm.works_order)), 'N') AS Rel, 
			scheme.bmwohm.quantity_finished into #tmp			
FROM        scheme.opdetm WITH (NOLOCK) 
INNER JOIN	scheme.stockm WITH (NOLOCK) 
ON			scheme.opdetm.warehouse = scheme.stockm.warehouse 
AND         scheme.opdetm.product = scheme.stockm.product 
INNER JOIN  scheme.opheadm WITH (NOLOCK) 
ON			scheme.opdetm.order_no = scheme.opheadm.order_no 
INNER JOIN	scheme.bmassdm WITH (NOLOCK) 
ON			scheme.stockm.warehouse = scheme.bmassdm.assembly_warehouse 
AND			scheme.stockm.product = scheme.bmassdm.product_code 
INNER JOIN	scheme.stockm AS stockm_1 WITH (NOLOCK) 
ON			scheme.bmassdm.component_whouse = stockm_1.warehouse 
AND			scheme.bmassdm.component_code = stockm_1.product 
LEFT OUTER JOIN	scheme.bmwohm WITH (NOLOCK) 
ON			scheme.opheadm.order_no = scheme.bmwohm.sales_order
and			scheme.opdetm.warehouse = scheme.bmwohm.warehouse 
AND         scheme.opdetm.product = scheme.bmwohm.product_code
WHERE       (scheme.opdetm.description LIKE 'HED%') 
AND			(scheme.stockm.analysis_a LIKE 'HS09%') 
AND			(scheme.opheadm.date_required > GETDATE() - 30) 
AND			(stockm_1.analysis_a IN ('LABEL', 'CARTON', 'LEAFLET')) 
AND			(stockm_1.analysis_c <> 'REORDER')
AND			(scheme.opheadm.status <> 9)
--AND			(scheme.stockm.product IN ('058033','057576')
--OR			scheme.opheadm.order_no  in ('183158'))
GROUP BY	scheme.opheadm.order_no, scheme.opdetm.warehouse, scheme.opdetm.product, scheme.stockm.description, scheme.stockm.long_description, 
            scheme.stockm.unit_code, scheme.stockm.shelf_life, scheme.stockm.economic_reorder_q, scheme.stockm.physical_qty, scheme.bmwohm.works_order, 
            scheme.bmassdm.component_whouse, scheme.bmassdm.component_code, scheme.bmwohm.quantity_required, scheme.opheadm.date_required, 
            scheme.bmwohm.due_date, scheme.bmwohm.quantity_finished
HAVING		SUM(scheme.opdetm.despatched_qty) = 0
ORDER BY	scheme.opdetm.product

--SELECT * FROM  #tmp
--return

ALTER  TABLE #tmp
Add Id INT Identity(1,1)

DECLARE @cur_order varchar(10) = ''
DECLARE @next_order varchar(10) = ''
DECLARE @cur_worder varchar(10) = ''
DECLARE @next_worder varchar(10) = ''
DECLARE @Rows INT = (SELECT COUNT(1) FROM #tmp)
DECLARE @Iter INT = 1


WHILE @Iter <= @Rows
BEGIN
	set @next_worder = ''
	set @next_order = ''

	SELECT @next_order = order_no, @next_worder = coalesce(works_order, '') from #tmp where Id = @Iter-- and Order_Qty > 0 and physical_qty > 0
	
	--select @next_order, @next_worder 

	IF	@cur_worder <> @next_worder
	BEGIN	
		SET @cur_worder = @next_worder
	END
	
	IF	@cur_order <> @next_order
	BEGIN
		SET @cur_order = @next_order
	END	
	
	IF @cur_worder <> ''
	BEGIN
		UPDATE	#tmp 
		SET		Order_Qty = 0,
				quantity_required = 0,
				quantity_finished = 0,
				physical_qty = 0,
				Rel = '',
				works_order = ''
		WHERE	order_no = @cur_order 
		AND		works_order = @cur_worder	
		AND 	Id > @Iter
	END
	ELSE
	BEGIN
		UPDATE	#tmp 
		SET		Order_Qty = 0,
				quantity_required = 0,
				quantity_finished = 0,
				physical_qty = 0,
				Rel = '',
				works_order = ''
		WHERE	order_no = @cur_order 			
		AND 	Id > @Iter
	END
	SET @Iter = @Iter + 1
END

ALTER  TABLE #tmp
DROP COLUMN Id

SELECT		product, order_no, description, long_description, unit_code, shelf_life, economic_reorder_q, 
			component_whouse, component_code, works_order, due_date,  date_required, Rel,
			COALESCE(SUM(Order_Qty), 0) AS Order_Qty, 
			COALESCE(SUM(physical_qty), 0) AS physical_qty, 
			COALESCE(SUM(quantity_finished),0) AS quantity_finished, 
			COALESCE(SUM(quantity_required), 0) AS quantity_required
FROM		#tmp 
GROUP BY	product, order_no, description, long_description, unit_code, shelf_life, economic_reorder_q, component_whouse, component_code, works_order, due_date, date_required,Rel
ORDER BY	product, order_no desc, Order_Qty desc, works_order desc, COALESCE(SUM(quantity_required), 0) desc

GO

 rpt_ProductOrders              