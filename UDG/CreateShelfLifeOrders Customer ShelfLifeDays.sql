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
	FROM	syslive.scheme.opdetm WITH (NOLOCK) 
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
	LEFT OUTER JOIN	syslive.scheme.ophdrpcm WITH(NOLOCK) 
	ON			syslive.scheme.opheadm.order_no = syslive.scheme.ophdrpcm.order_no
	WHERE		(syslive.scheme.opheadm.order_no = @OrderNumber)
	
	SET @SalesHeaderId = (SELECT SCOPE_IDENTITY() AS [SCOPE_IDENTITY]);
	
	-- NOW THAT WE'VE FINISHED ALL THAT, GET THE REST OF THE LINES...
	INSERT INTO SalesOrderLine (SalesOrderHeaderId, LineNumber, ProductCode, ProductDescription, AltProductCode, QtyRequired, Batch, UOM, ShelfLifeDays)
	SELECT			@SalesHeaderId AS SalesOrderHeaderId, 
					syslive.scheme.opdetm.order_line_no, 
					syslive.scheme.opdetm.product, 
					syslive.scheme.opdetm.description, 
					ISNULL(syslive.scheme.opcustinm.customer_product, '') AS AltProductCode, -- Customers own ProducCode
					ISNULL(syslive.scheme.stallocm.[qty_allocated],
					syslive.scheme.opdetm.order_qty) as order_qty, 
					ISNULL(syslive.scheme.stquem.lot_number, '') AS LotNumber, 
					syslive.scheme.opdetm.unit_of_sale,
					ISNULL(DATEDIFF(DAY, GETDATE(), DATEADD(MONTH, p.ShelfLifeMonths, GETDATE())), 0) AS ShelfLifeDays										
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
	INNER JOIN		syslive.scheme.opheadm WITH (NOLOCK) 
	ON				syslive.scheme.opheadm.order_no = syslive.scheme.opdetm.order_no 
	LEFT JOIN		syslive.scheme.opcustinm WITH (NOLOCK) 
	ON				syslive.scheme.opdetm.product = syslive.scheme.opcustinm.product_code 
	AND				syslive.scheme.opheadm.customer = syslive.scheme.opcustinm.customer_code
	LEFT JOIN		CustomerShelfLife p WITH (NOLOCK) 
	ON				syslive.scheme.opdetm.product = p.ProductCode
	AND				syslive.scheme.opdetm.warehouse = p.warehouse
	AND				syslive.scheme.opheadm.customer = p.CustomerCode	
	WHERE			(syslive.scheme.opdetm.line_type = 'P') 
	AND				(syslive.scheme.opdetm.order_no = @OrderNumber)	
	
	UPDATE syslive.scheme.opheadm SET status = '6' WHERE order_no = @OrderNumber
	PRINT 'Commit'
	COMMIT TRAN
	SELECT '' AS ResultMessage
END

go
