--  WORK CENTRE STAGE
SELECT *  FROM dbo.WorkCentreStage

--  WORK CENTRE STATUS
SELECT * FROM dbo.WorkCentreStatus

SELECT * FROM dbo.Area 

SELECT * FROM dbo.WorkCentre

SELECT * FROM dbo.WorkCentreLog where WorkCentreId = 1

SELECT * FROM dbo.WorkCentreJob where WorkCentreId = 1

SELECT * FROM dbo.WorkCentreJobLog where WorkCentreJobId = 84

select * from dbo.WorkCentreJobLogLabourDetail where EmpRef = 2403

select * from dbo.AreaLabourLog order by StartDateTime desc


SELECT * 
FROM		dbo.WorkCentreJob  wcj
INNER JOIN	dbo.WorkCentreJobLog wcjl
ON			wcj.Id = wcjl.WorkCentreJobId
