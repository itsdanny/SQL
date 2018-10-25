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


  scheme.sp__GetMachineTrackerChangeOver 'Line11', 'HS1123'