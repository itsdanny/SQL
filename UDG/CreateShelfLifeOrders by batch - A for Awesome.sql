USE [Integrate]
GO
/****** Object:  StoredProcedure [dbo].[sp__create_sales_order]    Script Date: 25/09/2014 14:11:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp__create_sales_order]	@OrderNumber varchar(12)
AS
BEGIN
	SET NOCOUNT ON;

    DECLARE @Notes VARCHAR(8000) 
	SELECT @Notes = COALESCE(@Notes  + ' - ', '') +  LTRIM(RTRIM(long_description))
	FROM	syslive.scheme.opdetm
	WHERE   (order_no = @OrderNumber) AND (line_type = 'C')
	
	BEGIN TRAN
	DECLARE @SalesHeaderId int
	INSERT INTO SalesOrderHeader (OrderNumber, SaleOrderTypeId, OrderDate, CustomerAccountNumber, CustomerType, DelAddress1, DelAddress2, DelAddress3, DelAddress4, DelPostCode, DeliveryDate, BookingTime, BookRef, Notes, CustomerOrderNumber, CustomerName)
	SELECT		syslive.scheme.opheadm.order_no, 1 AS SalesOrderType, syslive.scheme.opheadm.date_received, syslive.scheme.opheadm.customer, 'UK' AS CustomerType, 
				syslive.scheme.opheadm.address1, 
				syslive.scheme.opheadm.address2, 
				syslive.scheme.opheadm.address3, 
				LTRIM(RTRIM(syslive.scheme.opheadm.address4)) + ' ' + LTRIM(RTRIM(syslive.scheme.opheadm.address5)) AS address4, 
				-- IF ophdrpcm HAS NO POSTCODE THEN GET IT FROM THE CUSTOMER TABLE...DMC 15 SEP 2014
				CASE WHEN RTRIM(LTRIM(syslive.scheme.ophdrpcm.post_code)) = '' THEN syslive.scheme.slcustm.address6 ELSE syslive.scheme.ophdrpcm.post_code END AS PostCode, 				 								
				syslive.scheme.opheadm.date_required, 
				syslive.scheme.opheadm.vehicle_reference AS BookingTime, syslive.scheme.opheadm.schedule_number AS BookingRef, '' AS Notes, 
				syslive.scheme.opheadm.customer_order_no, syslive.scheme.slcustm.name
	FROM		syslive.scheme.opheadm WITH (NOLOCK) 
	INNER JOIN	syslive.scheme.slcustm WITH (NOLOCK) 
	ON			syslive.scheme.opheadm.customer = syslive.scheme.slcustm.customer 
	LEFT OUTER JOIN	syslive.scheme.ophdrpcm WITH (NOLOCK) 
	ON			syslive.scheme.opheadm.order_no = syslive.scheme.ophdrpcm.order_no
	WHERE		(syslive.scheme.opheadm.order_no = @OrderNumber)
	
	SET @SalesHeaderId = (SELECT SCOPE_IDENTITY() AS [SCOPE_IDENTITY]);

	PRINT 'SalesHeaderId: ' + CAST(@SalesHeaderId AS CHAR)

	-- GET ANY PRODUCTS THIS CUST HAS A MIN SHELF LIFE REQUIREMENT FOR THIS CUSTOMER, WHICH ARE ON THIS ORDER	
	CREATE TABLE #Prods(Id INT IDENTITY(1,1), ProductCode varchar(10), ProductDescription varchar(25), Months INT, warehouse CHAR(2))
	INSERT INTO #Prods(ProductCode, ProductDescription, Months, warehouse)
	SELECT		ProductCode, ProductDescription, ShelfLifeMonths, c.warehouse  
	FROM		CustomerShelfLife c
	INNER JOIN	syslive.scheme.opdetm m
	ON			c.ProductCode = m.product	
	AND			c.warehouse = m.warehouse
	INNER JOIN	syslive.scheme.opheadm h
	ON			h.order_no = m.order_no
	AND			c.CustomerCode = h.customer
	WHERE		h.order_no = @OrderNumber
	
	DECLARE @RowCount INT = (SELECT COUNT(*) FROM #Prods)
	IF @RowCount > 0 
		BEGIN
		DECLARE @Iter INT  = 1
		DECLARE @Prod varchar(10)
		DECLARE @Months INT
		DECLARE @OrderQty INT
		DECLARE @BatchNo varchar(12)
		DECLARE @ProductDesc varchar(25)

	
		--	NOW LOOP THROUGH SAID PRODUCTS AND 
		--	IF ANY EXISTS ON THE ORDER THEN GET A BATCH WITH THE MIN SHELF LIFE	ON IT
		WHILE @Iter <= @RowCount
		BEGIN
			SELECT		@Prod = ProductCode, 
						@Months = Months,
						@ProductDesc = ProductDescription,
						@BatchNo = NULL
			FROM		#Prods p 		
			WHERE		Id = @Iter			
			
			CREATE TABLE #batches(Id INT IDENTITY(1,1), sequence_number VARCHAR(15), lot_number VARCHAR(15), batch_number VARCHAR(15), quantity_free INT, order_qty INT) 
			
			INSERT INTO #batches(sequence_number, lot_number, batch_number, quantity_free, order_qty)
			SELECT		q.sequence_number, q.lot_number, batch_number, q.quantity_free, d.order_qty
			FROM		syslive.scheme.stquem q 
			INNER JOIN	syslive.scheme.opdetm d
			ON			q.product = d.product
			AND			q.warehouse = d.warehouse
			WHERE		d.product =  @Prod
			AND			DATEDIFF(MONTH, GETDATE(), expiry_date) >=  @Months
			AND			d.order_no =  @OrderNumber
			AND			q.quantity_free > 0												
			ORDER BY	expiry_date
									
			SELECT @OrderQty = MAX(order_qty) FROM #batches

			PRINT 'Order Qty: ' + CAST(@OrderQty AS CHAR)
			-- CHECK WE HAVE ENOUGH STOCK WITH THE RIGHT AMOUNT OF SHELF LIFE
			IF (SELECT COUNT(1) FROM #batches) = 0 OR (SELECT SUM(quantity_free) FROM #batches) < @OrderQty -- Take it out of the temp table so it doesn't get left behind...
			BEGIN
				SELECT 'Order ' + @OrderNumber +' has products, which this customer requires a minimum shelf life for. ' + @ProductDesc + ' ('+ @Prod + ') requires at least ' + CAST(@Months AS VARCHAR) + ' months worth of shelf life. This means we cannot satisfy this order.' AS ResultMessage
				BEGIN TRY
				DROP TABLE #Prods 
			    DROP TABLE #batches				
				END TRY
				BEGIN CATCH
				END CATCH
				PRINT 'ROLLBACK'
				ROLLBACK
				RETURN
			END

			-- All boxes ticked, let's get some lines now to make up the order
			DECLARE @CurQty INT = 0
			DECLARE @CurBatch VARCHAR(15)
			DECLARE @CurSequence VARCHAR(15)
			DECLARE @CurLot VARCHAR(15)
			DECLARE @BatchIter INT = 1	
			DECLARE @BatchCount INT = (SELECT COUNT(1) FROM #batches)
			WHILE (@OrderQty > @CurQty)
			BEGIN
			
				SELECT @CurBatch = batch_number, @CurSequence = sequence_number, @CurLot = lot_number FROM #batches WHERE Id = @BatchIter

				INSERT INTO SalesOrderLine (SalesOrderHeaderId, LineNumber, ProductCode, ProductDescription, AltProductCode, QtyRequired, Batch, UOM)
				SELECT		@SalesHeaderId, 
							syslive.scheme.opdetm.order_line_no, 
							syslive.scheme.opdetm.product, 
							syslive.scheme.opdetm.description, 
							syslive.scheme.opcustinm.customer_product AS AltProductCode, 		
							CASE WHEN @OrderQty >= (@CurQty + syslive.scheme.stquem.quantity_free) THEN syslive.scheme.stquem.quantity_free ELSE (@OrderQty - @CurQty) END AS order_qty, 
							syslive.scheme.stquem.lot_number AS LotNumber, 
							syslive.scheme.opdetm.unit_of_sale
				FROM		syslive.scheme.stquem WITH (NOLOCK) 
				INNER JOIN	syslive.scheme.opdetm WITH (NOLOCK) 
				ON			syslive.scheme.stquem.product = syslive.scheme.opdetm.product 
				AND			syslive.scheme.stquem.warehouse = syslive.scheme.opdetm.warehouse 			
				INNER JOIN	syslive.scheme.opheadm 
				ON			syslive.scheme.opheadm.order_no = syslive.scheme.opdetm.order_no 
				LEFT JOIN	syslive.scheme.opcustinm 
				ON			syslive.scheme.opdetm.product = syslive.scheme.opcustinm.product_code 
				AND			syslive.scheme.opheadm.customer = syslive.scheme.opcustinm.customer_code
				WHERE		(syslive.scheme.opdetm.line_type = 'P') 
				AND			(syslive.scheme.opdetm.order_no = @OrderNumber)
				AND			syslive.scheme.stquem.batch_number = @CurBatch 
				AND			syslive.scheme.stquem.sequence_number = @CurSequence 
				AND			syslive.scheme.stquem.quantity_free > 0				

				SELECT @CurQty = SUM(QtyRequired) FROM SalesOrderLine WHERE SalesOrderHeaderId = @SalesHeaderId AND ProductCode = @Prod
				PRINT 'Cur Qty: ' + CAST(@CurQty AS CHAR) + '. BatchID: ' + @CurBatch + 'Seq: ' + @CurSequence

				SET @BatchIter = @BatchIter + 1
			END -- end of this product batches while

			-- do the next shelf life managed product
			SET @Iter = @Iter + 1
  		    DROP TABLE #batches
		  END -- WHILE		
	END -- IF

	-- NOW THAT WE'VE FINISHED ALL THAT, GET THE REST OF THE LINES...
	INSERT INTO SalesOrderLine (SalesOrderHeaderId, LineNumber, ProductCode, ProductDescription, AltProductCode, QtyRequired, Batch, UOM)
	SELECT			@SalesHeaderId AS SalesOrderHeaderId, 
					syslive.scheme.opdetm.order_line_no, 
					syslive.scheme.opdetm.product, 
					syslive.scheme.opdetm.description, 
					syslive.scheme.opcustinm.customer_product AS AltProductCode, 
					ISNULL(syslive.scheme.stallocm.[qty_allocated],
					syslive.scheme.opdetm.order_qty) as order_qty, 
					ISNULL(syslive.scheme.stquem.lot_number, '') AS LotNumber, 
					syslive.scheme.opdetm.unit_of_sale
	FROM			syslive.scheme.stallocm  WITH (NOLOCK)  
	INNER JOIN		syslive.scheme.stquem WITH (NOLOCK) 
	ON				syslive.scheme.stallocm.warehouse = syslive.scheme.stquem.warehouse 
	AND				syslive.scheme.stallocm.product = syslive.scheme.stquem.product 
	AND				syslive.scheme.stallocm.sequence_number = syslive.scheme.stquem.sequence_number 	
	RIGHT OUTER JOIN syslive.scheme.opdetm WITH (NOLOCK) 
	ON				syslive.scheme.stallocm.product = syslive.scheme.opdetm.product 
	AND				syslive.scheme.stallocm.warehouse = syslive.scheme.opdetm.warehouse 
	AND            	syslive.scheme.stallocm.order_no = syslive.scheme.opdetm.order_no	
	AND				syslive.scheme.stallocm.order_line = syslive.scheme.opdetm.order_line_no
	INNER JOIN		syslive.scheme.opheadm 
	ON				syslive.scheme.opheadm.order_no = syslive.scheme.opdetm.order_no 
	LEFT JOIN		syslive.scheme.opcustinm 
	ON				syslive.scheme.opdetm.product = syslive.scheme.opcustinm.product_code 
	AND				syslive.scheme.opheadm.customer = syslive.scheme.opcustinm.customer_code
	WHERE			(syslive.scheme.opdetm.line_type = 'P') 
	AND				(syslive.scheme.opdetm.order_no = @OrderNumber)
	AND				syslive.scheme.opdetm.product NOT IN (select ProductCode FROM #Prods) -- EXCLUDE ANY WE MAY HAVE ADDED BEFORE/ABOVE.
	
	UPDATE syslive.scheme.opheadm SET status = '6' WHERE order_no = @OrderNumber
	PRINT 'Commit'
	COMMIT TRAN
	SELECT '' AS ResultMessage
END


