USE [syslive]
GO

/****** Object:  StoredProcedure [dbo].[sp___ComponentItemPickList]    Script Date: 07/17/2014 12:26:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Ben Hopper
-- Create date: 03 May 2013
-- Description:	A replacement Component Item Pick List
-- =============================================
ALTER PROCEDURE [dbo].[sp___ComponentItemPickList] 
	-- Add the parameters for the stored procedure here
	@warehouse char(2),
	@product char(8),
	@qtyRequired int,
	@whoFor char(8)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @PickList TABLE 
	(
		warehouse VARCHAR(2), 
		product VARCHAR(20),
		description VARCHAR(100),
		bin_number VARCHAR(6),
		lot_number VARCHAR(10),
		expiry_date DATETIME,
		quantity INT,
		quantity_free INT,
		stock_held CHAR
	)


	DECLARE @QuantityRequired INT
	DECLARE @LastQuantityReq INT
	--DECLARE @Supplier varchar(50)
	-- QTYLeft equals the total we want
	SET @QuantityRequired = @qtyRequired
	
	-- Table Columns
	DECLARE @TableWarehouse VARCHAR(2)
	DECLARE @TableProduct VARCHAR(20)
	DECLARE @TableDescription VARCHAR(100)
	DECLARE @TableBin_number VARCHAR(6)
	DECLARE @TableLot_number VARCHAR(10)
	DECLARE @TableExpiry_date DATETIME
	DECLARE @TableQuantity INT
	DECLARE @TableQuantity_free INT
	DECLARE @TableStockHeld CHAR

	DECLARE StockLocations CURSOR LOCAL FOR

	  SELECT stquem.warehouse, stquem.product, stockm.long_description, stquem.bin_number, stquem.lot_number
			,stquem.expiry_date, stquem.quantity, 
			stquem.quantity_free,
		   CASE LOWER(stqueam.stock_held_flag)
			  WHEN 'y' THEN 'y'
			  ELSE 'n'
		   END AS stock_held
	  FROM scheme.stquem AS stquem WITH (NOLOCK) INNER JOIN scheme.stqueam AS stqueam WITH (NOLOCK) 
	  ON stquem.warehouse = stqueam.warehouse AND
	  stquem.product = stqueam.product AND
	  stquem.sequence_number = stqueam.sequence_number
	  INNER JOIN scheme.stockm AS stockm WITH (NOLOCK)
	  ON stquem.warehouse = stockm.warehouse AND
	  stquem.product = stockm.product
	  WHERE stquem.warehouse = @warehouse
	  AND stquem.product = @product
	  AND stquem.quantity > 0
	  AND LOWER(stquem.passed_inspection) = 'y'
	  AND LOWER(stqueam.stock_held_flag) != 'y'
	  AND ISNUMERIC(stquem.bin_number) = 1
	  ORDER BY stquem.date_received, quantity

 
	OPEN StockLocations -- open the cursor

		FETCH NEXT FROM StockLocations INTO @TableWarehouse, @TableProduct, @TableDescription, @TableBin_number, @TableLot_number,
											@TableExpiry_date, @TableQuantity, @TableQuantity_free, @TableStockHeld
			
	WHILE @@FETCH_STATUS = 0
	 
	BEGIN
		-- If we still need some items
		IF @QuantityRequired >= 0
		-- Begin
		BEGIN
			SET @LastQuantityReq = @QuantityRequired
			-- QtyReq = QtyReq - row amount
			SET @QuantityRequired = (@QuantityRequired - @TableQuantity_free)
			-- QtyReq is the amount we need
			
			IF @QuantityRequired >= 0
			BEGIN
				-- Insert row into temp table as we still need more
				INSERT INTO @PickList
				SELECT @TableWarehouse, @TableProduct, @TableDescription, @TableBin_number, @TableLot_number,
						@TableExpiry_date, @TableQuantity, @TableQuantity_free, @TableStockHeld
			END
			ELSE
			BEGIN
				-- Insert row into temp table as we still need more
				INSERT INTO @PickList
				SELECT @TableWarehouse, @TableProduct, @TableDescription, @TableBin_number, @TableLot_number,
						@TableExpiry_date, @TableQuantity, @LastQuantityReq, @TableStockHeld			
			END	
		END
		
		FETCH NEXT FROM StockLocations
		INTO @TableWarehouse, @TableProduct, @TableDescription, @TableBin_number, @TableLot_number,
				@TableExpiry_date, @TableQuantity, @TableQuantity_free, @TableStockHeld

	END
	
	CLOSE StockLocations -- close the cursor

	DEALLOCATE StockLocations -- Deallocate the cursor

	SELECT warehouse, product, description, bin_number, lot_number, expiry_date, SUM(quantity) AS quantity, SUM(quantity_free) AS quantity_free, stock_held
	,@warehouse AS ParamWarehouse, @product AS ParamProduct, @qtyRequired AS ParamQtyRequired, @whoFor AS ParamWhoFor
	FROM @PickList
	GROUP BY warehouse, product, description, bin_number, lot_number, expiry_date, stock_held
END

GO


