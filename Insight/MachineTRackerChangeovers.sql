/*
SELECT *
FROM WorkCentre
WHERE DepartmentID IN (13)
ORDER BY Description

SELECT *
FROM Insight.dbo.WorkCentre
WHERE AreaId IN (1,2)
ORDER BY areaid, NAME

SELECT *
FROM		Insight.dbo.WorkCentre iw
LEFT JOIN	WorkCentre wc
ON			iw.SageRef = wc.WorkCentreCode
WHERE		AreaId IN (1,2)
AND			DepartmentID IN (7,13)
ORDER BY	NAME
GO

Id	ChangeOverName
1	Washout
2	Size Change
3	Washout and Size Change
4	Batch Change
5	Washout and Drying
6	Washout, Size Change and Drying

SELECT		'*'+ISNULL(CAST(c.ID AS VARCHAR), '')+'*' AS ChangeOverBarcoder,
			c.ID AS Id,
			c.PlanStandard,
			c.IdealStandard as BatchTime,
			e.Description AS ChangeOverName,
			wc.WorkCentreCode,
			wc.Description AS MachineTrackerName,
			iwc.NAME, iwc.id,
			c.Crew 
FROM		MachineTracker.dbo.WorkCentre wc
RIGHT JOIN	Insight.dbo.WorkCentre iwc
ON			wc.WorkCentreCode = iwc.SageRef
LEFT JOIN	MachineTracker.dbo.ChangeOverStandards c
ON			wc.ID = c.WorkCentreID
LEFT JOIN	MachineTracker.dbo.Event e
ON			e.ID = c.EventID
WHERE		iwc.AreaId IN (1,2)
AND			DepartmentID IN (7,13)
AND			iwc.SageRef IN ('HP51','HP52','LS51')
ORDER BY	iwc.NAME
*/
Alter  procedure scheme.sp__GetMachineTrackerChangeOver
@WorkCentre		varchar(150) = null,
@ChangeOverId	INT
AS
--		sp__GetMachineTrackerChangeOver 'Line8'
SELECT		'*'+ISNULL(CAST(c.ID AS VARCHAR), '')+'*' AS ChangeOverBarcoder,
			c.ID AS Id,
			c.PlanStandard,
			c.IdealStandard as BatchTime,
			e.Description AS ChangeOverName,
			wc.WorkCentreCode,
			wc.Description AS MachineTrackerName,
			iwc.NAME,
			c.Crew 
FROM		MachineTracker.dbo.WorkCentre wc
RIGHT JOIN	Insight.dbo.WorkCentre iwc
ON			wc.WorkCentreCode = iwc.SageRef
LEFT JOIN	MachineTracker.dbo.ChangeOverStandards c
ON			wc.ID = c.WorkCentreID
LEFT JOIN	MachineTracker.dbo.Event e
ON			e.ID = c.EventID
WHERE		iwc.AreaId IN (1,2)
AND			DepartmentID IN (7,13)
AND			((@WorkCentre IS NULL) OR (iwc.NAME = @WorkCentre))
AND			c.ID = @ChangeOverId
ORDER BY	iwc.NAME
