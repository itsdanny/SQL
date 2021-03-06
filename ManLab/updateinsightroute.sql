  SELECT		a.resource_code , b.works_order, b.warehouse, b.product_code, b.description, time_per_batchsize, 
				CAST(CAST(DATEADD(Minute, time_per_batchsize, CAST(CAST(GETDATE() as DATE) As DateTime))as Time) AS VARCHAR(5)) AS WorkCentreJobHoursMins				
  FROM			syslive.scheme.wsroutdm a  WITH(NOLOCK) 
  INNER JOIN	syslive.scheme.bmwohm b WITH(NOLOCK) 
  ON			a.code = (b.warehouse+b.product_code) 
  --INNER	JOIN	ManufacturingJob mj WITH(NOLOCK) 
  --ON			a.resource_code = mj.WorkOrderNumber collate Latin1_General_CI_AS	
  where			b.works_order = 'HZ33A'
go
/*

update mj set mj.ManufacturingRoute = a.resource_code
FROM		syslive.scheme.wsroutdm a  WITH(NOLOCK) 
INNER JOIN	syslive.scheme.bmwohm b WITH(NOLOCK) 
ON			a.code = (b.warehouse+b.product_code) 
INNER JOIN	ManufacturingJob mj WITH(NOLOCK) 
ON			b.works_order = mj.WorkOrderNumber collate Latin1_General_CI_AS 


*/

