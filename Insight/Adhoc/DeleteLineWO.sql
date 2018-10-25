/*-- DELETE JOB HISTORY
DECLARE @Job varchar(6)
SET @Job = 'HK90'
DECLARE @JobID INT
SELECT	@JobID = ID FROM dbo.WorkCentreJob WHERE WorkOrderNumber = @Job

DECLARE @JobLogID INT
SELECT	@JobLogID = ID FROM dbo.WorkCentreJobLog WHERE WorkCentreJobId = @JobID

SELECT * FROM dbo.WorkCentreJob WHERE WorkOrderNumber = @Job
SELECT * FROM dbo.WorkCentreJobEventLog WHERE WorkCentreJobId = @JobID
SELECT * FROM dbo.WorkCentreJobLog WHERE CAST(FinishDateTime  AS Date) = CAST(GETDATE() As Date)
select * from WorkCentreLog
--SELECT * FROM dbo.WorkCentreJobLogLabourDetail WHERE WorkCentreJobLogId = @JobLogID

/*	DELETE FROM dbo.WorkCentreJob WHERE WorkOrderNumber = @Job
	DELETE FROM dbo.WorkCentreJobEventLog WHERE WorkCentreJobId = @JobID
	DELETE FROM dbo.WorkCentreJobLog WHERE WorkCentreJobId = @JobID
	DELETE FROM dbo.WorkCentreJobLogLabourDetail WHERE WorkCentreJobLogId = @JobLogID
*/
--update WorkCentreJobEventLog set StartDateTime = '2014-02-20 16:11:20.970', FinishDateTime = null where id = 214
--update WorkCentreJobLog set StartDateTime = '2014-02-20 11:01:41.577', StageRuntime = 250 where id = 120
SELECT CAST(SUM(CASE SIGN(StageRuntime - standardruntime) WHEN -1 THEN 0 ELSE 1 END) AS FLOAT) / CAST(COUNT(1) AS FLOAT) AS CompletedJobs FROM WorkCentreJobLog wcjl INNER JOIN WorkCentreJob wcj ON wcjl.WorkCentreJobId = wcj.Id WHERE wcj.WorkCentreId = 1 AND CAST(wcjl.FinishDateTime as Date) = CAST(GETDATE() AS DATE)


*/