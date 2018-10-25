ALTER PROCEDURE sp__ProductionHours
AS 
SELECT		a.Id as AreaId, 
			a.Name, 
			wc.Name as Line,
			MIN(l.StartDateTime) as StartDateTime,
			MAX(l.FinishDateTime) as FinishDateTime,
			--CASE DATEDIFF(week, l.StartDateTime, l.FinishDateTime) WHEN 1 THEN '*' ELSE '' END as Diff,
			dbo.fn_IntToTime(SUM(j.WorkCentreJobRuntime)) as WorkCentreJobRuntime
FROM		WorkCentreJob j with(NOLOCK)
INNER JOIN	WorkCentre wc with(NOLOCK)
ON			wc.Id = j.WorkCentreId
INNER JOIN	WorkCentreJobLog l with(NOLOCK)
ON          j.Id = l.WorkCentreJobId
INNER JOIN	Area a
ON			a.Id = wc.AreaId
WHERE		DATEDIFF(week, StartDateTime, GETDATE()) = 1
AND			j.WorkCentreJobRuntime IS NOT NULL
AND			j.WorkCentreJobRuntime > 0
GROUP BY	a.Id, a.Name, wc.Name--, DATEDIFF(WEEK, l.StartDateTime, l.FinishDateTime)
UNION
SELECT		a.Id as AreaId, 
			a.Name, 
			CASE WHEN wc.Name LIKE 'LARGEVOLBAY%' THEN '4000L Manufacturing Pan' WHEN wc.Name LIKE 'SMALLVOLBOOTH%' THEN 'Small Mixing Booths' WHEN wc.Name LIKE 'DINEX%' THEN 'Dinex 3500' ELSE wc.Name end as Line,
			MIN(L.StartDateTime),
			MAX(FinishDateTime), 
			--CASE DATEDIFF(week, l.StartDateTime, l.FinishDateTime) WHEN 1 THEN '*' ELSE '' END as Diff,
			dbo.fn_IntToTime(SUM(l.StageRuntime)) as WorkCentreJobRuntime
FROM		WorkCentre wc
LEFT JOIN	syslive.scheme.wswopm w
ON			wc.SageRef = w.machine_group collate Latin1_General_BIN
INNER JOIN	Area a
ON			a.Id = wc.AreaId
INNER JOIN	ManufacturingJob j
ON			j.WorkOrderNumber = w.works_order collate Latin1_General_BIN
INNER JOIN	ManufacturingJobLog l
ON			j.Id = l.ManufacturingJobId
WHERE		DATEDIFF(week, StartDateTime, GETDATE()) = 1
AND			wc.AreaId = 3
GROUP BY	a.Id, a.Name, wc.Name
ORDER BY	AreaId

go


RETURN
select * from	syslive.scheme.wswopm w
INNER JOIN		syslive.scheme.bmwohm b
ON				w.works_order = b.works_order
where DATEDIFF(week, completion_date , GETDATE()) = 1 and alpha_code not like 'TPTY%' AND warehouse = 'BK'
and machine_group = 'MN13'