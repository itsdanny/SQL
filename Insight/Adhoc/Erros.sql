use Insight
SELECT * FROM INSIGHTERRORS Where ErrorMessage not in ('Connection ON','Connection OFF','Line logged in','Insight turned on') and ErrorMessage not like 'Insight Logging out%' order by ErrorDate desc
SELECT * FROM INSIGHTERRORS Where ErrorMessage not in ('Connection ON','Connection OFF','Line logged in','Insight turned on') and ErrorMessage not like 'Insight Logging out%' order by  ErrorDate desc
SELECT * FROM INSIGHTERRORS Where ErrorMessage not in ('. Error: Object reference not set to an instance of an object.')  order by  ErrorDate desc
SELECT * FROM INSIGHTERRORS Where ErrorMethod in ('set staff','SetLineStatus','SetObjects')  order by  ErrorDate desc

-- WIFI DROPS
SELECT OtherInfo, COUNT(1) as DropOffs FROM INSIGHTERRORS Where ErrorMessage ('Connection ON') 
and CAST(ErrorDate AS DATE) = CAST(GETDATE()-3 AS DATE)
group by OtherInfo
order by COUNT(1) desc

-- VERSION
SELECT * FROM WorkCentre where Name not in(
SELECT DISTINCT UserName FROM INSIGHTERRORS Where OtherInfo  = ('1.0.21.0'))
AND name in (SELECT distinct OtherInfo FROM INSIGHTERRORS)
and AreaId <> 4

SELECT wc.Name FROM WorkCentre wc 
LEFT JOIN InsightErrors ie
ON		wc.Name = ie.UserName
WHERE IE.ErrorID IS NULL
and wc.AreaId <> 4

-- BY WORK CENTRE
SELECT * FROM INSIGHTERRORS Where OtherInfo ='1.0.21.0' order by ErrorDate desc
SELECT * FROM INSIGHTERRORS Where ErrorMessage =  'Line logged in' order by ErrorDate desc
select top 4 * from WorkCentreJobEventLog order by id desc
select * from WorkCentreJob where id = 4207

--DELETE FROM INSIGHTERRORS where ErrorDate < getDate()-14


select * from test
SELECT * FROM dbo.WorkCentreManufacturingRoute

--	select * from InsightErrors where ErrorMessage in('Insight turned on') and errordate > '2014-04-29 15:28:35.867' order by  ErrorDate desc
SELECT		e.* 
FROM		WorkCentre w
LEFT JOIN   InsightErrors  e
ON			w.Name = e.OtherInfo
ORDER BY	ErrorDate DESC
--	SELECT * FROM INSIGHTERRORS ORDER BY ErrorDate desc
DELETE FROM INSIGHTERRORS WHERE OtherInfo ='IT5' 
--	employee 0723. Logged in Date: 15/05/2014 13:01:26

select * from InsightErrors order by ErrorDate desc
delete from InsightErrors where ErrorDate < GETDATE()-7
select OtherInfo, COUNT(1) delete from InsightErrors 
where ErrorMessage ='No Connectivity'
group by OtherInfo
order by count(1) desc

SELECT * FROM WorkCentreJobStillageLog order by StillageTime desc
SELECT * FROM WorkCentreJobStillageLog order by WorkCentreJobId desc


select * from WorkCentreJob
select * from WorkCentreJobLog where FinishDateTime is null
select *  from WorkCentre  order by areaid

select * from WorkCentreChangeOver co
inner join ChangeOverType ct
on	CO.ChangeOverTypeId = CT.Id
inner join WorkCentre wc
ON		co.WorkCentreId = wc.Id
select * from WorkCentreJobEventLog 

select *
FROM WorkCentre
WHERE AreaId in(1)

SELECT * 
FROM		WorkCentreJobEventLog a
INNER JOIN	WorkCentreJob b
ON			a.WorkCentreJobId = b.Id
WHERE		b.Id = 242

select * from WorkCentreJobStillageLog where StillageTime > getdate()-1 order by StillageTime
select * from WorkCentreJobStillageLog  order by StillageTime desc

select c.Name, '*'+cast(o.Id as varchar)+'*', T.ChangeOverName from WorkCentreChangeOver o
INNER JOIN WorkCentre C
on			C.Id = o.WorkCentreId
inner join ChangeOverType t
ON	o.ChangeOverTypeId = T.Id

select * from AreaLabourLog where FinishDateTime is null order by StartDateTime
select LEN(s.LotNumber),* from WorkCentreJobStillageLog s
INNER JOIN WorkCentreJob j
on j.Id = s.WorkCentreJobId where j.Id = 348
 order by StillageTime desc
select * from AreaLabourLog order by FinishDateTime desc
--DELETE from InsightErrors where  CAST(errordate AS dATE) < GETdATE()-1sekect

SELECT * FROM	WorkCentreJob j
INNER JOIN		WorkCentreJobLog l
on			j.Id = l.WorkCentreJobId
ORDER BY L.StartDateTime DESC

select		*, DATEDIFF(MINUTE, l.StartDateTime, getDAte()), DATEDIFF(MINUTE, l.StartDateTime, getDAte())
FROM		WorkCentreJob j
INNER JOIN	WorkCentreJobLog l
ON			j.Id = l.WorkCentreJobId
INNER JOIN WorkCentreJobEventLog e
ON			e.WorkCentreJobId = j.Id
WHERE		j.WorkOrderNumber = 'JD95B'

SELECT *
FROM		WorkCentreJob j
INNER JOIN	WorkCentreJobLog l
ON			j.Id = l.WorkCentreJobId
WHERE		l.StandardRuntime < 30
