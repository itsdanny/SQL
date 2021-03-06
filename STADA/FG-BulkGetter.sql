USE StadaFactBook

DELETE	FROM Budgets WHERE Warehouse ='BK' OR Warehouse IS NULL

DECLARE		@FGProducts TABLE(Id INT IDENTITY(1,1), Product VARCHAR(10), Quantity INT, Period DateTime)
INSERT INTO @FGProducts SELECT Product, Quantity, BudgetPeriod FROM Budgets WHERE Warehouse = 'FG'
--INSERT INTO @FGProducts SELECT DISTINCT TOP 100 Product, SUM(Quantity) FROM Budgets WHERE Warehouse = 'FG' AND Product IN('055026','002828') GROUP BY Product

DECLARE @FGRows INT	= (SELECT DISTINCT count(1) from @FGProducts)
DECLARE @FGIter INT	= 1
DECLARE @FGSKU VARCHAR(10)
DECLARE @FGQTY INT
DECLARE @Period DateTime
DECLARE @Bulks TABLE(Id INT IDENTITY(1,1), Product VARCHAR(10), Usage_Quantity INT)
DECLARE @Bulks2 TABLE(Id INT IDENTITY(1,1), Product VARCHAR(10), Usage_Quantity INT, Period DateTime)

IF OBJECT_ID('tempdb..#LvlOneBulks') IS NOT NULL
BEGIN
DROP TABLE #LvlOneBulks
END
IF OBJECT_ID('tempdb..#LvlTwoBulks') IS NOT NULL
BEGIN
DROP TABLE #LvlTwoBulks
END
IF OBJECT_ID('tempdb..#LvlThreeBulks') IS NOT NULL
BEGIN
DROP TABLE #LvlThreeBulks
END

DECLARE @LvlOneIter INT	= 1
DECLARE @LvlOneQtyReq FLOAT
DECLARE @LvlOneSKU VARCHAR(10)
DECLARE @LvlOneBulkCount INT 
CREATE TABLE #LvlOneBulks (Id INT IDENTITY(1,1), Product VARCHAR(10), UOM VARCHAR(5), Usage_Quantity FLOAT)

DECLARE @LvlTwoIter INT	= 1
DECLARE @LvlTwoQtyReq FLOAT
DECLARE @LvlTwoSKU VARCHAR(10)
DECLARE @LvlTwoBulkCount INT 
CREATE TABLE #LvlTwoBulks (Id INT IDENTITY(1,1), Product VARCHAR(10), UOM VARCHAR(5), Usage_Quantity FLOAT)

DECLARE @LvlThreeIter INT = 1
DECLARE @LvlThreeQtyReq FLOAT
DECLARE @LvlThreeSKU VARCHAR(10)
DECLARE @LvlThreeBulkCount INT
CREATE TABLE #LvlThreeBulks (Id INT IDENTITY(1,1), Product VARCHAR(10), UOM VARCHAR(5), Usage_Quantity FLOAT)

WHILE @FGIter <= @FGRows
BEGIN		
	SELECT DISTINCT @FGSKU = Product, @FGQTY = Quantity, @Period = Period FROM @FGProducts WHERE Id = @FGIter
	--SELECT 'GET LEVEL ONE BULKS: ' + @FGSKU	

	SET @LvlOneIter = 1		
	INSERT INTO @Bulks(Product, Usage_Quantity)
	SELECT DISTINCT component_code, CASE component_unit WHEN 'g' THEN @FGQTY*(usage_quantity/1000) ELSE @FGQTY*usage_quantity END FROM syslive.scheme.bmassdm WHERE component_whouse = 'BK' AND product_code = @FGSKU	
	TRUNCATE TABLE #LvlOneBulks

	INSERT INTO #LvlOneBulks(Product, Usage_Quantity)	
	SELECT DISTINCT component_code, CASE component_unit WHEN 'g' THEN (usage_quantity/1000) ELSE usage_quantity END FROM syslive.scheme.bmassdm WHERE component_whouse = 'BK' AND product_code = @FGSKU
	SET @LvlOneBulkCount = (SELECT COUNT(1) FROM #LvlOneBulks)
	IF @LvlOneBulkCount > 0
	BEGIN		
		WHILE @LvlOneIter <= @LvlOneBulkCount 
		BEGIN				
			SELECT DISTINCT @LvlOneSKU = Product, @LvlOneQtyReq = Usage_Quantity FROM #LvlOneBulks WHERE Id = @LvlOneIter				
			
			--SELECT 'GET LEVEL TWO BULKS: ', @FGSKU as FG, @LvlOneSKU as LvlOneBK			
			INSERT INTO @Bulks(Product, Usage_Quantity)
			SELECT DISTINCT component_code, CASE component_unit WHEN 'g' THEN @LvlOneQtyReq*(usage_quantity/1000) ELSE @LvlOneQtyReq*usage_quantity END FROM syslive.scheme.bmassdm WHERE component_whouse = 'BK' AND product_code = @LvlOneSKU	
			TRUNCATE TABLE #LvlTwoBulks
			
			INSERT INTO #LvlTwoBulks(Product, Usage_Quantity)
			SELECT DISTINCT component_code, CASE component_unit WHEN 'g' THEN (usage_quantity/1000) ELSE usage_quantity END FROM syslive.scheme.bmassdm WHERE component_whouse = 'BK' AND product_code = @LvlOneSKU
			
			SET @LvlTwoBulkCount = (SELECT COUNT(1) FROM #LvlTwoBulks)
				IF @LvlTwoBulkCount > 0
				BEGIN				
					WHILE @LvlTwoIter <= @LvlTwoBulkCount 
					BEGIN
						SELECT DISTINCT @LvlTwoSKU = Product, @LvlTwoQtyReq = Usage_Quantity FROM #LvlTwoBulks WHERE Id = @LvlTwoIter
						
						--SELECT 'GET LEVEL THREE BULKS: ', @FGSKU as FG, @LvlOneSKU as LvlOneBK, @LvlTwoSKU as LvlTwoBK
						INSERT INTO @Bulks(Product, Usage_Quantity)
						SELECT DISTINCT component_code, CASE component_unit WHEN 'g' THEN (usage_quantity/1000) ELSE usage_quantity END FROM syslive.scheme.bmassdm WHERE component_whouse = 'BK' AND product_code = @LvlTwoSKU							
						
						TRUNCATE TABLE #LvlTwoBulks
						
						INSERT INTO #LvlThreeBulks(Product, Usage_Quantity)
						SELECT DISTINCT component_code, CASE component_unit WHEN 'g' THEN @LvlTwoQtyReq*(usage_quantity/1000) ELSE @LvlTwoQtyReq*usage_quantity END FROM syslive.scheme.bmassdm WHERE component_whouse = 'BK' AND product_code = @LvlTwoSKU
						
						SET	@LvlThreeBulkCount = (SELECT COUNT(1) FROM #LvlThreeBulks)
						IF @LvlThreeBulkCount > 0
						BEGIN							
							SET @LvlThreeIter = 1
							WHILE @LvlThreeIter <= @LvlThreeBulkCount 
							BEGIN
								SELECT DISTINCT @LvlThreeSKU = Product, @LvlThreeQtyReq = Usage_Quantity FROM #LvlThreeBulks WHERE Id = @LvlThreeIter
								
								--SELECT 'GET LEVEL FOUR BULKS: ', @FGSKU as FG, @LvlOneSKU as LvlOneBK, @LvlTwoSKU as LvlTwoBK, @LvlThreeSKU AS LvlThreeBK
								INSERT INTO @Bulks(Product, Usage_Quantity)
								SELECT DISTINCT component_code, CASE component_unit WHEN 'g' THEN @LvlThreeQtyReq*(usage_quantity/1000) ELSE @LvlThreeQtyReq*usage_quantity END FROM syslive.scheme.bmassdm WHERE component_whouse = 'BK' AND product_code = @LvlThreeSKU							
							
								SET @LvlThreeIter = @LvlThreeIter + 1
							END -- END WHILE LEVEL 3 BULKS

						END -- END IF
						SET @LvlTwoIter = @LvlTwoIter + 1
					END-- END WHILE LEVEL 2 BULKS

				END
			SET @LvlOneIter = @LvlOneIter +1		
		END -- END WHILE LEVEL 1 BULKS
			
	IF(SELECT COUNT(1) FROM Budgets WHERE Warehouse ='BK' AND Product = @LvlOneSKU AND BudgetPeriod = @Period) > 0  
	BEGIN
		UPDATE	b1
		SET		b1.Quantity = b1.Quantity + (SELECT ISNULL(SUM(Usage_Quantity), 0)
							FROM	@Bulks b2
							WHERE	b2.Product = b1.Product)
		FROM	Budgets b1
		WHERE	b1.BudgetPeriod = @Period
		AND		b1.Warehouse ='BK'
	END
	ELSE
	BEGIN
		INSERT INTO Budgets(Product, Warehouse, Quantity, BudgetPeriod)
		SELECT Product, 'BK', SUM(Usage_Quantity), @Period FROM @Bulks GROUP BY Product
	END
	
	DELETE FROM @Bulks	
	END	

	SET @FGIter = @FGIter + 1	
END -- END WHILE OF FG products	


