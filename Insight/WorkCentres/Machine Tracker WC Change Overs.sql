/****** Script for SelectTopNRows command from SSMS  ******/
SELECT distinct * FROM [MachineTracker].[dbo].[Process] ORDER BY operation_description  
SELECT distinct * FROM [MachineTracker].[dbo].[ProcessGroup]
SELECT * FROM WorkCentre
  


  SELECT DISTINCT 
				w.Description,  
				pg.Description, 
				'(' + w.WorkCentreCode + CAST(o.ID AS VARCHAR(3))+')' AS BARCODE, 
				--p.PlanStandard,
				CAST(p.PlanStandard *60 AS INT) AS MINS
  FROM			[MachineTracker].[dbo].[Process] p 
  INNER JOIN	[MachineTracker].[dbo].[ProcessGroup] pg
  ON			p.ProcessGroupID = pg.ID
  INNER JOIN	WorkCentre w
  ON			w.ID = pg.WorkCentreID
  RIGHT JOIN	Insight.dbo.WorkCentre iwc
  ON			w.WorkCentreCode = iwc.SageRef
  INNER JOIN	OperationName o
  ON			o.ID = p.OperationNameID
  WHERE			operation_code >= 70
  AND			p.IsDead = 0
  AND			p.IsDummy = 0
  ORDER BY		w.Description
  

  SELECT DISTINCT * FROM Process p inner join OperationName o on p.OperationNameID = o.ID 
  where p.operation_code >= 70  AND	p.IsDead = 0
  AND			p.IsDummy = 0 order by operation_code
  SELECT DISTINCT operation_code, operation_description, * FROM Process 
  SELECT * FROM ProcessGroup
  
  SELECT * FROM OperationName

  select distinct Description from OperationName where ID > 70