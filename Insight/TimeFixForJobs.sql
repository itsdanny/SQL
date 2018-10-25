/*SELECT			j.Description, j.WorkCentreJobRuntime, l.StartDateTime, l.FinishDateTime, l.StageRuntime, l.StandardRuntime, 
				el.StartDateTime as EventStart, el.FinishDateTime as EventFinish, 
				el.TotalNumberOfMinutes as InsightRecordedMinutes, 
				DATEDIFF(MINUTE, el.StartDateTime, el.FinishDateTime) AS ActualMinutes,
				e.DisplayName
FROM			WorkCentreJob J
INNER JOIN		WorkCentreJobLog l
ON				l.WorkCentreJobId = j.Id
LEFT JOIN		WorkCentreJobEventLog el
ON				j.Id = el.WorkCentreJobId
INNER JOIN		WorkCentreEvent e
ON				e.Id = el.WorkCentreEventId
where			J.Id = 6435
*/
SELECT			wc.Name, wc.SageRef, j.WorkOrderNumber,	j.Description, l.StartDateTime, l.FinishDateTime, l.StandardRuntime, j.WorkCentreJobRuntime, l.StageRuntime, 
				DATEDIFF(MINUTE, l.StartDateTime, l.FinishDateTime) AS ActualMinutes								
FROM			WorkCentre wc
INNER JOIN		WorkCentreJob J
ON				wc.Id  = j.WorkCentreId
INNER JOIN		WorkCentreJobLog l
ON				l.WorkCentreJobId = j.Id
WHERE			L.FinishDateTime IS NOT NULL
AND				l.StageRuntime > 0
AND				j.WorkOrderNumber = 'KJ42B'
GROUP BY		wc.Name, wc.SageRef, j.WorkOrderNumber, j.Description, j.WorkCentreJobRuntime, l.StartDateTime, l.FinishDateTime, l.StageRuntime, l.StandardRuntime
HAVING			ISNULL(l.StageRuntime, 0) - DATEDIFF(MINUTE, l.StartDateTime, l.FinishDateTime) > 1
ORDER BY		l.StartDateTime	
/*
SELECT			wc.Name, wc.SageRef, j.WorkOrderNumber,	j.Description, j.WorkCentreJobRuntime, l.StartDateTime, l.FinishDateTime, l.StageRuntime, l.StandardRuntime, 
				el.StartDateTime as EventStart, el.FinishDateTime as EventFinish, 
				el.TotalNumberOfMinutes as InsightRecordedMinutes, 
				DATEDIFF(MINUTE, el.StartDateTime, el.FinishDateTime) AS ActualMinutes,				
				e.DisplayName
FROM			WorkCentre wc
INNER JOIN		WorkCentreJob J
ON				wc.Id  = j.WorkCentreId
INNER JOIN		WorkCentreJobLog l
ON				l.WorkCentreJobId = j.Id
LEFT JOIN		WorkCentreJobEventLog el
ON				j.Id = el.WorkCentreJobId
INNER JOIN		WorkCentreEvent e
ON				e.Id = el.WorkCentreEventId
GROUP BY		wc.Name, wc.SageRef, j.WorkOrderNumber, j.Description, j.WorkCentreJobRuntime, l.StartDateTime, l.FinishDateTime, l.StageRuntime, l.StandardRuntime, el.StartDateTime, el.FinishDateTime, el.TotalNumberOfMinutes, e.DisplayName
HAVING			el.TotalNumberOfMinutes - DATEDIFF(MINUTE, el.StartDateTime, el.FinishDateTime) > 1
ORDER BY		l.StartDateTime	
*/

--
select *, DATEDIFF(MINUTE, StartDateTime, FinishDateTime) from WorkCentreJobEventLog where (TotalNumberOfMinutes - DATEDIFF(MINUTE, StartDateTime, FinishDateTime) ) > 1
--
select * from WorkCentreJobLog  where StageRuntime <> DATEDIFF(MINUTE, StartDateTime, FinishDateTime)
--
update WorkCentreJobEventLog set TotalNumberOfMinutes = DATEDIFF(MINUTE, StartDateTime, FinishDateTime) where DATEDIFF(MINUTE, StartDateTime, FinishDateTime) <> TotalNumberOfMinutes
--
update WorkCentreJobLog set StageRuntime = DATEDIFF(MINUTE, StartDateTime, FinishDateTime) where StageRuntime <> DATEDIFF(MINUTE, StartDateTime, FinishDateTime)


