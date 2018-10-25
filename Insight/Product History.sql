SELECT	j.WorkOrderNumber, j.Warehouse, j.Product, j.Description, ms.Name, Min(mjl.StartDateTime) as StartDateTime, Max(mjl.FinishDateTime) as FinishDateTime, mjl.StandardRuntime, SUM(mjl.StageRuntime) as StageRuntime
FROM ManufacturingJob j
INNER JOIN ManufacturingJobLog mjl
ON		j.Id = mjl.ManufacturingJobId
inner join ManufacturingStage ms
ON		mjl.ManufacturingStageId = ms.Id
where Product = '129126'
group by j.WorkOrderNumber, j.Warehouse, j.Product, j.Description, ms.Name, mjl.StandardRuntime
order by StartDateTime

       