/*
--select * from InsightErrors order by ErrorDate desc
--DELETE FROM dbo.AreaLabourLog
--DBCC CHECKIDENT (AreaLabourLog, reseed, 0)
DELETE FROM AreaLabourLog WHERE AreaId <> 3
--DELETE FROM dbo.ManufactureCampaignJob
--DBCC CHECKIDENT (ManufactureCampaignJob, reseed, 0)
--DELETE FROM dbo.InsightErrors
--DBCC CHECKIDENT (InsightErrors, reseed, 0)
DELETE FROM dbo.WorkCentreJobLogLabourDetail
DBCC CHECKIDENT (WorkCentreJobLogLabourDetail, reseed, 0)
DELETE FROM dbo.WorkCentreRuntimeLog
DBCC CHECKIDENT (WorkCentreRuntimeLog, reseed, 0)
--DELETE FROM dbo.ManufacturingJobLog
--DBCC CHECKIDENT (ManufacturingJobLog, reseed, 0)
--DELETE FROM dbo.Campaign
--DBCC CHECKIDENT (Campaign, reseed, 0)
DELETE FROM dbo.WorkCentreJobLogLabourSummary
DBCC CHECKIDENT (WorkCentreJobLogLabourSummary, reseed, 0)
DELETE FROM dbo.WorkCentreJobEventLog
DBCC CHECKIDENT (WorkCentreJobEventLog, reseed, 0)
DELETE FROM dbo.WorkCentreLog
DBCC CHECKIDENT (WorkCentreLog, reseed, 0)
DELETE FROM WorkCentreJobStillageLog
DBCC CHECKIDENT (WorkCentreJobStillageLog, reseed, 0)
DELETE FROM dbo.WorkCentreJob
DBCC CHECKIDENT (WorkCentreJob, reseed, 0)
DELETE FROM dbo.WorkCentreJobLog
DBCC CHECKIDENT (WorkCentreJobLog, reseed, 0)
--DELETE FROM dbo.ManufacturingJob
--DBCC CHECKIDENT (ManufacturingJob, reseed, 0)

 update [Insight].[dbo].[WorkCentre] set [WorkCentreStatusId] = 2
/*	not deleting this lot...
	from dbo.Area	
	from dbo.WorkCentre
	from dbo.WorkCentreStage
	ManufacturingStage
	from dbo.WorkCentreStatus
	from dbo.WorkCentreEvent
*/

*/