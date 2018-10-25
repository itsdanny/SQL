select		a.EmpRef, a.StartDateTime, a.FinishDateTime, 
			a.StartDateTime,
			a.FinishDateTime,
			dbo.fn_IntToTime(DATEDIFF(MINUTE, a.StartDateTime, a.FinishDateTime)) HHMM, 
			DATEDIFF(MINUTE, a.StartDateTime, a.FinishDateTime) as MinutesLoggedIn
FROM		AreaLabourLog a
WHERE		a.FinishDateTime is not null
AND			a.TotalMinutes > 0
--WHERE		CAST(a.StartDateTime AS DATE) = CAST(GETdATE()-5 AS dATE)
--AND			a.EmpRef = 750

go
create procedure sp_ManLabJobs
as			
select		sum(dbo.fn_IntToTime(DATEDIFF(MINUTE, mjl.StartDateTime, mjl.FinishDateTime))) As HHMM, 
			mj.WorkOrderNumber,
			mj.Product, 
			mj.Description, 
			CASE WHEN mc.Id IS NULL THEN 'No' Else 'Yes' end as Campaign,
			ms.Name
FROM		ManufacturingJobLog mjl
INNER JOIN	ManufacturingJob mj
ON			mj.Id = mjl.ManufacturingJobId
LEFT JOIN	ManufactureCampaignJob mc
ON			mjl.Id = mc.ManufactureJobLogId
INNER JOIN  ManufacturingStage ms
ON			mjl.ManufacturingStageId = ms.Id
WHERE		mjl.FinishDateTime is not null
AND			mjl.StageRuntime > 0
GROUP BY	mj.WorkOrderNumber,			mj.Product, 			mj.Description, 			CASE WHEN mc.Id IS NULL THEN 'No' Else 'Yes' end,	ms.Name, mjl.StartDateTime, mjl.FinishDateTime
order by	mjl.StartDateTime

sp_ManLabJobs

select * from WorkCentre where AreaId in(1,2) and SageRef is not null
