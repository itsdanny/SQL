 use Insight
---- PRODUCTION
SELECT		j.id, j.WorkOrderNumber, j.Description,  l.StartDateTime, l.FinishDateTime, j.WorkCentreJobRuntime, 
			sum(e.TotalNumberOfMinutes) AS AllMins,
			SUM(CASE WHEN e.WorkCentreEventId in (1) then e.TotalNumberOfMinutes end) AS StartToEndMins,
			SUM(CASE WHEN e.WorkCentreEventId in (12,3) then e.TotalNumberOfMinutes end) AS WaitMins,
			SUM(CASE WHEN e.WorkCentreEventId in (1) then e.TotalNumberOfMinutes else 0 end) - SUM(CASE WHEN e.WorkCentreEventId in (12,3) then e.TotalNumberOfMinutes else 0 end) as CleanMins into #tmp
FROM		WorkCentreJob j
INNER JOIN	WorkCentreJobEventLog e
ON			j.Id = e.WorkCentreJobId
INNER JOIN	WorkCentreJobLog l
ON			j.Id = l.WorkCentreJobId
WHERE		l.WorkCentreStageId = 1
--AND			e.WorkCentreEventId IN (4)
--and			j.WorkCentreId = 8
--and			l.StartDateTime BETWEEN '2015-04-01' AND '2015-04-30'
--AND			e.WorkCentreJobId = 9786
group by	j.id, j.WorkCentreJobRuntime, j.WorkOrderNumber, j.Description, l.StartDateTime, l.FinishDateTime

UPDATE	j
SET		j.WorkCentreJobRuntime = t.CleanMins
FROM	WorkCentreJob j
INNER JOIN #tmp t
ON			j.Id = t.id

DROP TABLE #tmp
go

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--	CHANGEOVERS
SELECT		j.id, j.WorkOrderNumber, j.Description,  l.StartDateTime, l.FinishDateTime, j.WorkCentreJobRuntime, 
			sum(e.TotalNumberOfMinutes) AS AllMins,
			SUM(CASE WHEN e.WorkCentreEventId in (4) then e.TotalNumberOfMinutes end) AS StartToEndMins,
			SUM(CASE WHEN e.WorkCentreEventId in (12,3) then e.TotalNumberOfMinutes end) AS WaitMins,
			SUM(CASE WHEN e.WorkCentreEventId in (4) then e.TotalNumberOfMinutes else 0 end) - COALESCE(SUM(CASE WHEN e.WorkCentreEventId in (12,3) then e.TotalNumberOfMinutes else 0 end), 0) as CleanMins into #tmp
FROM		WorkCentreJob j
INNER JOIN	WorkCentreJobEventLog e
ON			j.Id = e.WorkCentreJobId
INNER JOIN	WorkCentreJobLog l
ON			j.Id = l.WorkCentreJobId
WHERE		l.WorkCentreStageId = 2
--and			j.WorkCentreId = 8
--and			l.StartDateTime BETWEEN '2015-04-01' AND '2015-04-30'
--AND			e.WorkCentreJobId = 9786
group by	j.id, j.WorkCentreJobRuntime, j.WorkOrderNumber, j.Description, l.StartDateTime, l.FinishDateTime

update	j
set		j.WorkCentreJobRuntime = t.CleanMins
 FROM		WorkCentreJob j
inner join #tmp t
ON			j.Id = t.id

DROP TABLE #tmp

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Job Performance
UPDATE		l
SET			l.JobPerformance = CAST(l.StandardRuntime AS FLOAT)/j.WorkCentreJobRuntime
FROM		WorkCentreJob j
INNER JOIN	WorkCentreJobLog l
ON			l.WorkCentreJobId = j.Id
WHERE		j.WorkCentreJobRuntime > 0

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Job Costing
SELECT ((CAST(l.StandardRuntime AS MONEY)/60)*c.std_labour_rate)-(MAX(CAST(j.WorkCentreJobRuntime AS MONEY)/60)*c.std_labour_rate) AS CostVariance, J.Id , j.WorkOrderNumber INTO #TMP
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


UPDATE j
set j.[JobCost] =  t.CostVariance
from WorkCentreJob j inner join #TMP t
ON		J.Id = T.Id

drop table #TMP
