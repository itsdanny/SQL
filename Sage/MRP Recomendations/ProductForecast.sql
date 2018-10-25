create procedure sp__getSupplierRecommendations
@Product varchar(10)
as
DECLARE @ProductForecast TABLE 
(
	warehouse VARCHAR(2), 
	product VARCHAR(20), 
	product_description VARCHAR(50), 
	supplier VARCHAR(20), 
	supplier_name VARCHAR(50), 
	reorder_days int, 
	unit_code  VARCHAR(10),
	OverdueRec INT,
	Month1Rec INT,
	Month1Start DATETIME,
	Month1End DATETIME,
	Month2Rec INT,
	Month2Start DATETIME,
	Month2End DATETIME,
	Month3Rec INT,
	Month3Start DATETIME,
	Month3End DATETIME,
	Month4Rec INT,
	Month4Start DATETIME,
	Month4End DATETIME,
	Month5Rec INT,
	Month5Start DATETIME,
	Month5End DATETIME,
	Month6Rec INT,
	Month6Start DATETIME,
	Month6End DATETIME,
	Month7Rec INT,
	Month7Start DATETIME,
	Month7End DATETIME,
	Month8Rec INT,
	Month8Start DATETIME,
	Month8End DATETIME,
	Month9Rec INT,
	Month9Start DATETIME,
	Month9End DATETIME,
	Month10Rec INT,
	Month10Start DATETIME,
	Month10End DATETIME,
	Month11Rec INT,
	Month11Start DATETIME,
	Month11End DATETIME,
	Month12Rec INT,
	Month12Start DATETIME,
	Month12End DATETIME
)
DECLARE @Supplier varchar(10)

DECLARE SupplierProducts CURSOR -- Declare cursor

LOCAL SCROLL STATIC
 
FOR
 
SELECT scheme.stockm.supplier
FROM scheme.stockm WITH (NOLOCK)
WHERE (product = @Product) and (NOT(lower(analysis_a) = 'zzzz')) AND (warehouse = 'IG')
 
OPEN SupplierProducts -- open the cursor

	FETCH NEXT FROM SupplierProducts
	INTO @Supplier
		
WHILE @@FETCH_STATUS = 0
 
BEGIN

	INSERT INTO @ProductForecast
	EXEC sp_rpt_supplier_recs_by_product @Supplier, @Product
	
	FETCH NEXT FROM SupplierProducts
	INTO @Product

END
 
CLOSE SupplierProducts -- close the cursor

DEALLOCATE SupplierProducts -- Deallocate the cursor

SELECT * FROM @ProductForecast ORDER BY product

go
EXEC sp__getSupplierRecommendations '245257'
go
EXEC sp__getSupplierRecommendations '245249'

EXEC SP__getMRP_Product '245249'

SELECT		DATEPART(YEAR, p.order_date) AS OrderYear, 
			DATEPART(MONTH, p.order_date) AS OrderMonth, 
			SUM(p.quantity_required) AS quantity_required, 
			SUM(ISNULL(d.orig_qty, 0)) AS orig_qty
FROM        scheme.plsuppm s
INNER JOIN	scheme.stockm m
ON			s.supplier = m.supplier 
LEFT OUTER JOIN	scheme.mrmrprm p
ON			m.warehouse = p.warehouse 
AND			m.product = p.product  
AND		    p.kind = 'P'
LEFT JOIN	scheme.poheadm h
ON			h.order_no like LEFT(p.order_line, 6)
LEFT JOIN  scheme.podetm d
ON			h.order_no = d.order_no
WHERE		(m.product = '245249') 
AND			(m.warehouse = 'IG') 
AND			(NOT(lower(analysis_a) = 'zzzz'))
AND			order_date > dbo.fn_StartOfYear()
AND			d.line_type = 'P'
group by	DATEPART(Year, p.order_date) , DATEPART(Month, p.order_date) 
order by	DATEPART(Year, p.order_date) , DATEPART(Month, p.order_date) 


SELECT		d.*
FROM        scheme.plsuppm s
INNER JOIN	scheme.stockm m
ON			s.supplier = m.supplier 
LEFT OUTER JOIN	scheme.mrmrprm p
ON			m.warehouse = p.warehouse 
AND			m.product = p.product  
AND		    p.kind = 'P'
LEFT JOIN	scheme.poheadm h
ON			h.order_no like LEFT(p.order_line, 6)
LEFT JOIN  scheme.podetm d
ON			h.order_no = d.order_no
WHERE		(m.product = '245249') 
AND			(m.warehouse = 'IG') 
AND			(NOT(lower(analysis_a) = 'zzzz'))
AND			order_date > dbo.fn_StartOfYear()
AND			d.line_type = 'P'