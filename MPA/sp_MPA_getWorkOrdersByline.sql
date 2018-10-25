USE [syslive]
GO
/****** Object:  StoredProcedure [scheme].[sp_MPA_getWorkOrdersByline]    Script Date: 08/03/2016 14:40:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [scheme].[sp_MPA_getWorkOrdersByline]
@SageRef		VARCHAR(5) = NULL,
@FromDate		DATETIME = NULL,
@SearchText		VARCHAR(20) = NULL,
@View			INT = 6,
@BoardOrPlanner INT = 1
-- [scheme].[sp_MPA_getWorkOrdersByline] 'MN02',  '2016-03-18', NULL, 2
AS
/*
 Author:	Dan McGregor
 Date:		04 September 2015
 Desc:		Returns the data in a format that 'should' be easy to decipher for the front end, with out too much jiggery pokery there.
 
*/
--SET @FromDate = CAST(getDate() AS DATE)
PRINT @View
IF @SearchText IS NOT NULL 
BEGIN
	SELECT		@FromDate = order_date,
				@SageRef = r.machine_group 
	FROM		scheme.bmwohm h
	INNER JOIN	scheme.bmwodm d
	ON			h.works_order = d.works_order
	INNER JOIN	syslive.scheme.wswopm r WITH(NOLOCK)  
	ON			(h.works_order = r.works_order) 
	WHERE		h.works_order = @SearchText	
	AND			d.warehouse = 'BK'
END
IF @BoardOrPlanner = 1
BEGIN
	SET @FromDate = CAST(DATEADD(dd, -(DATEPART(dw, @FromDate))+2, @FromDate) AS DATE)-- [WeekStart]	
END
ELSE
BEGIN
	SET @FromDate = DATEADD(dd, -1,@FromDate)-- Yesterday
END

--set @SageRef ='HS07'
DECLARE @ToDate	DATETIME = DATEADD(DAY, @View, @FromDate)

DECLARE	@Results TABLE (Id INT IDENTITY(1,1), 
						Line				VARCHAR(6), 						
						OrderDate			DATETIME, 
						Slot				INT, 
						SlotBlocked			BIT DEFAULT 0,
						SlotBlockedReason	VARCHAR(50), 
						SlotBlockedComment	NVARCHAR(1000),
						BlockedFromDate		DATETIME, 
						BlockedToDate		DATETIME,
						BlockedHours		INT,
						SlotBlockedReasonId	INT)

DECLARE	@WOResults TABLE (Id INT IDENTITY(1,1), 
						 Line				VARCHAR(6), 
						 Warehouse			VARCHAR(2), 
						 ProductCode		VARCHAR(15), 
						 ProductDescription	VARCHAR(50),
						 UnitCode			VARCHAR(10), 
						 Alpha				VARCHAR(10), 
						 WOStatus			VARCHAR(20), 
						 FirmPlanned		VARCHAR(10), 
						 CompletedAmount	FLOAT,
						 WorkOrderNumber	VARCHAR(8), 
						 QuantityRequired	INT DEFAULT 0, 
						 QuantityFinished	INT DEFAULT 0, 
						 StandardRunTime	INT DEFAULT 0,
						 OrderDate			DATETIME,
						 Slot				INT DEFAULT 0,
						 --Operation			VARCHAR(3),
						 BatchType			VARCHAR(50)
						)

DECLARE	@BlockedSlots TABLE (Id					INT IDENTITY(1,1), 							
							SlotNumber			INT, 
							SlotBlockedReasonId	INT, 
							SlotBlockedReason	VARCHAR(50), 
							SlotBlockedComment	NVARCHAR(1000), 
							BlockedFromDate		DATETIME, 
							BlockedToDate		DATETIME,
							BlockedHours		INT)

DECLARE @DT	DATETIME = @FromDate

DECLARE @BlockedFromDate DATETIME, @BlockedToDate DATETIME, @BlockedReason NVARCHAR(1000), @BlockedComment VARCHAR(50), @BlockedHours INT, @SlotBlockedReasonId INT

DECLARE @Slots INT = 1, @Slot INT = 1, @Row INT = 1, @Rows INT = 1

SELECT	@Slots = NumberOfSlots 
FROM	MPA.dbo.WorkCentre w
WHERE	w.SageRef = @SageRef

PRINT	'SORT OUT THE SLOTS'
WHILE	@DT <= @ToDate
BEGIN	
	IF DATEPART(DW, @DT) <= 7
		SET @Slot = 1		
	
		WHILE @Slot	<= @Slots
		BEGIN
			INSERT INTO @Results(OrderDate, Slot) VALUES(@DT, @Slot)
			SET @Slot = @Slot + 1
		END
		SET @DT = DateAdd(DAY, 1, @DT)
END

INSERT INTO @BlockedSlots 
SELECT		b.SlotNumber, r.Id, r.BlockTypeDescription as SlotBlockedReason, b.SlotBlockedComment, b.BlockedFromDate, b.BlockedToDate, b.BlockedHours
FROM		MPA.dbo.WorkCentre w 
INNER JOIN	MPA.dbo.WorkCentreBlockedSlots b
ON			w.Id = b.WorkCentreId
INNER JOIN	MPA.dbo.SlotBlockReason r
ON			b.SlotBlockedReasonId = r.Id
WHERE		w.SageRef = @SageRef
AND			((CAST(b.BlockedFromDate AS DATE) BETWEEN @FromDate and @ToDate)
OR			(CAST(b.BlockedToDate AS DATE) BETWEEN @FromDate and @ToDate))
PRINT 'GO THROUGH EACH BLOCKED SLOT AND SET THEM TO BLOCKED IN THE RESULTS TABLE'

SELECT @Slot = 1,  @Row = 1, @Slots = COUNT(1) FROM @BlockedSlots
WHILE @Row <= @Slots
	BEGIN
		SELECT	@Slot = SlotNumber,
				@SlotBlockedReasonId = SlotBlockedReasonId,
				@BlockedFromDate = BlockedFromDate, 
				@BlockedToDate = BlockedToDate, 
				@BlockedReason = SlotBlockedReason,
				@BlockedComment = SlotBlockedComment,
				@BlockedHours = BlockedHours

		FROM	@BlockedSlots
		WHERE	Id = @Row
		
		--SELECT @Slot, @BlockedReason, @BlockedFromDate, @BlockedToDate

		UPDATE	@Results
		SET		SlotBlocked = 1,
				SlotBlockedReasonId = @SlotBlockedReasonId,
				SlotBlockedComment = @BlockedComment,
				SlotBlockedReason = @BlockedReason,
				BlockedFromDate = @BlockedFromDate,
				BlockedToDate = @BlockedToDate,
				BlockedHours = @BlockedHours
		
		WHERE	Slot = @Slot
		AND		OrderDate BETWEEN @BlockedFromDate AND @BlockedToDate		
		
		SET		@Row = @Row + 1
	END

PRINT  'GET THE WOS FOR THIS LINE'

INSERT INTO @WOResults
SELECT		LTRIM(RTRIM(r.machine_group)), 
			LTRIM(RTRIM(wo.warehouse)) as Warehouse, 
			LTRIM(RTRIM(product_code)) as ProductCode, 
			LTRIM(RTRIM(wo.description)) as ProductDescription, 
			LTRIM(RTRIM(u.unit_code)),
			LTRIM(RTRIM(st.alpha)),
			LTRIM(RTRIM(CASE wo.status WHEN 'H' THEN 'Held' WHEN 'C' THEN 'Complete' WHEN 'I' THEN 'Issued' WHEN 'A'THEN 'Waiting'  ELSE '' END)),
			LTRIM(RTRIM(wo.firm_planned)),
			--ISNULL(ROUND(CAST(SUM(s.StillageQuantity) AS FLOAT)/MAX(j.WorkCentreJobBatchSize),2), 0),			
			CASE WHEN SUM(wo.quantity_finished) > 0 THEN ROUND(CAST(SUM(wo.quantity_finished) AS FLOAT)/CAST(MAX(wo.quantity_required) AS FLOAT), 2) END,
			LTRIM(RTRIM(r.works_order)) as WorkOrderNumber, 			
			MAX(ISNULL(wo.quantity_required, 0)) As QuantityRequired,			
			MAX(ISNULL(wo.quantity_finished, 0)) As QuantityFinished,			
			ISNULL(CEILING(COALESCE(CAST((SUM(r.run_time)/MAX(r.batch_size))*MAX(wo.quantity_required) AS FLOAT), 0)), 0) As StandardRunTime,				
			wo.order_date as OrderDate,
			CASE wo.security_reference WHEN 'AM' THEN '1' WHEN 'PM' THEN '2' WHEN 'NS' THEN '3' ELSE wo.security_reference END AS Slot,
		--	MAX(r.operation_number) AS operation_number,
			ISNULL(m.text2,'') AS BatchType
FROM		syslive.scheme.bmwohm wo WITH(NOLOCK)  
INNER JOIN	scheme.stunitdm u WITH(NOLOCK)  
ON			u.unit_code = wo.finish_prod_unit
inner  JOIN	scheme.stockm st WITH(NOLOCK)
ON			wo.product_code = st.product 
AND			wo.warehouse = st.warehouse
LEFT JOIN	syslive.scheme.wswopm r WITH(NOLOCK)  
ON			(wo.works_order = r.works_order) 
LEFT JOIN	scheme.mrwotextm m 
ON			(wo.works_order = m.works_order) 
LEFT JOIN	Insight.dbo.WorkCentreJob j
ON			wo.works_order = j.WorkOrderNumber collate Latin1_General_CI_AS
LEFT JOIN	Insight.dbo.WorkCentreJobStillageLog s
ON			j.Id = s.WorkCentreJobId
WHERE		(r.machine_group = @SageRef) 
AND			wo.order_date BETWEEN @FromDate AND @ToDate-1
GROUP BY	wo.warehouse, product_code, r.works_order, wo.description, 
			r.batch_size, 
			--r.run_skill_needed, 
			r.machine_group,
			--wo.quantity_required,wo.quantity_finished, run_time, 
			r.batch_size, 
			st.alpha, u.unit_code, wo.order_date, security_reference,wo.status, wo.firm_planned,ISNULL(m.text2,'')  

--SELECT * FROM @WOResults
PRINT	'FRIG SOME SLOTS'
DECLARE @Curdate DATETIME, @NextDate DATETIME

/*SELECT @Row = 1, @Rows = count(1), @Curdate = MIN(OrderDate), @NextDate =MIN(OrderDate) -1, @Slot = 1  FROM @WOResults
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
*/
PRINT		'RETURN THE RESULTS'
SELECT		ISNULL(w.Slot, r.Slot) AS Slot,
			r.OrderDate, Warehouse, ProductCode, ProductDescription, WorkOrderNumber, 
			ISNULL(QuantityRequired, 0) AS QuantityRequired, 
			ISNULL(QuantityFinished, 0) AS QuantityFinished, 			
			Insight.dbo.fn_IntToTime(ISNULL((SELECT SUM(StandardRunTime) FROM @WOResults), 0)+ISNULL((SELECT sum(BlockedHours)*60 FROM @BlockedSlots), 0.0)) AS LineRunTime,
			Insight.dbo.fn_IntToTime(ISNULL(StandardRunTime, 0)) AS StandardRunTime,
			CASE WHEN WorkOrderNumber IS NULL THEN r.BlockedFromDate ELSE NULL END AS BlockedFromDate,
			CASE WHEN WorkOrderNumber IS NULL THEN r.BlockedToDate ELSE NULL END AS BlockedToDate, 
			CASE WHEN WorkOrderNumber IS NULL THEN ISNULL(r.BlockedHours, 0.0) ELSE 0.0 END AS BlockedHours,
			CASE WHEN WorkOrderNumber IS NULL THEN ISNULL(r.SlotBlockedReasonId,0) ELSE 0 END AS SlotBlockedReasonId, 
			CAST(CASE WHEN WorkOrderNumber IS NULL THEN r.SlotBlocked ELSE 0 END AS BIT) AS SlotBlocked, 
			CAST(CASE WHEN WorkOrderNumber IS NULL THEN r.SlotBlockedReason ELSE '0' END AS VARCHAR(50)) AS SlotBlockedReason, 
			CAST(CASE WHEN WorkOrderNumber IS NULL THEN r.SlotBlockedComment ELSE '0' END AS NVARCHAR(1000)) AS SlotBlockedComment, 
			w.UnitCode,
			w.Alpha,
			w.FirmPlanned,
			w.WOStatus,
			ISNULL(w.CompletedAmount, 0.0) as CompletedAmount,
			--w.Operation,
			@SearchText as SearchText,
			ISNULL(LTRIM(RTRIM(w.BatchType)), '') AS BatchType
FROM		@Results r
LEFT JOIN	@WOResults w
ON			r.OrderDate = w.OrderDate
AND			r.Slot = w.Slot
--WHERE		(w.WorkOrderNumber IS NOT NULL OR BlockedFromDate IS NOT NULL)
ORDER BY	2, 1
-- USE THIS BUT USING ABOVE TO FRIG DATA
--SELECT		r.Slot, 
--			r.OrderDate, Warehouse, ProductCode, ProductDescription, WorkOrderNumber, 
--			ISNULL(QuantityRequired, 0) AS QuantityRequired, 
--			ISNULL(StandardRunTime, 0) AS StandardRunTime, 
--			r.BlockedFromDate,
--			r.BlockedToDate, 
--			r.SlotBlocked, 
--			r.SlotBlockedReason,
--			r.SlotBlockedComment,
--			w.UnitCode,
--			w.Alpha,
--			w.FirmPlanned,
--			w.WOStatus,
--			ISNULL(w.CompletedAmount, 0.0) as CompletedAmount
--FROM		@Results r
--LEFT JOIN	@WOResults w
--ON			r.OrderDate = w.OrderDate
--AND			r.Slot = w.Slot
----WHERE		(w.WorkOrderNumber IS NOT NULL OR BlockedFromDate IS NOT NULL)
--ORDER BY	2, 1
 --		[scheme].[sp_MPA_getWorkOrdersByline] 'HS05', '2016-02-18'
GO


 [scheme].[sp_MPA_getWorkOrdersByline] 'MN02',  '2016-03-18'

 go
 [scheme].[sp_MPA_getWorkOrdersByline] 'MN02',  '2016-03-18', NULL, 2
 go
 [scheme].[sp_MPA_getWorkOrdersByline] 'MN02',  '2016-03-18', NULL, 1