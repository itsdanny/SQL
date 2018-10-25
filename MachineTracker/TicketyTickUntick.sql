/*TRUNCATE TABLE Process 
DBCC CHECKIDENT(Process, RESEED, 1)
INSERT INTO Process 
SELECT ProductID, ProcessGroupID, OperationNameID, Crew, line_number, operation_code, operation_description, IsCurrent, IsCosting, IsRework, IsDead, IsDummy, IdealStandard, CostStandard, PlanStandard, DateCreated, ReasonForChange, CreatedBy, DateDied FROM Process15Nov2016
*/

--SELECT * into Process15Nov2016 FROM Process 

-- SAVE THE DATA
SELECT	* INTO Process09Nov2017
FROM		Process

--1.	Update IsDead to Ticked and untick IsCosting AND IsCurrent
SELECT IsDead as Tick, IsCosting as Untick1,  IsCurrent as Untick2  FROM Process WHERE (IsCosting = 1 or IsCurrent = 1) AND IsDead = 0

--2.	Then everything that has a letter at the end of the line_number for example 010A. Please remove the IsDummy tick and tick the IsCurrent instead.
SELECT IsDummy AS UnTick,  IsCurrent as Tick  FROM Process WHERE ISNUMERIC(RIGHT(LTRIM(RTRIM(line_number)),1)) = 0 AND line_number IS NOT NULL AND IsDead = 0

--3.	For everthing that just has numbers in the line_number for example 010. Please can you untick IsDummy and tick both IsCurrent and IsCosting.
SELECT IsDummy AS UnTick, IsCurrent as Tick1, IsCosting as Tick2  FROM Process WHERE ISNUMERIC(LTRIM(RTRIM(line_number))) = 1 AND line_number IS NOT NULL AND IsDead = 0

BEGIN TRAN
----1.	Update IsDead to Ticked and untick IsCosting AND IsCurrent
--UPDATE Process SET IsDead = 1, IsCosting = 0, IsCurrent = 0 WHERE (IsCosting = 1 or IsCurrent = 1) AND IsDead = 0

----2.	Then everything that has a letter at the end of the line_number for example 010A. Please remove the IsDummy tick and tick the IsCurrent instead.
--UPDATE Process SET IsDummy = 0, IsCurrent = 1 FROM Process WHERE ISNUMERIC(RIGHT(LTRIM(RTRIM(line_number)),1)) = 0 AND line_number IS NOT NULL AND IsDead = 0

----3.	For everthing that just has numbers in the line_number for example 010. Please can you untick IsDummy and tick both IsCurrent and IsCosting.
--UPDATE Process SET IsDummy = 0, IsCurrent = 1, IsCosting =1 FROM Process WHERE ISNUMERIC(LTRIM(RTRIM(line_number))) = 1 AND line_number IS NOT NULL AND IsDead = 0


--1.	Update IsDead to Ticked and untick IsCosting AND IsCurrent
UPDATE Process SET IsDead = 1, IsCosting = 0, IsCurrent = 0 WHERE (IsCosting = 1 or IsCurrent = 1) AND IsDead = 0 AND	IsDummy = 0
--2.	Then everything that has a letter at the end of the line_number for example 010A. Please remove the IsDummy tick and tick the IsCurrent instead.
UPDATE Process SET IsDummy = 0 FROM Process WHERE IsDummy = 1

ROLLBACK
BEGIN TRAN
DROP TABLE Process
SELECT	* INTO Process
FROM		Process09Nov2017

ROLLBACK