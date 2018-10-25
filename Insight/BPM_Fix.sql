
--SELECT * FROM		WorkCentreJob
select * from WorkCentreJobStillageLog where WorkCentreJobId = 19185

--DROP TABLE #bmp
SELECT		j.id, max(ISNULL(l.BPM,0)) as CurrBMP, (sum(s.StillageQuantity)*max(j.UOM))/MAX(ISNULL(j.WorkCentreJobRuntime,0)) as newBPM into #bmp
--select		distinct j.Id, j.WorkCentreJobRuntime, e.*, UOM, s.StillageQuantity
FROM		WorkCentreJob j
INNER JOIN	WorkCentreJobLog l
ON			j.Id = l.WorkCentreJobId
INNER JOIN  WorkCentreJobStillageLog s
ON			s.WorkCentreJobId = j.Id
WHERE		l.WorkCentreStageId = 1
--AND			j.WorkOrderNumber = 'LK67'
--AND			j.Id = 19029
AND			j.WorkCentreJobRuntime > 0
GROUP BY	j.id


select	 l.BPM, b.*
--update l	set l.BPM = b.newBPM
from	WorkCentreJobLog l
INNER JOIN #bmp b
ON			l.WorkCentreJobId = b.id 
order by l.BPM desc

SELECT * FROM #bmp WHERE id = 19029

SELECT (3024*12)/315

select		MAX(j.WorkCentreJobRuntime), MAX(UOM), SUM(s.StillageQuantity), MAX(L.BPM)
FROM		WorkCentreJob j
INNER JOIN	WorkCentreJobLog l
ON			j.Id = l.WorkCentreJobId
INNER JOIN  WorkCentreJobStillageLog s
ON			s.WorkCentreJobId = j.Id
--INNER JOIN	WorkCentreJobEventLog e
--ON			j.Id = e.WorkCentreJobId
WHERE		l.WorkCentreStageId = 1
AND			j.Id = 19029
AND			j.WorkCentreJobRuntime > 0


