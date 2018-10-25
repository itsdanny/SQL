SELECT		distinct j.*, l.*, e.* --INTO #tmp
FROM		WorkCentreJob j
INNER JOIN 	WorkCentreJobLog l
ON			j.Id = l.WorkCentreJobId
INNER JOIN 	WorkCentreJobEventLog e
ON			j.Id = e.WorkCentreJobId
WHERE		j.Id = 940191
AND			l.FinishDateTime is null
RETURN 
/*
1	939502
2	939630
3	940150
4	940181
5	940191
*/
DELETE FROM	WorkCentreJobEventLog 
WHERE		(Id < 117865) 
AND			WorkCentreJobId = 939630
AND			FinishDateTime IS NULL

UPDATE 	l
SET		l.FinishDateTime = e.FinishDateTime, StageRuntime =DATEDIFF(MINUTE, e.StartDateTime, e.FinishDateTime)
FROM	WorkCentreJobLog l
INNER JOIN 	WorkCentreJobEventLog e
ON		l.WorkCentreJobId = e.WorkCentreJobId
AND		l.WorkCentreJobId = 939630
AND		WorkCentreStageId = 1


SELECT	*
FROM		WorkCentreJob j
INNER JOIN 	WorkCentreJobLog l
ON			j.Id = l.WorkCentreJobId
WHERE		j.Id = 939633

UPDATE 		j
SET 		j.WorkCentreJobRuntime = 1382
FROM		WorkCentreJob j
INNER JOIN 	WorkCentreJobLog l
ON			j.Id = l.WorkCentreJobId
WHERE		j.Id = 939633
