SELECT wc.SageRef,
	dbo.WorkCentreJob.Product,
	dbo.WorkCentreJob.Description,
	dbo.WorkCentreJob.WorkOrderNumber,
	dbo.WorkCentreJobLogLabourDetail.EmpRef,
	dbo.WorkCentreJobLogLabourDetail.StartDateTime,
	dbo.WorkCentreJobLogLabourDetail.FinishDateTime,	
	DATEDIFF(MINUTE, dbo.WorkCentreJobLogLabourDetail.StartDateTime, dbo.WorkCentreJobLogLabourDetail.FinishDateTime) AS TimeMins
	
FROM dbo.WorkCentre AS wc
INNER JOIN dbo.WorkCentreJob
	ON		 wc.Id = dbo.WorkCentreJob.WorkCentreId
INNER JOIN	dbo.WorkCentreJobLogLabourDetail
	ON		dbo.WorkCentreJob.Id = dbo.WorkCentreJobLogLabourDetail.WorkCentreJobLogId

WHERE (wc.SageRef = 'DP52')
AND StartDateTime > '2014-05-30 00:00:00'