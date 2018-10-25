
/*
---- Return the summary by day
--SELECT		Id AS ManufacturingStageId, Name AS ManufacturingStage, SUM(Performance) AS Performance, [DayOfWeek], [DayNo]
--FROM		#Tmp	
--GROUP BY	[DayOfWeek], Id, [DayNo],Name
--ORDER BY	Id, [DayNo]	

-- Return the summary by performance
SELECT		Id AS ManufacturingStageId, Name AS ManufacturingStage, 
			SUM(CASE Performance WHEN 1 THEN 1 ELSE 0 END) AS Performance,
			SUM(CASE Performance WHEN 0 THEN 0 ELSE 0 END) AS NoPerformance
FROM		#Tmp	
GROUP BY	Id, Name
UNION ALL
SELECT		Id AS ManufacturingStageId, Name AS ManufacturingStage, 
			SUM(CASE Performance WHEN 0 THEN 1 ELSE 0 END) AS Performance,
			SUM(CASE Performance WHEN 1 THEN 0 ELSE 0 END) AS NoPerformance
FROM		#Tmp	
GROUP BY	Id, Name
ORDER BY	Id*/
