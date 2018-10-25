SELECT		l.BPM 
FROM		WorkCentreJob j
INNER JOIN	WorkCentreJobLog l
ON			j.Id = l.WorkCentreJobId
WHERE		l.BPM = 0
AND			l.WorkCentreStageId = 1
AND			j.WorkCentreJobRuntime > 0

UPDATE		l
SET			l.BPM = (SELECT SUM(s.StillageQuantity)/j.WorkCentreJobRuntime from WorkCentreJobStillageLog s where s.WorkCentreJobId = j.Id)
FROM		WorkCentreJob j
INNER JOIN	WorkCentreJobLog l
ON			j.Id = l.WorkCentreJobId
WHERE		l.BPM = 0
AND			l.WorkCentreStageId = 1
AND			j.WorkCentreJobRuntime > 0

--WHERE		l.FinishDateTime is not null
--group by	l.BPM, j.Id

SELECT		l.BPM
FROM		WorkCentreJob j
INNER JOIN	WorkCentreJobLog l
ON			j.Id = l.WorkCentreJobId
WHERE		l.BPM = 0
AND			l.WorkCentreStageId = 1
AND			j.WorkCentreJobRuntime > 0

SELECT * FROM WorkCentreJobLog WHERE WorkCentreJobId = 8473
SELECT * FROM WorkCentreJobLog WHERE WorkCentreStageId = 2


select * from WorkCentreJobLogLabourDetail where FinishDateTime < StartDateTime

 select d.FinishDateTime, l.FinishDateTime  from WorkCentreJobLogLabourDetail d INNER JOIN WorkCentreJobLog l on d.WorkCentreJobLogId = l.id where d.FinishDateTime < d.StartDateTime
 BEGIN TRAN
	UPDATE	d
	SET		d.FinishDateTime = l.FinishDateTime, 
			d.TotalMinutes = DATEDIFF(MINUTE, d.startDateTime, l.FinishDateTime)  
	FROM		WorkCentreJobLogLabourDetail d 
	INNER JOIN	WorkCentreJobLog l 
	ON			d.WorkCentreJobLogId = l.id WHERE d.FinishDateTime < d.StartDateTime
  
  rollback