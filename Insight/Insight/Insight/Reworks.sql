--SELECT        j.WorkOrderNumber, j.Warehouse, j.Product, j.Description, j.WorkCentreJobBatchSize, l.StartDateTime, l.FinishDateTime, l.StageRuntime
select *
FROM            dbo.WorkCentreJob AS j INNER JOIN
                         dbo.WorkCentreJobLog AS l ON j.Id = l.WorkCentreJobId
WHERE        (l.WorkCentreStageId = 3)
AND StartDateTime > '2014-06-01'

--SELECT        j.WorkOrderNumber, j.Warehouse, j.Product, j.Description, j.WorkCentreJobBatchSize, l.StartDateTime, l.FinishDateTime, l.StageRuntime
select *
FROM            dbo.WorkCentreJob AS j INNER JOIN
                         dbo.WorkCentreJobLog AS l ON j.Id = l.WorkCentreJobId
WHERE      j.WorkOrderNumber ='JE08B'
