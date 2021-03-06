USE [InsightTest]
GO
/****** Object:  StoredProcedure [dbo].[rpt_ManLabSummary]    Script Date: 06/05/2014 10:57:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[rpt_ManLabSummary]
@fromDate	DATETIME,
@toDate		DATETIME
AS

SELECT		ms.Id, ms.Name AS ManufacturingStage, mj.ManufacturingRoute, mj.WorkOrderNumber, mj.Product, mj.[Description],
			MIN(mjl.StartDateTime) AS StartTime, 
			MAX(mjl.FinishDateTime) AS FinishTime, 
			mjl.StandardRuntime,			
			SUM(mjl.StageRuntime) AS StageRunTime,			
			mj.ManufacturingJobRunTime,			
			COUNT(DISTINCT mjl.EmpRef) AS NumberOfStaff,
			CASE WHEN mc.Id IS NULL THEN 'No' ELSE 'Yes' END AS Campaign,
			CASE WHEN SUM(mjl.StageRuntime) < mjl.StandardRuntime THEN 1 ELSE 0 END AS Performance,
			DATENAME(dw, MAX(mjl.FinishDateTime)) AS [DayOfWeek],
			DATEPART(WEEKDAY, MAX(mjl.FinishDateTime)) AS [DayNo],
			wc.ManufacturingArea,
			'' AS JobSummary
			--COUNT(mjl.EmpRef) AS DirectLabour
			INTO #Tmp	
FROM		ManufacturingJob mj
INNER JOIN	ManufacturingJobLog mjl
ON			mj.Id = mjl.ManufacturingJobId
INNER JOIN  ManufacturingStage ms
ON			mjl.ManufacturingStageId = ms.Id		
LEFT JOIN	ManufactureCampaignJob mc
ON			mjl.Id = mc.ManufactureJobLogId
INNER JOIN   ManufacturingRoute mr
ON			mj.ManufacturingRoute = mr.ManufacturingRoute
INNER JOIN   WorkCentreManufacturingRoute wcmr
ON			mr.Id = wcmr.ManufacturingRouteId
INNER JOIN	WorkCentre wc
ON			wc.Id = wcmr.WorkCentreId
WHERE		CAST(mjl.StartDateTime AS DATE) BETWEEN CAST(@fromDate AS DATE) AND CAST(@toDate AS DATE)
AND			mjl.FinishDateTime IS NOT NULL
--and			MJ.WorkOrderNumber ='HR43A'
GROUP BY	ms.Id, ms.Name, MJ.WorkOrderNumber, mj.Product, StandardRuntime, 
			mj.ManufacturingRoute, mc.Id, mj.ManufacturingJobRunTime,mj.[Description], 
			wc.ManufacturingArea--, mjl.EmpRef
ORDER BY	MJ.WorkOrderNumber, ms.Id, mj.Product


-- Return the summary by performance
SELECT		Id AS ManufacturingStageId, ManufacturingStage, 
			CAST(SUM(CASE Performance WHEN 1 THEN 1 ELSE 0 END) AS VARCHAR(4)) AS Performance,
			'To Standard' AS Performer				
FROM		#Tmp	
WHERE		Performance = 1
GROUP BY	ManufacturingStage, Id
union all
SELECT		Id AS ManufacturingStageId,  ManufacturingStage, 
			CAST(SUM(CASE Performance WHEN 0 THEN 1 ELSE 0 END) AS VARCHAR(4)) AS Performance,
			'Over Standard' AS Performer	
FROM		#Tmp	
WHERE		Performance = 0
GROUP BY	ManufacturingStage, Id;

-- Return Area/Bay level data
SELECT		CAST(dbo.fn_IntToTime(SUM(StandardRuntime)) AS VARCHAR(12)) AS StandardHours,									
			CAST(dbo.fn_IntToTime(SUM(StageRunTime)) AS VARCHAR(12)) AS ActualHours, 
			CAST(CASE WHEN SUM(StandardRuntime) > SUM(StageRunTime) THEN 1 ELSE 0 END AS VARCHAR(10)) AS Performance,
			CAST(COUNT(DISTINCT WorkOrderNumber)AS VARCHAR(6)) AS AreaJobCount,
			ManufacturingArea
FROM		#Tmp t
WHERE		Performance = 1
GROUP  BY	ManufacturingArea
UNION
SELECT		CAST(dbo.fn_IntToTime(SUM(StandardRuntime)) AS VARCHAR(12)) AS StandardHours,									
			CAST(dbo.fn_IntToTime(SUM(StageRunTime)) AS VARCHAR(12)) AS ActualHours, 
			CAST(CASE WHEN SUM(StandardRuntime) > SUM(StageRunTime) THEN 1 ELSE 0 END AS VARCHAR(10)) AS Performance,
			CAST(COUNT( DISTINCT WorkOrderNumber) AS VARCHAR(6)) AS AreaJobCount,
			ManufacturingArea
FROM		#Tmp t
WHERE		Performance = 0
GROUP  BY	ManufacturingArea
union 
SELECT		'Standard Hours','Actual Hours','Performance','Job Count', 'Area'

; 
-- Return work order level data
WITH PIV
AS(
SELECT	WorkOrderNumber, [Description], ManufacturingArea, SUM(StandardHours) AS StandardHours, 
		SUM(COALESCE([Dispensing],0) + COALESCE([Manufacturing],0) + COALESCE([Setup],0) + COALESCE([Transfer],0) + COALESCE([Cleaning],0)) AS ActualHours
		,[Dispensing],[Manufacturing],[Setup],[Transfer], [Cleaning]
FROM(
SELECT		WorkOrderNumber, [Description], 			
			dbo.fn_IntToTime(SUM(StandardRuntime)) AS StandardHours,									
			dbo.fn_IntToTime(SUM(StageRunTime)) AS ActualHours,			
			ManufacturingArea, ManufacturingStage
FROM		#Tmp
GROUP  BY	WorkOrderNumber, [Description], ManufacturingArea, ManufacturingStage
) x 
	PIVOT
	(
	SUM(ActualHours)
		FOR	ManufacturingStage IN ([Dispensing],[Manufacturing],[Setup],[Transfer],[Cleaning])
	) p
GROUP  BY WorkOrderNumber, [Description], ManufacturingArea, [Dispensing],[Manufacturing],[Setup],[Transfer],[Cleaning]
)

SELECT  WorkOrderNumber, [Description], ManufacturingArea, 
		SUM(StandardHours) AS StandardHours, 
		SUM(ActualHours) AS ActualHours, 
		CASE WHEN SUM(StandardHours) > SUM(ActualHours) THEN 1 ELSE 0 END AS Performance,	
		COALESCE('D:' + CAST(MAX(Dispensing) AS VARCHAR(6)) + ' | ', '') + 
		COALESCE('M:' + CAST(MAX(Manufacturing) AS VARCHAR(6)) + ' | ','') +
		COALESCE('S:' + CAST(MAX(Setup) AS VARCHAR(6)) + ' | ','') +
		COALESCE('T:' + CAST(MAX([Transfer]) AS VARCHAR(6)) + ' | ','') +
		COALESCE('C:' + CAST(MAX(Cleaning) AS VARCHAR(6)),'')
		AS StageTimes
FROM PIV
GROUP BY  ManufacturingArea, WorkOrderNumber, [Description]
ORDER BY  ManufacturingArea, WorkOrderNumber, [Description]

--  RETURN THE AREAS
SELECT DISTINCT ManufacturingArea FROM WorkCentre WHERE AreaId  = 3 and ManufacturingArea is not null
GO 

[rpt_ManLabSummary] '2014-05-01','2014-05-31'
go


