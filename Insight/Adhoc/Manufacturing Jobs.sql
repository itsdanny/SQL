SELECT		* 
FROM		ManufacturingJobLog mjl
INNER JOIN	ManufacturingJob mj
ON			mj.Id = mjl.ManufacturingJobId
INNER JOIN	ManufacturingStage ms
ON			ms.Id = mjl.ManufacturingStageId

SELECT		mjl.* , mj.*
FROM		ManufactureCampaignJob mcj
INNER JOIN  ManufacturingJobLog mjl
ON			mcj.ManufactureJobLogId = mjl.Id
INNER JOIN	ManufacturingJob mj
ON			mj.Id = mjl.ManufacturingJobId
INNER JOIN	ManufacturingStage ms
ON			ms.Id = mjl.ManufacturingStageId

SELECT  [ManufacturingJob].[Id], [ManufacturingJob].[WorkOrderNumber], 
[ManufacturingJob].[Warehouse], [ManufacturingJob].[Product], 
[ManufacturingJob].[Description], [ManufacturingJob].[ManufacturingJobRuntime] FROM [dbo].[ManufacturingJob] WHERE (WorkOrderNumber = 'HG51')
select * from InsightErrors