select * from WorkCentreJobLog order by Id desc
select * from WorkCentreJob order by id desc
select * from WorkCentreJob where WorkCentreId  in (8,14,19,20) order by id desc
select * from WorkCentre where Id  in (8,21)
select * from WorkCentreJob where WorkOrderNumber in ('KN64B')
select * from WorkCentreJob where Id  in (8928)
select * from WorkCentreJobLog where WorkCentreJobId in (8928)
select * from WorkCentreJobEventLog where WorkCentreJobId = 8928

UPDATE l SET l.BPM = (SELECT SUM(s.StillageQuantity)/(MAX(l.StageRuntime) - SUM(el.TotalNumberOfMinutes)) FROM WorkCentreJobEventLog el WHERE el.WorkCentreJobId = j.Id and el.WorkCentreEventId in (12,2,3))
FROM WorkCentreJobLog l
INNER JOIN	WorkCentreJob j
ON			j.Id = l.WorkCentreJobId
INNER JOIN	WorkCentreJobStillageLog s
ON			j.Id = s.WorkCentreJobId
WHERE		J.WorkOrderNumber ='KW54B'
--WHERE		l.FinishDateTime is not null
group by	l.BPM, j.Id))

UPDATE WorkCentreJobLog SET BPM = 5.7 where WorkCentreJobId = 9290

select DATEDIFF(MINUTE, '2015-03-24 08:22:54.000','2015-03-25 09:03:34.690')

SELECT (298 - 49),  2175/CAST((381) AS FLOAT)

SELECT * from WorkCentreJobStillageLog s where WorkCentreJobId = 9808


 SELECT * FROM syslive.scheme.stkhstm where transaction_type = 'COMP'  AND to_bin_number = 'FG01'  AND lot_number LIKE 'KX83%'  ORDER BY comments DESC
 
 --select * from WorkCentreJob where WorkOrderNumber = 'KX83'

 select * from Insight.dbo.WorkCentreJobEventLog where WorkCentreJobId = 9786

SELECT  * 
FROM syslive.scheme.stkhstm 
where transaction_type = 'COMP' 
AND to_bin_number = 'FG01' 
AND lot_number LIKE 'KV82%' 
ORDER BY comments DESC


use Integrate
select * from SalesOrderHeader h INNER JOIN SalesOrderLine d ON h.Id = d.SalesOrderHeaderId where SaleOrderTypeId =1 AND OrderNumber IN ('192520','192498')