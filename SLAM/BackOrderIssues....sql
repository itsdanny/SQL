use slam
GO
--UPDATE 	slam.scheme.opheadm  SET status = 3 WHERE	order_no IN ('SB035851')
--DELETE FROM	CreditStopBackOrders WHERE		1=1

DECLARE @OrderNo VARCHAR(20) = 'SB039960'
SELECT		h.order_no, h.customer,h.date_entered, h.status, LTRIM(RTRIM(d.product)) AS product,order_line_status, d.order_qty, allocated_qty, despatched_qty, h.shipper_code1, shipper_code2, shipper_code3  
FROM		slam.scheme.opheadm h WITH(NOLOCK)
INNER JOIN 	slam.scheme.opdetm d WITH(NOLOCK)
ON			h.order_no = d.order_no
WHERE		h.order_no IN (@OrderNo)
AND			d.order_line_status != 'D'

INSERT INTO CreditStopBackOrders
SELECT		h.order_no, h.customer,h.date_entered, LTRIM(RTRIM(d.product)) AS product,order_line_status, d.order_qty, allocated_qty, despatched_qty, h.shipper_code1, shipper_code2, shipper_code3  
FROM		slam.scheme.opheadm h WITH(NOLOCK)
INNER JOIN 	slam.scheme.opdetm d WITH(NOLOCK)
ON			h.order_no = d.order_no
WHERE		h.order_no IN (@OrderNo)

SELECT	*	
FROM		CreditStopBackOrders
WHERE		order_no = @OrderNo


-- CLEAR SHIPPER DATA
UPDATE 		slam.scheme.opheadm 
SET			shipper_code1 = '', shipper_code2 = '', shipper_code3 = ''
WHERE		order_no IN (@OrderNo)
RETURN
--- DO SOMETHING ON	SAGE, AGAINST THE ORDER...!

-- PUT SHIPPER DATA BACK
UPDATE 		h
SET			h.shipper_code1 = c.shipper_code1, 
			h.shipper_code2 = c.shipper_code2, 
			h.shipper_code3 = c.shipper_code3
FROM		slam.scheme.opheadm h
INNER JOIN 	CreditStopBackOrders c
ON			h.order_no = c.order_no
WHERE		h.order_no IN ('SB039960')

/*
SELECT	*
FROM		VapeConnect.[dbo].[SYSTaskSchedule] 

UPDATE 	VapeConnect.[dbo].[SYSTaskSchedule] SET Active =  1 WHERE		Id IN (21)

UPDATE 	[dbo].[SYSTaskSchedule] SET RunTime = '21:34:00.0000000', NextRun ='2017-11-13 21:40:00.000' WHERE		ServiceId IN (25)
UPDATE 	[dbo].[SYSTaskSchedule] SET RunTime = '21:40:00.0000000' ,NextRun ='2017-11-13 21:45:00.000' WHERE		ServiceId IN (24)
*/


SELECT	*
FROM		scheme.stallocm WHERE		order_no = 'SB039960'


SELECT	*
FROM		slam.scheme.opheadm 
WHERE		customer ='1N4'
AND	date_entered = '2017-11-26'


UPDATE 	slam.scheme.opheadm 
SET		status = 3
WHERE	order_no = 'SB039960'

/* Supersession data */
SELECT *
FROM	 slam.scheme.stockm WITH(NOLOCK)
WHERE	product = '030042'

UPDATE 	slam.scheme.stockm  SET supersession = 'SL030562'
WHERE	product = '030042'
--SL030562              