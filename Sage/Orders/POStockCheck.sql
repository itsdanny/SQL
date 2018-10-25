DECLARE	@prod	varchar(12)	= '072354'
DECLARE	@PO		varchar(12) = '051840'

SELECT * FROM scheme.poheadm  WITH(NOLOCK) WHERE order_no = @PO
SELECT qty_ordered, qty_received FROM scheme.podetm  WITH(NOLOCK) WHERE order_no = @PO AND line_type = 'P' and warehouse = 'IG' and product = @prod
SELECT unit_code from scheme.stockm  WITH(NOLOCK) where warehouse = 'IG' AND product = @prod

SELECT		h.quantity_required, h.quantity_finished, h.quantity_rejected 
FROM		scheme.bmwohm h WITH(NOLOCK)
INNER JOIN	scheme.bmwodm d WITH(NOLOCK)
ON			h.works_order = d.works_order
WHERE		d.component_code = @prod
AND			alpha_code = 'TPTY'+@PO

SELECT		d.quantity_required, d.quantity_issued, d.aux_qty_issued, d.qty_used_so_far, d.actual_qty_per_kit, d.aux_qty_scrappe
FROM		scheme.bmwohm h  WITH(NOLOCK)
INNER JOIN	scheme.bmwodm d WITH(NOLOCK)
ON			h.works_order = d.works_order
WHERE		d.component_code = @prod
AND			alpha_code = 'TPTY'+@PO

use Integrate 
select * from Errors order by Id desc
select * from Log order by Id desc


select * from POToleranceCheck
select * from ReturnsAdjustment order by Id desc
USE syslive
SELECT DISTINCT LTRIM(RTRIM(lot_number)) AS lot_number, CONVERT(VARCHAR(10), expiry_date, 3) as expiry_date from scheme.stkhstm WITH(NOLOCK) where product = '005576' AND from_bin_number like 'UDG%' AND lot_number LIKE 'HM%' 

SELECT DISTINCT LTRIM(RTRIM(lot_number)) AS lot_number, CONVERT(VARCHAR(10), expiry_date, 3) as expiry_date from scheme.stquem WITH(NOLOCK) where product = '005576' AND bin_number like 'UDG%' AND lot_number LIKE 'HM%' 


SELECT * FROM SalesOrderHeader
use syslive
SELECT * FROM scheme.stquem a WITH(NOLOCK) INNER JOIN scheme.stqueam b WITH(NOLOCK) ON a.warehouse = b.warehouse AND a.product = b.product AND a.sequence_number = b.sequence_number WHERE (a.quantity > 0) AND a.product = '057118' AND a.warehouse ='FG' AND a.bin_number = 'UDG08' AND b.stock_held_flag <> 'y' AND batch_number = 'RJA90'