/*-- JOBS ALL OF DEM!
SELECT		DISTINCT a.Name, w.Name, w.SageRef, j.WorkOrderNumber, j.Product,  j.[Description], j.WorkCentreJobRuntime, j.WorkCrewe, ev.DisplayName, el.StartDateTime, el.FinishDateTime, el.TotalNumberOfMinutes
			,jl.StartDateTime, jl.FinishDateTime, jl.StandardRuntime, jl.StageRuntime, COUNT(distinct d.EmpRef) as StaffWorkedOnJob
FROM		Area a
INNER JOIN	WorkCentre w
ON			a.Id = w.AreaId
INNER JOIN	WorkCentreJob j
ON			w.Id = j.WorkCentreId
INNER JOIN	WorkCentreJobEventLog el
ON			j.Id = el.WorkCentreJobId
INNER JOIN	WorkCentreEvent ev
ON			el.WorkCentreEventId = ev.Id
INNER JOIN	WorkCentreJobLog jl
ON			j.Id = jl.WorkCentreJobId
INNER JOIN	WorkCentreJobLogLabourDetail d
ON			jl.Id = d.WorkCentreJobLogId	
INNER JOIN	WorkCentreStage s
ON			jl.WorkCentreStageId = s.Id
WHERE		jl.StartDateTime > ='2014-06-4' -- ignoring the 1st couple of days of data as it's crap!
AND			w.name in ('LINE1','LINE4','LINE6')
GROUP BY	a.Name, w.Name, w.SageRef, j.WorkOrderNumber, j.Product,  j.[Description], j.WorkCentreJobRuntime, j.WorkCrewe, ev.DisplayName, el.StartDateTime, el.FinishDateTime, 
			el.TotalNumberOfMinutes, jl.StartDateTime, jl.FinishDateTime, jl.StandardRuntime, jl.StageRuntime
ORDER by	a.Name, w.Name, w.SageRef, j.WorkOrderNumber, j.Product,  j.[Description], j.WorkCentreJobRuntime, j.WorkCrewe, el.StartDateTime

-- JOBS BY EVENT
SELECT		a.Name, w.Name, w.SageRef, j.WorkOrderNumber, j.Product,  j.[Description], j.WorkCentreJobRuntime, j.WorkCrewe, ev.DisplayName, el.StartDateTime, el.FinishDateTime, el.TotalNumberOfMinutes
			--,jl.StartDateTime, jl.FinishDateTime, jl.StandardRuntime, jl.StageRuntime, COUNT(distinct d.EmpRef) as StaffWorkedOnJob--, ct.ChangeOverName, co.BatchTime
FROM		Area a
INNER JOIN	WorkCentre w
ON			a.Id = w.AreaId
INNER JOIN	WorkCentreJob j
ON			w.Id = j.WorkCentreId
INNER JOIN	WorkCentreJobEventLog el
ON			j.Id = el.WorkCentreJobId
INNER JOIN	WorkCentreEvent ev
ON			el.WorkCentreEventId = ev.Id
INNER JOIN	WorkCentreJobLog jl
ON			j.Id = jl.WorkCentreJobId
INNER JOIN	WorkCentreJobLogLabourDetail d
ON			jl.Id = d.WorkCentreJobLogId
INNER JOIN	WorkCentreStage s
ON			jl.WorkCentreStageId = s.Id

--INNER JOIN	WorkCentreChangeOver co
--ON			w.Id = co.WorkCentreId
--INNER JOIN	ChangeOverType ct
--ON			ct.Id = co.ChangeOverTypeId
WHERE		jl.StartDateTime > ='2014-05-01' -- ignoring the 1st couple of days of data as it's crap!
AND			w.name in ('LINE1','LINE6','LINE12')
GROUP BY	a.Name, w.Name, w.SageRef, j.WorkOrderNumber, j.Product,  j.[Description], j.WorkCentreJobRuntime, j.WorkCrewe, ev.DisplayName, el.StartDateTime, el.FinishDateTime, 
			el.TotalNumberOfMinutes--, jl.StartDateTime, jl.FinishDateTime, jl.StandardRuntime, jl.StageRuntime--,ct.ChangeOverName, co.BatchTime
ORDER by	a.Name, w.Name, w.SageRef, j.WorkOrderNumber, j.Product,  j.[Description], j.WorkCentreJobRuntime, j.WorkCrewe, el.StartDateTime

-- JOBS BY LOG
SELECT		a.Name, w.Name, w.SageRef, j.WorkOrderNumber, j.Product,  j.[Description], j.WorkCentreJobRuntime, j.WorkCrewe, s.Name, jl.StartDateTime, jl.FinishDateTime, jl.StandardRuntime, jl.StageRuntime, COUNT(distinct d.EmpRef) as StaffWorkedOnJob
FROM		Area a
INNER JOIN	WorkCentre w
ON			a.Id = w.AreaId
INNER JOIN	WorkCentreJob j
ON			w.Id = j.WorkCentreId
INNER JOIN	WorkCentreJobLog jl
ON			j.Id = jl.WorkCentreJobId
INNER JOIN	WorkCentreJobLogLabourDetail d
ON			jl.Id = d.WorkCentreJobLogId
INNER JOIN	WorkCentreStage s
ON			jl.WorkCentreStageId = s.Id
WHERE		jl.StartDateTime > ='2014-05-01' -- ignoring the 1st couple of days of data as it's crap!
AND			w.name in ('LINE1','LINE6','LINE12')
GROUP BY	a.Name, w.Name, w.SageRef, j.WorkOrderNumber, j.Product,  j.[Description], j.WorkCentreJobRuntime, j.WorkCrewe,
			jl.StartDateTime, jl.FinishDateTime, jl.StandardRuntime, jl.StageRuntime,s.Name
ORDER by	a.Name, w.Name, w.SageRef, j.WorkOrderNumber, j.Product,  j.[Description], j.WorkCentreJobRuntime, j.WorkCrewe,jl.StartDateTimE
select * from WorkCentreJob where id in(
select distinct(WorkCentreJobId) from WorkCentreJobEventLog where FinishDateTime is null and StartDateTime < GETDATE()-3)
select distinct(WorkCentreJobId) from WorkCentreJobEventLog where FinishDateTime is null and StartDateTime < GETDATE()-3 and WorkCentreEventId = 3
*/
SELECT	 j.id as JobID, jl.Id as JobLogId, jl.WorkCentreJobId, jl.StartDateTime, jl.FinishDateTime, l.id as EventId, l.WorkCentreJobId, l.StartDateTime, l.FinishDateTime
FROM		WorkCentreJob j
LEFT JOIN	WorkCentreJobEventLog l
ON			j.Id = l.WorkCentreJobId
LEFT  JOIN	WorkCentreJobLog jl
ON			j.Id = jl.WorkCentreJobId
WHERE		j.WorkOrderNumber = 'HX43B'
*/
select w.Name, j.Id, j.WorkOrderNumber, j.Description, j.WorkCrewe, jl.Id, jl.StartDateTime as JobStartTime, jl.FinishDateTime as JobFinishTime
from WorkCentreJob j
--LEFT JOIN WorkCentreJobEventLog l
--ON		j.Id = l.WorkCentreJobId
LEFT JOIN WorkCentreJobLog jl
ON		j.Id = jl.WorkCentreJobId
LEFT JOIN WorkCentre w
ON		j.WorkCentreId = w.Id
--LEFT JOIN WorkCentreEvent wce
--ON		l.WorkCentreEventId = wce.Id
where	W.Name in ('NORDEN','MARCHESINI','LINE6','LINE8')
and		(jl.StartDateTime > '2014-06-20')
ORDER BY W.Name, j.Id desc, j.WorkOrderNumber, j.Description, j.WorkCrewe

SELECT DISTINCT W.Name, j.WorkOrderNumber, j.Description, j.WorkCrewe,  jl.BPM, jl.StandardRuntime, jl.StageRuntime, CASE wce.Name WHEN 'Paused' THEN jl.StageRuntime - el.TotalNumberOfMinutes ELSE jl.StageRuntime end as JobMinusPaused, 
jl.StartDateTime as JobStartTime, jl.FinishDateTime as JobFinishTime, wce.Name, el.StartDateTime, el.FinishDateTime, el.TotalNumberOfMinutes
from WorkCentreJob j
LEFT JOIN WorkCentreJobEventLog el
ON		j.Id = el.WorkCentreJobId
LEFT JOIN WorkCentreJobLog jl
ON		j.Id = jl.WorkCentreJobId
LEFT JOIN WorkCentre w
ON		j.WorkCentreId = w.Id
inner JOIN WorkCentreEvent wce
ON		el.WorkCentreEventId = wce.Id
where	W.Name in ('NORDEN','MARCHESINI')
and		(jl.StartDateTime > '2014-06-20')
ORDER BY w.name,  jl.StartDateTime desc, el.StartDateTime desc


SELECT		w.Name, w.SageRef, j.WorkOrderNumber, j.Description, j.WorkCrewe, count(distinct lab.EmpRef) as ActualCrewe, jl.StandardRuntime,  ws.Name, 
			MAX(jl.StageRuntime) AS JobRunTime,
--			SUM(CASE WHEN jl.StageRuntime > 0 THEN jl.StageRuntime ELSE 0 END) AS TotalTime, 
--			SUM(CASE wce.Name WHEN 'Paused' THEN CASE WHEN el.TotalNumberOfMinutes > 0 THEN el.TotalNumberOfMinutes ELSE 0 END ELSE 0 END) as PausedTime, 			
			jl.StartDateTime as JobStartTime, jl.FinishDateTime as JobFinishTime, el.Id, el.StartDateTime as EventStartTime, el.FinishDateTime as EventFinishTime, el.TotalNumberOfMinutes as EventMinutes, wce.Name
from		WorkCentreJob j
LEFT JOIN	WorkCentreJobEventLog el
ON			j.Id = el.WorkCentreJobId
LEFT JOIN	WorkCentreJobLog jl
ON			j.Id = jl.WorkCentreJobId
LEFT JOIN	WorkCentre w
ON			j.WorkCentreId = w.Id
INNER JOIN	WorkCentreEvent wce
ON			el.WorkCentreEventId = wce.Id
INNER JOIN	WorkCentreStage ws
ON			jl.WorkCentreStageId = ws.Id
INNER JOIN  WorkCentreJobLogLabourDetail lab
ON			lab.WorkCentreJobLogId = jl.Id
WHERE		(jl.StartDateTime between '2014-07-01' and '2014-07-31')
group by  W.Name, w.SageRef, j.WorkOrderNumber, j.Description, j.WorkCrewe, jl.StandardRuntime, jl.StartDateTime,  jl.FinishDateTime,el.StartDateTime, el.FinishDateTime, el.TotalNumberOfMinutes, wce.Name,ws.Name, el.Id
ORDER BY w.name,  jl.StartDateTime desc, el.StartDateTime 



select * from ManufacturingJob where ManufacturingRoute is not null
select * from WorkCentreJob 
inner join WorkCentreJobLog 
ON WorkCentreJob.Id = WorkCentreJobLog.WorkCentreJobId 
inner join WorkCentreJobStillageLog s
ON		  s.WorkCentreJobId = WorkCentreJobLog.WorkCentreJobId 
where WorkOrderNumber ='JC98B'
select * from WorkCentreJobEventLog where WorkCentreJobId = 24
select * from WorkCentreJobLog where WorkCentreJobId = 3697
select * from WorkCentreJobEventLog where WorkCentreJobId = 20
select DATEDIFF(minute, '2014-06-11 02:16:14.65','2014-06-11 13:55:54.650')


update WorkCentreJobEventLog set TotalNumberOfMinutes  = datediff(MINUTE, StartDateTime, FinishDateTime) where TotalNumberOfMinutes < 0
SELECT DATEDIFF(MINUTE,'2014-07-08 10:47:31.000','2014-07-11 09:31:13.190')
select StartDateTime, FinishDateTime, datediff(MINUTE, StartDateTime, FinishDateTime), TotalNumberOfMinutes from WorkCentreJobEventLog where TotalNumberOfMinutes < 0