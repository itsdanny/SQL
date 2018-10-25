/****** Script for SelectTopNRows command from SSMS  ******/

SELECT dspare02 FROM scheme.stockm WHERE dspare02 <> 0
  
SELECT * 
FROM	scheme.stockm a
WHERE	dspare02 <> 0

SELECT		* 
FROM		SafetyStockExclude

SELECT		* 
FROM		scheme.stockm a
INNER JOIN	SafetyStockExclude b
ON			a.product = b.Product
WHERE		a.warehouse ='FG'
AND			a.dspare02 = 1

UPDATE		a
SET			a.dspare02 = 1 
FROM		scheme.stockm a
INNER JOIN	SafetyStockExclude b
ON			a.product = b.Product
WHERE		a.warehouse ='FG'
AND			a.dspare02 = 0


SELECT     warehouse, LTRIM(RTRIM(product)) AS product, abc_category, economic_reorder_q, safety_days, ISNULL
                          ((SELECT     reorder_days
                              FROM         scheme.stockm
                              WHERE     (warehouse = 'IG') AND (product = stockm_1.product)), 0) AS IGReorder, shelf_life, lead_time
FROM         scheme.stockm AS stockm_1
WHERE     (analysis_a = 'TPTY') AND (warehouse = 'FG') AND (NOT(product IN (SELECT SafetyStockExclude.Product FROM SafetyStockExclude)))
ORDER	BY product

SELECT     warehouse, LTRIM(RTRIM(product)) AS product, abc_category, economic_reorder_q, safety_days, ISNULL
                          ((SELECT     reorder_days
                              FROM         scheme.stockm
                              WHERE     (warehouse = 'IG') AND (product = stockm_1.product)), 0) AS IGReorder, shelf_life, lead_time
FROM    scheme.stockm AS stockm_1
WHERE   (analysis_a = 'TPTY') 
AND		(warehouse = 'FG') 
AND		dspare02 <> 1
ORDER	BY product

/*
		
		******************************************************************************************************

*/

SELECT     warehouse, product, abc_category, economic_reorder_q, safety_days, ISNULL
                          ((SELECT     reorder_days
                              FROM         scheme.stockm
                              WHERE     (warehouse = 'IG') AND (product = stockm_1.product)), 0) AS IGReorder, shelf_life, lead_time
FROM         scheme.stockm AS stockm_1
WHERE    (NOT(analysis_a = 'TPTY')) AND (warehouse = 'FG') AND (NOT(product IN (SELECT SafetyStockExclude.Product FROM SafetyStockExclude)))
ORDER	BY product


SELECT     warehouse, product, abc_category, economic_reorder_q, safety_days, ISNULL
                          ((SELECT     reorder_days
                              FROM         scheme.stockm
                              WHERE     (warehouse = 'IG') AND (product = stockm_1.product)), 0) AS IGReorder, shelf_life, lead_time
FROM         scheme.stockm AS stockm_1
WHERE    (NOT(analysis_a = 'TPTY')) AND (warehouse = 'FG') 
AND		dspare02 <> 1
ORDER	BY product
