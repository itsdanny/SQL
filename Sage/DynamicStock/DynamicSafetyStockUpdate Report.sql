SELECT      DynSafetyStockUpdate.warehouse, 
			DynSafetyStockUpdate.product, 
			DynSafetyStockUpdate.safety_stock_level, 
			DynSafetyStockUpdate.maximum_stock_leve, 
			DynSafetyStockUpdate.min_stock_level, 
			DynSafetyStockUpdate.new_safety_stock_level, 
			DynSafetyStockUpdate.new_maximum_stock_leve, 
			DynSafetyStockUpdate.new_min_stock_level, 
			scheme.stockm.analysis_a, 
			scheme.stockm.long_description,
			scheme.stockm.abc_category
FROM        DynSafetyStockUpdate 
INNER JOIN  scheme.stockm 
ON          DynSafetyStockUpdate.warehouse = scheme.stockm.warehouse 
AND         DynSafetyStockUpdate.product = scheme.stockm.product
WHERE       (NOT (DynSafetyStockUpdate.product 
IN			(SELECT Product FROM SafetyStockExclude)))  AND (NOT (scheme.stockm.analysis_a = 'ZZZZ'))


SELECT      DynSafetyStockUpdate.warehouse, 
			DynSafetyStockUpdate.product, 
			DynSafetyStockUpdate.safety_stock_level, 
			DynSafetyStockUpdate.maximum_stock_leve, 
			DynSafetyStockUpdate.min_stock_level, 
			DynSafetyStockUpdate.new_safety_stock_level, 
			DynSafetyStockUpdate.new_maximum_stock_leve, 
			DynSafetyStockUpdate.new_min_stock_level, 
			scheme.stockm.analysis_a, 
			scheme.stockm.long_description,
			scheme.stockm.abc_category
FROM        DynSafetyStockUpdate 
INNER JOIN  scheme.stockm 
ON          DynSafetyStockUpdate.warehouse = scheme.stockm.warehouse 
AND         DynSafetyStockUpdate.product = scheme.stockm.product
WHERE		scheme.stockm.dspare02 <> 1
AND			(NOT (scheme.stockm.analysis_a = 'ZZZZ'))
