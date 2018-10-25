SELECT MAX(r.resource_code) AS line, warehouse, product_code, works_order, wo.description, quantity_required, SUM(time_per_batchsize) As StandardRunTime,r.operator_code as operator_code FROM syslive.scheme.bmwohm wo WITH(NOLOCK) INNER JOIN syslive.scheme.wsroutdm r ON (wo.warehouse + wo.product_code = r.code) WHERE (works_order = 'JH85') group by  warehouse, product_code, works_order, wo.description, quantity_required, r.operator_code  order by StandardRunTime desc