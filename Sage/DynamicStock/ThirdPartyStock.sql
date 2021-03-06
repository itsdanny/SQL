use syslive

select *
FROM		scheme.stockm a
INNER JOIN	SafetyStockExclude b
ON			a.product = b.Product
WHERE		a.warehouse = 'FG'

UPDATE		a 
SET			dspare02 = 1
FROM		scheme.stockm a
INNER JOIN	SafetyStockExclude b
ON			a.product = b.Product
WHERE		a.warehouse = 'FG'

-- GET TPTY
SELECT	warehouse, 
		LTRIM(RTRIM(product)) AS product, 
		abc_category, 
		economic_reorder_q, 
		safety_days, 
		ISNULL((SELECT	reorder_days
				FROM    scheme.stockm
                WHERE	(warehouse = 'IG') 
				AND		(product = stockm_1.product)), 0) AS IGReorder, 
		shelf_life,
		lead_time
FROM    scheme.stockm AS stockm_1
WHERE   (analysis_a = 'TPTY') 
AND		(warehouse = 'FG') 
AND		 dspare02 = 0
--AND	(NOT(product IN (SELECT SafetyStockExclude.Product FROM SafetyStockExclude)))

-- GET NON TPTY
SELECT	warehouse, 
		product, 
		abc_category, 
		economic_reorder_q, 
		safety_days, 
		ISNULL((SELECT	reorder_days
                FROM	scheme.stockm
				WHERE   (warehouse = 'IG') 
				AND (product = stockm_1.product)), 0) AS IGReorder, 
		shelf_life, 
		lead_time
FROM    scheme.stockm AS stockm_1
WHERE   (NOT(analysis_a = 'TPTY')) 
AND		(warehouse = 'FG') 
AND		 dspare02 = 0
--AND		(NOT(product IN (SELECT SafetyStockExclude.Product FROM SafetyStockExclude)))

select * from scheme.stquem where warehouse = 'FG' ORDER BY prod_code, expiry_date_key

