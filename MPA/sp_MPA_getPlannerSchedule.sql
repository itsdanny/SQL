USE [MPA]
GO
/****** Object:  StoredProcedure [dbo].[sp_MPA_getPlannerSchedule]    Script Date: 07/03/2016 08:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_MPA_getPlannerSchedule]
@WorkCentreGroupId	INT = 9999,
@PlannerGroupId		INT = 9999,
@FromDate			DATETIME
AS
SET NOCOUNT OFF

DECLARE	@WorkCentres TABLE (Id INT IDENTITY(1,1), SageRef VARCHAR(6), WorkCentreName VARCHAR(30))
DECLARE @Schedule TABLE (SageRef VARCHAR(6), WorkCentreName VARCHAR(30), Slot INT, OrderDate DATETIME, Warehouse VARCHAR(2), ProductCode VARCHAR(10), ProductDescription VARCHAR(50), 
						WorkOrderNumber VARCHAR(8), QuantityRequired INT, QuantityFinished INT, LineRunTime VARCHAR(8), StandardRunTime VARCHAR(8), 
						BlockedFromDate DATETIME, BlockedToDate DATETIME, BlockedHours FLOAT, SlotBlockedReasonId INT, SlotBlocked BIT, 
						SlotBlockedReason NVARCHAR(500), SlotBlockedComment NVARCHAR(2000), 
						UnitCode VARCHAR(10), Alpha VARCHAR(10), FirmPlanned VARCHAR(5), WOStatus VARCHAR(25), CompletedAmount FLOAT, Operation  VARCHAR(4), SearchText VARCHAR(1), BatchType VARCHAR(30))



IF @PlannerGroupId < 9999 -- Get WCs from the planning board 
BEGIN
	PRINT 'Planning Board View'
	INSERT INTO @WorkCentres
	SELECT SageRef, WorkCentreName FROM WorkCentre WHERE @PlannerGroupId = 0 OR PlanningBoardGroupId = @PlannerGroupId	
END
ELSE IF @WorkCentreGroupId < 9999  -- or Planners WC group
BEGIN
	PRINT 'Work Centre Group View'
	INSERT INTO @WorkCentres
	SELECT SageRef, WorkCentreName FROM WorkCentre WHERE @WorkCentreGroupId = 0 OR GroupId = @WorkCentreGroupId
END


DECLARE @Row INT = 1, @Rows INT = (SELECT COUNT(1) FROM @WorkCentres)
DECLARE @SageRef VARCHAR(6), @WorkCenteName VARCHAR(30)
WHILE @Row <= @Rows
BEGIN
	SELECT @SageRef = SageRef, @WorkCenteName = WorkCentreName from @WorkCentres where Id = @Row
	
	INSERT INTO @Schedule (Slot, OrderDate, Warehouse, ProductCode, ProductDescription, WorkOrderNumber, QuantityRequired, QuantityFinished, LineRunTime, StandardRunTime, BlockedFromDate, BlockedToDate, BlockedHours, SlotBlockedReasonId, SlotBlocked, SlotBlockedReason, SlotBlockedComment, UnitCode, Alpha, FirmPlanned, WOStatus, CompletedAmount, Operation, SearchText,BatchType)
	EXEC syslive.[scheme].[sp_MPA_getWorkOrdersByline] @SageRef, @FromDate, 1
	
	UPDATE @Schedule SET SageRef = @SageRef, WorkCentreName = @WorkCenteName WHERE SageRef IS NULL
 SET @Row = @Row + 1
END

SELECT * FROM @Schedule


--	[sp_MPA_getPlannerSchedule] 1, '2016-03-07'
--	EXEC syslive.[scheme].[sp_MPA_getWorkOrdersByline] 'CS01',  '2016-03-14', 1
go 


 EXEC [sp_MPA_getPlannerSchedule] 3, 9999, '2016-03-04'
 go
 	--EXEC syslive.[scheme].[sp_MPA_getWorkOrdersByline] 'CS01',  '2016-03-14', 1
	--EXEC [sp_MPA_getPlannerSchedule] 9999, 0, '2016-03-22'
 go
