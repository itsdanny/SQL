USE [syslive]
GO
/****** Object:  StoredProcedure [scheme].[sp_getRouteInfoForInsight]    Script Date: 03/09/2015 14:52:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [scheme].[sp_getWorkOrdersByline]
@SageRef	VARCHAR(5),
@FromDate	DATETIME

AS
/*
 Author:	Dan McGregor
 Date:		04 September 2015
 Desc:		Returns the data in a format that 'should' be easy to to decipher for the front end, with out too much jiggery pokery

*/

DECLARE @ToDate	DATETIME = dATEADD(DAY, 7, @FromDate)

DECLARE	@Results TABLE (Id INT IDENTITY(1,1), 
						Line				VARCHAR(6), 						
						OrderDate			DATETIME, 
						Slot				INT, 
						SlotBlocked			BIT,
						SlotBlockedReason	NVARCHAR(1000),
						BlockedFromDate		DATETIME, 
						BlockedToDate DATETIME)

DECLARE	@WOResults TABLE (Id INT IDENTITY(1,1), 
						Line				VARCHAR(6), 
						Warehouse			VARCHAR(2), 
						ProductCode			VARCHAR(10), 
						ProductDescription	VARCHAR(50), 
						WorkOrderNumber		VARCHAR(8), 
						QuantityRequired	INT DEFAULT 0, 
						StandardRunTime		INT DEFAULT 0,
						OrderDate			DATETIME,
						Slot				INT DEFAULT 0
						)

DECLARE	@BlockedSlots TABLE (Id INT IDENTITY(1,1), 
							SlotNumber INT, 
							SlotBlockedReason NVARCHAR(1000), 
							BlockedFromDate DATETIME, 
							BlockedToDate DATETIME)

DECLARE @DT	DATETIME = @FromDate

DECLARE @BlockedFromDate DateTime, @BlockedToDate DateTime, @BlockedReason NVARCHAR(1000)

DECLARE @Slots INT = 1, @Slot INT = 1, @Row INT = 1, @Rows INT = 1

SELECT	@Slots = NumberOfSlots 
FROM	MPA.dbo.WorkCentre w
WHERE	w.SageRef = @SageRef

PRINT	'SORT OUT THE SLOTS'
WHILE @DT <= @ToDate
BEGIN	
	IF DATEPART(DW, @DT) > 1 AND DATEPART(DW, @DT) < 7
	
		SET @Slot = 1		
	
		WHILE @Slot	<= @Slots
		BEGIN
			INSERT INTO @Results(OrderDate, Slot) VALUES(@DT, @Slot)
			SET @Slot = @Slot + 1
		END
		SET @DT = DateAdd(DAY, 1, @DT)
END

INSERT INTO @BlockedSlots 
SELECT		b.SlotNumber, b.BlockedReason, b.BlockedFromDate, b.BlockedToDate
FROM		MPA.dbo.WorkCentre w 
LEFT JOIN	MPA.dbo.WorkCentreBlockedSlots b
ON			w.Id = b.WorkCentreId
WHERE		w.SageRef = @SageRef
AND			(@FromDate BETWEEN b.BlockedFromDate and b.BlockedToDate)
OR			(b.BlockedToDate > @ToDate)

PRINT 'GO THROUGH EACH BLOCKED SLOT AND SET THEM TO BLOCKED'

SELECT @Slot = 1,  @Row = 1, @Slots = COUNT(1) FROM @BlockedSlots
WHILE @Row <= @Slots
	BEGIN
		SELECT	@Slot = SlotNumber,
				@BlockedFromDate = BlockedFromDate, 
				@BlockedToDate = BlockedToDate, 
				@BlockedReason = SlotBlockedReason
		FROM	@BlockedSlots
		WHERE	Id = @Row
		
		--SELECT @Slot, @BlockedReason, @BlockedFromDate, @BlockedToDate

		UPDATE	@Results
		SET		SlotBlocked = 1,
				SlotBlockedReason = @BlockedReason,
				BlockedFromDate = @BlockedFromDate,
				BlockedToDate = @BlockedToDate
		WHERE	Slot = @Slot
		AND		OrderDate BETWEEN @BlockedFromDate AND @BlockedToDate
		
		SET		@Row = @Row + 1
	END

INSERT INTO @WOResults
SELECT		r.machine_group, 
			wo.warehouse as Warehouse, 
			product_code as ProductCode, 
			wo.description as ProductDescription, 
			r.works_order as WorkOrderNumber, 
			ISNULL(wo.quantity_required, 0) As QuantityRequired,			
			ISNULL(CEILING(COALESCE(CAST((r.run_time/r.batch_size)*wo.quantity_required AS FLOAT), 0)), 0) As StandardRunTime,				
			wo.order_date as OrderDate,
			1 AS Slot			
FROM		syslive.scheme.bmwohm wo WITH(NOLOCK)  
INNER JOIN	scheme.stunitdm u WITH(NOLOCK)  
ON			u.unit_code = wo.finish_prod_unit
LEFT JOIN	syslive.scheme.wswopm r WITH(NOLOCK)  
ON			(wo.works_order = r.works_order) 
WHERE		(r.machine_group = @SageRef) 
AND			wo.order_date BETWEEN @FromDate AND @ToDate
GROUP BY	wo.warehouse, product_code, r.works_order, wo.description, r.batch_size, r.run_skill_needed, r.machine_group,wo.quantity_required,wo.quantity_finished, run_time, r.batch_size, u.spare,  wo.order_date, security_reference 
ORDER BY	wo.order_date

-- FRIG SOME SLOTS
DECLARE @Curdate DATETIME, @NextDate DATETIME

SELECT @Row = 1, @Rows = count(1), @Curdate = MIN(OrderDate), @NextDate =MIN(OrderDate) -1, @Slot = 1  FROM @WOResults
WHILE @Row <= @Rows
BEGIN
	SELECT	@NextDate = OrderDate
	FROM	@WOResults 
	WHERE	Id = @Row

	IF @NextDate <> @Curdate
	BEGIN
		SELECT	@Slot = 1, @Curdate = @NextDate

		UPDATE	@WOResults
		SET		Slot = @Slot
		WHERE	Id = @Row
		
		SET	@Slot = @Slot + 1
	END
	ELSE
	BEGIN
		UPDATE	@WOResults
		SET		Slot =	@Slot
		WHERE	Id	=	@Row
	
		SET @Slot = @Slot + 1
	END
	
	SELECT	@Row = @Row + 1
END

SELECT		r.Slot, 
			r.OrderDate, Warehouse, ProductCode, ProductDescription, WorkOrderNumber, 
			ISNULL(QuantityRequired, 0) AS QuantityRequired, 
			ISNULL(StandardRunTime, 0) AS StandardRunTime, 
			r.BlockedFromDate,
			r.BlockedToDate, 
			r.SlotBlocked, 
			r.SlotBlockedReason
FROM		@Results r
LEFT JOIN	@WOResults w
on			r.OrderDate = w.OrderDate
AND			r.Slot = w.Slot

GO

[scheme].[sp_getWorkOrdersByline] 'HS04','2015-09-28'
