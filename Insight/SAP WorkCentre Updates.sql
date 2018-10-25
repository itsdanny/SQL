/* SSMSBoost
Event: DocumentExecuted
Event date: 2017-08-24 15:28:07
Connection: trsagev3d1.InsightTest (WinAuth)
*/
--UPDATE 	 INSIGHT WORKCENTRES TO NEW SAP CODE
update		w
SET			w.SageRef = m.NewLineCode
FROM		SAPMigration.dbo.MasterRecipeResourceInfo m
INNER JOIN 	InsightTest.dbo.WorkCentre w
ON			m.LineCode = w.SageRef COLLATE Latin1_General_CI_AS
WHERE		w.AreaId IN (1,2,3)

SELECT	*
FROM		SAPMigration.dbo.MasterRecipeResourceInfo m
INNER JOIN 		InsightTest.dbo.WorkCentre w
ON			m.LineCode = w.SageRef COLLATE Latin1_General_CI_AS
WHERE		w.AreaId IN (1,2,3)

SELECT	*
FROM			InsightTest.dbo.WorkCentre