DROP TABLE  Fact_Product
create  TABLE  Fact_Product(Id INT IDENTITY(1,1), DateId INT, ProductCode VARCHAR(10), Description varchar(40), Warehouse VARCHAR(2), Analysis_a varchar(10), Analysis_b varchar(10), Analysis_c varchar(10), Supplier VARCHAR(6), 
					AllocatedStock FLOAT, FreeStock FLOAT, PhysicalStock FLOAT, OnOrderQty FLOAT, BackOrderQty FLOAT, ForwardOrderQty FLOAT, Batch_Traceability CHAR(1), FromDate DateTime, ToDate DateTime, CurrentFlag bit)

--INSERT INTO Fact_Product

DECLARE @Fact_Product TABLE(Id INT IDENTITY(1,1), DateId INT, ProductCode VARCHAR(10), Description varchar(40), Warehouse VARCHAR(2), Analysis_a varchar(10), Analysis_b varchar(10), Analysis_c varchar(10), Supplier VARCHAR(6), 
					AllocatedStock FLOAT, FreeStock FLOAT, PhysicalStock FLOAT, OnOrderQty FLOAT, BackOrderQty FLOAT, ForwardOrderQty FLOAT, Batch_Traceability CHAR(1))

--INSERT INTO @Fact_Product 
INSERT INTO Fact_Product

SELECT	c.DateId, product, long_description, warehouse, analysis_a, analysis_b, analysis_c,supplier, allocated_qty, physical_qty-allocated_qty AS FreeStock, physical_qty, on_order_qty, back_order_qty, forward_order_qty, 
		batch_traceability, NULL, NULL, NULL
FROM	scheme.stockm m, 
DWCalendar c
WHERE	analysis_a <> 'ZZZZ'
AND		warehouse in('IG','BK','FG')
AND		product <> '999999'
AND		c.CalenderDate = cast(getDate() as date)
AND		c.DateId NOT IN (SELECT DISTINCT DateId from Fact_Product)

-- Dim vars
DECLARE @code varchar(10)
DECLARE @desc varchar(10)
DECLARE @wh varchar(2)
DECLARE @anal_a varchar(10)
DECLARE @anal_b varchar(10)
DECLARE @anal_c varchar(10)

SELECT * FROM Fact_Product
 ORDER BY ProductCode