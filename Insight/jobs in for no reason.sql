-- JOBS GO INTO INSIGHT WHEN YOU USE THE SAVE METHOD ON THE Business.WorkCentre class. 
use Insight
select * from WorkCentre
select * from [dbo].[WorkCentreJob] where Id Not in (select WorkCentreJobid from [dbo].[WorkCentreJobLog]) 

--delete from [dbo].[WorkCentreJob] where Id Not in (select WorkCentreJobid from [dbo].[WorkCentreJobLog])

SELECT * FROM WorkCentreJob WHERE WorkOrderNumber ='LC73B'

select * from [dbo].[WorkCentreJob] where WorkCentreJobRuntime is null


select * from InsightErrors order by Errorid desc

select * from InsightErrors where ErrorMessage = 'Insight Screen logging in Employee from the ML/PFD/HPD' order by Errorid desc