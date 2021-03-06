USE [syslive]
GO
/****** Object:  StoredProcedure [dbo].[sp_rpt_supplier_recs_by_product_monthly]    Script Date: 27/01/2015 15:54:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		Dan McGregor
-- Create date: 11/11/2014
-- Description:	taken from sp_rpt_supplier_recs_by_product
-- Changed the months to be Jan-Dec rather than the old period thing

-- =============================================
ALTER  PROCEDURE [dbo].[sp_rpt_supplier_recs_by_product_monthly]

@supplier varchar(10) = null,
@product varchar(10),
@year int = null

--	sp_rpt_supplier_recs_by_product_dan 'T0350', '100756'
--	sp_rpt_supplier_recs_by_product_monthly_test NULL, '100756'
AS
BEGIN
	SET NOCOUNT ON;

	IF @year IS NULL
	BEGIN
		SET @year = 0
	END
	DECLARE @Month1Start DateTime;
	DECLARE @Month1End DateTime;
	SET @Month1Start = (DATEADD(YEAR, @year,(select dbo.fn_StartOfYear())))
	SET @Month1End = (DATEADD(day, -1, DATEADD(month, 1, @Month1Start)));
	
	DECLARE @Month2Start DateTime;
	DECLARE @Month2End DateTime;
	SET @Month2Start = DATEADD(month, 1, @Month1Start);
	SET @Month2End = (DATEADD(day, -1, DATEADD(month, 2, @Month1Start)));

	DECLARE @Month3Start DateTime;
	DECLARE @Month3End DateTime;
	SET @Month3Start = DATEADD(month, 2, @Month1Start);
	SET @Month3End = (DATEADD(day, -1, DATEADD(month, 3, @Month1Start)));

	DECLARE @Month4Start DateTime;
	DECLARE @Month4End DateTime;
	SET @Month4Start =  DATEADD(month, 3, @Month1Start);
	SET @Month4End = (DATEADD(day, -1, DATEADD(month, 4, @Month1Start)));

	DECLARE @Month5Start DateTime;
	DECLARE @Month5End DateTime;
	SET @Month5Start =  DATEADD(month, 4, @Month1Start);
	SET @Month5End = (DATEADD(day, -1, DATEADD(month, 5, @Month1Start)));

	DECLARE @Month6Start DateTime;
	DECLARE @Month6End DateTime;
	SET @Month6Start =  DATEADD(month, 5, @Month1Start);
	SET @Month6End = (DATEADD(day, -1, DATEADD(month, 6, @Month1Start)));

	DECLARE @Month7Start DateTime;
	DECLARE @Month7End DateTime;
	SET @Month7Start = DATEADD(month, 6, @Month1Start);
	SET @Month7End = (DATEADD(day, -1, DATEADD(month, 7, @Month1Start)));

	DECLARE @Month8Start DateTime;
	DECLARE @Month8End DateTime;
	SET @Month8Start =  DATEADD(month, 7, @Month1Start);
	SET @Month8End = (DATEADD(day, -1, DATEADD(month, 8, @Month1Start)));

	DECLARE @Month9Start DateTime;
	DECLARE @Month9End DateTime;
	SET @Month9Start = DATEADD(month, 8, @Month1Start);
	SET @Month9End = (DATEADD(day, -1, DATEADD(month, 9, @Month1Start)));

	DECLARE @Month10Start DateTime;
	DECLARE @Month10End DateTime;
	SET @Month10Start =  DATEADD(month, 9, @Month1Start);
	SET @Month10End = (DATEADD(day, -1, DATEADD(month, 10, @Month1Start)));

	DECLARE @Month11Start DateTime;
	DECLARE @Month11End DateTime;
	SET @Month11Start =  DATEADD(month, 10, @Month1Start);
	SET @Month11End = (DATEADD(day, -1, DATEADD(month, 11, @Month1Start)));

	DECLARE @Month12Start DateTime;
	DECLARE @Month12End DateTime;
	SET @Month12Start = DATEADD(month, 11, @Month1Start);
	SET @Month12End = (DATEADD(day, -1, DATEADD(month, 12, @Month1Start)));

	--select @Month1Start, @Month1End,  @Month2Start, @Month2End, @Month3Start, @Month3End, @Month4Start, @Month4End, @Month5Start, @Month5End, @Month6Start, @Month6End, @Month7Start, @Month7End, @Month8Start, @Month8End, @Month9Start, @Month9End, @Month10Start, @Month10End, @Month11Start, @Month11End, @Month12Start, @Month12End;


	WITH SupplierRecsByProduct (warehouse, product, product_description, order_date, amended_date, supplier, supplier_name, reorder_days, unit_code, order_line, quantity_required) AS
	(
		SELECT      scheme.stockm.warehouse, scheme.stockm.product, scheme.stockm.long_description, scheme.mrmrprm.order_date, scheme.mrmrprm.amended_date, scheme.stockm.supplier, scheme.plsuppm.name, 
                    scheme.stockm.reorder_days, scheme.stockm.unit_code, scheme.mrmrprm.order_line, scheme.mrmrprm.quantity_required
		FROM        scheme.plsuppm 
		INNER JOIN	scheme.stockm 
		ON			scheme.plsuppm.supplier = scheme.stockm.supplier 
		LEFT OUTER JOIN	scheme.mrmrprm 
		ON			scheme.stockm.warehouse = scheme.mrmrprm.warehouse 
		AND			scheme.stockm.product = scheme.mrmrprm.product  
		AND		    scheme.mrmrprm.kind = 'P'
		WHERE		(@supplier IS NULL OR scheme.stockm.supplier = @supplier) 
		AND			(scheme.stockm.product LIKE @product+'%') 
		AND			(scheme.stockm.warehouse = 'IG') 
		AND			(NOT(lower(analysis_a) = 'zzzz'))
	
		--SELECT	scheme.mrmrprm.warehouse, scheme.mrmrprm.product, scheme.stockm.long_description, scheme.mrmrprm.order_date, scheme.mrmrprm.supplier, scheme.plsuppm.name, scheme.stockm.reorder_days, scheme.stockm.unit_code, scheme.mrmrprm.order_line, scheme.mrmrprm.quantity_required
		--FROM	scheme.mrmrprm INNER JOIN scheme.stockm ON scheme.mrmrprm.warehouse = scheme.stockm.warehouse AND scheme.mrmrprm.product = scheme.stockm.product INNER JOIN scheme.plsuppm ON scheme.mrmrprm.supplier = scheme.plsuppm.supplier
		--WHERE	(scheme.mrmrprm.supplier = @supplier) AND (scheme.mrmrprm.kind = 'P') AND (scheme.mrmrprm.product = @product)
	)

	SELECT warehouse, product, product_description, supplier, supplier_name, reorder_days, unit_code,
	(SELECT ISNULL(SUM(quantity_required),0) AS Total FROM SupplierRecsByProduct WHERE (order_date BETWEEN DateAdd(year, -1, @Month1Start) AND DateAdd(day,-1,@Month1Start)) /*AND (order_line = '')*/) AS Overdue,
	(SELECT ISNULL(SUM(quantity_required),0) AS Total FROM SupplierRecsByProduct WHERE (order_date BETWEEN @Month1Start AND @Month1End) /*AND (order_line = '')*/) AS CurrentMonth,	
	@Month1Start AS Month1Start, @Month1End AS Month1End,
	(SELECT ISNULL(SUM(quantity_required),0) AS Total FROM SupplierRecsByProduct WHERE (order_date BETWEEN @Month2Start AND @Month2End) /*AND (order_line = '')*/) AS Plus1,	
	@Month2Start AS Month2Start, @Month2End AS Month2End,
	(SELECT ISNULL(SUM(quantity_required),0) AS Total FROM SupplierRecsByProduct WHERE (order_date BETWEEN @Month3Start AND @Month3End) /*AND (order_line = '')*/) AS Plus2,
	@Month3Start AS Month3Start, @Month3End AS Month3End,
	(SELECT ISNULL(SUM(quantity_required),0) AS Total FROM SupplierRecsByProduct WHERE (order_date BETWEEN @Month4Start AND @Month4End) /*AND (order_line = '')*/) AS Plus3,
	@Month4Start AS Month4Start, @Month4End AS Month4End,
	(SELECT ISNULL(SUM(quantity_required),0) AS Total FROM SupplierRecsByProduct WHERE (order_date BETWEEN @Month5Start AND @Month5End) /*AND (order_line = '')*/) AS Plus4,
	@Month5Start AS Month5Start, @Month5End AS Month5End,
	(SELECT ISNULL(SUM(quantity_required),0) AS Total FROM SupplierRecsByProduct WHERE (order_date BETWEEN @Month6Start AND @Month6End) /*AND (order_line = '')*/) AS Plus5,
	@Month6Start AS Month6Start, @Month6End AS Month6End,
	(SELECT ISNULL(SUM(quantity_required),0) AS Total FROM SupplierRecsByProduct WHERE (order_date BETWEEN @Month7Start AND @Month7End) /*AND (order_line = '')*/) AS Plus6,
	@Month7Start AS Month7Start, @Month7End AS Month7End,
	(SELECT ISNULL(SUM(quantity_required),0) AS Total FROM SupplierRecsByProduct WHERE (order_date BETWEEN @Month8Start AND @Month8End) /*AND (order_line = '')*/) AS Plus7,
	@Month8Start AS Month8Start, @Month8End AS Month8End,
	(SELECT ISNULL(SUM(quantity_required),0) AS Total FROM SupplierRecsByProduct WHERE (order_date BETWEEN @Month9Start AND @Month9End) /*AND (order_line = '')*/) AS Plus8,
	@Month9Start AS Month9Start, @Month9End AS Month9End,
	(SELECT ISNULL(SUM(quantity_required),0) AS Total FROM SupplierRecsByProduct WHERE (order_date BETWEEN @Month10Start AND @Month10End) /*AND (order_line = '')*/) AS Plus9,
	@Month10Start AS Month10Start, @Month10End AS Month10End,
	(SELECT ISNULL(SUM(quantity_required),0) AS Total FROM SupplierRecsByProduct WHERE (order_date BETWEEN @Month11Start AND @Month11End) /*AND (order_line = '')*/) AS Plus10,
	@Month11Start AS Month11Start, @Month11End AS Month11End,
	(SELECT ISNULL(SUM(quantity_required),0) AS Total FROM SupplierRecsByProduct WHERE (order_date BETWEEN @Month12Start AND @Month12End) /*AND (order_line = '')*/) AS Plus11,
	@Month12Start AS Month12Start, @Month12End AS Month12End
	--(SELECT CASE WHEN MAX(order_line) <> '' THEN '*' ELSE '' END AS Ordered FROM SupplierRecsByProduct WHERE (order_date BETWEEN @Month1Start AND @Month1End)) AS CurrentOrder,
	--(SELECT CASE WHEN MAX(order_line) <> '' THEN '*' ELSE '' END AS Ordered FROM SupplierRecsByProduct WHERE (order_date BETWEEN @Month2Start AND @Month2End)) AS Plus2Order,
	--(SELECT CASE WHEN MAX(order_line) <> '' THEN '*' ELSE '' END AS Ordered FROM SupplierRecsByProduct WHERE (order_date BETWEEN @Month3Start AND @Month3End)) AS Plus3Order,
	--(SELECT CASE WHEN MAX(order_line) <> '' THEN '*' ELSE '' END AS Ordered FROM SupplierRecsByProduct WHERE (order_date BETWEEN @Month4Start AND @Month4End)) AS Plus4Order,
	--(SELECT CASE WHEN MAX(order_line) <> '' THEN '*' ELSE '' END AS Ordered FROM SupplierRecsByProduct WHERE (order_date BETWEEN @Month5Start AND @Month5End)) AS Plus5Order,
	--(SELECT CASE WHEN MAX(order_line) <> '' THEN '*' ELSE '' END AS Ordered FROM SupplierRecsByProduct WHERE (order_date BETWEEN @Month6Start AND @Month6End)) AS Plus6Order,
	--(SELECT CASE WHEN MAX(order_line) <> '' THEN '*' ELSE '' END AS Ordered FROM SupplierRecsByProduct WHERE (order_date BETWEEN @Month7Start AND @Month7End)) AS Plus7Order,
	--(SELECT CASE WHEN MAX(order_line) <> '' THEN '*' ELSE '' END AS Ordered FROM SupplierRecsByProduct WHERE (order_date BETWEEN @Month8Start AND @Month8End)) AS Plus8Order,
	--(SELECT CASE WHEN MAX(order_line) <> '' THEN '*' ELSE '' END AS Ordered FROM SupplierRecsByProduct WHERE (order_date BETWEEN @Month9Start AND @Month9End)) AS Plus9Order,
	--(SELECT CASE WHEN MAX(order_line) <> '' THEN '*' ELSE '' END AS Ordered FROM SupplierRecsByProduct WHERE (order_date BETWEEN @Month10Start AND @Month10End)) AS Plus10Order,
	--(SELECT CASE WHEN MAX(order_line) <> '' THEN '*' ELSE '' END AS Ordered FROM SupplierRecsByProduct WHERE (order_date BETWEEN @Month11Start AND @Month11End)) AS Plus11Order,
	--(SELECT CASE WHEN MAX(order_line) <> '' THEN '*' ELSE '' END AS Ordered FROM SupplierRecsByProduct WHERE (order_date BETWEEN @Month12Start AND @Month12End)) AS Plus12Order

	FROM SupplierRecsByProduct
	GROUP BY warehouse, product, product_description, supplier, supplier_name, reorder_days, unit_code
		
END



go
sp_rpt_supplier_recs_by_product_monthly NULL, '100608'
sp_rpt_supplier_recs_by_product_12MONTHS '100608'