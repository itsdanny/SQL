USE [syslive]
GO
/****** Object:  StoredProcedure [scheme].[sp_MPA_UpdateWorkOrder]    Script Date: 11/03/2016 10:20:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE		[scheme].[sp_MPA_UpdateWorkOrder]
@WorkOrder			VARCHAR(6),
@Slot				CHAR(2),
@OrderDate			VARCHAR(20),
@FirmPlanned		CHAR(1),
@NewWorkCentreId	INT,
@OldWorkCentreId	INT


AS

DECLARE @DT DATETIME = (SELECT CONVERT(datetime, @OrderDate, 104))
DECLARE @Days  INT = (SELECT DATEDIFF(DAY, order_date, @DT) FROM scheme.bmwohm WITH (NOLOCK) WHERE works_order = @WorkOrder)
DECLARE @NewSageRef VARCHAR(6) = (SELECT SageRef FROM MPA.dbo.WorkCentre WHERE Id = @NewWorkCentreId)
DECLARE @OldSageRef VARCHAR(6) = (SELECT SageRef FROM MPA.dbo.WorkCentre WHERE Id = @OldWorkCentreId)


UPDATE	syslive.scheme.bmwohm 
SET		firm_planned = @FirmPlanned,
		order_date = @DT,
		due_date = DATEADD(DAY, @Days, due_date),
		security_reference = @Slot 
WHERE	works_order = @WorkOrder

UPDATE	scheme.bmwodm 
SET		date_required =  DATEADD(DAY, @Days, date_required)
WHERE	works_order = @WorkOrder

UPDATE	scheme.wswopm 
SET		machine_group = @NewSageRef
WHERE	works_order = @WorkOrder
AND		machine_group = @OldSageRef



