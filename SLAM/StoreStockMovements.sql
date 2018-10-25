alter PROCEDURE sp_GetStoreMovementsByDate
@Store		VARCHAR(5),
@FromDate	DATETIME,
@ToDate		DATETIME
AS 

SELECT		s.product, s.description, 
			@Store AS Store,
			0 AS StockMovements,
			0 AS Sales,
			0 AS CreditNotes,
			s.standard_cost AS StandardCostPrice
			INTO #BinMovements
FROM		scheme.stkhstm h WITH(NOLOCK)
INNER JOIN 	scheme.stockm s WITH(NOLOCK)
ON			h.warehouse = s.warehouse
AND			h.product = s.product
GROUP BY	s.product, s.description, s.standard_cost
ORDER BY	s.product, s.description

-- SALES
UPDATE		bm
SET			bm.StockMovements = (SELECT		ISNULL(SUM(h.movement_quantity),0)
						FROM		scheme.stkhstm h WITH(NOLOCK)
						WHERE		h.warehouse = s.warehouse
						AND			h.product = s.product
						AND			h.to_bin_number = @Store
						AND			h.transaction_type IN ('BINT','ADJ','RECP')
						AND			h.dated BETWEEN @FromDate AND	@ToDate
						)
FROM		scheme.stockm s WITH(NOLOCK)
LEFT JOIN 	#BinMovements bm
ON			s.product = bm.product 

-- SALES
UPDATE		bm
SET			bm.Sales = (SELECT		ISNULL(SUM(h.movement_quantity),0)*-1
						FROM		scheme.stkhstm h WITH(NOLOCK)
						WHERE		h.warehouse = s.warehouse
						AND			h.product = s.product
						AND			h.from_bin_number = @Store
						AND			h.transaction_type IN ('SALE','FSLS')
						AND			h.dated BETWEEN @FromDate AND	@ToDate
						)
FROM		scheme.stockm s WITH(NOLOCK)
LEFT JOIN 	#BinMovements bm
ON			s.product = bm.product 


UPDATE		bm
SET			bm.CreditNotes = (	SELECT		ISNULL(SUM(d.despatched_qty), 0)
								FROM		scheme.opheadm h
								INNER JOIN	scheme.opdetm d
								ON			h.order_no = d.order_no
								where		h.date_received BETWEEN @FromDate AND @ToDate
								AND			h.customer = '1' + @Store
								AND			d.product = s.product
								AND			h.order_no LIKE	'CN%')
FROM		scheme.stockm s WITH(NOLOCK)
LEFT JOIN 	#BinMovements bm
ON			s.product = bm.product 

SELECT	product, description, StandardCostPrice, StockMovements, Sales, CreditNotes 
FROM	#BinMovements WHERE	(StockMovements + Sales + CreditNotes) > 0

DROP TABLE #BinMovements
go

sp_GetStoreMovementsByDate 'EC001','2017-01-01 00:00:00','2017-02-24  23:59:59' -- 34
GO

sp_GetStoreMovementsByDate 'F1','2017-02-01 00:00:00','2017-02-22  23:59:59' -- 34


/*
	ADJ 
	BINT
	C/N 
	FSLR
	FSLS
	RC/N
	RECP
	SALE
	SCRP
*/


SELECT * FROM slam.scheme.stquem WHERE		bin_number ='EC001' AND	quantity  > 0 ORDER BY date_received desc

--SELECT * FROM slam.scheme.stkhstm WHERE		to_bin_number ='EC001' AND	quantity  > 0 ORDER BY date_received desc
