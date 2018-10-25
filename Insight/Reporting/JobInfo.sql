SELECT		* 
FROM		WorkCentreJob j
INNER JOIN	WorkCentreJobLog jl
ON			j.Id = JL.WorkCentreJobId
INNER JOIN	WorkCentreJobEventLog el
ON			j.Id = eL.WorkCentreJobId
WHERE		J.WorkOrderNumber = 'HS26B'


select 