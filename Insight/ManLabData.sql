declare @fromDate	DATETIME = '2015-03-01 23:59:59'
declare @toDate		DATETIME = '2015-04-01 23:59:59'
SELECT		WorkOrderNumber, Warehouse, Product, Description,	
			COALESCE(ManufacturingRoute, '') AS Route, s.Name,  ManufacturingJobRuntime, MAX(StandardRuntime) AS StandardRuntime, SUM(StageRuntime) AS StageRuntime
--select *
FROM		ManufacturingJob mj
INNER JOIN	ManufacturingJobLog mjl
ON			mj.Id = mjl.ManufacturingJobId
INNER JOIN	ManufacturingStage s
ON			mjl.ManufacturingStageId = s.Id
WHERE		CAST(mjl.StartDateTime AS DATE) BETWEEN CAST(@fromDate AS DATE) AND CAST(@toDate AS DATE)
AND			mjl.FinishDateTime IS NOT NULL
GROUP BY	WorkOrderNumber, Warehouse, Product, Description, ManufacturingJobRuntime, COALESCE(ManufacturingRoute, ''), s.Name

