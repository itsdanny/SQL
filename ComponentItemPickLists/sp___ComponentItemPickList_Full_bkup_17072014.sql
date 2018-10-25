USE [syslive]
GO

/****** Object:  StoredProcedure [dbo].[sp___ComponentItemPickList_Full]    Script Date: 07/17/2014 12:27:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Ben Hopper
-- Create date: 03 May 2013
-- Description:	A replacement Component Item Pick List
-- Amended:		A Gill 2014 to provide a full list of available locations and also include the pallet number
-- =============================================
ALTER PROCEDURE [dbo].[sp___ComponentItemPickList_Full] 
	-- Add the parameters for the stored procedure here
	@warehouse char(2),
	@product char(8),
	@quantity_required int,
	@work_order char(8)
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
		pallet_number VARCHAR(3),
		expiry_date DATETIME,
		quantity int,
		quantity_allocated int
	)


	DECLARE @QuantityRequired INT
	DECLARE @LastQuantityReq INT
	--DECLARE @Supplier varchar(50)
	-- QTYLeft equals the total we want
	SET @QuantityRequired = @quantity_required
	
	-- Table Columns
	DECLARE @TableWarehouse VARCHAR(2)
	DECLARE @TableProduct VARCHAR(20)
	DECLARE @TableDescription VARCHAR(100)
	DECLARE @TableBin_number VARCHAR(6)
	DECLARE @TableLot_number VARCHAR(10)
	DECLARE @TablePallet_number VARCHAR(3)
	DECLARE @TableExpiry_date DATETIME
	DECLARE @TableQuantity INT
	DECLARE @Tablequantity_allocated INT

	DECLARE StockLocations CURSOR LOCAL FOR

	  SELECT stquem.warehouse, stquem.product, stockm.long_description, stquem.bin_number, stquem.lot_number, right(stqueam.pallet_number,11) as pallet_number
			,stquem.expiry_date, stquem.quantity, 
			stquem.quantity_free
		   
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
	  ORDER BY stquem.expiry_date, quantity

 
	OPEN StockLocations -- open the cursor

		FETCH NEXT FROM StockLocations INTO @TableWarehouse, @TableProduct, @TableDescription, @TableBin_number, @TableLot_number, @TablePallet_number,
											@TableExpiry_date, @TableQuantity, @Tablequantity_allocated
			
	WHILE @@FETCH_STATUS = 0
	 
	BEGIN
		-- If we still need some items
		--IF @QuantityRequired >= 0
		-- Begin
		BEGIN
			SET @LastQuantityReq = @QuantityRequired
			-- QtyReq = QtyReq - row amount
			SET @QuantityRequired = (@QuantityRequired - @Tablequantity_allocated)
			-- QtyReq is the amount we need
			
			IF @LastQuantityReq < 0
			BEGIN
				SET @LastQuantityReq = 0
			END
			IF @QuantityRequired >=0			
			BEGIN
				-- Insert row into temp table as we still need more
				INSERT INTO @PickList
				SELECT @TableWarehouse, @TableProduct, @TableDescription, @TableBin_number, @TableLot_number, @TablePallet_number,
						@TableExpiry_date, @TableQuantity, @Tablequantity_allocated
			END
			ELSE
			BEGIN
			
				-- Insert row into temp table as we still need more
				INSERT INTO @PickList
				SELECT @TableWarehouse, @TableProduct, @TableDescription, @TableBin_number, @TableLot_number, @TablePallet_number,
						@TableExpiry_date, @TableQuantity, @LastQuantityReq
						
			END	
		END
		
		FETCH NEXT FROM StockLocations
		INTO @TableWarehouse, @TableProduct, @TableDescription, @TableBin_number, @TableLot_number, @TablePallet_number,
				@TableExpiry_date, @TableQuantity, @Tablequantity_allocated

	END
	
	CLOSE StockLocations -- close the cursor

	DEALLOCATE StockLocations -- Deallocate the cursor

	SELECT warehouse, product, description, bin_number, lot_number, pallet_number, expiry_date,  SUM(quantity_allocated) AS quantity_to_allocate,SUM(quantity) AS quantity_available, @quantity_required AS quantity_required, @work_order AS work_order
	FROM @PickList
	GROUP BY warehouse, product, description, bin_number, lot_number, pallet_number, expiry_date
	ORDER BY quantity_to_allocate DESC, bin_number ASC, lot_number ASC, pallet_number ASC
END



GO


