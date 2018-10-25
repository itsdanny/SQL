select LocationId, PracticeCode, LocationName,  GeogCode,  Address1, Address2, Address3, Town, County, CommInfo, PostCode, CustomerId, ForeName, Surname, JobTitle, Title, CustomerType, Grade, 
CASE  WHEN UPPER(CustomerType) LIKE '%MANAGER%' THEN 0 WHEN UPPER(JobTitle) LIKE '%PRAC%MANAGER%' THEN 0  WHEN UPPER(CustomerType) LIKE '%GP%' THEN 1 WHEN UPPER(CustomerType) LIKE '%NURSE%' THEN 2 WHEN UPPER(CustomerType) LIKE '%DISPENSER%' THEN 3 WHEN UPPER(CustomerType) LIKE '%RECEPTION%' THEN 5 WHEN UPPER(CustomerType) LIKE '%VISITOR%' THEN 4 ELSE 4 END JobRoleCategory
  FROM GPData.dbo.ACTISPracticeStaffData  a    
  ORDER BY LocationId, PostCode,
  CASE  WHEN UPPER(Grade) like '%GP' THEN 0
 WHEN UPPER(Grade) like 'PRACTICE NURSE' THEN 1
 WHEN UPPER(Grade) like 'DISPENSER' THEN 2
 WHEN UPPER(Grade) like 'OTHER PERSONNEL' THEN 3
 else 4
 end 
 ,Surname

/*
SELECT DISTINCT LEFT(GeogCode, 2) AS ccg, GeogCode, LocationId  FROM GPData.dbo.ACTISPracticeStaffData  a  ORDER BY LEFT(GeogCode, 2)

SELECT LocationId, PracticeCode, LocationName,  GeogCode,  Address1, Address2, Address3, Town, County, CommInfo, PostCode, CustomerId, ForeName, Surname, JobTitle, Title, CustomerType, Grade FROM GPData.dbo.ACTISPracticeStaffData  a WHERE GeogCode = 'FK10' ORDER BY LocationId, PostCode, CASE WHEN UPPER(Grade) LIKE '%GP' THEN 0 WHEN UPPER(Grade) LIKE 'PRACTICE NURSE' THEN 1 WHEN UPPER(Grade) LIKE 'DISPENSER' THEN 2 WHEN UPPER(Grade) LIKE 'OTHER PERSONNEL' THEN 3 ELSE 4 END ,Surname 



SELECT DISTINCT TOP 100 GeogCode, LocationId FROM GPData.dbo.ACTISPracticeStaffData order by GeogCode


*/

SELECT * FROM GPData.dbo.ACTISPracticeStaffData WHERE GeogCode = 'AL07'