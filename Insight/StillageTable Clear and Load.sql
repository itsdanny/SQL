-- THIS CLEARS THE STILLAGE TABLEI IN INSIGHT AND READDS THE DATA FROM SAGE, SHOULD ONE MAKE A HOWLER OF THINGS.
truncate table WorkCentreJobStillageLog
DBCC CHECKIDENT  (WorkCentreJobStillageLog, RESEED, 1)
INSERT INTO WorkCentreJobStillageLog	
SELECT		j.Id,
			p.lot_number, 
			CASE p.comments WHEN 'W/O Complete' THEN P.movement_date + CAST(GETDATE() AS TIME) ELSE CONVERT(DATETIME, REPLACE(SUBSTRING(LTRIM(RTRIM(p.comments)), 12, 17), ',',' '), 5) END AS movement_date,
			--CAST(wo.quantity_required AS FLOAT) AS Qty, 
			CAST(p.movement_quantity AS FLOAT) AS movement_quantity,
			0
FROM		syslive.scheme.stkhstm p WITH (NOLOCK) 
INNER JOIN	syslive.scheme.bmwohm wo WITH (NOLOCK) 
ON			p.product = wo.product_code
INNER JOIN	WorkCentreJob j
ON			wo.works_order =  J.WorkOrderNumber COLLATE Latin1_General_CI_AS
WHERE		p.transaction_type = 'COMP'
AND			p.movement_quantity > 0
AND			SUBSTRING(p.lot_number, 1, LEN(wo.alpha_code)) = wo.alpha_code 
AND			movement_date >= '2014-04-18'

SELECT * from WorkCentreJobStillageLog	
