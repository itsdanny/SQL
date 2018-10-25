SELECT  cot.ChangeOverName,
		wc.NAME,
		wc.SageRef,
		wc.AreaId,
		wcco.WorkCrewe,
		wcco.ChangeOverInfo,
		wcco.BatchTime, wc.Id
FROM		dbo.ChangeOverType AS cot
INNER JOIN	dbo.WorkCentreChangeOver AS wcco
ON			cot.Id = wcco.ChangeOverTypeId
INNER JOIN	dbo.WorkCentre AS wc
ON			wcco.WorkCentreId = wc.Id
WHERE (
		wc.SageRef IN (			'HP51',			'HP52',			'LS51')			
		AND wc.AreaId <> 4
		)