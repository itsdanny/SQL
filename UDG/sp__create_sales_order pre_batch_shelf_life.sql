USE [Integrate]
GO
/****** Object:  StoredProcedure [dbo].[sp__create_sales_order]    Script Date: 23/09/2014 16:41:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp__create_sales_order]
	
	@OrderNumber varchar(12)

AS
BEGIN
	SET NOCOUNT ON;

    DECLARE @Notes VARCHAR(8000) 
	SELECT @Notes = COALESCE(@Notes  + ' - ', '') +  LTRIM(RTRIM(long_description))
	FROM syslive.scheme.opdetm
	WHERE        (order_no = @OrderNumber) AND (line_type = 'C')
	
	DECLARE @SalesHeaderId int
	BEGIN TRAN
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
	
	-- Get any products this cust has a min shelf life requirement for	
	CREATE TABLE #Prods(Id INT IDENTITY(1,1), ProductCode varchar(10), ProductDescription varchar(25), Months INT, warehouse CHAR(2))
	INSERT INTO #Prods(ProductCode, ProductDescription, Months, warehouse)
	SELECT ProductCode, ProductDescription, ShelfLifeMonths, warehouse  FROM CustomerShelfLife WHERE CustomerCode = (SELECT CustomerAccountNumber FROM SalesOrderHeader WHERE Id = @SalesHeaderId)

	
	DECLARE @RowCount INT = (SELECT COUNT(*) FROM #Prods)
	IF @RowCount > 0 
		BEGIN
		DECLARE @Iter INT  = 1
		DECLARE @Prod varchar(10)
		DECLARE @Months INT
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
				
			SELECT TOP 1 @BatchNo = batch_number 
			FROM		syslive.scheme.stquem q 
			INNER JOIN	syslive.scheme.opdetm d
			ON			q.product = d.product
			and			q.warehouse = d.warehouse
			WHERE		d.product = @Prod 
			AND			DATEDIFF(MONTH, GETDATE(), expiry_date) >= @Months
			AND			d.order_no = @OrderNumber
			AND			q.quantity_free >= d.order_qty
			ORDER BY	expiry_date

			IF @BatchNo IS NULL -- Take it out of the temp table so it doesn't get left behind...
			BEGIN
				SELECT 'Order ' +@OrderNumber +' has products which this customer requires a minimum shelf life for. ' + @ProductDesc + ' ('+ @Prod + ') requires at least ' + CAST(@Months AS VARCHAR) + ' months worth of shelf life. This means we cannot satisfy this order.' AS ResultMessage
				DROP TABLE #Prods 
				ROLLBACK
				RETURN
			END
			ELSE
			BEGIN -- WE HAVE A BATCH THAT HAS THE SHELF LIFE REQUIRED, SO USE THAT
				INSERT INTO SalesOrderLine (SalesOrderHeaderId, LineNumber, ProductCode, ProductDescription, AltProductCode, QtyRequired, Batch, UOM)
				SELECT		TOP 1
							 @SalesHeaderId AS SalesOrderHeaderId, 
							syslive.scheme.opdetm.order_line_no, 
							syslive.scheme.opdetm.product, 
							syslive.scheme.opdetm.description, 
							'' AS AltProductCode, 
							syslive.scheme.opdetm.order_qty as order_qty, 
							syslive.scheme.stquem.lot_number AS LotNumber, 
							syslive.scheme.opdetm.unit_of_sale
				FROM		syslive.scheme.stquem WITH (NOLOCK) 
				INNER JOIN	syslive.scheme.opdetm WITH (NOLOCK) 
				ON			syslive.scheme.stquem.product = syslive.scheme.opdetm.product 
				AND			syslive.scheme.stquem.warehouse = syslive.scheme.opdetm.warehouse 			
				WHERE		(syslive.scheme.opdetm.line_type = 'P') 
				AND			(syslive.scheme.opdetm.order_no = @OrderNumber)
				AND			syslive.scheme.stquem.batch_number = @BatchNo 
				AND			syslive.scheme.stquem.quantity_free >= syslive.scheme.opdetm.order_qty 
			END

			SET @Iter = @Iter + 1
		  END		
	END

	-- NOW THAT WE'VE FINISHED ALL THAT, GET THE REST OF THE LINES...
	INSERT INTO SalesOrderLine (SalesOrderHeaderId, LineNumber, ProductCode, ProductDescription, AltProductCode, QtyRequired, Batch, UOM)
	SELECT		@SalesHeaderId AS SalesOrderHeaderId, 
				syslive.scheme.opdetm.order_line_no, 
				syslive.scheme.opdetm.product, 
				syslive.scheme.opdetm.description, 
				'' AS AltProductCode, 
				ISNULL(syslive.scheme.stallocm.[qty_allocated],
				syslive.scheme.opdetm.order_qty) as order_qty, 
				ISNULL(syslive.scheme.stquem.lot_number, '') AS LotNumber, 
					syslive.scheme.opdetm.unit_of_sale
	FROM			syslive.scheme.stallocm  WITH (NOLOCK)  
	INNER JOIN		syslive.scheme.stquem WITH (NOLOCK) 
	ON				syslive.scheme.stallocm.warehouse = syslive.scheme.stquem.warehouse 
	AND				syslive.scheme.stallocm.product = syslive.scheme.stquem.product 
	AND				syslive.scheme.stallocm.sequence_number = syslive.scheme.stquem.sequence_number 
	RIGHT OUTER JOIN	syslive.scheme.opdetm WITH (NOLOCK) 
	ON				syslive.scheme.stallocm.product = syslive.scheme.opdetm.product 
	AND				syslive.scheme.stallocm.warehouse = syslive.scheme.opdetm.warehouse 
	AND            	syslive.scheme.stallocm.order_no = syslive.scheme.opdetm.order_no	
	AND				syslive.scheme.stallocm.order_line = syslive.scheme.opdetm.order_line_no
	WHERE			(syslive.scheme.opdetm.line_type = 'P') 
	AND				(syslive.scheme.opdetm.order_no = @OrderNumber)
	AND				syslive.scheme.opdetm.product NOT IN (select ProductCode FROM #Prods) -- EXCLUDE ANY WE MAY HAVE ADDED BEFORE/ABOVE.
	
	UPDATE syslive.scheme.opheadm SET status = '6' WHERE order_no = @OrderNumber
	
	COMMIT TRAN
	SELECT '' AS ResultMessage
END

