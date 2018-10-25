/*
select distinct LOCK_STATUS, QC_STATUS, LOCK_CODE, * from imp_UDGFlexitolStock
select * from [Log]
SELECT TOP 5 * FROM syslive.scheme.stockm where warehouse = 'FG' AND product = '076309' AND physical_qty > 0
SELECT * FROM syslive.scheme.stquem where warehouse = 'FG' AND product = '076007' --and quantity > 0
SELECT * FROM syslive.scheme.stqueam where warehouse = 'FG' AND product = '076007' 
SELECT * FROM syslive.scheme.stquem where warehouse = 'FG' AND batch_number ='10000000'
SELECT * FROM syslive.scheme.stqueam where  pallet_number in ('U3382652','U3619602')

SELECT * 
FROM		syslive.scheme.stqueam a
INNER JOIN	imp_UDGFlexitolStock2 b
ON			a.product = b.ProductCode
WHERE		a.warehouse = 'FG'

truncate table  imp_UDGFlexitolStock2

truncate table imp_MissingBatches
DBCC CHECKIDENT (imp_MissingBatches, reseed, 1)

SELECT SUM(QTY_ON_HAND), BATCH_ID, LOCK_CODE, LOCK_STATUS FROM imp_UDGFlexitolStock WHERE ProductCode = '076201'
group by BATCH_ID,LOCK_CODE, LOCK_STATUS ,TAG_ID
select distinct LOCK_STATUS, QC_STATUS, LOCK_CODE from NULL WHERE sequence_number ='QC9l$!'
select * from imp_status_bins


SELECT
-- INTO STQUEM 

/**/*/
SELECT		MAX(b.Product) AS Product, 
			MAX(b.ExpiryDate) as ExDate, 
			MAX(b.Inspected) AS Inspected, 
			MAX(b.LotNumber) as Batch,
			MAX(b.LotNumber) as PalletID,
			MAX(b.Qty) as Qty,
			MAX(b.Reason) as Reason
FROM		imp_MissingBatches b
left  JOIN	imp_UDGFlexitolStock a
ON			b.LotNumber = a.BATCH_ID
group by	a.ProductCode, b.LotNumber
UPDATE imp_MissingBatches SET Product = '0'+Product

SELECT * FROM imp_MissingBatches


--DBCC CHECKIDENT (imp_UDGFlexitolStock2, reseed, 1)
*/
/*
	SELECT	 top 10000 ROW_NUMBER() OVER(ORDER BY sequence_number asc) AS row_num,  
			sequence_number into #tmp
	FROM	syslive.scheme.stqueam where warehouse ='FG'
	GROUP BY sequence_number 
	

	update		i
	SET			i.sequence_number = t.sequence_number
	FROM		imp_MissingBatches i
	INNER JOIN	#tmp t
	ON			i.Id = t.row_num
	DROP TABLE #tmp
	*/
	--select * from imp_StockAdjustments 
	--select * from [dbo].[imp_UDGFlexitolStock]

	--SELECT		distinct top 11  ltrim(rtrim(a.product))--, QTY_ON_HAND, BATCH_ID, c.*
	--FROM		syslive.scheme.stockm a
	--INNER JOIN	Integrate.dbo.imp_UDGTRProducts b
	--ON			a.product = b.ProductCode
	--INNER JOIN	Integrate.dbo.imp_UDGFlexitolStock c
	--ON			c.SKU_ID = b.SKUID

	select * from imp_MissingBatches
	select * from imp_status_bins

BEGIN TRAN
	INSERT INTO syslive.scheme.stquem(warehouse, product, sequence_number, prod_code, serial_number, batch_number, date_received, bin_number, lot_number, [expiry_date], passed_inspection, inspector_code, inspection_date, source_code, conformity_ref, quantity, quantity_free, unit_cost, labour_cost, overhead_cost, sub_contract_cost, concentration, users_field_1, users_field_2, users_field_3, users_text_field, spare, expiry_date_key, sellby_date_key, best_date_key, sell_by_date, best_before_date)
	SELECT		'FG' AS warehouse,
				a.product, 
				c.sequence_number AS sequence_number,  
				a.product AS prod_code,
				'' AS serial_number, 
				c.LotNumber AS batch_number,
				DATEADD(YEAR, -3, c.ExpiryDate) AS date_received, 
				COALESCE(b.UDGBINLocation, 'UDG01') AS bin_number,
				c.LotNumber AS lot_number, 			
				c.ExpiryDate AS [expiry_date], 			
				'Y' AS passed_inspection,
				'UDG' AS inspector_code,
				DATEADD(YEAR, -3, c.ExpiryDate) AS inspected_date, 
				'UDG' AS source_code,			
				'' AS conformity_ref,
				0 AS quantity,
				0 AS quantity_free,			
				0 AS unit_cost,
				0 AS labour_cost,
				0 AS overhead_cost,
				0 AS sub_contract_cost,
				0 AS concentration_cost,
				0 AS users_field_1,
				0 AS users_field_2,
				0 AS users_field_3,
				0 AS users_text_field,
				'' AS spare,
				'FG' + a.product + '	' AS expiry_date_key,
				'FG' + a.product + '	' AS sellby_date_key,
				'FG' + a.product + '	' AS best_date_key,			
				c.ExpiryDate AS sell_by_date, 
				c.ExpiryDate AS best_before_date
	FROM		syslive.scheme.stockm a
	INNER JOIN	Integrate.dbo.imp_MissingBatches c
	ON			a.product = c.Product
	INNER JOIN	syslive.scheme.stunitdm u
	ON			a.unit_code = u.unit_code
	LEFT JOIN	imp_status_bins b
	ON			c.Reason = b.Stock_Status
	WHERE		a.warehouse = 'FG'	
	GROUP BY	a.product, c.ExpiryDate, c.LotNumber, b.Stock_Status, sequence_number, UDGBINLocation
ROLLBACK

BEGIN TRAN
---- INTO STQUEAM
	INSERT INTO syslive.[scheme].[stqueam](warehouse, product, sequence_number, lot_number2, pallet_number, status_code, stock_held_flag, held_reason_code)
	SELECT		 'FG' AS warehouse,
				a.product, 
				sequence_number AS sequence_number,  
				'UDG01' AS lot_number2, 
				c.LotNumber,
				'' AS status_code,
				CASE WHEN b.Stock_Status IS NULL THEN '' ELSE 'y' END AS stock_held_flag, 
				CASE WHEN b.Stock_Status IS NULL THEN '' ELSE b.Stock_Status END AS held_reason_code
	FROM		syslive.scheme.stockm a
	INNER JOIN	Integrate.dbo.imp_MissingBatches c
	ON			a.product = c.Product
	INNER JOIN	syslive.scheme.stunitdm u
	ON			a.unit_code = u.unit_code
	LEFT JOIN	imp_status_bins b
	ON			c.Reason = b.Stock_Status
	WHERE		a.warehouse = 'FG'	
	GROUP BY	a.product, b.Stock_Status, c.LotNumber, sequence_number
ROLLBACK


