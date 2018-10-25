/*
	select * from ContDrugsImport
	select * from scheme.stunitdm
*/

ALTER PROCEDURE sp_rpt_ControlledDrugs
@FromDate	DATETIME = NULL,
@ToDate		DATETIME = NULL,
@WH			INT = NULL
AS

IF @FromDate IS NULL
SET @FromDate = DATEADD(MONTH, DATEDIFF(MONTH, '20500101', DATEADD(MONTH, -1, GETDATE())), '20500101')

IF @ToDate IS NULL
SET @ToDate = DATEADD(MONTH, DATEDIFF(MONTH, '20500131', DATEADD(MONTH, -1, GETDATE())), '20500131')

DECLARE @CONTDRUGS  TABLE(Warehouse VARCHAR(2), Product VARCHAR(10), BaseProductCode VARCHAR(8), BaseDescription VARCHAR(40), Alpha VARCHAR(10), unit_code VARCHAR(5), PackSize INT, long_description VARCHAR(40), 
						 analysis_c VARCHAR(10),
						 Base_g FLOAT,			
						 Receipts FLOAT,  
						 BaseDrugReceipts_g FLOAT,  
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
						 Other_Tran_TypesQty FLOAT,
						 Other_Tran_Types_g	FLOAT,
						 WorkOrderQty FLOAT,						 
						 AdjustmentQty FLOAT,
						 Adjustment_g FLOAT,
						 CompletionQty FLOAT, 						 
						 movement_quantity FLOAT, 
						 KG_Usage FLOAT, Grams_Usage FLOAT, Miligram_Usage FLOAT)

INSERT INTO @CONTDRUGS(Warehouse, Product, Alpha, unit_code, long_description, BaseProductCode, BaseDescription, Base_g, PackSize) 
SELECT		s.warehouse, FGCode, s.alpha, s.unit_code, s.long_description, IGCode, c.BaseDrugDescription, Base_g, u.spare
FROM		ContDrugsImport c 
INNER JOIN	scheme.stockm s with(NOLOCK)
ON			c.FGCode = s.product 
INNER JOIN	scheme.stunitdm u with(NOLOCK)
ON			s.unit_code = u.unit_code
WHERE		s.warehouse = 'FG' 
--AND			c.FGCode IN ('073709','040029')

UPDATE		c
SET			c.Receipts = x.Receipts,
			c.BaseDrugReceipts_g = x.Receipts * c.Base_g,
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
			c.OtherTransQty  = x.Other_Tran_Types,
			c.Other_Tran_Types_g  = x.Other_Tran_Types * c.Base_g
FROM		@CONTDRUGS c
INNER JOIN	(SELECT		 
			   SUM(CASE WHEN transaction_type in ('RECP','COMP','DKIT') THEN (movement_quantity) else 0 END) AS Receipts
			  ,SUM(CASE transaction_type WHEN 'SALE' THEN (movement_quantity) else 0 END) *-1 AS Sale
			  ,SUM(CASE transaction_type WHEN 'RETN' THEN (movement_quantity) else 0 END) AS Returns
			  ,SUM(CASE transaction_type WHEN 'ISSU' THEN (movement_quantity) else 0 END) AS Issues
			  ,SUM(CASE transaction_type WHEN 'SCRP' THEN (movement_quantity) else 0 END) AS Scrap
			  ,SUM(CASE transaction_type WHEN 'ADJ' THEN (movement_quantity) else 0 END) AS Adjustment
			  ,SUM(CASE WHEN transaction_type IN ('W/O','BINT','DESP','GRN','PROD','RINV','RWRK','SRET','TRAN') THEN movement_quantity else 0 END) AS Other_Tran_Types
			  ,SUM(sh.movement_quantity) AS adj
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
INNER JOIN (	SELECT 		
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
WHERE		oph.date_despatched BETWEEN @FromDate AND  @ToDate
GROUP BY	opd.warehouse, opd.product) b
ON			c.Product = b.product
AND			c.Warehouse = b.warehouse

IF @WH = 0 
BEGIN
	PRINT 'Return FG'
	SELECT @FromDate as FromDate, @ToDate as ToDate, * FROM @CONTDRUGS
END
ELSE IF @WH = 1
BEGIN
	PRINT 'Return IG'
	SELECT @FromDate as FromDate, @ToDate as ToDate, Warehouse, BaseProductCode, BaseDescription,-- unit_code, long_description, analysis_c, Base_g, 
	SUM(Receipts) AS Receipts,
	SUM(BaseDrugReceipts_g) AS BaseDrugReceipts_g,
	SUM(SalesQty) AS SalesQty,
	SUM(Sales_g) AS Sales_g,
	SUM(WholesaleQty) AS WholesaleQty,
	SUM(Wholesale_g) AS Wholesale_g,
	SUM(RetailQty) AS RetailQty,
	SUM(Retail_g) AS Retail_g,
	SUM(UKQty) AS UKQty,
	SUM(UK_g) AS UK_g,
	SUM(OtherSalesQty) AS OtherSalesQty,
	SUM(OtherSales_g) AS OtherSales_g,
	SUM(ExportQty) AS ExportQty,
	SUM(Export_g) AS Export_g, 
	SUM(OtherTransQty) AS OtherTransQty,
	SUM(OtherTrans_g) AS OtherTrans_g, SUM(ReturnQty) AS ReturnQty, SUM(Return_g) AS Return_g, SUM(Issue) AS Issue, 
	SUM(Issue_g) AS Issue_g, SUM(ScrapQty) AS ScrapQty, SUM(Scrap_g) AS Scrap_g, SUM(Other_Tran_TypesQty) AS Other_Tran_TypesQty, SUM(Other_Tran_Types_g) AS Other_Tran_Types_g, 
	SUM(WorkOrderQty) AS WorkOrderQty, SUM(AdjustmentQty) AS AdjustmentQty, SUM(Adjustment_g) AS Adjustment_g, SUM(CompletionQty) AS CompletionQty, SUM(movement_quantity) AS movement_quantity
	FROM		@CONTDRUGS
	GROUP BY	Warehouse, BaseProductCode, BaseDescription--, Alpha, unit_code, PackSize, long_description, analysis_c, Base_g 
 END
go

exec sp_rpt_ControlledDrugs @WH=0

--	SELECT DISTINCT transaction_type from scheme.stkhstm sh with(NOLOCK) order by transaction_type

--select DISTINCT transaction_type from scheme.stkhstm sh with(NOLOCK) where product = '073709'
--ORDER BY dated DESC