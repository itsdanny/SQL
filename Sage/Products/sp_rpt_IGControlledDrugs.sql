USE [syslive]
GO
/****** Object:  StoredProcedure [dbo].[sp_rpt_ControlledDrugs]    Script Date: 30/07/2015 15:57:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO 


ALTER PROCEDURE [dbo].[sp_rpt_IGControlledDrugs]
@FromDate	DATETIME = NULL,
@ToDate		DATETIME = NULL
AS


IF @FromDate IS NULL
SET @FromDate = DATEADD(yy, DATEDIFF(yy,0,getdate())-1, 0)

IF @ToDate IS NULL
SET @ToDate = DATEADD(yy, DATEDIFF(yy,0,getdate()), 0)-1

DECLARE @CONTDRUGS  TABLE(Warehouse		VARCHAR(2), 
						 Product		VARCHAR(10), 
						 LongDescription VARCHAR(40), 
						 Alpha			VARCHAR(10), 
						 unit_code		VARCHAR(5), 
						 IGOpeningStock FLOAT,
						 IGClosingStock FLOAT,
						 IGOpeningStock_g FLOAT,
						 IGClosingStock_g FLOAT,
						 Base_g			FLOAT,
						 PackSize		INT, 
						 GramLitre		FLOAT,						 
						 ReceiptsQty	FLOAT,  
						 Receipts_g		FLOAT,  						
						 OtherTransQty	FLOAT,	
						 OtherTrans_g	FLOAT,					 						 
						 Issue			FLOAT,		
						 Issue_g		FLOAT,				 
						 ScrapQty		FLOAT, 
						 Scrap_g		FLOAT,						 
						 WorkOrderQty	FLOAT,						 
						 WorkOrder_g	FLOAT,
						 AdjustmentQty	FLOAT,
						 Adjustment_g	FLOAT,
						 CompletionQty	FLOAT,
						 CompQty		FLOAT,
						 Comp_g			FLOAT,						
						 DKITQty		FLOAT,
						 DKIT_g			FLOAT)

--	SELECT * FROM		ContDrugsImport c 

INSERT INTO @CONTDRUGS(Warehouse, Product, LongDescription, Alpha, unit_code, Base_g, GramLitre, IGOpeningStock, IGClosingStock, IGOpeningStock_g, IGClosingStock_g) 
SELECT		DISTINCT s.warehouse, IGCode, c.IGProductDescription, s.alpha, UPPER(s.unit_code) AS unit_code, Base_g,
			CASE UPPER(s.unit_code) WHEN 'KG' THEN 1000 WHEN 'G' THEN 1 ELSE u.spare END,
				ROUND(scheme.fn_GetStockQuantity(c.IGCode, s.warehouse, @FromDate),5) AS IGOpeningStock, 
				ROUND(scheme.fn_GetStockQuantity(c.IGCode, s.warehouse, @ToDate),5) AS IGClosingStock,
				ROUND(scheme.fn_GetStockQuantity(c.IGCode, s.warehouse, @FromDate),5) * Base_g AS IGOpeningStock_g, 
				ROUND(scheme.fn_GetStockQuantity(c.IGCode, s.warehouse, @ToDate),5) * Base_g AS IGClosingStock_g
FROM		ContDrugsImport c 
INNER JOIN	scheme.stockm s WITH(NOLOCK)
ON			c.IGCode = s.product 
INNER JOIN	scheme.stunitdm u WITH(NOLOCK)
ON			s.unit_code = u.unit_code
WHERE		s.warehouse = 'IG' 
--AND			c.IGCode IN ('105588')
 
PRINT 'FG Qty and Grams'
UPDATE		c
SET			c.ReceiptsQty = x.ReceiptsQty,
			c.Issue = x.Issues,
			c.ScrapQty = x.Scrap,
			c.OtherTransQty = x.Other_Tran_Types,
			c.WorkOrderQty = x.WorkOrders,
			c.CompQty = x.Comps,
			c.DKITQty = x.DKITs,
			c.Receipts_g = x.ReceiptsQty * c.GramLitre * c.Base_g,
			c.Issue_g = x.Issues * c.GramLitre * c.Base_g,
			c.Scrap_g = x.Scrap * c.GramLitre * c.Base_g,			
			c.OtherTrans_g = x.Other_Tran_Types * c.GramLitre * c.Base_g,
			c.WorkOrder_g = x.WorkOrders * c.GramLitre * c.Base_g,
			c.Comp_g = x.Comps * c.GramLitre * c.Base_g,
			c.DKIT_g = x.DKITs * c.GramLitre * c.Base_g
--select *
FROM		@CONTDRUGS c
INNER JOIN	(SELECT		 
			 SUM(CASE WHEN transaction_type IN ('RECP','SRET') THEN (movement_quantity) else 0 END) AS ReceiptsQty
			,SUM(CASE transaction_type WHEN 'ISSU' THEN (movement_quantity) ELSE 0 END)*-1 AS Issues
			,SUM(CASE transaction_type WHEN 'SCRP' THEN (movement_quantity) ELSE 0 END)*-1 AS Scrap			
			,SUM(CASE transaction_type WHEN 'COMP' THEN (movement_quantity) ELSE 0 END) AS Comps
			,SUM(CASE transaction_type WHEN 'DKIT' THEN (movement_quantity) ELSE 0 END) AS DKITs
			,SUM(CASE transaction_type WHEN 'W/O' THEN (movement_quantity) ELSE 0 END) AS WorkOrders
			,SUM(CASE WHEN transaction_type IN ('DESP','GRN','PROD','RINV','RWRK','TRAN') THEN movement_quantity ELSE 0 END) AS Other_Tran_Types			  
			,sh.product
FROM		scheme.stkhstm sh WITH(NOLOCK)
WHERE		sh.dated BETWEEN @FromDate AND @ToDate
AND			sh.warehouse in ('FG','IG')
GROUP BY	sh.product) x
ON			c.Product = x.product



PRINT	'Return IG'
SELECT		@FromDate as FromDate, 
			@ToDate as ToDate, 
			Product,
			LongDescription,		
			SUM(IGOpeningStock) AS IGOpeningStock,
			SUM(IGClosingStock) AS IGClosingStock,
			SUM(IGOpeningStock_g) AS IGOpeningStock_g,
			SUM(IGClosingStock_g) AS IGClosingStock_g,
			SUM(ReceiptsQty) AS ReceiptsQty,
			SUM(Issue) AS IssueQty, 
			SUM(ScrapQty) AS ScrapQty, 
			SUM(CompQty) AS CompQty, 
			SUM(DKITQty) AS DKITQty,	
			SUM(OtherTransQty) AS OtherTransQty,								
			SUM(Receipts_g) AS Receipts_g,
			SUM(Issue_g) AS Issue_g, 
			SUM(Scrap_g) AS Scrap_g, 
			SUM(Comp_g) AS Comp_g, 
			SUM(DKIT_g) AS DKIT_g,
			SUM(OtherTrans_g) AS OtherTrans_g
FROM		@CONTDRUGS
GROUP BY	Product, LongDescription
ORDER BY	LongDescription

GO
/*
	[sp_rpt_FGControlledDrugs] '2014-01-01','2014-12-31'
	GO
	[sp_rpt_IGControlledDrugs] '2015-01-01','2015-09-30'

	[sp_rpt_FGControlledDrugs] 
	GO

*/

	[sp_rpt_IGControlledDrugs] 
