/* SSMSBoost
Event: Timer
Event date: 2016-01-29 10:02:20
Connection: trsagev3d1.syslive (WinAuth)
*/
DECLARE @StartDate datetime, @EndDate Datetime
-- 2012 0
-- 2013 58
-- 2014	3535
-- 2015 3735 ROWS
SELECT @StartDate = '2015-01-01', @EndDate = '2015-12-31'

SELECT     --scheme.wsroutdm.resource_code AS spare, 
		   LEFT(LTRIM(RTRIM(scheme.stkhstm.lot_number)), 4) AS works_order, 
		   scheme.stkhstm.warehouse, 
           scheme.stkhstm.product AS product_code, 
		   MAX(scheme.stkhstm.dated) AS completion_date, 
		   scheme.stockm.unit_code AS finish_prod_unit, 
           SUM(scheme.stkhstm.movement_quantity) AS quantity_finished, 
		   SUM(scheme.stkhstm.movement_quantity) * u.spare AS total, 
           --scheme.bmwohm.quantity_required, 
		   scheme.stockm.description
FROM       scheme.stockm WITH (NOLOCK) 
INNER JOIN scheme.stkhstm WITH (NOLOCK) 
ON		   scheme.stockm.warehouse = scheme.stkhstm.warehouse 
AND        scheme.stockm.product = scheme.stkhstm.product 
INNER JOIN scheme.stunitdm u
ON		   scheme.stockm.unit_code = u.unit_code
INNER JOIN scheme.bmwohm WITH (NOLOCK) 
ON		   scheme.stkhstm.warehouse = scheme.bmwohm.warehouse 
AND        scheme.stkhstm.product = scheme.bmwohm.product_code 
--AND        LEFT(LTRIM(RTRIM(scheme.stkhstm.lot_number)), 4) = scheme.bmwohm.alpha_code
--INNER JOIN scheme.wsroutdm WITH (NOLOCK)
--ON		  (scheme.bmwohm.warehouse + scheme.bmwohm.product_code) = scheme.wsroutdm.code
WHERE     (scheme.stockm.warehouse = 'FG') 
AND		  (scheme.stkhstm.transaction_type = 'COMP') 
AND		  (scheme.stkhstm.dated BETWEEN @StartDate AND @EndDate)
GROUP BY   --scheme.wsroutdm.resource_code, 
			LEFT(LTRIM(RTRIM(scheme.stkhstm.lot_number)), 4), scheme.stkhstm.warehouse, 
		   scheme.stkhstm.product, scheme.stockm.unit_code, u.spare, 
		   --scheme.bmwohm.quantity_required, 
		   scheme.stockm.description

select top 10 * from syslive.scheme.wswopm r WITH(NOLOCK)  
-- 2967 2013 with no WOH
SELECT	   s.analysis_a,  SUM(movement_quantity) FGs, SUM(movement_quantity)*u.spare as Bottles, LEFT(LTRIM(RTRIM(h.lot_number)), 4) as Lot, s.alpha,s.unit_code
FROM	    scheme.stockm s WITH (NOLOCK) 
INNER JOIN  scheme.stkhstm h WITH (NOLOCK) 
ON		    s.warehouse = h.warehouse 
AND         s.product = h.product 
INNER JOIN  scheme.stunitdm u
ON		    s.unit_code = u.unit_code
WHERE		h.transaction_type = 'COMP'
AND			h.warehouse ='FG'
AND			DATEPART(YEAR, dated) = 2013
AND			s.analysis_a  NOT IN ('TPTY','ZZZZ','ZZZY')
GROUP BY s.analysis_a, LEFT(LTRIM(RTRIM(h.lot_number)), 4), s.alpha,s.unit_code,u.spare

select	*--quantity_required, quantity_finished 
from	scheme.bmwohm WITH(NOLOCK) where warehouse ='FG' 
AND		DATEPART(YEAR, order_date) = 2013
AND		alpha_code not like 'TPTY%'

SELECT top 50 * FROM MachineTracker.DBO.Product
SELECT * FROM MachineTracker.DBO.ProcessGroup
SELECT top 50 * FROM MachineTracker.DBO.Process



select * from MachineTracker.dbo.WorkCentre

