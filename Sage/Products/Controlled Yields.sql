ALTER PROCEDURE sp_rpt_IGBKYeilds 
@FromDate	DATETIME = NULL,
@ToDate		DATETIME = NULL
AS

IF @FromDate IS NULL
SET @FromDate = DATEADD(yy, DATEDIFF(yy,0,getdate())-1, 0)

IF @ToDate IS NULL
SET @ToDate =  DATEADD(yy, DATEDIFF(yy,0,getdate()), 0)-1

DECLARE @WorkOrders TABLE(Id INT IDENTITY(1,1), Dated DATE, Alpha VARCHAR(10), WO VARCHAR(8), IGProductCode VARCHAR(10), BKProductCode VARCHAR(10), IGDescription VARCHAR(40), BatchSize FLOAT, g_litre FLOAT, Base_g FLOAT,
					QuantityRequired FLOAT, QuantityFinished FLOAT, QuantityRejected FLOAT, 
					LitresRequired FLOAT, 
					LitresFinished FLOAT, 
					LitresRejected FLOAT, 
					LitresLost FLOAT, GramsLost FLOAT, BaseGramLost FLOAT,
					IGCode VARCHAR(10), BKCode VARCHAR(10), FGCode VARCHAR(10), Mass FLOAT, WOType INT, IGOpeningStock FLOAT, AvailableStock FLOAT DEFAULT 0, Receipts FLOAT DEFAULT 0, Scrap FLOAT)

DECLARE @Yields TABLE(Id INT IDENTITY(1,1), Dated DATE, Alpha VARCHAR(10), WO VARCHAR(8), ProductCode VARCHAR(10), GramUsage FLOAT, DrugUsage FLOAT, IGOpeningStock FLOAT, Receipts FLOAT, Scrap FLOAT)

INSERT INTO @WorkOrders (Dated, Alpha, WO, IGProductCode, BKProductCode, IGDescription, BatchSize, QuantityRequired, QuantityFinished, QuantityRejected, IGCode, BKCode, FGCode, Mass, g_litre, Base_g, WOType, IGOpeningStock)
(SELECT		DISTINCT s.dated, a.alpha_code, works_order, s.product, product_code, c.FGProductDescription, batch_size, quantity_required, quantity_finished, quantity_rejected,IGCode, BKCode, FGCode, Mass, g_lt, Base_g, WOType,
			ROUND(scheme.fn_GetStockQuantity(c.IGCode, s.warehouse, s.dated), 5) * 1000 AS IGOpeningStock 
FROM		scheme.stkhstm s WITH(NOLOCK)
INNER JOIN	scheme.bmwohm a WITH(NOLOCK)
ON			a.works_order = s.movement_reference
INNER JOIN	ContDrugsImport c
ON			s.product = c.IGCode
AND			(a.product_code = c.BKCode or a.product_code = c.FGCode)
--WHERE		s.dated BETWEEN '2014-01-01' AND '2014-12-31'
WHERE		s.dated BETWEEN @FromDate AND @ToDate
--AND			s.product = '105065'
--AND			s.product  in ('105588','100063','113130')
)


UPDATE	@WorkOrders
SET		BatchSize = QuantityRequired		
WHERE	UPPER(Alpha) LIKE 'DEV%'
AND		BatchSize = 0

DECLARE	 @Alpha VARCHAR(10), @ProductCode VARCHAR(10), @BatchSize FLOAT, @ActQuantityRequired FLOAT, @ActQuantityFinished FLOAT, @ActQuantityRejected FLOAT, @WorkOrder VARCHAR(10)
DECLARE	 @LitresFilled FLOAT, @LitresLost FLOAT, @IGCode VARCHAR(10), @BKCode VARCHAR(10), @FGCode VARCHAR(10), @Mass FLOAT, @WOType INT, @Base_g FLOAT, @IGOpeningStock FLOAT, @UsedStock FLOAT
DECLARE	 @GramUsage FLOAT, @Receipts FLOAT
DECLARE	 @Row INT = (SELECT MIN(Id) FROM @WorkOrders)
DECLARE	 @Rows INT = (SELECT COUNT(1) FROM @WorkOrders WHERE WOType = 0)

 
WHILE @Row <= @Rows
BEGIN
	SELECT @ProductCode = '', @Alpha = ''

	SELECT	@ProductCode = IGProductCode, 			
			@FGCode = FGCode,
			@BKCode = BKCode,
			@WorkOrder = WO,
			@Alpha  = Alpha,
			@BatchSize = BatchSize, 
			@Mass = Mass,
			@WOType = WOType,
			@Base_g =  Base_g,
			@IGOpeningStock = IGOpeningStock 
	FROM	@WorkOrders 
	WHERE	Id = @Row
	--AND		WOType = 0

	IF @WOType = 0
	BEGIN
		SELECT	@ActQuantityRequired = SUM(quantity_required) * @Mass, 
				@ActQuantityFinished = SUM(quantity_finished) * @Mass, 
				@ActQuantityRejected = SUM(quantity_rejected) * @Mass			 
		FROM	scheme.bmwohm 
		WHERE	alpha_code = @Alpha
		--AND		works_order	NOT LIKE @WorkOrder
		AND		product_code = @FGCode
	END
	IF @WOType = 1
	BEGIN
		SELECT	@ActQuantityRequired = SUM(quantity_required),
				@ActQuantityFinished = SUM(quantity_finished),
				@ActQuantityRejected = SUM(quantity_rejected) 
		FROM	scheme.bmwohm 
		WHERE	alpha_code = @Alpha
		--AND		works_order	NOT LIKE @WorkOrder
		AND		product_code = @FGCode
	END			
		UPDATE	@WorkOrders
		SET		LitresFinished = @ActQuantityFinished,
				LitresRejected = @ActQuantityRejected,
				LitresRequired = @ActQuantityRequired,
				LitresLost = ROUND(QuantityFinished - @ActQuantityFinished ,5),
				GramsLost =  ROUND((QuantityFinished - @ActQuantityFinished) * g_litre, 5),
				BaseGramLost = ROUND((QuantityFinished - @ActQuantityFinished) * g_litre * Base_g ,5)
		WHERE	Id = @Row
	
	SET @Row = @Row + 1
END

-- UPDATE ANY DEV (AMOUNTS ARE NULL)
UPDATE	@WorkOrders
SET		LitresRequired = QuantityRequired,
		LitresFinished = QuantityFinished,
		LitresRejected = QuantityRejected,
		LitresLost = 0,
		GramsLost = 0,
		BaseGramLost = 0
WHERE	UPPER(Alpha) LIKE 'DEV%'


-- ADD IN ANY UPS/DOWNS
INSERT INTO @WorkOrders(Dated, IGProductCode, IGDescription, Receipts, Scrap, WOType, IGOpeningStock)
SELECT		dated, m.product, m.long_description, 
			CASE WHEN transaction_type IN ('RECP', 'RINV') THEN SUM(movement_quantity)*1000 ELSE 0 END,
			CASE WHEN transaction_type IN ('SCRP') THEN SUM(movement_quantity)*1000 ELSE 0 END, 9,
			ROUND(scheme.fn_GetStockQuantity(m.product, s.warehouse, s.dated), 5) * 1000 AS IGOpeningStock  
FROM		scheme.stkhstm s
INNER JOIN	scheme.stockm m
ON			s.product = m.product
AND			s.warehouse = m.warehouse
WHERE		s.product IN (SELECT DISTINCT IGCode FROM ContDrugsImport)
AND			s.warehouse = 'IG'
AND			s.transaction_type IN ('RECP', 'RINV', 'SCRP')
AND			s.dated BETWEEN @FromDate AND @ToDate
--AND			s.product = '105065'
GROUP BY	dated, m.product, m.long_description,transaction_type, s.warehouse


-- RECALC THE STOCK LEVELS PER DAY, ACCOUNTING FOR RECEIPTS AND LOSSES


Set @IGOpeningStock = (SELECT top 1 IGOpeningStock FROM @WorkOrders)
SELECT @IGOpeningStock

SELECT		* 
FROM		@WorkOrders
ORDER BY	IGCode, Dated, WO
GO

sp_rpt_IGBKYeilds '2014-01-01','2014-12-31'


/*
-- SORT OUT THE STOCK LEVELS AT EACH W/O
INSERT INTO @Yields(Dated, Alpha, WO, ProductCode, GramUsage, DrugUsage, IGOpeningStock, Receipts)
SELECT		Dated, Alpha, WO, IGProductCode, LitresFinished * g_litre AS GramUsage, (LitresFinished * g_litre) * Base_g AS DrugUsage, IGOpeningStock AS IGOpeningStock, Receipts 		
FROM		@WorkOrders
--WHERE		LitresRequired IS NOT NULL
ORDER BY	Dated, WO


SET @Row = 1
SET @Rows = (SELECT COUNT(1) FROM @Yields)

WHILE @Row <= @Rows
BEGIN
	SELECT  @UsedStock = 0, @GramUsage = 0, @IGOpeningStock = 0, @Receipts = 0

	SELECT	@ProductCode = ProductCode, 						
			@WorkOrder = WO,			
			@IGOpeningStock = IGOpeningStock, 
			@GramUsage = GramUsage,
			@UsedStock += GramUsage,
			@Receipts = Receipts			
	FROM	@Yields 
	WHERE	Id = @Row

	IF @Receipts > 0
	BEGIN -- ADD TO Available stock
		SET		@UsedStock = @UsedStock + @Receipts

		UPDATE 	@WorkOrders 
		SET		AvailableStock = @Receipts
		WHERE	Id >= @Row
	END
	ELSE
	BEGIN
		SELECT	@UsedStock = SUM(AvailableStock)
		FROM	@WorkOrders 
		WHERE	IGProductCode = @ProductCode

		--SELECT @IGOpeningStock AS OpeningStock, @UsedStock as UsedStock, *
		--FROM	@Yields 
		--WHERE	Id = @Row
	
		UPDATE 	@WorkOrders 
		SET		AvailableStock = (@IGOpeningStock - (@UsedStock+@GramUsage))
		WHERE	Id = @Row
	END
	SET @Row = @Row + 1
END

*/