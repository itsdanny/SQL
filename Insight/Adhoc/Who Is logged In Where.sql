-- Who's logged in to where
/*
-- Work centres
SELECT		*
FROM		WorkCentreJobLogLabourDetail staff
INNER JOIN	WorkCentreJobLog wclog
ON			staff.WorkCentreJobLogId = wclog.Id
INNER JOIN	WorkCentreJob wcJob
ON			wclog.WorkCentreJobId = wcJob.Id
INNER JOIN  WorkCentre wc
ON			wcJob.WorkCentreId = wc.Id
INNER JOIN  Area a
ON			wc.AreaId = a.Id

*/

SELECT		top 5 * 
FROM		WorkCentreJobEventLog logs
INNER JOIN	WorkCentreJob jobs
ON			logs.WorkCentreJobId = jobs.Id
INNER JOIN  WorkCentre wc
ON			wc.Id = jobs.WorkCentreId
WHERE		WC.Id = 1
ORDER BY	logs.Id desc
-- Manufacturing
SELECT		* 
FROM		Area a
INNER JOIN  ManufacturingJobLog mjl
ON			a.Id = mjl.AreaId
INNER JOIN	AreaLabourLog al
ON			a.Id = al.AreaId
INNER JOIN  ManufacturingJob mj
ON			mjl.ManufacturingJobId = mj.Id
WHERE		mj.WorkOrderNumber = 'GY92A'

select * from WorkCentreEvent