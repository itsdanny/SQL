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
CREATE PROCEDURE [dbo].[sp_rpt_FGControlledDrugs]
@FromDate	DATETIME = NULL,
@ToDate		DATETIME = NULL
AS


IF @FromDate IS NULL
SET @FromDate = DATEADD(MONTH, DATEDIFF(MONTH, '20500101', DATEADD(MONTH, -1, GETDATE())), '20500101')

IF @ToDate IS NULL
SET @ToDate = DATEADD(MONTH, DATEDIFF(MONTH, '20500131', DATEADD(MONTH, -1, GETDATE())), '20500131')

DECLARE @CONTDRUGS  TABLE(Warehouse VARCHAR(2), Product VARCHAR(10), BaseProductCode VARCHAR(8), BaseDescription VARCHAR(40), Alpha VARCHAR(10), unit_code VARCHAR(5), PackSize INT, long_description VARCHAR(40), 
						 analysis_c VARCHAR(10),
						 Base_g FLOAT,			
						 ReceiptsQty FLOAT,  
						 Receipts_g FLOAT,  
						 SalesQty FLOAT, 						 
						 Sales_g FLOAT,  
						 WholesaleQty FLOAT, 
						 Wholesale_g FLOAT,
						 RetailQty FLOAT,						  
						 Retail_g FLOAT,						
						 UKQty FLOAT,	
						 UK_g FLOAT,					 
						 OtherSalesQty FLOAT,						 
						 OtherSales_g FLOAT,
						 ExportQty	FLOAT,						 
						 Export_g	FLOAT,
						 OtherTransQty FLOAT,	
						 OtherTrans_g FLOAT,					 
						 ReturnQty	FLOAT,
						 Return_g	FLOAT,
						 Issue		FLOAT,		
						 Issue_g	FLOAT,				 
						 ScrapQty	FLOAT, 
						 Scrap_g	FLOAT,						 
						 WorkOrderQty FLOAT,						 
						 WorkOrder_g FLOAT,
						 AdjustmentQty FLOAT,
						 Adjustment_g FLOAT,
						 CompletionQty FLOAT,
						 CompQty FLOAT,
						 Comp_g FLOAT,						
						 DKITQty FLOAT,
						 DKIT_g FLOAT, 						 
						 movement_quantity FLOAT, 
						 KG_Usage FLOAT, Grams_Usage FLOAT, Miligram_Usage FLOAT)


	INSERT INTO @CONTDRUGS(Warehouse, Product, Alpha, unit_code, long_description, BaseProductCode, BaseDescription, Base_g, PackSize) 
	SELECT		s.warehouse, FGCode, s.alpha, s.unit_code, c.FGProductDescription, IGCode, c.IGProductDescription, FGBase_g, u.spare
	FROM		ContDrugsImport c 
	INNER JOIN	scheme.stockm s WITH(NOLOCK)
	ON			c.FGCode = s.product 
	INNER JOIN	scheme.stunitdm u WITH(NOLOCK)
	ON			s.unit_code = u.unit_code	
--	WHERE		c.IGCode IN ('073709')
	AND			s.warehouse = 'FG'


-- FG Qty and Grams
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
			 SUM(CASE WHEN transaction_type IN ('RECP','COMP','DKIT') THEN (movement_quantity) else 0 END) AS ReceiptsQty
			,SUM(CASE transaction_type WHEN 'SALE' THEN (movement_quantity) else 0 END)*-1 AS Sale
			,SUM(CASE transaction_type WHEN 'RETN' THEN (movement_quantity) else 0 END) AS Returns
			,SUM(CASE transaction_type WHEN 'ISSU' THEN (movement_quantity) else 0 END) AS Issues
			,SUM(CASE transaction_type WHEN 'SCRP' THEN (movement_quantity) else 0 END) AS Scrap
			,SUM(CASE transaction_type WHEN 'ADJ' THEN (movement_quantity) else 0 END) AS Adjustment			
			,SUM(CASE WHEN transaction_type IN ('BINT','DESP','GRN','PROD','RINV','RWRK','TRAN') THEN movement_quantity else 0 END) AS Other_Tran_Types			  
			,sh.product
FROM		scheme.stkhstm sh WITH(NOLOCK)
WHERE		sh.dated BETWEEN @FromDate AND @ToDate
GROUP BY	sh.product) x
ON			c.Product = x.product

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
FROM		syslive.scheme.opdetm opd with(NOLOCK)
INNER JOIN	syslive.scheme.opheadm oph with(NOLOCK)
ON			opd.order_no = oph.order_no
INNER JOIN	scheme.slcustm sl with(NOLOCK)
ON			oph.customer = sl.customer
WHERE		oph.date_despatched BETWEEN @FromDate AND @ToDate
GROUP BY	opd.warehouse, opd.product) b
ON			c.Product = b.product
AND			c.Warehouse = b.warehouse


	PRINT	'Return FG'
	SELECT		@FromDate as FromDate, 
				@ToDate as ToDate, 				
				Product,
				long_description, 
				SUM(ReceiptsQty) AS ReceiptsQty, 
				SUM(SalesQty) AS SalesQty,
				SUM(WholesaleQty) AS WholesaleQty,
				SUM(RetailQty) AS RetailQty,
				SUM(UKQty) AS UKQty,
				SUM(OtherSalesQty) AS OtherSalesQty,
				SUM(ExportQty) AS ExportQty,				
				SUM(ReturnQty) AS ReturnsQty,
				SUM(Issue) AS IssueQty, 
				SUM(ScrapQty) AS ScrapQty, 
				SUM(AdjustmentQty) AS AdjustmentQty,				
				SUM(OtherTransQty) AS OtherTransQty,				
				SUM(Receipts_g) AS Receipts_g, 
				SUM(Sales_g) AS Sales_g,				
				SUM(Wholesale_g) AS Wholesale_g,				
				SUM(Retail_g) AS Retail_g,
				SUM(UK_g) AS UK_g,				
				SUM(OtherSales_g) AS OtherSales_g,
				SUM(Export_g) AS Export_g, 								
				SUM(Return_g) as Returns_g,
				SUM(Issue_g) AS Issue_g, 
				SUM(Scrap_g) AS Scrap_g, 
				SUM(Adjustment_g) AS Adjustment_g,
				SUM(OtherTrans_g) AS OtherTrans_g
	FROM		@CONTDRUGS
	GROUP BY	Product, long_description
	ORDER BY	long_description

GO

[sp_rpt_FGControlledDrugs] '2014-01-01','2014-12-31'
GO
