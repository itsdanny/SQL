SELECT * FROM WorkCentre
SELECT dbo.fn_IntToTime(4029)

SELECT		*--dbo.fn_IntToTime(sum(WorkCentreJobRuntime)),dbo.fn_IntToTime(sum(StageRuntime))
FROM		WorkCentreJob wcj
INNER JOIN	WorkCentreJobLog wcjl
ON			wcj.Id = wcjl.WorkCentreJobId
WHERE		wcj.WorkOrderNumber = 'JY18B'

SELECT dbo.fn_IntToTime(3061)

SELECT		DIStinct wcjel.*--, WCJ.WorkCentreId
FROM		WorkCentreJob wcj
INNER JOIN	WorkCentreJobLog wcjl
ON			wcj.Id = wcjl.WorkCentreJobId
INNER JOIN	WorkCentreJobEventLog wcjel
ON			wcj.Id = wcjel.WorkCentreJobId
WHERE		wcj.WorkCentreId = 19
--and			WorkOrderNumber ='HW25B'
AND			wcj.Id IN(294)
order by	wcjel.Id desc

SELECT		wcjel.* 
FROM		WorkCentreJob wcj
INNER JOIN	WorkCentreJobEventLog wcjel 
ON			wcj.Id = wcjel.WorkCentreJobId	
WHERE		WorkOrderNumber ='HJ98B'
ORDER BY	wcjel.id DESC

SELECT *
FROM WorkCentreJobLog a WITH(NOLOCK) 
INNER JOIN WorkCentreJob b WITH(NOLOCK) 
on a.WorkCentreJobId = b.Id 
INNER JOIN WorkCentreJobEventLog e 
on e.WorkCentreJobId = a.WorkCentreJobId
 where WorkCentreID = 8
 order by e.Id desc
 
 select * from WorkCentreJobEventLog where FinishDateTime is null
 
 SELECT * FROM WorkCentreJob 
 INNER JOIN WorkCentreJobLog 
 ON		 WorkCentreJob.Id = WorkCentreJobLog.WorkCentreJobId 
 WHERE	(WorkCentreJobLog.FinishDateTime IS NULL) 
 AND	(WorkCentreJob.WorkCentreId = 20)
 
 select * from WorkCentreJob j
 INNER JOIN	WorkCentreJobLog l
 ON			J.Id = l.WorkCentreJobId
 where		l.FinishDateTime is null
 
 select * from WorkCentreJob order by id desc WHERE WorkCrewe is null
 
 delete from WorkCentreJobStillageLog WHERE ID not in(select WorkCentreJobId from WorkCentreJobLog)
 
 
delete from WorkCentreJob WHERE ID not in(select WorkCentreJobId from WorkCentreJobLog)
 or WorkCrewe is null