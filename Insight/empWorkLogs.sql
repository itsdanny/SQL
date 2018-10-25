--SELECT		a.Name as Area, al.EmpRef, StartDateTime,FinishDateTime
---- case when FinishDateTime  < StartDateTime then DATEADD(HOUR, 7.5, StartDateTime) ELSE FinishDateTime END AS  FinishDateTme, case when FinishDateTime  < StartDateTime then '!'  else '' end as Erroneous
--FROM			AreaLabourLog al
--INNER JOIN		Area a
--ON				al.AreaId = a.Id
--WHERE		StartDateTime BETWEEN '2015-08-01 00:00:00' AND '2015-08-31 23:59:59' 
--AND			AreaId in (1,2,3)
--AND			EmpRef in('0111','0126','0138','0429','0442','0465','0488','0512','0516','0566','0570','0584','0629','0719','0748','0751','0767','0773','0776','0781','0782','0784')
--ORDER BY	al.AreaId, StartDateTime


go
SELECT		a.Name, wl.EmpRef, wl.StartDateTime
FROM		WorkCentreLog wl
INNER JOIN	dbo.WorkCentre w
ON			wl.WorkCentreId = w.Id
INNER JOIN	Area a
ON			a.Id = w.AreaId
WHERE		[IsEngineer] = 1
AND			StartDateTime BETWEEN '2015-08-01 00:00:00' AND '2015-08-31 23:59:59' 
ORDER BY	a.Id, EmpRef, StartDateTime