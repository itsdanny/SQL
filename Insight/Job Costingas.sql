--select ((CAST(l.StandardRuntime AS MONEY)/60)*c.std_labour_rate)-(MAX(CAST(j.WorkCentreJobRuntime AS MONEY)/60)*c.std_labour_rate) AS CostVariance, J.Id , j.WorkOrderNumber
-- from 
--WorkCentre w
--INNER JOIN	Area a
--ON			w.AreaId = a.Id
--INNER JOIN syslive.scheme.wsskm c 
--ON			a.CostCentreCode = c.code collate Latin1_General_BIN
--INNER JOIN	WorkCentreJob j
--ON			w.Id = j.WorkCentreId
--INNER JOIN	WorkCentreJobLog l
--ON			j.Id = l.WorkCentreJobId
--WHERE		j.WorkOrderNumber = 'KY34B'
--GROUP BY J.Id, l.StandardRuntime, c.std_labour_rate,j.WorkOrderNumber



SELECT ((CAST(l.StandardRuntime AS MONEY)/60)*c.std_labour_rate)-(MAX(CAST(j.WorkCentreJobRuntime AS MONEY)/60)*c.std_labour_rate) AS CostVariance, J.Id , j.WorkOrderNumber, MAX(j.JobCost) as CurJobCost INTO #TMP
 from 
WorkCentre w
INNER JOIN	Area a
ON			w.AreaId = a.Id
INNER JOIN syslive.scheme.wsskm c 
ON			a.CostCentreCode = c.code collate Latin1_General_BIN
INNER JOIN	WorkCentreJob j
ON			w.Id = j.WorkCentreId
INNER JOIN	WorkCentreJobLog l
ON			j.Id = l.WorkCentreJobId
GROUP BY J.Id, l.StandardRuntime, c.std_labour_rate,j.WorkOrderNumber

DECLARE @JobId INT = 15219
select * from #TMP WHERE Id = @JobId

UPDATE j
set j.[JobCost] =  t.CostVariance
from WorkCentreJob j inner join #TMP t
ON		J.Id = T.Id

drop table #TMP