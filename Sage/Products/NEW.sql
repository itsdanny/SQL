--Original Top Table

Declare @WorkScheduler1 table

(warehouse char(20), product char(20), long_description char(60), Qty int, 
selling_unit char(20), batch_number char(20), lot_number char(20), date_received datetime, 
safety_days float, Revised_available_date datetime, stock_held_flag char(20), held_reason_code char(20));

INSERT INTO @WorkScheduler1
SELECT      quem.warehouse
		   ,quem.product
	       ,scheme.stockm.long_description
	       ,SUM(quem.quantity) AS Qty
	       ,stockm.selling_unit
	       ,quem.batch_number
	       ,MIN(quem.lot_number) AS lot_number
	  --,quem.source_code
	       ,quem.date_received
	       ,stockm.safety_days - isnull(stockm.dspare03,0) as safety_days
	  ,(SELECT Date
		FROM(SELECT ROW_NUMBER() OVER (ORDER BY [Date] ASC) AS SrNo, [Date]
			 FROM [syslive].[dbo].[MRPCalendar] with(NOLOCK)
			 WHERE Date > (SELECT TOP 1 [date_received]
							FROM [syslive].[scheme].[stquem] AS sub_quem WITH (NOLOCK)
							WHERE sub_quem.product = quem.product AND sub_quem.batch_number = quem.batch_number
							ORDER BY sub_quem.date_received) AND MRPValue != 'N') AS MRPCal
		WHERE SrNo = (stockm.safety_days -  isnull(stockm.dspare03,0))
      ) AS Revised_available_date
	      ,MAX(LOWER(queam.stock_held_flag)) AS stock_held_flag
	      ,MAX(LOWER(queam.held_reason_code)) AS held_reason_code
FROM	   scheme.stquem AS quem WITH (NOLOCK) 
INNER JOIN scheme.stqueam AS queam WITH (NOLOCK) 
ON		   quem.warehouse = queam.warehouse 
AND		   quem.product = queam.product 
AND        quem.sequence_number = queam.sequence_number
INNER JOIN scheme.stockm WITH (NOLOCK) 
ON         quem.warehouse = scheme.stockm.warehouse 
AND        quem.product = scheme.stockm.product
WHERE      quem.warehouse = 'FG' 
AND        stockm.analysis_a = 'TPTY' 
AND        LOWER(quem.passed_inspection) != 'y' 
AND        quem.quantity > 0
GROUP BY   quem.warehouse, quem.product, stockm.long_description, stockm.selling_unit, quem.batch_number
	      ,quem.date_received, stockm.safety_days, stockm.dspare03, quem.lot_number, quem.passed_inspection
ORDER BY   Revised_available_date, product, lot_number


Declare @NoWeeks1 table

(warehouse char(10), product char(20), quantity_required float);

INSERT INTO @NoWeeks1
SELECT      warehouse
		   ,product
		   ,SUM(quantity_required) as quantity_required
FROM	    syslive.scheme.mrgrpdm WITH(NOLOCK)
WHERE       date_required between getdate() and dateadd(week,13,getdate())
--and product = '014672'
GROUP BY    warehouse, product


Declare @WeekStock1 table

(warehouse char(10), product char(20), week_stock float);

INSERT INTO @WeekStock1
SELECT     b.warehouse, b.product, sum(b.quantity) - MAX(m.allocated_qty) - sum(case when a.stock_held_flag = 'y' then b.quantity else 0 end) -
		   SUM(case when b.passed_inspection = 'N' AND a.held_reason_code NOT IN ('QCH', 'QCI', 'QCR', 'QCQ', 'SR', 'SD', 'BS') then b.quantity else 0 end) as week_stock
		   --* 13) / SUM(nw.quantity_required) AS week_stock,
		   --w.*
FROM	   scheme.stqueam a
INNER JOIN scheme.stquem b WITH(NOLOCK)
ON		   a.product = b.product
AND		   a.warehouse = b.warehouse
AND		   a.sequence_number = b.sequence_number
INNER JOIN scheme.stockm m WITH(NOLOCK)
ON		   a.product = m.product
AND		   a.warehouse = m.warehouse
--INNER JOIN @WorkScheduler w
--ON		   a.product = w.product
--AND		   a.warehouse = w.warehouse
--INNER JOIN @NoWeeks nw
--ON		   w.product = nw.product
--AND		   w.warehouse = nw.warehouse
WHERE	   b.quantity > 0 
AND		   a.warehouse = 'FG' 
--AND        m.product in ('001147', '001155', '002119','002909', '003425')
GROUP BY   b.warehouse, b.product
--GROUP BY   w.warehouse, w.product, w.long_description, w.production_date, w.passed_inspection, w.source_code, w.quantity_finished, 
--		   w.works_order, w.description, w.status, w.finish_prod_unit, w.safety_days, w.WO_Comment, 
--		   w.production_date_new, w.qty, w.Actual_Bulk_Batch_Issued, w.Revised_available_date, w.stock_held_flag, w.held_reason_code, nw.quantity_required
----ORDER BY   product		   
 

select     ROUND(CASE WHEN SUM(nw1.quantity_required) IS NOT NULL THEN ws1.week_stock * 13 / SUM(nw1.quantity_required) ELSE 99 END,2) as Week_Stock_total,
           w1.*, ws1.product as prod
FROM	   @WorkScheduler1 w1
RIGHT JOIN @NoWeeks1 nw1
ON		   w1.product = nw1.product
AND		   w1.warehouse = nw1.warehouse
RIGHT JOIN @WeekStock1 ws1
ON		   w1.product = ws1.product
AND		   w1.warehouse = ws1.warehouse
GROUP BY   w1.warehouse, w1.product, w1.long_description, w1.Qty, w1.selling_unit, w1.batch_number, w1.lot_number, w1.date_received, 
		   w1.safety_days, w1.Revised_available_date, w1.stock_held_flag, w1.held_reason_code, ws1.product, ws1.week_stock
ORDER BY   w1.Revised_available_date