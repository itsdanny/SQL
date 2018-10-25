SELECT      scheme.opheadm.order_no, scheme.opdetm.warehouse, scheme.opdetm.product, 
			scheme.stockm.description, scheme.stockm.long_description, 
            scheme.stockm.unit_code, scheme.stockm.shelf_life, scheme.stockm.economic_reorder_q, 
			SUM(scheme.opdetm.order_qty) AS Order_Qty, 
            scheme.stockm.physical_qty, scheme.bmassdm.component_whouse, 
			--scheme.bmassdm.component_code, 
			scheme.bmwohm.works_order, 
            scheme.bmwohm.quantity_required, scheme.opheadm.date_required, scheme.bmwohm.due_date, ISNULL
                ((SELECT        TOP (1) passed_inspection
                    FROM            scheme.stquem WITH (NOLOCK)
                    WHERE        (product = scheme.opdetm.product) 
					AND (warehouse = scheme.opdetm.warehouse) 
					AND (quantity > 0) 
					AND (source_code = scheme.bmwohm.works_order)), 'N') AS Rel, 
			scheme.bmwohm.quantity_finished			
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
WHERE       (scheme.opdetm.description LIKE 'HED%') 
AND			(scheme.stockm.analysis_a LIKE 'HS09%') 
AND			(scheme.opheadm.date_required > GETDATE() - 30) 
AND			(stockm_1.analysis_a IN ('LABEL', 'CARTON', 'LEAFLET')) 
AND			(stockm_1.analysis_c <> 'REORDER')
AND			(scheme.opheadm.status <> 9)
AND			scheme.stockm.product = '058130'
GROUP BY	scheme.opheadm.order_no, scheme.opdetm.warehouse, scheme.opdetm.product, scheme.stockm.description, scheme.stockm.long_description, 
            scheme.stockm.unit_code, scheme.stockm.shelf_life, scheme.stockm.economic_reorder_q, scheme.stockm.physical_qty, scheme.bmwohm.works_order, 
            scheme.bmassdm.component_whouse, 
			--scheme.bmassdm.component_code, 
			scheme.bmwohm.quantity_required, scheme.opheadm.date_required, 
            scheme.bmwohm.due_date, scheme.bmwohm.quantity_finished
HAVING		SUM(scheme.opdetm.despatched_qty) = 0
