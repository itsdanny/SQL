select * from WorkCentreJob where WorkOrderNumber ='LJ83C'
select * from WorkCentreJobLog where WorkCentreJobId =  13165
select * from WorkCentreJob where Warehouse is not null and WorkCentreJobRuntime is null
select * from WorkCentreJob order by id desc

select * from WorkCentreJobLog where Id =  8790
select * from WorkCentre where id in (11,29,23)
select * from WorkCentreJobLogLabourDetail where TotalMinutes > 600 
select * from WorkCentreJob where WorkCentreId = 17 ORDER BY Id desc
select * from WorkCentreJobEventLog where WorkCentreJobId = 13109
select * from WorkCentreJobLogLabourDetail where  WorkCentreJobLogId = 10700

select * from InsightErrors order by ErrorID desc
select * from WorkCentreJobLogLabourDetail where  EmpRef = '7015' order by Id desc


select * from InsightErrors where ErrorMessage like '%object refer%' order by ErrorID desc
select * from InsightErrors  order by ErrorID desc
select * from InsightErrors  where ErrorMethod ='LocalPing' order by ErrorID desc

select * from InsightErrors order by ErrorID desc
select * from InsightTest.dbo.InsightErrors where ErrorScreen = 'service' order by ErrorID desc

select * from WorkCentreJobLogLabourDetail where TotalMinutes > 500 and EmpRef = '0562' order by Id desc

select * from WorkCentreJobLogLabourDetail where  EmpRef = '0262' order by Id desc

select * from InsightErrors where (ErrorScreen = 'CheckEmployeeTMS service' or ErrorScreen = 'service')  order by ErrorID desc

sp_GetWorkCentreStats

select * from WorkCentreJobLogLabourDetail where TotalMinutes > 600 order by Id desc

select * from ManufacturingJobLog where EmpRef in ('0026','0774')

select * from AreaLabourLog where FinishDateTime IS NULL
select * from WorkCentreJob where HourlyRate is null
select * from WorkCentreJobLog where WorkCentreJobId in(11250,11346) order by FinishDateTime
select * from WorkCentreJobEventLog where WorkCentreJobId in(11250,11346) order by FinishDateTime 



/*use InsightTest
update	WorkCentre 
set		LastBatchPerformance = 25.6, 
		LastChangeOverPerformance = 77.4
		WHERE Id = 17

		select * from WorkCentre where Id = 17
*/
go
select * from Area a inner join workcentre c on a.Id= c.AreaId inner join WorkcentreJob j on c.Id = j.WorkCentreId where a.id = 2


update j set j.HourlyRate = 45.06 from Area a inner join workcentre c on a.Id= c.AreaId inner join WorkcentreJob j on c.Id = j.WorkCentreId where a.id = 1 And j.HourlyRate IS NULL
update j set j.HourlyRate = 24.08 from Area a inner join workcentre c on a.Id= c.AreaId inner join WorkcentreJob j on c.Id = j.WorkCentreId where a.id = 2 And j.HourlyRate IS NULL
update ManufacturingJob set HourlyRate = 45.76 WHERE HourlyRate IS NULL

