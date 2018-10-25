
  SELECT		a.resource_code , b.works_order, b.warehouse, b.product_code, b.description, time_per_batchsize, 
				CAST(DATEADD(Minute, time_per_batchsize, CAST(CAST(GETDATE() as DATE) As DateTime))as Time) AS WorkCentreJobHoursMins 
				--select *
  FROM			syslive.scheme.wsroutdm a  WITH(NOLOCK) 
  INNER JOIN	syslive.scheme.bmwohm b WITH(NOLOCK) 
  ON			a.code = (b.warehouse+b.product_code) 
   WHERE	    b.works_order in('HR22A')
  
 -- AND			a.resource_code = @SageRef  
  AND			b.works_order  NOT IN(SELECT		DISTINCT wcj.WorkOrderNumber COLLATE Latin1_General_CI_AS  				
									FROM			WorkCentreJob wcj
									INNER	JOIN	WorkCentreJobLog wcjl
									ON				wcj.Id = wcjl.WorkCentreJobId 
									WHERE			wcj.WorkCentreId = wc.Id)
  GO
  
    
  sp_getFutureWorkCentreJobs 'DP52'
  
SELECT * FROM WorkCentreJob wj where WorkCentreId = 22 and WorkOrderNumber in ('HY44B','HY44A')

SELECT			*
FROM			WorkCentreJob wj
INNER JOIN		WorkCentreJobLog wcj
ON				wj.Id = wcj.WorkCentreJobId
inner join		WorkCentreJobEventLog el
ON				el.WorkCentreJobId = wj.Id
AND				WJ.WorkCentreId = 14
AND				wj.WorkOrderNumber = 'HM05B'

SELECT			*
FROM			WorkCentreJob wj
INNER JOIN		WorkCentreJobLog wcj
ON				wj.Id = wcj.WorkCentreJobId
INNER JOIN		WorkCentreJobEventLog wcje
ON				wj.Id = wcje.WorkCentreJobId
WHERE			wj.Id = 67


select * from WorkCentre where SageRef in ('HS06','DP52')

