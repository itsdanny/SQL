
/* 		
SELECT	'FG'+LTRIM(RTRIM(a.product)), physical_qty
FROM	syslive.scheme.stockm a
WHERE	analysis_b ='FLEXITOL'
AND		a.warehouse = 'FG'

SELECT *
FROM		syslive.scheme.stquem 
WHERE		LTRIM(RTRIM(warehouse))+LTRIM(RTRIM(product)) IN(
			SELECT		'FG'+LTRIM(RTRIM(a.product))
			FROM		syslive.scheme.stockm a
			where		analysis_b ='FLEXITOL'
			and		a.warehouse = 'FG')

			
SELECT *
FROM		syslive.scheme.stqueam 
WHERE		LTRIM(RTRIM(warehouse))+LTRIM(RTRIM(product)) IN(
			SELECT		'FG'+LTRIM(RTRIM(a.product))
			FROM		syslive.scheme.stockm a
			where		analysis_b ='FLEXITOL'
			and		a.warehouse = 'FG')

UPDATE	syslive.scheme.stockm set physical_qty = 0 
WHERE	analysis_b ='FLEXITOL'
AND		warehouse = 'FG'

delete 
FROM		syslive.scheme.stquem 
WHERE		LTRIM(RTRIM(warehouse))+LTRIM(RTRIM(product)) IN(
			SELECT		'FG'+LTRIM(RTRIM(a.product))
			FROM		syslive.scheme.stockm a
			INNER JOIN	imp_UDGFlexitolStock2 c
			ON			a.product = c.ProductCode			
			WHERE		a.warehouse = 'FG')

delete
FROM		syslive.scheme.stqueam 
WHERE		warehouse+product IN(
SELECT		'FG'+a.product
FROM		syslive.scheme.stockm a
INNER JOIN	imp_UDGFlexitolStock2 c
ON			a.product = c.ProductCode
WHERE		a.warehouse = 'FG')
*/
SELECT		distinct c.*
FROM		syslive.scheme.stockm a
INNER JOIN	Integrate.dbo.imp_UDGTRProducts b
ON			a.product = b.ProductCode
INNER JOIN	Integrate.dbo.imp_UDGFlexitolStock c
ON			c.SKU_ID = b.SKUID
INNER JOIN	syslive.scheme.stunitdm u
ON			a.unit_code = u.unit_code
LEFT OUTER JOIN	Integrate.dbo.imp_status_bins i
ON			c.LOCK_CODE = i.UDGLockCode
WHERE		a.warehouse = 'FG'
AND			a.product ='076465'

select * from Integrate.dbo.imp_UDGFlexitolStock2
select ltrim(rtrim(ProductCode)), max(BATCH_ID) as batchID, LOCK_STATUS,LOCK_CODE, SUM(QTY_ON_HAND) from Integrate.dbo.imp_UDGFlexitolStock
group by ProductCode, LOCK_STATUS,LOCK_CODE
select
UPDATE	a
set a.quantity =  SUM(QTY_ON_HAND) 
 LTRIM(RTRIM(ProductCode)), MAX(BATCH_ID) as batchID, LOCK_STATUS, LOCK_CODE,
 FROM Integrate.dbo.imp_UDGFlexitolStock b
 inner join [dbo].[imp_StockAdjustments] a
group by ProductCode, LOCK_STATUS,LOCK_CODE
