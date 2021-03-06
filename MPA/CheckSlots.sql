USE [MPA]
GO
/****** Object:  StoredProcedure [dbo].[sp__GetWorkCentreBlockedSlots]    Script Date: 18/11/2015 14:09:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER	PROCEDURE sp__checkSlots
@WorkCentreId	INT,
@SlotNumber		INT = NULL,
@WorkOrderDate	DATETIME = NULL
AS
-- CHECK FOR WO's AT THIS TIME ETC
SELECT		LTRIM(RTRIM(r.machine_group)) AS SageRef, 
			LTRIM(RTRIM(wo.warehouse)) as Warehouse, 
			LTRIM(RTRIM(product_code)) as ProductCode, 
			LTRIM(RTRIM(wo.description)) as ProductDescription, 			
			--LTRIM(RTRIM(CASE wo.status WHEN 'H' THEN 'Held' WHEN 'C' THEN 'Complete' WHEN 'I' THEN 'Issued' WHEN 'A'THEN 'Waiting'  ELSE '' END)) as WOStatus,
			LTRIM(RTRIM(wo.firm_planned)) AS FirmPlanned,
			--ISNULL(ROUND(CAST(SUM(s.StillageQuantity) AS FLOAT)/MAX(j.WorkCentreJobBatchSize),2), 0) AS PercentComplete,			
			LTRIM(RTRIM(r.works_order)) as WorkOrderNumber, 			
			--ISNULL(wo.quantity_required, 0) As QuantityRequired,			
			--ISNULL(CEILING(COALESCE(CAST((r.run_time/r.batch_size)*wo.quantity_required AS FLOAT), 0)), 0) As StandardRunTime,				
			wo.order_date as OrderDate,
			1 AS Slot INTO #tmp	
FROM		syslive.scheme.bmwohm wo WITH(NOLOCK)  
LEFT JOIN	syslive.scheme.wswopm r WITH(NOLOCK)  
ON			(wo.works_order = r.works_order) 
LEFT JOIN	Insight.dbo.WorkCentreJob j
ON			wo.works_order = j.WorkOrderNumber collate Latin1_General_CI_AS
LEFT JOIN	Insight.dbo.WorkCentreJobStillageLog s
ON			j.Id = s.WorkCentreJobId
INNER JOIN	WorkCentre wc
ON			wc.SageRef = r.machine_group
--WHERE		(r.machine_group = @SageRef) 
WHERE		wc.Id = @WorkCentreId
AND			wo.order_date = @WorkOrderDate
AND			wo.security_reference = 'AM'--cast(@SlotNumber as varchar(2))
GROUP BY	wo.warehouse, product_code, r.works_order, wo.description, r.batch_size, r.run_skill_needed, r.machine_group,wo.quantity_required,wo.quantity_finished, run_time, r.batch_size,wo.order_date, security_reference,wo.status, wo.firm_planned 
ORDER BY	wo.order_date

IF (SELECT COUNT(1) FROM #tmp) > 0
BEGIN
	SELECT top 1 *, 0 as WorkCentreId FROM #tmp
END
BEGIN
PRINT 'NO WO SO WHAT ABOUT BLOCKED SLOTS'
	IF @SlotNumber IS NOT NULL
	BEGIN
		SELECT * 
		FROM	WorkCentreBlockedSlots 
		WHERE	WorkCentreId = @WorkCentreId
		AND		SlotNumber = @SlotNumber
		AND		BlockedToDate > GETDATE()
		ORDER BY SlotNumber, BlockedFromDate;
	END
	ELSE IF @WorkOrderDate IS NOT NULL
	BEGIN
		SELECT * 
		FROM	WorkCentreBlockedSlots 
		WHERE	WorkCentreId = @WorkCentreId
		AND		@WorkOrderDate BETWEEN BlockedFromDate AND BlockedToDate
		ORDER BY SlotNumber, BlockedFromDate;
	END
	ELSE IF @WorkOrderDate IS NULL AND @SlotNumber IS NULL
	BEGIN
		SELECT * 
		FROM	WorkCentreBlockedSlots 
		WHERE	WorkCentreId = @WorkCentreId	
		AND		GETDATE() BETWEEN BlockedFromDate AND BlockedToDate
		ORDER BY SlotNumber, BlockedFromDate;
	END
	ELSE IF @WorkOrderDate IS NOT NULL AND @SlotNumber IS NOT NULL
	BEGIN
		SELECT * 
		FROM	WorkCentreBlockedSlots 
		WHERE	WorkCentreId = @WorkCentreId	
		AND		@WorkOrderDate BETWEEN BlockedFromDate AND BlockedToDate
		AND		SlotNumber = @SlotNumber
		ORDER BY SlotNumber, BlockedFromDate;
	END
END
GO


EXEC sp__checkSlots 19, null, '2015-11-17' 
GO
EXEC sp__checkSlots 19, null, '2015-11-21' 
GO
EXEC sp__checkSlots 19, 1, '2015-11-23' 
