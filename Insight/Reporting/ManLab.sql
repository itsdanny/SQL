use Insight

SELECT		j.WorkOrderNumber, j.Product, j.Description, 
			ManufacturingJobRuntime,
			--dbo.fn_IntToTime(j.ManufacturingJobRuntime) as JobRunHours, ms.name AS StageName,
			count(distinct l.EmpRef) as Crewe,
			l.StandardRuntime,
			l.StageRuntime,
			--dbo.fn_IntToTime(MAX(l.StandardRuntime)) as StandardHours,
			--dbo.fn_IntToTime(SUM(l.StageRuntime)) as ActualHours,
			MIN(l.StartDateTime) as FinishDateTime,
			MAX(l.FinishDateTime) as FinishDateTime
FROM		ManufacturingJob j
INNER JOIN	ManufacturingJobLog l
ON			j.Id = l.ManufacturingJobId	
INNER JOIN  ManufacturingStage ms
ON			l.ManufacturingStageId = ms.Id
WHERE		l.ManufacturingStageId <> 4441
AND			l.StartDateTime >= '2014-06-01'
GROUP BY	j.WorkOrderNumber, j.Product, j.Description, j.ManufacturingJobRuntime, ms.name,			l.StandardRuntime,			l.StageRuntime
--order by	min(l.StartDateTime)
