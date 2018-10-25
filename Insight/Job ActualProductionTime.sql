-- PRODUCTION
SELECT		j.id,
			--, j.WorkOrderNumber, j.Description,  l.StartDateTime, l.FinishDateTime, j.WorkCentreJobRuntime, 
			sum(e.TotalNumberOfMinutes) AS AllMins,
			SUM(CASE WHEN e.WorkCentreEventId in (1,5) then e.TotalNumberOfMinutes end) AS StartToEndMins,
			SUM(CASE WHEN e.WorkCentreEventId in (12) then e.TotalNumberOfMinutes end) AS WaitMins,
			SUM(CASE WHEN e.WorkCentreEventId in (1,5) then e.TotalNumberOfMinutes else 0 end) - SUM(CASE WHEN e.WorkCentreEventId in (12) then e.TotalNumberOfMinutes else 0 end) as CleanMins into #tmp
FROM		WorkCentreJob j
INNER JOIN	WorkCentreJobEventLog e
ON			j.Id = e.WorkCentreJobId
INNER JOIN	WorkCentreJobLog l
ON			j.Id = l.WorkCentreJobId
WHERE		l.WorkCentreStageId = 1
AND			l.FinishDateTime IS NOT NULL
GROUP BY	j.id--, j.WorkOrderNumber, j.Description, l.StartDateTime, l.FinishDateTime

UPDATE		j
SET			j.WorkCentreJobRuntime = t.CleanMins
FROM		WorkCentreJob j
INNER JOIN	#tmp t
ON			j.Id = t.id

UPDATE		l
SET			l.JobPerformance = CAST(l.StandardRuntime AS FLOAT)/t.CleanMins
FROM		WorkCentreJob j
INNER JOIN	#tmp t
ON			j.Id = t.id
INNER JOIN	WorkCentreJobLog l
ON			j.Id = l.WorkCentreJobId
WHERE		CleanMins > 0

DROP TABLE #tmp
GO

SELECT		j.id, 
			(sum(s.StillageQuantity)*max(j.UOM))/max(j.WorkCentreJobRuntime) as newBPM into #BPM
FROM		WorkCentreJob j
INNER JOIN  WorkCentreJobStillageLog s
ON			s.WorkCentreJobId = j.Id
WHERE 		j.WorkCentreJobRuntime > 0
GROUP BY	j.id

UPDATE		l
SET			l.BPM = b.newBPM
FROM		WorkCentreJobLog l
INNER JOIN	#BPM b
ON			l.WorkCentreJobId = b.id

DROP TABLE #BPM


--	CHANGEOVERS
SELECT		j.id, j.WorkOrderNumber, j.Description,  l.StartDateTime, l.FinishDateTime, j.WorkCentreJobRuntime, 
			sum(e.TotalNumberOfMinutes) AS AllMins,
			SUM(CASE WHEN e.WorkCentreEventId in (4) then e.TotalNumberOfMinutes end) AS StartToEndMins,
			SUM(CASE WHEN e.WorkCentreEventId in (12) then e.TotalNumberOfMinutes end) AS WaitMins,
			SUM(CASE WHEN e.WorkCentreEventId in (4) then e.TotalNumberOfMinutes else 0 end) - COALESCE(SUM(CASE WHEN e.WorkCentreEventId in (12) then e.TotalNumberOfMinutes else 0 end), 0) as CleanMins 
			--into #tmp
			select *
FROM		WorkCentreJob j
INNER JOIN	WorkCentreJobEventLog e
ON			j.Id = e.WorkCentreJobId
INNER JOIN	WorkCentreJobLog l
ON			j.Id = l.WorkCentreJobId
WHERE		l.WorkCentreStageId = 2
--and			j.WorkCentreId = 8
--and			l.StartDateTime BETWEEN '2015-04-01' AND '2015-04-30'
AND			e.WorkCentreJobId = 7705
GROUP BY	j.id, j.WorkCentreJobRuntime, j.WorkOrderNumber, j.Description, l.StartDateTime, l.FinishDateTime


select * from #tmp where id in (7705)

UPDATE		j
SET			j.WorkCentreJobRuntime = t.CleanMins
FROM		WorkCentreJob j
INNER JOIN	#tmp t
ON			j.Id = t.id

UPDATE #tmp SET CleanMins = 1 WHERE CleanMins = 0

UPDATE		l 
SET			l.JobPerformance = CAST(l.StandardRuntime AS FLOAT)/t.CleanMins
FROM		WorkCentreJob j
INNER JOIN	#tmp t
ON			j.Id = t.id
INNER JOIN	WorkCentreJobLog l
ON			j.Id = l.WorkCentreJobId

DROP TABLE #tmp

-- COSTS
SELECT		((CAST(l.StandardRuntime AS MONEY)/60)*c.std_labour_rate)-(MAX(CAST(j.WorkCentreJobRuntime AS MONEY)/60)*c.std_labour_rate) AS CostVariance, J.Id , j.WorkOrderNumber, MAX(j.JobCost) as CurJobCost INTO #TMP
FROM		WorkCentre w
INNER JOIN	Area a
ON			w.AreaId = a.Id
INNER JOIN	syslive.scheme.wsskm c 
ON			a.CostCentreCode = c.code collate Latin1_General_BIN
INNER JOIN	WorkCentreJob j
ON			w.Id = j.WorkCentreId
INNER JOIN	WorkCentreJobLog l
ON			j.Id = l.WorkCentreJobId
GROUP BY	j.Id, l.StandardRuntime, c.std_labour_rate, j.WorkOrderNumber


UPDATE		j
SET			j.[JobCost] =  t.CostVariance
FROM		WorkCentreJob j 
INNER JOIN	#TMP t
ON			j.Id = t.Id

DROP TABLE #TMP

/*

SELECT		j.id, j.WorkOrderNumber, j.Description,  l.StartDateTime, l.FinishDateTime, j.WorkCentreJobRuntime, 
			sum(e.TotalNumberOfMinutes) AS AllMins,
			SUM(CASE WHEN e.WorkCentreEventId in (1) then e.TotalNumberOfMinutes end) AS StartToEndMins,
			SUM(CASE WHEN e.WorkCentreEventId in (12,3) then e.TotalNumberOfMinutes end) AS WaitMins,
			SUM(CASE WHEN e.WorkCentreEventId in (1) then e.TotalNumberOfMinutes end) - SUM(CASE WHEN e.WorkCentreEventId in (12,3) then e.TotalNumberOfMinutes end) as CleanMins  Into #tmp
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
AND			j.WorkCentreJobRuntime IS NOT NULL
group by	j.id, j.WorkCentreJobRuntime, j.WorkOrderNumber, j.Description, l.StartDateTime, l.FinishDateTime
order by	L.FinishDateTime DESC

UPDATE		j
SET			j.WorkCentreJobRuntime = t.StartToEndMins
FROM		WorkCentreJob j
inner join	#tmp t
ON			j.Id = t.id	

go
--	CHANGEOVERS
SELECT		j.id, j.WorkOrderNumber, j.Description,  l.StartDateTime, l.FinishDateTime, j.WorkCentreJobRuntime, 
			sum(e.TotalNumberOfMinutes) AS AllMins,
			SUM(CASE WHEN e.WorkCentreEventId in (4) then e.TotalNumberOfMinutes end) AS StartToEndMins,
			SUM(CASE WHEN e.WorkCentreEventId in (12,3) then e.TotalNumberOfMinutes end) AS WaitMins,
			SUM(CASE WHEN e.WorkCentreEventId in (4) then e.TotalNumberOfMinutes end) - COALESCE(SUM(CASE WHEN e.WorkCentreEventId in (12,3) then e.TotalNumberOfMinutes end), 0) as CleanMins into #tmp
FROM		WorkCentreJob j
INNER JOIN	WorkCentreJobEventLog e
ON			j.Id = e.WorkCentreJobId
INNER JOIN	WorkCentreJobLog l
ON			j.Id = l.WorkCentreJobId
WHERE		l.WorkCentreStageId = 2
--and			j.WorkCentreId = 8
--and			l.StartDateTime BETWEEN '2015-04-01' AND '2015-04-30'
--AND			e.WorkCentreJobId = 9786
AND			j.WorkCentreJobRuntime IS  NULL
group by	j.id, j.WorkCentreJobRuntime, j.WorkOrderNumber, j.Description, l.StartDateTime, l.FinishDateTime

select * from #tmp

UPDATE		j
SET			j.WorkCentreJobRuntime = t.StartToEndMins
FROM		WorkCentreJob j
inner join	#tmp t
ON			j.Id = t.id	

*/


SELECT		j.WorkOrderNumber, j.Description, j.WorkCentreJobRuntime, l.StandardRuntime, l.StartDateTime, l.FinishDateTime, l.JobPerformance, j.JobCost
FROM		WorkCentreJob j
INNER JOIN	WorkCentreJobLog l
ON			j.Id = l.WorkCentreJobId
--WHERE		WorkCentreId = 17 
ORDER BY	J.Id DESC