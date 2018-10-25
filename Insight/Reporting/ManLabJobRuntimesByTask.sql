alter procedure rpt_ManLabSummary
@fromDate	DATETIME,
@toDate		DATETIME
as

SELECT		ms.Id, ms.Name, mj.Warehouse, mj.WorkOrderNumber, mj.Product, MIN(mjl.StartDateTime) As StartTime, MAX(mjl.FinishDateTime) As FinishTime, 
			mjl.StandardRuntime,			
			SUM(mjl.StageRuntime) AS StageRunTime,
			SUM(DATEDIFF(MINUTE, mjl.StartDateTime, mjl.FinishDateTime)) AS TotalMins,
			mj.ManufacturingJobRunTime,
			dbo.fn_IntToTime(SUM(mjl.StageRuntime))as TimeTakenHHMM,		
			COUNT(DISTINCT mjl.EmpRef) as NumberOfStaff,
			CASE WHEN mc.Id IS NULL THEN 'No' Else 'Yes' end as Campaign,
			CASE when SUM(mjl.StageRuntime) < mjl.StandardRuntime then 1 else 0 end as Performance		
FROM		ManufacturingJob mj
INNER JOIN	ManufacturingJobLog mjl
ON			mj.Id = mjl.ManufacturingJobId
INNER JOIN  ManufacturingStage ms
ON			mjl.ManufacturingStageId = ms.Id		
LEFT JOIN	ManufactureCampaignJob mc
ON			mjl.Id = mc.ManufactureJobLogId
WHERE		Cast(mjl.StartDateTime  AS DATE) between CAST(@fromDate AS DATE) AND  CAST(@toDate AS DATE)
AND			mjl.FinishDateTime is not null
GROUP BY	ms.Id, ms.Name, MJ.WorkOrderNumber, mj.Product, StandardRuntime,mj.Warehouse, mc.Id, mj.ManufacturingJobRunTime
ORDER BY	MJ.WorkOrderNumber, ms.Id, mj.Product

GO

rpt_ManLabSummary  '2014-04-01','2014-05-01'
