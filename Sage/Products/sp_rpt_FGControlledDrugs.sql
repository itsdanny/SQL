USE [syslive]
GO
/****** Object:  StoredProcedure [dbo].[sp_rpt_ControlledDrugs]    Script Date: 30/07/2015 15:57:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO 
/*
	select * from ContDrugsImport where 1=1
	select * from scheme.stunitdm
	select distinct transaction_type from scheme.stkhstm order by transaction_type
	
	-- cols taken from the IG results
	SUM(SalesQty) AS SalesQty,
	SUM(Sales_g) AS Sales_g,
	
	SUM(RetailQty) AS RetailQty,
	SUM(Retail_g) AS Retail_g,
	SUM(UKQty) AS UKQty,
	SUM(UK_g) AS UK_g,
	SUM(OtherSalesQty) AS OtherSalesQty,
	SUM(OtherSales_g) AS OtherSales_g,
	SUM(ExportQty) AS ExportQty,
	SUM(Export_g) AS Export_g, 
	SUM(WorkOrderQty) AS WorkOrderQty, 
	SUM(AdjustmentQty) AS AdjustmentQty, 
	SUM(Adjustment_g) AS Adjustment_g, 
	SUM(CompletionQty) AS CompletionQty,
	SUM(movement_quantity) AS MovementQty,
	SUM(WorkOrderQty) AS WorkOrderQty, 
	SUM(AdjustmentQty) AS AdjustmentQty, 
	SUM(CompletionQty) AS CompletionQty,
	SUM(ReturnQty) AS ReturnQty, 
	SUM(Return_g) AS Return_g, 				
*/
ALTER PROCEDURE [dbo].[sp_rpt_FGControlledDrugs]
@FromDate	DATETIME = NULL,
@ToDate		DATETIME = NULL
AS

--SELECT  DATEADD(yy, DATEDIFF(yy,0,getdate())-1, 0),   DATEADD(yy, DATEDIFF(yy,0,getdate()), 0)-1
IF @FromDate IS NULL
SET @FromDate = DATEADD(yy, DATEDIFF(yy,0,getdate())-1, 0)

IF @ToDate IS NULL
SET @ToDate =  DATEADD(yy, DATEDIFF(yy,0,getdate()), 0)-1

DECLARE @CONTDRUGS  TABLE(Warehouse	 VARCHAR(2), 
						 Product		VARCHAR(10), 
						 BaseProductCode VARCHAR(8), 
						 BaseDescription VARCHAR(40), 
						 Alpha VARCHAR(10), 
						 unit_code VARCHAR(5), 
						 PackSize INT, 
						 LongDescription VARCHAR(40), 
						 analysis_c VARCHAR(10),
						 FGOpeningStock FLOAT DEFAULT 0.0,
						 FGClosingStock FLOAT DEFAULT 0.0,
						 FGOpeningStock_g FLOAT DEFAULT 0.0,
						 FGClosingStock_g FLOAT DEFAULT 0.0,
						 Base_g FLOAT DEFAULT 0.0,			
						 ReceiptsQty FLOAT DEFAULT 0.0,  
						 Receipts_g FLOAT DEFAULT 0.0,  
						 SalesQty FLOAT DEFAULT 0.0 , 						 
						 Sales_g FLOAT DEFAULT 0.0 ,  
						 WholesaleQty FLOAT DEFAULT 0.0 , 
						 Wholesale_g FLOAT DEFAULT 0.0 ,
						 RetailQty FLOAT DEFAULT 0.0 ,						  
						 Retail_g FLOAT DEFAULT 0.0 ,						
						 UKQty FLOAT DEFAULT 0.0 ,	
						 UK_g FLOAT DEFAULT 0.0 ,					 
						 OtherSalesQty FLOAT DEFAULT 0.0 ,						 
						 OtherSales_g FLOAT DEFAULT 0.0 ,
						 ExportQty	FLOAT DEFAULT 0.0 ,						 
						 Export_g	FLOAT DEFAULT 0.0 ,
						 OtherTransQty FLOAT DEFAULT 0.0 ,	
						 OtherTrans_g FLOAT DEFAULT 0.0 ,					 
						 ReturnQty	FLOAT DEFAULT 0.0 ,
						 Return_g	FLOAT DEFAULT 0.0 ,
						 Issue		FLOAT DEFAULT 0.0 ,		
						 Issue_g	FLOAT DEFAULT 0.0 ,				 
						 ScrapQty	FLOAT DEFAULT 0.0 , 
						 Scrap_g	FLOAT DEFAULT 0.0 ,						 
						 WorkOrderQty FLOAT DEFAULT 0.0 ,						 
						 WorkOrder_g FLOAT DEFAULT 0.0 ,
						 AdjustmentQty FLOAT DEFAULT 0.0 ,
						 Adjustment_g FLOAT DEFAULT 0.0 ,
						 CompletionQty FLOAT DEFAULT 0.0 ,
						 CompQty FLOAT DEFAULT 0.0 ,
						 Comp_g FLOAT DEFAULT 0.0 ,						
						 DKITQty FLOAT DEFAULT 0.0 ,
						 DKIT_g FLOAT DEFAULT 0.0 , 						 
						 movement_quantity FLOAT DEFAULT 0.0 , 						 
						 ReturnExportQty FLOAT DEFAULT 0.0 , 
						 ReturnUKQty FLOAT DEFAULT 0.0 , 
						 ReturnRetailQty FLOAT DEFAULT 0.0 ,
						 ReturnWholesaleQty FLOAT DEFAULT 0.0 ,
						 ReturnOthersQty FLOAT DEFAULT 0.0 , 
					     ReturnExport_g FLOAT DEFAULT 0.0 , 
						 ReturnUK_g FLOAT DEFAULT 0.0 ,
						 ReturnRetail_g FLOAT DEFAULT 0.0 , 
						 ReturnWholesale_g FLOAT DEFAULT 0.0 , 
						 ReturnOthers_g FLOAT DEFAULT 0.0 ,
						 KG_Usage FLOAT DEFAULT 0.0 , 
						 Grams_Usage FLOAT DEFAULT 0.0 , 
						 Miligram_Usage FLOAT)

-- USE THIS AS MAY WANT A TEMP PLACE TO WORK WITH THE DATA!
DECLARE @Returns TABLE(ReturnProduct VARCHAR(10), 
						ReturnExport FLOAT DEFAULT 0.0, 
						ReturnUK FLOAT DEFAULT 0.0, 
						ReturnRetail FLOAT DEFAULT 0.0, 
						ReturnWholesale FLOAT DEFAULT 0.0,
						ReturnOthers FLOAT DEFAULT 0.0, 
					    ReturnExport_g FLOAT DEFAULT 0.0,
						ReturnUK_g FLOAT DEFAULT 0.0, 
						ReturnRetail_g FLOAT DEFAULT 0.0, 
						ReturnWholesale_g FLOAT DEFAULT 0.0,
						ReturnOthers_g FLOAT DEFAULT 0.0)

PRINT 'GET THE CDs AND THEIR STOCK VALUES, AT THE START AND END'
INSERT INTO @CONTDRUGS(Warehouse, Product, Alpha, unit_code, LongDescription, BaseProductCode, BaseDescription, Base_g, PackSize, FGOpeningStock, FGClosingStock, FGOpeningStock_g, FGClosingStock_g) 
	SELECT		s.warehouse, FGCode, s.alpha, s.unit_code, c.FGProductDescription, IGCode, c.IGProductDescription, FGBase_g, u.spare, 
				scheme.fn_GetStockQuantity(c.FGCode, s.warehouse, @FromDate) AS FGOpeningStock, 
				scheme.fn_GetStockQuantity(c.FGCode, s.warehouse, @ToDate) AS FGClosingStock,
				scheme.fn_GetStockQuantity(c.FGCode, s.warehouse, @FromDate)*FGBase_g AS FGOpeningStock_g, 
				scheme.fn_GetStockQuantity(c.FGCode, s.warehouse, @ToDate)*FGBase_g AS FGClosingStock_g
	FROM		ContDrugsImport c 
	INNER JOIN	scheme.stockm s WITH(NOLOCK)
	ON			c.FGCode = s.product 
	INNER JOIN	scheme.stunitdm u WITH(NOLOCK)
	ON			s.unit_code = u.unit_code	
	WHERE		s.warehouse = 'FG'
--AND			c.IGCode IN ('040029')	
	--AND				c.FGCode IN ('024716','073474','024724')	

PRINT 'GET THE RECIPTS AND OTHER TRANS'
UPDATE		c
SET			c.ReceiptsQty = x.ReceiptsQty,
			c.Receipts_g = x.ReceiptsQty * c.Base_g,
			c.SalesQty = x.Sale,
			c.Sales_g = x.Sale * c.Base_g,
			c.ReturnQty = x.Returns,
			c.Return_g = x.Returns * c.Base_g,
			c.Issue = x.Issues,
			c.Issue_g = x.Issues * c.Base_g,
			c.ScrapQty = x.Scrap,
			c.Scrap_g = x.Scrap * c.Base_g,
			c.AdjustmentQty = x.Adjustment,
			c.Adjustment_g = x.Adjustment * c.Base_g,
			c.OtherTransQty = x.Other_Tran_Types,
			c.OtherTrans_g = x.Other_Tran_Types * c.Base_g		
FROM		@CONTDRUGS c
INNER JOIN	(SELECT		 
			 SUM(CASE WHEN transaction_type IN ('RECP','COMP','DKIT','GRN','RWRK') THEN (movement_quantity) else 0 END) AS ReceiptsQty
			,SUM(CASE transaction_type WHEN 'SALE' THEN (movement_quantity) else 0 END)*-1 AS Sale
			,SUM(CASE WHEN transaction_type IN ('RETN','RINV') THEN (movement_quantity) else 0 END) AS Returns
			,SUM(CASE transaction_type WHEN 'ISSU' THEN (movement_quantity) else 0 END) * -1 AS Issues
			,SUM(CASE transaction_type WHEN 'SCRP' THEN (movement_quantity) else 0 END) * -1 AS Scrap
			,SUM(CASE transaction_type WHEN 'ADJ' THEN (movement_quantity) else 0 END) AS Adjustment			
			,SUM(CASE WHEN transaction_type IN ('DESP','PROD','TRAN') THEN movement_quantity else 0 END) AS Other_Tran_Types
			,sh.product			
FROM		scheme.stkhstm sh WITH(NOLOCK)
WHERE		sh.dated BETWEEN @FromDate AND @ToDate
AND			sh.warehouse ='IG'
GROUP BY	sh.product) x
ON			c.Product = x.product

PRINT 'GET THE VARIOUS SALES TYPES'
UPDATE		c
SET			c.WholesaleQty = b.Wholesale, 
			c.Wholesale_g = c.Base_g * b.Wholesale,
			c.RetailQty = b.Retail, 
			c.Retail_g = c.Base_g * b.Retail,
			c.UKQty = b.UK, 
			c.UK_g = c.Base_g * b.UK,
			c.ExportQty = b.Export, 
			c.Export_g= c.Base_g * b.Export,
			c.OtherSalesQty = b.Others,
			c.OtherSales_g = c.Base_g * b.Others			  
FROM		@CONTDRUGS c
INNER JOIN ( SELECT 		
		 	 opd.product,
		 	 opd.warehouse,		  
			 SUM(CASE WHEN oph.customer >='T000001' AND oph.customer <= 'T009999' THEN opd.despatched_qty END) AS Export
			,SUM(CASE WHEN oph.customer >='T000001' AND oph.customer <= 'T009999' THEN 0 else opd.despatched_qty END) AS UK
			,SUM(CASE WHEN sl.class IN ('01','02','04','05','06','13','16','') THEN opd.despatched_qty END) AS Retail
			,SUM(CASE WHEN sl.class IN ('03','07','09','17') THEN opd.despatched_qty END) AS Wholesale
			,SUM(CASE WHEN sl.class IN ('08','10','11','12','00','99') THEN opd.despatched_qty END) AS Others
			,SUM(CASE WHEN oph.transaction_anals3 IN ('EXP') THEN opd.despatched_qty END) AS EXPCustomers
			,SUM(CASE WHEN oph.transaction_anals3 IN ('') THEN opd.despatched_qty END) AS UKCustomers			
FROM		syslive.scheme.opdetm opd with(NOLOCK)
INNER JOIN	syslive.scheme.opheadm oph with(NOLOCK)
ON			opd.order_no = oph.order_no
INNER JOIN	scheme.slcustm sl with(NOLOCK)
ON			oph.customer = sl.customer
WHERE		oph.date_despatched BETWEEN @FromDate AND @ToDate
GROUP BY	opd.warehouse, opd.product) b
ON			c.Product = b.product
AND			c.Warehouse = b.warehouse

PRINT 'UPDATE SALES TYPE AND RETURNS TYPE QTY'
INSERT INTO  @Returns (ReturnProduct, ReturnExport, ReturnUK, ReturnRetail, ReturnWholesale, ReturnOthers)
SELECT		 s.product,
			 SUM(CASE WHEN sl.customer >='T000001' AND sl.customer <= 'T009999' THEN movement_quantity END) AS ReturnExport
			,SUM(CASE WHEN sl.customer >='T000001' AND sl.customer <= 'T009999' THEN 0 else movement_quantity END) AS ReturnUK
			,SUM(CASE WHEN sl.class IN ('01','02','04','05','06','13','16','') THEN movement_quantity END) AS ReturnRetail
			,SUM(CASE WHEN sl.class IN ('03','07','09','17') THEN  movement_quantity END) AS ReturnWholesale
			,SUM(CASE WHEN sl.class IN ('08','10','11','12','00','99') THEN movement_quantity END) AS ReturnOthers
FROM		Integrate.dbo.SalesOrderHeader ih
INNER JOIN	Integrate.dbo.SalesOrderLine il
ON			ih.Id = il.SalesOrderHeaderId
INNER JOIN	scheme.stkhstm s
ON			'TNR'+s.comments = ih.OrderNumber
AND			s.product = il.ProductCode
INNER JOIN	ContDrugsImport c
ON			s.product = c.FGCode
INNER JOIN	scheme.slcustm sl WITH(NOLOCK)
ON			ih.CustomerAccountNumber = sl.customer
WHERE		ih.SaleOrderTypeId in (3)
AND			s.transaction_type  IN('RETN','RINV')
AND			s.dated BETWEEN @FromDate AND @ToDate
GROUP BY	s.product

PRINT 'GET THE VARIOUS RETURN TYPES'
UPDATE		c	
SET			c.ReturnExportQty = ISNULL(r.ReturnExport, 0),
			c.ReturnRetailQty = ISNULL(r.ReturnRetail, 0),			
			c.ReturnWholesaleQty = ISNULL(r.ReturnWholesale, 0),
			c.ReturnOthersQty = ISNULL(r.ReturnOthers, 0),
			c.ReturnExport_g = ISNULL(c.Base_g * r.ReturnExport, 0),
			c.ReturnRetail_g = ISNULL(c.Base_g * r.ReturnRetail, 0),
			c.ReturnWholesale_g = ISNULL(c.Base_g * r.ReturnWholesale, 0),
			c.ReturnOthers_g = ISNULL(c.Base_g * r.ReturnOthers, 0)			
FROM		@Returns r
INNER JOIN	@CONTDRUGS c
ON			r.ReturnProduct = c.Product

/* TAKE ANY RETURNS OFF THE SALES WITH THE MOST SOLD */
SELECT		Product, (ReturnQty - (ReturnExportQty+ReturnOthersQty+ReturnRetailQty+ReturnWholesaleQty)) AS Excess INTO #Overs
FROM		@CONTDRUGS c
GROUP BY	Product, ReturnQty, ReturnExportQty, ReturnOthersQty, ReturnRetailQty, ReturnWholesaleQty
HAVING		ReturnQty > (ReturnExportQty+ReturnOthersQty+ReturnRetailQty+ReturnWholesaleQty)

UPDATE		c
SET			c.WholesaleQty = c.WholesaleQty - r.Excess, 
			c.ReturnOthersQty = r.Excess,
			c.ReturnOthers_g = (c.Base_g *r.Excess)
FROM		#Overs r
INNER JOIN	@CONTDRUGS c
ON			r.Product = c.Product
WHERE		c.WholesaleQty > c.RetailQty

UPDATE		c
SET			c.RetailQty = c.WholesaleQty - r.Excess,
			c.ReturnOthersQty = r.Excess,
			c.ReturnOthers_g = (c.Base_g *r.Excess)
FROM		#Overs r
INNER JOIN	@CONTDRUGS c
ON			r.Product = c.Product
WHERE		c.RetailQty > c.WholesaleQty 

PRINT	'RETURN THE RESULTS'
	SELECT		@FromDate AS FromDate, 
				@ToDate AS ToDate,
				Product,
				LongDescription, 
				BaseProductCode, 
				BaseDescription,
				SUM(FGOpeningStock) AS FGOpeningStock,
				SUM(FGClosingStock) AS FGClosingStock,
				SUM(FGOpeningStock) AS FGOpeningStock_g,
				SUM(FGClosingStock) AS FGClosingStock_g,
				SUM(ReceiptsQty) AS ReceiptsQty, 
				SUM(SalesQty) AS SalesQty,
				SUM(WholesaleQty) AS WholesaleQty,
				SUM(RetailQty) AS RetailQty,				
				SUM(OtherSalesQty) AS OtherSalesQty,
				SUM(ExportQty) AS ExportQty,				
				SUM(ReturnQty) AS ReturnsQty,
				SUM(ReturnRetailQty) AS ReturnsRetailQty,
				SUM(ReturnWholesaleQty) AS ReturnWholesaleQty,
				SUM(ReturnExportQty) AS ReturnExportQty,				
				SUM(ReturnOthersQty) AS ReturnOthersQty,
				SUM(Issue) AS IssueQty, 
				SUM(ScrapQty) AS ScrapQty, 
				SUM(AdjustmentQty) AS AdjustmentQty,				
				SUM(OtherTransQty) AS OtherTransQty,				
				SUM(Receipts_g) AS Receipts_g, 
				SUM(Sales_g) AS Sales_g,				
				(SUM(Retail_g) - SUM(ReturnRetail_g)) AS Retail_g,					
				(SUM(Wholesale_g) - SUM(ReturnWholesale_g)) AS Wholesale_g,				
				SUM(OtherSales_g) AS OtherSales_g,
				(SUM(Export_g) - SUM(ReturnExport_g)) AS Export_g, 								
				SUM(Return_g) AS Returns_g,
				SUM(ReturnRetail_g) AS ReturnRetail_g,
				SUM(ReturnWholesale_g) AS ReturnWholesale_g,
				SUM(ReturnExport_g) AS ReturnExport_g,		
				SUM(ReturnOthers_g) AS ReturnOthers_g,								
				SUM(Issue_g) AS Issue_g, 
				SUM(Scrap_g) AS Scrap_g, 
				SUM(Adjustment_g) AS Adjustment_g,
				SUM(OtherTrans_g) AS OtherTrans_g
	FROM		@CONTDRUGS
	GROUP BY	Product, LongDescription,BaseProductCode, BaseDescription
	ORDER BY	LongDescription

GO

[sp_rpt_FGControlledDrugs] '2015-01-01', '2015-09-30'

return 
/*
--SELECT		ih.CustomerAccountNumber, CustomerType, to_bin_number, batch_number, lot_number, movement_quantity
SELECT		movement_quantity
FROM		Integrate.dbo.SalesOrderHeader ih
INNER JOIN	Integrate.dbo.SalesOrderLine il
ON			ih.Id = il.SalesOrderHeaderId
INNER JOIN	scheme.stkhstm s
ON			'TNR'+s.comments = OrderNumber
AND			s.product = il.ProductCode
INNER JOIN	ContDrugsImport c
ON			s.product = c.FGCode
WHERE		ih.SaleOrderTypeId in (3)
AND			s.transaction_type = 'RETN'
AND			s.dated between '2014-01-01' and '2014-12-31'


GO
--select *, Mass* g_lt*Base_g from ContDrugsImport where 1=1
--UPDATE ContDrugsImport SET FGBase_g = round(Mass* g_lt*Base_g, 3) where 1=1

select * FROM scheme.stkhstm sh WITH(NOLOCK) where batch_number  =  'RJJ38' order by dated 

select * FROM scheme.stkhstm sh WITH(NOLOCK) where comments = 'RET2A190825' 



select * FROM scheme.stkhstm sh WITH(NOLOCK) where transaction_type = 'RETN' AND dated > '2014-01-01' AND movement_quantity > 2000 order by dated 
select * FROM scheme.stkhstm sh WITH(NOLOCK) where lot_number IN ('160L90R', '160L91R', '160L92R', '159H90R', '159H91R') order by dated 
select * FROM scheme.stkhstm sh WITH(NOLOCK) where lot_number IN ('160L90', '160L91', '160L92', '159H90', '159H91') order by dated 
select * FROM scheme.stkhstm sh WITH(NOLOCK) where batch_number LIKE '%01674' AND product = '073431' order by dated 
select * FROM scheme.stkhstm sh WITH(NOLOCK) where movement_quantity =5948 order by dated 
select * FROM scheme.stkhstm sh WITH(NOLOCK) where product = '073431' AND transaction_type = 'SALE' order by dated 
*/

 select * FROM scheme.stkhstm sh WITH(NOLOCK) where lot_number like 'LS12%' order by dated desc, lot_number 