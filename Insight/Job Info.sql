USE InsightTest
SELECT			j.*,l.WorkCentreStageId,el.*
FROM			WorkCentre wc
INNER JOIN		WorkCentreJob J
ON				wc.Id  = j.WorkCentreId
INNER JOIN		WorkCentreJobLog l
ON				l.WorkCentreJobId = j.Id
INNER JOIN		WorkCentreJobEventLog el
ON				el.WorkCentreJobId = j.Id
WHERE			wc.Name='Line8'
AND				el.StartDateTime between '2017-11-21 17:00' and '2017-11-29 17:00'
--GROUP BY		j.id, wc.Name, wc.SageRef, j.WorkOrderNumber, j.Description, j.WorkCentreJobRuntime, l.StartDateTime, l.FinishDateTime, l.StageRuntime, l.StandardRuntime
--HAVING			ISNULL(l.StageRuntime, 0) - DATEDIFF(MINUTE, l.StartDateTime, l.FinishDateTime) > 1
ORDER BY		el.StartDateTime	

UPDATE 	WorkCentreJob SET ProcessOrderNumber = '1082353' WHERE		Id = 36523

return

SELECT			wc.name, j.*,el.*
FROM			WorkCentre wc
INNER JOIN		WorkCentreJob J
ON				wc.Id  = j.WorkCentreId
INNER JOIN		WorkCentreJobLog l
ON				l.WorkCentreJobId = j.Id
INNER JOIN		WorkCentreJobEventLog el
ON				el.WorkCentreJobId = j.Id
WHERE			l.WorkCentreStageId = 2
and				el.WorkCentreEventId = 2
--GROUP BY		j.id, wc.Name, wc.SageRef, j.WorkOrderNumber, j.Description, j.WorkCentreJobRuntime, l.StartDateTime, l.FinishDateTime, l.StageRuntime, l.StandardRuntime
--HAVING			ISNULL(l.StageRuntime, 0) - DATEDIFF(MINUTE, l.StartDateTime, l.FinishDateTime) > 1
ORDER BY		el.StartDateTime	

SELECT * FROM WorkCentreJobStillageLog WHERE WorkCentreJobId = 10006

SELECT * FROM WorkCentreJobLog WHERE WorkCentreStageId = 1 ORDER BY Id 

SELECT		distinct l.*, W.Name, S.StillageTime 
FROM		WorkCentreJobStillageLog s 
INNER JOIN	WorkCentreJobLog l
ON			s.WorkCentreJobId = l.WorkCentreJobId
INNER JOIN	WorkCentreJob j 
ON			j.Id = l.WorkCentreJobId
INNER JOIN	WorkCentre w
ON			w.Id = j.WorkCentreId
WHERE		WorkCentreStageId = 1 
AND			l.BPM = 0
ORDER BY	l.Id DESC 

select * from WorkCentre