SELECT		wc.Name, wcj.*, wcjl.StartDateTime, wcjl.FinishDateTime, wce.Name, wcjecl.StartDateTime, wcjecl.FinishDateTime
FROM		WorkCentre wc
INNER JOIN	WorkCentreJob wcj
ON			wc.Id = wcj.WorkCentreId
INNER JOIN	WorkCentreJobLog wcjl
ON			wcj.Id = wcjl.WorkCentreJobId
INNER JOIN	WorkCentreJobEventLog wcjecl
ON			wcj.Id = wcjecl.WorkCentreJobId
INNER JOIN	WorkCentreEvent wce
ON			wcjecl.WorkCentreEventId = wce.Id
WHERE		wc.AreaId = 2