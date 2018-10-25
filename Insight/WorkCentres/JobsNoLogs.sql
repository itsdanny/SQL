select		*
FROM		WorkCentreJobLog l
left JOIN	WorkCentreJob j
ON			l.WorkCentreJobId = j.Id 
left join WorkCentreJobEventLog e
ON			e.WorkCentreJobId = j.Id 
where WorkOrderNumber = 'HY46B'

select * from WorkCentreJob where WorkOrderNumber ='HY36B'


SELECT * FROM WorkCentreJob j inner join WorkCentre w on w.Id = j.WorkCentreId where j.id not in (select WorkCentreJobId from WorkCentreJobLog) order by j.id desc

