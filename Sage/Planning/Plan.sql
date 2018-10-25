
alter PROCEDURE sp__SubWorkOrderDetail

@warehouse varchar(2), 
@workcentre varchar(6), 
@order_date DateTime, 
@shift varchar(2) 

AS

DECLARE @WC TABLE(WorkCentre varchar(6))
insert into @WC values (@workcentre)

if @workcentre = 'HP02' 
BEGIN
	
	SELECT * 
	FROM		scheme.stockm s WITH(NOLOCK)
	INNER JOIN	scheme.wsroutdm d  WITH (NOLOCK)
	ON			s.analysis_a = d.resource_code
	AND			s.warehouse+s.product = d.code
	INNER JOIN	scheme.bmwohm w  WITH(NOLOCK)
	ON			s.product = w.product_code
	AND			s.warehouse = w.warehouse 
	WHERE		s.analysis_a = 'HP51'

END
 
SELECT  distinct w.warehouse, 
		w.product_code, 
		w.works_order, 
		w.quantity_required, 
		w.finish_prod_unit, 		
		w.quantity_finished, 
		s.long_description,
		s.alpha,
		ISNULL((SELECT TOP 1 LEFT(lot_number, 6)
		FROM    scheme.stkhstm h WITH (NOLOCK)
		WHERE   (transaction_type = 'W/O') 
		AND		(movement_reference = w.works_order) 
		AND		(warehouse = 'BK')
		GROUP BY LEFT(lot_number, 6)), '') AS BulkWO,
w.order_date		
FROM		scheme.wsroutdm d  WITH (NOLOCK)
INNER JOIN	scheme.bmwohm w WITH (NOLOCK)
ON			d.code = w.warehouse + w.product_code
INNER JOIN	scheme.stockm s WITH (NOLOCK)
ON			s.product = w.product_code
and			s.warehouse = w.warehouse
INNER JOIN	GroupedWorkCentre g
on			d.resource_code = g.WorkCentre
WHERE       (w.warehouse = @warehouse) 
AND			(d.resource_code =@workcentre) 
AND			(w.order_date BETWEEN @order_date AND @order_date+7) 
--AND			(w.security_reference = @shift)
--and d.resource_code = 'HP02'
--and w.order_date  between '2015-03-30 00:00:00' and '2015-04-05 00:00:00'
--and	w.security_reference = 'AM'
--AND			(w.security_reference IN ('AM', 'PM', 'NS'))
order by		w.order_date


go

sp__SubWorkOrderDetail 'BK', 'HS11', '2015-03-30 00:00:00', 'AM'

/*
select * from GroupedWorkCentre where WorkCentreGroup = 'HPD1'
select distinct analysis_a from scheme.stockm order by 
analysis_a


select * from scheme.wsroutdm where resource_code = 'HP51'
select * from scheme.wsroutdm where resource_code = 'HS02'*/

SELECT		Insight.dbo.fn_IntToTime(sum((d.time_per_batchsize * CAST(RIGHT(LTRIM(RTRIM(d.operator_code)), 1) AS INT)))) AS LabourHour
--SELECT		order_date, d.time_per_batchsize, d.operator_code, RIGHT(LTRIM(RTRIM(d.operator_code)), 1) AS Crewe, (d.time_per_batchsize * CAST(RIGHT(LTRIM(RTRIM(d.operator_code)), 1) AS INT)) AS Mins
--SELECT		*
FROM		scheme.wsroutdm d WITH(NOLOCK) 
INNER JOIN	scheme.bmassdm bm WITH(NOLOCK) 
ON			d.code = bm.assembly_warehouse +bm.product_code
INNER JOIN	scheme.bmwohm w WITH(NOLOCK) 
ON			d.code = w.warehouse + w.product_code
AND			w.order_date  between getDate() +13 and getDate() +20
--AND			d.code = 'FG030023'
AND			bm.component_whouse = 'BK'
AND			d.resource_code in ('HP01','HP02','HP03')
--ORDER		by w.order_date, d.code
