DECLARE @WorkCentre VARCHAR(20) --= 'HP52'
/*
SELECT DISTINCT MAX(iwc.SageRef+CAST(mtp.ID AS VARCHAR(5))) AS Id,
			AVG(mtp.Crew) as Crew, 
			mtw.Description As Line, 
			pg.Description as ChangeOverName, 
			CAST(mtp.PlanStandard * 60 AS INT) AS BatchTime,  
			mtp.operation_code,
			r.std_labour_rate as HourlyRate*/

SELECT		DISTINCT iwc.SageRef,
			OperationNameID, Crew, operation_description,r.std_labour_rate
FROM		[MachineTracker].[dbo].[Process] mtp 
INNER JOIN	[MachineTracker].[dbo].[ProcessGroup] pg
ON			mtp.ProcessGroupID = pg.ID
INNER JOIN	[MachineTracker].[dbo].WorkCentre mtw
ON			mtw.ID = pg.WorkCentreID
INNER JOIN 	WorkCentre iwc
ON			LTRIM(RTRIM(mtw.SAPResourceCode)) = LTRIM(RTRIM(iwc.SageRef)) COLLATE Latin1_General_CI_AS
INNER JOIN	Area ia
ON			iwc.AreaId = ia.Id 
INNER JOIN	[MachineTracker].[dbo].OperationName mto
ON			mtp.OperationNameID = mto.ID  
INNER JOIN 	InsightLabourRates r
ON			ia.CostCentreCode+CAST(mtp.Crew AS VARCHAR(2)) = r.code COLLATE Latin1_General_CI_AS
WHERE		mtp.operation_code IN (1015,1020,1025)
AND			mtp.IsDead = 0
AND			mtp.IsDummy = 0
AND			mtp.IsCosting = 1
AND			(@WorkCentre is null or iwc.SageRef  = @WorkCentre)
--AND			CostingYear IS NOT NULL
--GROUP BY	mtw.Description, pg.Description,  mtp.PlanStandard,  mtp.operation_code,r.std_labour_rate

return
SELECT	*
FROM		[MachineTracker].[dbo].OperationName 