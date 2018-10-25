select DATEADD(month, datediff(month, 0, getdate())-4, 0), DATEADD(month, datediff(month, 0, getdate())-1, 0)
SELECT     wc.name
                --,jl.StartDateTime
                --,jl.FinishDateTime
                ,DATEADD(month, DATEDIFF(month, 0, jl.StartDateTime), 0) AS StartOfMonth
                ,dbo.fn_IntToHours(SUM(jlld.TotalMinutes)) as Totalhours


--SELECT jl.StartDateTime, jl.finishDateTime, jlld.*
FROM       dbo.WorkCentreJob j 
INNER JOIN dbo.WorkCentre wc 
ON         wc.Id = j.WorkCentreId
INNER JOIN dbo.WorkCentreJobLog jl 
ON         j.Id = jl.WorkCentreJobId
INNER JOIN dbo.WorkCentreJobLogLabourDetail jlld
ON         jl.Id = jlld.WorkCentreJobLogId
WHERE     jl.StartDateTime between DATEADD(month, datediff(month, 0, getdate())-4, 0) AND DATEADD(month, datediff(month, 0, getdate())-1, 0)
AND		DATEDIFF(MINUTE, jlld.StartDateTime, jlld.FinishDateTime) < 600
AND        wc.AreaId = 1
--and        wc.Name ='Booth5'
--and			jlld.EmpRef = '0118'
GROUP BY   wc.name ,DATEADD(month, DATEDIFF(month, 0, jl.StartDateTime), 0) --jl.StartDateTime, jl.FinishDateTime
ORDER BY   wc.name

select * from InsightErrors order by ErrorID desc
