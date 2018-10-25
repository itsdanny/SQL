/*
	SQL to copy live data if asked by planning, sometimes doen before the reoute load into operlive
*/

USE MachineTracker

-- Step 1
select * into ProcessJul2017
FROM Process

-- Step 2
DECLARE @DT DATETIME = GETDATE() -- BEING ANAL ON MAKING SURE THEY ALL HAVE THE SAME DATETIME STAMP
INSERT INTO Process
SELECT  ProductID, 
		ProcessGroupID, 
		OperationNameID, 
		Crew, 
		line_number, 
		operation_code, 
		operation_description,
		IsCurrent, 
		IsCosting, 
		IsRework, 
		IsDead, 
		1 AS IsDummy, 
		IdealStandard, 
		CostStandard, 
		PlanStandard, 
		@DT AS DateCreated, 
		'Annual Standards Review 2017' AS ReasonForChange, 
		'Lindsay Mitchell' AS CreatedBy, 
		DateDied
FROM Process
WHERE (IsCosting = 1 OR IsCurrent = 1)


--update Process set IsCurrent = 0, IsCosting = 0 FROM Process WHERE IsDummy = 1
