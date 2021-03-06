SELECT		wcj.WorkCentreId, wcj.Id, wcj.WorkOrderNumber, wcj.Product, wcj.Description, wcl.StartDateTime, wcs.Status, wce.Name, wcel.StartDateTime, wcj.*, wcl.*
FROM		WorkCentreJob wcj
INNER JOIN	WorkCentreJobLog wcl
ON			wcj.Id = wcl.WorkCentreJobId
INNER JOIN  WorkCentreStatus wcs
ON			wcs.Id = wcl.WorkCentreStageId
INNER JOIN	WorkCentreJobEventLog wcel
ON			wcj.Id = wcel.WorkCentreJobId
INNER JOIN	WorkCentreEvent wce
ON			wce.Id = wcel.WorkCentreEventId
WHERE		wcj.WorkCentreId = 1
ORDER BY	wcel.StartDateTime desc
/*
SELECT * FROM	dbo.Area
SELECT * FROM	dbo.WorkCentre
SELECT * FROM	dbo.WorkCentreEvent
SELECT * FROM	dbo.WorkCentreStage
SELECT * FROM	dbo.WorkCentreStatus
SELECT * FROM	dbo.ManufacturingStage

SELECT * FROM	dbo.AreaLabourLog
SELECT * FROM	dbo.Campaign
SELECT * FROM	dbo.InsightErrors order by errordate desc
SELECT * FROM	dbo.ManufactureCampaignJob
SELECT * FROM	dbo.ManufacturingJob
SELECT * FROM	dbo.ManufacturingJobLog
SELECT * FROM	dbo.WorkCentre
SELECT * FROM	dbo.WorkCentreJob
SELECT * FROM	dbo.WorkCentreLog
SELECT * FROM	dbo.WorkCentreJobEventLog Where CAST(StartDateTime AS DATE) = CAST(GETDATE() AS DATE)
select * FROM	dbo.WorkCentreJobLog
SELECT * FROM	dbo.WorkCentreJobLogLabourDetail
SELECT * FROM	dbo.WorkCentreJobLogLabourSummary
SELECT * FROM	dbo.WorkCentreRuntimeLog

/*
	SELECT CAST(SUM(CASE WorkCentreEventId WHEN 1 THEN 1 WHEN 3 THEN 1 ELSE 0 END) AS FLOAT) AS Others, CAST(SUM(CASE WorkCentreEventId WHEN 2 THEN 1 ELSE 0 END) AS FLOAT) as BReakDowns FROM WorkCentreJobEventLog WHERE WorkCentreJobId = 88
	SELECT  CAST(SUM(CASE WorkCentreEventId WHEN 2 THEN 1 ELSE 0 END) AS FLOAT) / CAST(SUM(1) AS FLOAT)FROM WorkCentreJobEventLog WHERE WorkCentreJobId = 88
	SELECT CAST(SUM(CASE WorkCentreEventId WHEN 2 THEN 1 ELSE 0 END) AS FLOAT) / CAST(SUM(CASE WorkCentreEventId WHEN 1 THEN 1 WHEN 3 THEN 1 ELSE 0 END) AS FLOAT) FROM WorkCentreJobEventLog WHERE WorkCentreJobId = 88


update dbo.ManufacturingJobLog set StageRunTime = 35 where Id = 147

delete from		dbo.ManufacturingJobLog where ManufacturingJobId = 80
delete from		dbo.ManufacturingJob where id = 80


UPDATE AreaLabourLog SET FinishDateTime = GETDATE(), TotalMinutes = DATEDIFF(MI, StartDateTime, GETDATE())
where id in (1442,1443,1444,1445)

SELECT * FROM	dbo.AreaLabourLog where id = 1412
*/*/
SELECT COALESCE(CAST(SUM(CASE SIGN(standardruntime - StageRuntime) WHEN -1 THEN 0 ELSE 1 END) AS FLOAT) / CAST(COUNT(1) AS FLOAT), 0) AS CompletedJobs FROM WorkCentreJobLog wcjl INNER JOIN WorkCentreJob wcj ON wcjl.WorkCentreJobId = wcj.Id WHERE wcj.WorkCentreId = 1 AND CAST(wcjl.FinishDateTime as Date) = CAST(GETDATE() AS DATE)