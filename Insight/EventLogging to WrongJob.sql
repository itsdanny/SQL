USE Insight;
select l.*, j.WorkOrderNumber, j.Description, j.MaxBPM, j.MinBPM, wj.*
FROM		InsightTest.dbo.WorkCentreJobEventLog l
INNER JOIN	InsightTest.dbo.WorkCentreJob j
ON			l.WorkCentreJobId = j.Id
INNER JOIN	InsightTest.dbo.WorkCentreJobLog wj
ON			wj.WorkCentreJobId = j.Id
INNER JOIN	InsightTest.dbo.WorkCentre w
ON			j.WorkCentreId = w.Id
WHERE		w.SageRef = 'HS05'
--AND			WorkCentreEventId = 12 
--AND			DATEDIFF(SECOND, StartDateTime, FinishDateTime) < 10
order by	l.StartDateTime desc

use Insight
SELECT * FROM InsightErrors where UserName = 'Marchesini' ORDER BY ErrorID desc
SELECT * FROM InsightErrors where OtherInfo = 'Marchesini' ORDER BY ErrorID desc
SELECT * FROM WorkCentreJob ORDER BY Id desc
SELECT * FROM WorkCentreJobLog  WHERE WorkCentreJobId = 8936
SELECT * FROM WorkCentreJobStillageLog WHERE WorkCentreJobId = 8936
SELECT * FROM Insight.dbo.WorkCentreJobStillageLog WHERE WorkCentreJobId = 8936

SELECT * FROM WorkCentreJob j INNER JOIN WorkCentreJobLog l on j.Id = l.WorkCentreJobId  where WorkCentreJobId in (8823)
SELECT * FROM WorkCentreJobEventLog order by Id desc
SELECT * FROM WorkCentre where Id = 20

select * from ChangeOverType c
inner join WorkCentreJob j
ON			CAST(c.Id AS VARCHAR(3)) = CAST(j.WorkOrderNumber AS VARCHAR(3))


select * from ChangeOverType c
inner join WorkCentreChangeOver wc
ON		c.Id = wc.ChangeOverTypeId
inner join WorkCentreJob j
ON			CAST(wc.Id AS VARCHAR(3)) = CAST(j.WorkOrderNumber AS VARCHAR(3))

/*
--	WILL NEED TO UPDATE INSIGHT LIVE CO's BEFORE ROLLING TEST PHASE OUT
update	c
set		c.ChangeOverName = c.ChangeOverName+'.'
from ChangeOverType c
inner join WorkCentreChangeOver wc
ON		c.Id = wc.ChangeOverTypeId
inner join WorkCentreJob j
ON			CAST(wc.Id AS VARCHAR(3)) = CAST(j.WorkOrderNumber AS VARCHAR(3))

update	j
set		j.Description =  j.Description+'.'
from ChangeOverType c
inner join WorkCentreChangeOver wc
ON		c.Id = wc.ChangeOverTypeId
inner join WorkCentreJob j
ON			CAST(wc.Id AS VARCHAR(3)) = CAST(j.WorkOrderNumber AS VARCHAR(3))
*/
*/