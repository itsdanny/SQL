CREATE TABLE	#ProdOrders(
				order_no char(10) NULL,
				warehouse char(2) NULL,
				product char(20) NULL,
				description char(20) NULL,
				long_description char(40) NULL,
				unit_code char(10) NULL,
				shelf_life float NULL,
				economic_reorder_q float NULL,
				Order_Qty INT NULL,
				physical_qty float NULL,
				component_whouse char(2) NULL,
				component_code char(20) NULL,
				works_order char(10) NULL,
				quantity_required float NULL,
				date_required datetime NULL,
				due_date datetime NULL,
				Rel char(1) NULL,
				quantity_finished float NULL)

INSERT INTO #ProdOrders(warehouse, product, description, long_description, unit_code, shelf_life, economic_reorder_q)
SELECT		warehouse, product, description, long_description, unit_code, shelf_life, economic_reorder_q from scheme.stockm where (scheme.stockm.analysis_a LIKE 'HS09%') 

INSERT INTO #ProdOrders(warehouse, product, description, long_description, unit_code, shelf_life, economic_reorder_q, order_no, Order_Qty, date_required)
SELECT		p.warehouse, p.product, p.description, p.long_description, p.unit_code, p.shelf_life, p.economic_reorder_q, oh.order_no, SUM(od.order_qty), oh.date_required
FROM		#ProdOrders p
INNER JOIN	scheme.opdetm od WITH (NOLOCK) 
ON			od.warehouse = p.warehouse 
AND			od.product = p.product 
INNER JOIN	scheme.opheadm oh WITH (NOLOCK) 
ON			oh.order_no = od.order_no 
WHERE		(od.description LIKE 'HED%') 
AND			(oh.date_required > GETDATE() - 30) 
GROUP BY	p.product, p.warehouse, p.description, p.long_description, p.unit_code, p.shelf_life, p.economic_reorder_q, oh.order_no,  oh.date_required

INSERT INTO #ProdOrders(warehouse, product, description, long_description, unit_code, shelf_life, economic_reorder_q,  order_no, Order_Qty, date_required, component_whouse, component_code, works_order, quantity_finished, due_date, Rel)
SELECT		p.warehouse, p.product, p.description, p.long_description, p.unit_code, p.shelf_life, p.economic_reorder_q, p.order_no, p.Order_Qty, p.date_required, d.component_whouse, 
			d.component_code, 
			b.works_order, 
			b.quantity_required, 			
			b.due_date, 
			ISNULL((SELECT TOP (1) passed_inspection
			FROM      scheme.stquem WITH (NOLOCK)
			WHERE    (product = p.product) 
			AND (warehouse = p.warehouse) 
			AND (quantity > 0) 
			AND (source_code = b.works_order)), 'N') AS Rel
FROM		scheme.bmassdm d WITH (NOLOCK) 
INNER JOIN	#ProdOrders p
ON			p.warehouse = d.assembly_warehouse 
AND			p.product = d.product_code 
RIGHT JOIN	scheme.stockm AS stockm_1 WITH (NOLOCK) 
ON			d.component_whouse = stockm_1.warehouse 
AND			d.component_code = stockm_1.product 
INNER JOIN	scheme.bmwohm b WITH (NOLOCK) 
ON			p.order_no = b.sales_order
AND			(stockm_1.analysis_a IN ('LABEL', 'CARTON', 'LEAFLET')) 
AND			(stockm_1.analysis_c <> 'REORDER')


SELECT * into #Res
FROM		#ProdOrders 
WHERE		order_no IS NULL

SELECT * 
FROM		#ProdOrders 
WHERE		order_no IS NOT NULL --AND works_order IS NULL
and			product  IN (SELECT product FROM #Res)

SELECT	DISTINCT * 
FROM		#ProdOrders 
WHERE		order_no IS NOT NULL AND works_order IS NOT NULL

SELECT		MAX(warehouse) AS warehouse, MAX(product) AS product, MAX(description) AS description, 
			MAX(long_description) AS long_description, MAX(unit_code) AS unit_code, MAX(shelf_life) AS shelf_life, 
			MAX(economic_reorder_q) AS economic_reorder_q, MAX(component_whouse) AS component_whouse, 
			MAX(component_code) AS component_code, MAX(works_order) AS works_order, 
			SUM(quantity_finished) AS quantity_finished, MAX(due_date) AS due_date, MAX(Rel) AS Rel
FROM		#ProdOrders
group by	warehouse, product, description, long_description, component_whouse, component_code, works_order


drop TABLE	#ProdOrders