USE [Insight]
GO
/****** Object:  StoredProcedure [dbo].[sp_IsEmpLoggedOnAJob]    Script Date: 03/10/2014 09:05:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_IsEmpLoggedOnAJob]
@EmpRef INT,
@NewWorkCentreJobLogId INT
AS

DECLARE @OldLoggedInToWorkCentreId INT
DECLARE @OldLoggedInToJobLogId INT

DECLARE @JobLogLabourSummaryId INT
DECLARE @JobLogLabourSummaryCount INT

DECLARE @OldJobLogLabourSummaryId INT
DECLARE @OldJobLogLabourSummaryCount INT

DECLARE @NewJobLogLabourSummaryId INT
DECLARE @NewJobLogLabourSummaryCount INT
DECLARE @LogDate DATETIME

PRINT 'LOG USER ONTO '  + CAST(@NewWorkCentreJobLogId AS VARCHAR(3))
	
SET	 @LogDate = GETDATE()
-- Deal with workCentres FIRST
	-- DOES THE EMP HAVE AN EXISTING WORKJOB THEY ARE ON?
	SELECT		@OldLoggedInToWorkCentreId = wcj.Id, 
				@OldLoggedInToJobLogId = wcjl.Id
	FROM		WorkCentreJobLogLabourDetail wcjlld
	INNER JOIN	WorkCentreJobLog wcjl
	ON			wcjlld.WorkCentreJobLogId = wcjl.Id
	INNER JOIN	WorkCentreJob wcj
	ON			wcjl.WorkCentreJobId = wcj.Id
	INNER JOIN  WorkCentre wc
	ON			wcj.WorkCentreId = wc.Id
	WHERE		EmpRef = @EmpRef
	AND			wcjlld.FinishDateTime IS NULL

IF @OldLoggedInToJobLogId IS NOT NULL 
  BEGIN    
	IF @NewWorkCentreJobLogId <> @OldLoggedInToJobLogId  
	 BEGIN
		  -- END PEVIOUS LABOUR LOG AND CREATE A NEW LABOUR LOG
		  
		 PRINT 'SORT OUT THE EMPS RECORDS'
		 UPDATE	WorkCentreJobLogLabourDetail 
		 SET	FinishDateTime = DATEDIFF(MINUTE, StartDateTime, @LogDate) 
	  	 WHERE	EmpRef = @EmpRef 
		 AND	FinishDateTime IS NULL
		 AND	WorkCentreJobLogId = @OldLoggedInToJobLogId
		
		 PRINT 'ADD NEW LABOUR LOG'
		 INSERT INTO WorkCentreJobLogLabourDetail (StartDateTime, EmpRef, WorkCentreJobLogId, TotalMinutes)
		 VALUES (@LogDate, @EmpRef, @NewWorkCentreJobLogId, 0)
					
					
					
		 -- SORT OUT THE SUMMARY RECORDS			 
		 
		 -- GET THEIR OLD SUMMARY
		 SELECT	@OldJobLogLabourSummaryId = Id, 
		 		@OldJobLogLabourSummaryCount = TotalNumberOfStaff
		 FROM	WorkCentreJobLogLabourSummary
		 WHERE	WorkCentreJobLogId = @OldLoggedInToJobLogId
		 AND	FinishDateTime IS NULL
		
		 -- DOES THE LOGGING INTO JOB HAVE A EXISTING SUMMARY, IF SO END IT
		 SELECT	 @NewJobLogLabourSummaryId = Id, 
		 		 @NewJobLogLabourSummaryCount = COALESCE(TotalNumberOfStaff, 0)
		 FROM	 WorkCentreJobLogLabourSummary
		 WHERE	 WorkCentreJobLogId = @NewWorkCentreJobLogId
		 AND	 FinishDateTime IS NULL
		 
		 PRINT	'END THE OLD LABOURSUMMARY'
		 UPDATE	WorkCentreJobLogLabourSummary
		 SET	FinishDateTime = @LogDate,
				TotalNumberOfMinutes =  DATEDIFF(MINUTE, StartDateTime, @LogDate) 
		 WHERE	WorkCentreJobLogId = @NewWorkCentreJobLogId
		 AND	FinishDateTime IS NULL		
		
		 
		 print @NewJobLogLabourSummaryCount
		 -- AND CREATE A NEW SUMMARY
		IF @NewJobLogLabourSummaryId IS NOT NULL
		  BEGIN
		   PRINT 'UPDATE THE LAST SUMMARY'
		   UPDATE	WorkCentreJobLogLabourSummary
		   SET		FinishDateTime = DATEDIFF(MINUTE, StartDateTime, @LogDate) 
		   WHERE	WorkCentreJobLogId = @OldLoggedInToJobLogId
		   AND		FinishDateTime IS NULL
		  END
		 
		 PRINT 'CREATE A NEW ONE'
		 INSERT INTO WorkCentreJobLogLabourSummary(StartDateTime, TotalNumberOfStaff, WorkCentreJobLogId)
		 VALUES(@LogDate, (@JobLogLabourSummaryCount +1), @LoggedInToJobLogId)	
			
		 -- BACK THE THE USERS LAST JOB NOW...															
		 IF @JobLogLabourSummaryCount = 1
		  BEGIN						
			PRINT 'SET JOB TO WAITING IF NOT FINISHED'
			INSERT INTO WorkCentreJobEventLog(StartDateTime, WorkCentreJobId, WorkCentreEventId, TotalNumberOfMinutes)
			VALUES	(@LogDate, @LoggedInToJobLogId, (SELECT Id FROM WorkCentreEvent WHERE UPPER(Name) = 'WAITING'), 0)
		  END
		  ELSE 
		  BEGIN  
			PRINT 'STAFF LEFT ON THE LINE SO CREATE NEW LABOUR SUMMARY FOR THE OLD JOB'
			INSERT INTO WorkCentreJobLogLabourSummary(StartDateTime, TotalNumberOfStaff, WorkCentreJobLogId)
			VALUES(@LogDate, (@JobLogLabourSummaryCount -1), @LoggedInToJobLogId)			
		  END	
 	 END
	-- RETURN RESULTS 
	SELECT	* 
	FROM	WorkCentreJobLogLabourDetail 
	WHERE	WorkCentreJobLogId = @LoggedInToJobLogId
	and		FinishDateTime IS NULL		
	ORDER BY StartDateTime 
   END	 -- END OF WORK ORDER STUFF
ELSE
BEGIN
	SELECT 'MAN LAB'
END
/*
SELECT		AreaId, ManufacturingJobId AS JobId, Id AS LogId
FROM		ManufacturingJobLog
WHERE		EmpRef = @EmpRef
AND			FinishDateTime IS NULL
*/

GO

sp_IsEmpLoggedOnAJob 2215, 1