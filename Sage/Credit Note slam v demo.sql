
-- ANY BACK ORDERS?
/*
SELECT	*
FROM		TRConnect.dbo.ENLocations
WHERE		IsLive = 1
--WHERE		SageRef = 'HF'
ORDER BY	3
SELECT		distinct h.order_no, h.date_entered, h.customer, h.status
FROM		slam.scheme.opheadm h WITH(NOLOCK)
INNER JOIN 	slam.scheme.opdetm d WITH(NOLOCK)
ON			h.order_no = d.order_no
WHERE		h.order_no NOT like 'SB%'
AND			h.status < 5
ORDER BY	h.date_entered DESC 
*/
DECLARE @FromDate DATETIME = '2018-10-04'
DECLARE @OrderType VARCHAR(4) = 'SB%'

SELECT		sum(d.val) GrossVal, sum(d.order_qty) AS Qty
--SELECT		h.date_entered,d.*
FROM		slam.scheme.opheadm h WITH(NOLOCK)
INNER JOIN 	slam.scheme.opdetm d WITH(NOLOCK)
ON			h.order_no = d.order_no
WHERE		h.order_no like @OrderType
AND			date_entered = @FromDate
AND			(d.product NOT LIKE '%GEN%')
--AND			d.product = '032220'
--AND			h.customer = '1C3'

--SELECT		sum(d.net_price) GrossVal, sum(d.order_qty) AS Qty
----SELECT		h.date_entered,d.*
--FROM		demo.scheme.opheadm h WITH(NOLOCK)
--INNER JOIN 	demo.scheme.opdetm d WITH(NOLOCK)
--ON			h.order_no = d.order_no
--WHERE		h.order_no like @OrderType
--AND			date_entered = @FromDate
--AND			(d.product NOT LIKE '%GEN%')
----AND			d.product = '032220'
----AND			h.customer = '1C3'
--RETURN 
DECLARE @Resultsa TABLE (db VARCHAR(4), customer VARCHAR(5), netvalue FLOAT,  qty INT, OrderDate DATETIME,  orderno VARCHAR(20), cname VARCHAR(50), val float)-- product VARCHAR(70),

INSERT INTO @Resultsa
SELECT		'slam', h.customer, sum(d.net_price) NetValue, sum(d.order_qty) AS Qty, h.date_entered,LTRIM(RTRIM(h.order_no)), LTRIM(RTRIM(h.address1)), sum(d.val)-- LTRIM(RTRIM(d.product)) + ' - '+ LTRIM(RTRIM(d.description))
FROM		slam.scheme.opheadm h WITH(NOLOCK)
INNER JOIN 	slam.scheme.opdetm d WITH(NOLOCK)
ON			h.order_no = d.order_no
WHERE		date_entered = @FromDate
AND			h.order_no like @OrderType
--AND			h.customer = '1C3'
AND			d.product NOT LIKE '%GEN%'
GROUP BY	h.customer, h.date_entered, LTRIM(RTRIM(h.order_no)),LTRIM(RTRIM(h.address1))--, LTRIM(RTRIM(d.description)),  LTRIM(RTRIM(d.product)), 
ORDER BY	4

SELECT	*
FROM		@Resultsa
ORDER BY	cname

--DECLARE @Resultsb TABLE (db VARCHAR(4), customer VARCHAR(5), netvalue FLOAT,  qty INT, OrderDate DATETIME, product VARCHAR(70), orderno VARCHAR(20), cname VARCHAR(50), val float)
--INSERT INTO @Resultsb
--SELECT		'demo',h.customer, sum(d.net_price) NetValue, sum(d.order_qty) AS Qty, h.date_entered, LTRIM(RTRIM(d.product)) + ' - '+ LTRIM(RTRIM(d.description)), LTRIM(RTRIM(h.order_no)), LTRIM(RTRIM(h.address1)), sum(d.val)
--FROM		demo.scheme.opheadm h WITH(NOLOCK)
--INNER JOIN 	demo.scheme.opdetm d WITH(NOLOCK)
--ON			h.order_no = d.order_no
--WHERE		h.order_no like @OrderType
--AND			date_entered = @FromDate
----AND			h.customer = '1C3'
----AND			d.product LIKE '%GEN%'
--GROUP BY	h.customer, h.date_entered, LTRIM(RTRIM(d.product)), LTRIM(RTRIM(h.order_no)),LTRIM(RTRIM(h.address1)), LTRIM(RTRIM(d.description))
--ORDER BY	4

--SELECT	*
--FROM		@Resultsa a
--left JOIN 	@Resultsb b
--ON			a.customer = b.customer
--AND			a.OrderDate = b.OrderDate
--AND			a.product = b.product
--AND			a.netvalue <> b.netvalue

--RETURN  
-- IN LIVE NOT TEST
--SELECT	'IN LIVE NOT TEST' AS Issue, customer, netvalue, qty, OrderDate, product, val--, cname 
--FROM	@Resultsa 
--except  
--SELECT	'IN LIVE NOT TEST' AS Issue, customer, netvalue, qty, OrderDate, product,val--, cname 
--FROM	@Resultsb
--ORDER BY	6

---- IN TEST NOT LIVE
--SELECT	'IN TEST NOT LIVE' AS Issue, customer, netvalue, qty, OrderDate, product, val--, cname 
--FROM	@Resultsb
--except 
--SELECT	'IN TEST NOT LIVE' AS Issue, customer, netvalue, qty, OrderDate, product, val--, cname 
--FROM	@Resultsa
--ORDER BY	6