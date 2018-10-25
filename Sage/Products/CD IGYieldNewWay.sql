--PITA  101108
-- NOT A PITA 100063, 100349, 100403, 105065
--select * from ContDrugsImport
use syslive
IF object_id('tempdb..#tmp') IS NOT NULL
	DROP TABLE #tmp
GO
IF object_id('tempdb..#bks') IS NOT NULL
	DROP TABLE #bks
GO
IF object_id('tempdb..#fgs') IS NOT NULL
	DROP TABLE #fgs	
GO
DECLARE @FromDate DATETIME = '2015-01-01'
SELECT		warehouse, product as IGProductCode, dated, movement_reference as WorkOrder, transaction_type, sum(movement_quantity) as Qty, comments
INTO		#tmp
FROM		scheme.stkhstm s WITH(NOLOCK) 
WHERE		product IN (SELECT DISTINCT IGCode FROM ContDrugsImport WHERE LEFT(IGCode,1) = '1' AND IGCode in ('101108'))
AND			dated BETWEEN @FromDate AND DATEADD(YEAR, 1, @FromDate)
GROUP BY	warehouse, product, dated, movement_reference, transaction_type, comments
ORDER BY	dated--, movement_reference

SELECT		t.*, a.warehouse AS BKWarhouse, a.product_code AS BKProductCode, a.alpha_code, a.description, a.quantity_required, a.quantity_rejected, a.quantity_finished, a.batch_size
INTO		#bks
FROM		#tmp t
LEFT JOIN	scheme.bmwohm a WITH(NOLOCK) 
ON			t.WorkOrder = a.works_order 
ORDER BY	t.dated 

-- THIS IS WHERE WE GET THE FILLED DATA
SELECT		--b.warehouse, b.IGProductCode, b.dated, b.WorkOrder, b.transaction_type, b.Qty, b.comments, b.BKWarhouse, b.BKProductCode, b.alpha_code, b.description, b.quantity_required, b.quantity_rejected, b.quantity_finished, b.batch_size, 
			a.warehouse AS FGWarhouse, a.product_code AS FGProductcode, a.alpha_code AS FGAlpha, a.works_order as FGWorkOrder, a.description AS FGDescription, 
			--SUM(a.quantity_required * ISNULL(i.Mass, 0)) AS FGQuantityRequired, 
			--SUM(a.quantity_rejected * ISNULL(i.Mass, 0)) AS FGQuantityRejected, 
			--SUM(a.quantity_finished * ISNULL(i.Mass, 0)) AS FGQuantityfinished, 
			b.*,
			a.quantity_required AS FGQuantityRequired, 
			a.quantity_rejected AS FGQuantityRejected, 
			a.quantity_finished AS FGQuantityfinished, 
			a.batch_size as FGBatchSize, u.spare, 
			CAST(0.0 AS FLOAT) as LitresFilled, 
			CAST(0.0 AS FLOAT) as LitresLost, 
			CAST(0.0 AS FLOAT) AS GramsLost, 
			CAST(0.0 AS FLOAT) AS Base, 
			CAST(0.0 AS FLOAT) AS Stock, 
			CAST(0.0 AS FLOAT) AS ManuQty, 
			CAST(0.0 AS FLOAT) AS BatchLoss, 
			CAST(0.0 AS FLOAT) AS QCUse, 
			CAST(0.0 AS FLOAT) AS IGReceipts			
INTO		#fgs
FROM		#bks b
LEFT JOIN	scheme.bmwohm a WITH(NOLOCK) 
ON			b.alpha_code = a.alpha_code
AND			a.warehouse = 'FG'
LEFT JOIN	scheme.stunitdm u
ON			u.unit_code = a.finish_prod_unit
LEFT JOIN	ContDrugsImport i
ON			a.product_code = i.FGCode
--GROUP BY	b.warehouse, b.IGProductCode, b.dated, b.WorkOrder, b.transaction_type, b.Qty, b.comments, b.BKWarhouse, b.BKProductCode, b.alpha_code, b.description, b.quantity_required, b.quantity_rejected, b.quantity_finished,u.spare, b.batch_size--, a.batch_size, u.spare
ORDER BY	dated, CASE transaction_type WHEN 'W/O' THEN 1 WHEN 'SCRP' THEN 2 WHEN 'ISSUE' THEN 3 ELSE 4 END

DECLARE	 @Alpha VARCHAR(10), @CurIG VARCHAR(10) = '', @BatchSize FLOAT
DECLARE	 @QuantityRequired FLOAT, @QuantityFinished FLOAT, @QuantityRejected FLOAT
DECLARE	 @ActQuantityRequired FLOAT, @ActQuantityFinished FLOAT, @ActQuantityRejected FLOAT, @WorkOrder VARCHAR(10) = '', @NextWorkOrder VARCHAR(10)
DECLARE	 @LitresFilled FLOAT, @LitresLost FLOAT, @IGCode VARCHAR(10), @BKCode VARCHAR(10), @FGCode VARCHAR(10), @Mass FLOAT, @TranType VARCHAR(20), @Alpha_Code VARCHAR(4)
DECLARE  @Base_g FLOAT, @IGOpeningStock FLOAT, @UsedStock FLOAT, @IGQty FLOAT
DECLARE	 @GramUsage FLOAT, @Receipts FLOAT, @Dated DATETIME, @FGUsage FLOAT
DECLARE	 @Row INT = 1
DECLARE	 @Rows INT = (SELECT COUNT(1) FROM #fgs)-- WHERE WOType = 0)
DELETE FROM #fgs WHERE alpha_code <> 'MK77' --order by IGProductCode 

--SELECT * FROM #fgs --order by IGProductCode 
--RETURN


ALTER TABLE #fgs
ADD	Id INT IDENTITY(1,1)

WHILE @Row <= @Rows
BEGIN
		SELECT  @NextWorkOrder = WorkOrder FROM	#fgs f WHERE Id = @Row
	--	IF @WorkOrder <> @NextWorkOrder  or @NextWorkOrder IS NULL
		BEGIN
		SELECT @IGCode = NULL, @BKCode = NULL, @FGCode = NULL, @WorkOrder = NULL, @ActQuantityFinished = 0, @TranType =''
		 
		SELECT  @Dated = dated, 
				@IGCode = IGProductCode, 
				@BKCode = BKProductCode,
				@FGCode = FGProductcode, 
				@IGQty = Qty, 
				@WorkOrder = WorkOrder,
				@Alpha_Code = alpha_code,
				@QuantityRequired = quantity_required, 
				@QuantityRejected = quantity_rejected,
				@QuantityFinished = quantity_finished,
				@TranType = LTRIM(RTRIM(UPPER(transaction_type)))
		FROM	#fgs f
		WHERE	Id = @Row
	--AND		BKProductCode IS NOT NULL
				
		IF @CurIG <> @IGCode -- NEW PRODUCT, SO GET OPENING STOCK
		BEGIN			
			SELECT	@CurIG = @IGCode, @IGOpeningStock = 0 
			SELECT	@IGOpeningStock = ROUND(scheme.fn_GetStockQuantity(@IGCode, 'IG', @FromDate), 5)
			--SELECT	@IGOpeningStock
		END

		SELECT	@GramUsage = g_lt, 
				@Base_g = Base_g, 
				@FGUsage =	FGBase_g, 
				@Mass = Mass
				
		FROM	ContDrugsImport 
		WHERE	IGCode = @IGCode
		AND		FGCode = @FGCode
		AND		BKCode = @BKCode
		IF @TranType = 'W/O'
		BEGIN				
			
			SET			@IGOpeningStock = @IGOpeningStock - (@IGQty)*-1-- * @GramUsage)
		--	select @IGCode ig, @BKCode bk, @FGCode fg, @WorkOrder as wo, @Alpha_Code as alpha
						
			SELECT		@ActQuantityRequired = SUM(quantity_required)*@Mass, 
						@ActQuantityFinished = SUM(quantity_finished)*@Mass, 
						@ActQuantityRejected = SUM(quantity_rejected)*@Mass
			/*SELECT		SUM(quantity_required) * @Mass REQ,  
						SUM(quantity_finished) * @Mass FIRN, 
						SUM(quantity_rejected) * @Mass REJ,@Mass		*/
			FROM		scheme.bmwohm 
			WHERE		alpha_code = @Alpha_Code
			--AND			works_order <> @WorkOrder
			AND			product_code = @FGCode
			--GROUP BY	alpha_code
			

			UPDATE	#fgs
			SET		LitresFilled = @ActQuantityFinished,
					ManuQty = @QuantityRequired * @GramUsage,
					LitresLost =(@QuantityRequired - @ActQuantityFinished),
					GramsLost = (@QuantityRequired - @ActQuantityFinished)*@GramUsage,
					Base = ((@QuantityRequired - @ActQuantityFinished)*@GramUsage)* @Base_g,
					Stock = @IGOpeningStock 			
			WHERE	Id = @Row		
		END
		ELSE IF @TranType ='ISSU'--Q.C. SAMPLES                                                
		BEGIN
			SET @IGOpeningStock = @IGOpeningStock + COALESCE(@IGQty,0)

			UPDATE	#fgs
			SET		QCUse = @IGQty,
					Stock = @IGOpeningStock		
			WHERE	Id = @Row
		END
		ELSE IF @TranType ='SCRP'--BATCH LOSS                                                  
		BEGIN			
			SET @IGOpeningStock = @IGOpeningStock + COALESCE(@IGQty,0)
			UPDATE	#fgs
			SET		BatchLoss = @IGQty,
					Stock = @IGOpeningStock
			WHERE	Id = @Row
		END
		ELSE IF @TranType ='RECP'
		BEGIN
			SET @IGOpeningStock =  @IGOpeningStock + (COALESCE(@IGQty,0))
			
			UPDATE	#fgs
			SET		Stock = @IGOpeningStock
			WHERE	Id >= @Row
			AND		IGProductCode = @IGCode
		END		
		ELSE IF @TranType ='ADJ'
		BEGIN
			SET @IGOpeningStock =  @IGOpeningStock + (COALESCE(@IGQty,0))
			UPDATE	#fgs
			SET		Stock = Stock + @IGOpeningStock
			WHERE	Id >= @Row
			AND		IGProductCode = @IGCode
		END		
		ELSE IF @TranType ='DKIT'
		BEGIN
			SET @IGOpeningStock =  @IGOpeningStock + (COALESCE(@IGQty,0))
			UPDATE	#fgs
			SET		Stock = Stock + @IGOpeningStock
			WHERE	Id >= @Row
			AND		IGProductCode = @IGCode
		END		
	 END
	SET @Row = @Row + 1
END

SELECT		dated, 
			IGProductCode, 
			alpha_code, 
			CASE UPPER(unit_code) WHEN 'G' THEN Stock ELSE Stock * 1000 END AS StockHeld,
			ManuQty AS ManuQty, 
			CASE UPPER(unit_code) WHEN 'G' THEN QCUse ELSE QCUse * 1000 END AS QCUse, 
			CASE UPPER(unit_code) WHEN 'G' THEN BatchLoss ELSE BatchLoss * 1000 END as BatchLoss, 
			CASE UPPER(unit_code) WHEN 'G' THEN Qty ELSE Qty * 1000 END as Qty, 
			quantity_required AS IGREQ, 
			quantity_rejected AS IGREJ, 
			quantity_finished AS IGFIN, 
			LitresFilled, 
			LitresLost, 
			GramsLost, 
			Base, 
			comments, 
			alpha_code, 
		--	FGWorkOrder,
			s.description, s.unit_code			
FROM		#fgs f
INNER JOIN	scheme.stockm s
ON			f.IGProductCode = s.product
and			f.warehouse = s.warehouse
ORDER BY	IGProductCode, dated--, f.alpha_code

GO



--SELECT works_order, warehouse, product_code, description, finish_prod_unit, quantity_required, quantity_rejected, quantity_finished, batch_size FROM scheme.bmwohm WHERE alpha_code = 'MK77'
--select * from scheme.stkhstm where dated = '2015-11-28 00:00:00.000' and product = '101108' ORDER BY transaction_type
--select * from ContDrugsImport
	              
		--		  130140    	089230    
		--		SELECT *
		--FROM	ContDrugsImport 
		--WHERE	IGCode = '101108'
		--AND		FGCode = '089230'
		--AND		BKCode = '130140'

		--124108