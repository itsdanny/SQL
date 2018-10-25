-- GETS THE BKS
SELECT  * FROM scheme.bmassdm WHERE (product_code = '100608')
SELECT  * FROM scheme.bmassdm WHERE (component_whouse = 'IG') AND (component_code = '100608')
SELECT assembly_warehouse, product_code, usage_quantity, component_unit FROM scheme.bmassdm WHERE (component_whouse = 'IG') AND (component_code = '100608')
SELECT sum(usage_quantity) as usage_quantity FROM scheme.bmassdm WHERE (component_whouse = 'IG') AND (component_code = '100608')

SELECT assembly_warehouse, product_code, usage_quantity, component_unit FROM scheme.bmassdm WHERE (component_whouse = 'BK') AND (component_code = '128626')
SELECT assembly_warehouse, product_code, usage_quantity, component_unit FROM scheme.bmassdm WHERE (component_whouse = 'BK') AND (component_code = '119147')
SELECT assembly_warehouse, product_code, usage_quantity, component_unit FROM scheme.bmassdm WHERE (component_whouse = 'BK') AND (component_code = '129134')

select * from scheme.bmassdm where product_code = '007862'
select * from scheme.bmassdm where product_code = '128626'

              
SELECT * FROM scheme.mrmrprm where product = '100608'

SELECT sum(quantity_required)  FROM scheme.mrmrprm where product = '100608'

select * from scheme.mrmrprm where product = '100608' and date_required between '2015-01-01 00:00:00' and '2016-01-01 00:00:00' and supplier <> ''

SELECT ISNULL(SUM(scheme.mrmrprm.quantity_required), 0)* 0.2733 AS Total FROM scheme.stockm INNER JOIN scheme.mrmrprm  ON scheme.stockm.warehouse = scheme.mrmrprm.warehouse  AND scheme.stockm.product = scheme.mrmrprm.product  WHERE (stockm.warehouse = 'FG') AND (NOT(lower(analysis_a) = 'zzzz'))  AND scheme.mrmrprm.kind = 'W' AND (stockm.product = '007862')   AND (date_required BETWEEN '21 January 2015' AND '22 January 2016')
union
SELECT ISNULL(SUM(scheme.mrmrprm.quantity_required), 0) * 0.2733 AS Total FROM scheme.stockm INNER JOIN scheme.mrmrprm  ON scheme.stockm.warehouse = scheme.mrmrprm.warehouse  AND scheme.stockm.product = scheme.mrmrprm.product  WHERE (stockm.warehouse = 'FG') AND (NOT(lower(analysis_a) = 'zzzz'))  AND scheme.mrmrprm.kind = 'W' AND (stockm.product = '044172')   AND (date_required BETWEEN '21 January 2015' AND '22 January 2016')
union
SELECT ISNULL(SUM(scheme.mrmrprm.quantity_required), 0) * 0.2733 as Total FROM scheme.stockm INNER JOIN scheme.mrmrprm  ON scheme.stockm.warehouse = scheme.mrmrprm.warehouse  AND scheme.stockm.product = scheme.mrmrprm.product  WHERE (stockm.warehouse = 'FG') AND (NOT(lower(analysis_a) = 'zzzz'))  AND scheme.mrmrprm.kind = 'W' AND (stockm.product = '044180')   AND (date_required BETWEEN '21 January 2015' AND '22 January 2016')
union
SELECT ISNULL(SUM(scheme.mrmrprm.quantity_required), 0) *0.2733 as Total FROM scheme.stockm INNER JOIN scheme.mrmrprm  ON scheme.stockm.warehouse = scheme.mrmrprm.warehouse  AND scheme.stockm.product = scheme.mrmrprm.product  WHERE (stockm.warehouse = 'FG') AND (NOT(lower(analysis_a) = 'zzzz'))  AND scheme.mrmrprm.kind = 'W' AND (stockm.product = '044482')   AND (date_required BETWEEN '21 January 2015' AND '22 January 2016') 	
union
SELECT ISNULL(SUM(scheme.mrmrprm.quantity_required), 0) *0.2733 as Total FROM scheme.stockm INNER JOIN scheme.mrmrprm  ON scheme.stockm.warehouse = scheme.mrmrprm.warehouse  AND scheme.stockm.product = scheme.mrmrprm.product  WHERE (stockm.warehouse = 'FG') AND (NOT(lower(analysis_a) = 'zzzz'))  AND scheme.mrmrprm.kind = 'W' AND (stockm.product = '001201')   AND (date_required BETWEEN '21 January 2015' AND '22 January 2016') 	
union
SELECT ISNULL(SUM(scheme.mrmrprm.quantity_required), 0) *0.2733 as Total FROM scheme.stockm INNER JOIN scheme.mrmrprm  ON scheme.stockm.warehouse = scheme.mrmrprm.warehouse  AND scheme.stockm.product = scheme.mrmrprm.product  WHERE (stockm.warehouse = 'FG') AND (NOT(lower(analysis_a) = 'zzzz'))  AND scheme.mrmrprm.kind = 'W' AND (stockm.product = '001406')   AND (date_required BETWEEN '21 January 2015' AND '22 January 2016') 	
union
SELECT ISNULL(SUM(scheme.mrmrprm.quantity_required), 0) *0.2733 as Total FROM scheme.stockm INNER JOIN scheme.mrmrprm  ON scheme.stockm.warehouse = scheme.mrmrprm.warehouse  AND scheme.stockm.product = scheme.mrmrprm.product  WHERE (stockm.warehouse = 'FG') AND (NOT(lower(analysis_a) = 'zzzz'))  AND scheme.mrmrprm.kind = 'W' AND (stockm.product = '001473')   AND (date_required BETWEEN '21 January 2015' AND '22 January 2016') 	
union
SELECT ISNULL(SUM(scheme.mrmrprm.quantity_required), 0) *0.2733 as Total FROM scheme.stockm INNER JOIN scheme.mrmrprm  ON scheme.stockm.warehouse = scheme.mrmrprm.warehouse  AND scheme.stockm.product = scheme.mrmrprm.product  WHERE (stockm.warehouse = 'FG') AND (NOT(lower(analysis_a) = 'zzzz'))  AND scheme.mrmrprm.kind = 'W' AND (stockm.product = '001546')   AND (date_required BETWEEN '21 January 2015' AND '22 January 2016') 	
union
SELECT ISNULL(SUM(scheme.mrmrprm.quantity_required), 0) *0.2733 as Total FROM scheme.stockm INNER JOIN scheme.mrmrprm  ON scheme.stockm.warehouse = scheme.mrmrprm.warehouse  AND scheme.stockm.product = scheme.mrmrprm.product  WHERE (stockm.warehouse = 'FG') AND (NOT(lower(analysis_a) = 'zzzz'))  AND scheme.mrmrprm.kind = 'W' AND (stockm.product = '001910')   AND (date_required BETWEEN '21 January 2015' AND '22 January 2016') 	
union
SELECT ISNULL(SUM(scheme.mrmrprm.quantity_required), 0) *0.2733 as Total FROM scheme.stockm INNER JOIN scheme.mrmrprm  ON scheme.stockm.warehouse = scheme.mrmrprm.warehouse  AND scheme.stockm.product = scheme.mrmrprm.product  WHERE (stockm.warehouse = 'FG') AND (NOT(lower(analysis_a) = 'zzzz'))  AND scheme.mrmrprm.kind = 'W' AND (stockm.product = '044377')   AND (date_required BETWEEN '21 January 2015' AND '22 January 2016') 	
union
SELECT ISNULL(SUM(scheme.mrmrprm.quantity_required), 0) *0.2733 as Total FROM scheme.stockm INNER JOIN scheme.mrmrprm  ON scheme.stockm.warehouse = scheme.mrmrprm.warehouse  AND scheme.stockm.product = scheme.mrmrprm.product  WHERE (stockm.warehouse = 'FG') AND (NOT(lower(analysis_a) = 'zzzz'))  AND scheme.mrmrprm.kind = 'W' AND (stockm.product = '044369')   AND (date_required BETWEEN '21 January 2015' AND '22 January 2016') 	
union
SELECT ISNULL(SUM(scheme.mrmrprm.quantity_required), 0) *0.2733 as Total FROM scheme.stockm INNER JOIN scheme.mrmrprm  ON scheme.stockm.warehouse = scheme.mrmrprm.warehouse  AND scheme.stockm.product = scheme.mrmrprm.product  WHERE (stockm.warehouse = 'FG') AND (NOT(lower(analysis_a) = 'zzzz'))  AND scheme.mrmrprm.kind = 'W' AND (stockm.product = '044350')   AND (date_required BETWEEN '21 January 2015' AND '22 January 2016') 	
union
SELECT ISNULL(SUM(scheme.mrmrprm.quantity_required), 0) *0.2733 as Total FROM scheme.stockm INNER JOIN scheme.mrmrprm  ON scheme.stockm.warehouse = scheme.mrmrprm.warehouse  AND scheme.stockm.product = scheme.mrmrprm.product  WHERE (stockm.warehouse = 'FG') AND (NOT(lower(analysis_a) = 'zzzz'))  AND scheme.mrmrprm.kind = 'W' AND (stockm.product = '061514')   AND (date_required BETWEEN '21 January 2015' AND '22 January 2016') 	
union
SELECT ISNULL(SUM(scheme.mrmrprm.quantity_required), 0) *0.2733 as Total FROM scheme.stockm INNER JOIN scheme.mrmrprm  ON scheme.stockm.warehouse = scheme.mrmrprm.warehouse  AND scheme.stockm.product = scheme.mrmrprm.product  WHERE (stockm.warehouse = 'FG') AND (NOT(lower(analysis_a) = 'zzzz'))  AND scheme.mrmrprm.kind = 'W' AND (stockm.product = '061522')   AND (date_required BETWEEN '21 January 2015' AND '22 January 2016')




SELECT ISNULL(SUM(scheme.mrmrprm.quantity_required), 0) AS Total FROM scheme.stockm INNER JOIN scheme.mrmrprm  ON scheme.stockm.warehouse = scheme.mrmrprm.warehouse  AND scheme.stockm.product = scheme.mrmrprm.product  WHERE (stockm.warehouse = 'FG') AND (NOT(lower(analysis_a) = 'zzzz'))  AND scheme.mrmrprm.kind = 'W' AND (stockm.product = '007862')   AND (date_required BETWEEN '21 January 2015' AND '22 January 2016')
union
SELECT ISNULL(SUM(scheme.mrmrprm.quantity_required), 0)  AS Total FROM scheme.stockm INNER JOIN scheme.mrmrprm  ON scheme.stockm.warehouse = scheme.mrmrprm.warehouse  AND scheme.stockm.product = scheme.mrmrprm.product  WHERE (stockm.warehouse = 'FG') AND (NOT(lower(analysis_a) = 'zzzz'))  AND scheme.mrmrprm.kind = 'W' AND (stockm.product = '044172')   AND (date_required BETWEEN '21 January 2015' AND '22 January 2016')
union
SELECT ISNULL(SUM(scheme.mrmrprm.quantity_required), 0)  as Total FROM scheme.stockm INNER JOIN scheme.mrmrprm  ON scheme.stockm.warehouse = scheme.mrmrprm.warehouse  AND scheme.stockm.product = scheme.mrmrprm.product  WHERE (stockm.warehouse = 'FG') AND (NOT(lower(analysis_a) = 'zzzz'))  AND scheme.mrmrprm.kind = 'W' AND (stockm.product = '044180')   AND (date_required BETWEEN '21 January 2015' AND '22 January 2016')
union
SELECT ISNULL(SUM(scheme.mrmrprm.quantity_required), 0)  as Total FROM scheme.stockm INNER JOIN scheme.mrmrprm  ON scheme.stockm.warehouse = scheme.mrmrprm.warehouse  AND scheme.stockm.product = scheme.mrmrprm.product  WHERE (stockm.warehouse = 'FG') AND (NOT(lower(analysis_a) = 'zzzz'))  AND scheme.mrmrprm.kind = 'W' AND (stockm.product = '044482')   AND (date_required BETWEEN '21 January 2015' AND '22 January 2016') 	
union
SELECT ISNULL(SUM(scheme.mrmrprm.quantity_required), 0)  as Total FROM scheme.stockm INNER JOIN scheme.mrmrprm  ON scheme.stockm.warehouse = scheme.mrmrprm.warehouse  AND scheme.stockm.product = scheme.mrmrprm.product  WHERE (stockm.warehouse = 'FG') AND (NOT(lower(analysis_a) = 'zzzz'))  AND scheme.mrmrprm.kind = 'W' AND (stockm.product = '001201')   AND (date_required BETWEEN '21 January 2015' AND '22 January 2016') 	
union
SELECT ISNULL(SUM(scheme.mrmrprm.quantity_required), 0)  as Total FROM scheme.stockm INNER JOIN scheme.mrmrprm  ON scheme.stockm.warehouse = scheme.mrmrprm.warehouse  AND scheme.stockm.product = scheme.mrmrprm.product  WHERE (stockm.warehouse = 'FG') AND (NOT(lower(analysis_a) = 'zzzz'))  AND scheme.mrmrprm.kind = 'W' AND (stockm.product = '001406')   AND (date_required BETWEEN '21 January 2015' AND '22 January 2016') 	
union
SELECT ISNULL(SUM(scheme.mrmrprm.quantity_required), 0)  as Total FROM scheme.stockm INNER JOIN scheme.mrmrprm  ON scheme.stockm.warehouse = scheme.mrmrprm.warehouse  AND scheme.stockm.product = scheme.mrmrprm.product  WHERE (stockm.warehouse = 'FG') AND (NOT(lower(analysis_a) = 'zzzz'))  AND scheme.mrmrprm.kind = 'W' AND (stockm.product = '001473')   AND (date_required BETWEEN '21 January 2015' AND '22 January 2016') 	
union
SELECT ISNULL(SUM(scheme.mrmrprm.quantity_required), 0)  as Total FROM scheme.stockm INNER JOIN scheme.mrmrprm  ON scheme.stockm.warehouse = scheme.mrmrprm.warehouse  AND scheme.stockm.product = scheme.mrmrprm.product  WHERE (stockm.warehouse = 'FG') AND (NOT(lower(analysis_a) = 'zzzz'))  AND scheme.mrmrprm.kind = 'W' AND (stockm.product = '001546')   AND (date_required BETWEEN '21 January 2015' AND '22 January 2016') 	
union
SELECT ISNULL(SUM(scheme.mrmrprm.quantity_required), 0)  as Total FROM scheme.stockm INNER JOIN scheme.mrmrprm  ON scheme.stockm.warehouse = scheme.mrmrprm.warehouse  AND scheme.stockm.product = scheme.mrmrprm.product  WHERE (stockm.warehouse = 'FG') AND (NOT(lower(analysis_a) = 'zzzz'))  AND scheme.mrmrprm.kind = 'W' AND (stockm.product = '001910')   AND (date_required BETWEEN '21 January 2015' AND '22 January 2016') 	
union
SELECT ISNULL(SUM(scheme.mrmrprm.quantity_required), 0)  as Total FROM scheme.stockm INNER JOIN scheme.mrmrprm  ON scheme.stockm.warehouse = scheme.mrmrprm.warehouse  AND scheme.stockm.product = scheme.mrmrprm.product  WHERE (stockm.warehouse = 'FG') AND (NOT(lower(analysis_a) = 'zzzz'))  AND scheme.mrmrprm.kind = 'W' AND (stockm.product = '044377')   AND (date_required BETWEEN '21 January 2015' AND '22 January 2016') 	
union
SELECT ISNULL(SUM(scheme.mrmrprm.quantity_required), 0)  as Total FROM scheme.stockm INNER JOIN scheme.mrmrprm  ON scheme.stockm.warehouse = scheme.mrmrprm.warehouse  AND scheme.stockm.product = scheme.mrmrprm.product  WHERE (stockm.warehouse = 'FG') AND (NOT(lower(analysis_a) = 'zzzz'))  AND scheme.mrmrprm.kind = 'W' AND (stockm.product = '044369')   AND (date_required BETWEEN '21 January 2015' AND '22 January 2016') 	
union
SELECT ISNULL(SUM(scheme.mrmrprm.quantity_required), 0)  as Total FROM scheme.stockm INNER JOIN scheme.mrmrprm  ON scheme.stockm.warehouse = scheme.mrmrprm.warehouse  AND scheme.stockm.product = scheme.mrmrprm.product  WHERE (stockm.warehouse = 'FG') AND (NOT(lower(analysis_a) = 'zzzz'))  AND scheme.mrmrprm.kind = 'W' AND (stockm.product = '044350')   AND (date_required BETWEEN '21 January 2015' AND '22 January 2016') 	
union
SELECT ISNULL(SUM(scheme.mrmrprm.quantity_required), 0)  as Total FROM scheme.stockm INNER JOIN scheme.mrmrprm  ON scheme.stockm.warehouse = scheme.mrmrprm.warehouse  AND scheme.stockm.product = scheme.mrmrprm.product  WHERE (stockm.warehouse = 'FG') AND (NOT(lower(analysis_a) = 'zzzz'))  AND scheme.mrmrprm.kind = 'W' AND (stockm.product = '061514')   AND (date_required BETWEEN '21 January 2015' AND '22 January 2016') 	
union
SELECT ISNULL(SUM(scheme.mrmrprm.quantity_required), 0)  as Total FROM scheme.stockm INNER JOIN scheme.mrmrprm  ON scheme.stockm.warehouse = scheme.mrmrprm.warehouse  AND scheme.stockm.product = scheme.mrmrprm.product  WHERE (stockm.warehouse = 'FG') AND (NOT(lower(analysis_a) = 'zzzz'))  AND scheme.mrmrprm.kind = 'W' AND (stockm.product = '061522')   AND (date_required BETWEEN '21 January 2015' AND '22 January 2016')






sp_rpt_supplier_recs_by_product_12MONTHS