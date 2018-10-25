/****** Script for SelectTopNRows command from SSMS  ******/
-- This uses TRSERVSQL -> TestStuff

Create Table #ScoreTable(
Value varchar(100) ,
Score int,
AgeGroup varchar(100),
Gender varchar(25),
Department varchar(100)
)

Insert into #ScoreTable(Value,Score,AgeGroup,Gender,Department) 

Select Value1 as value,
5 as score,
Age,
Gender,
Department                   
                                                                              
  FROM [TestStuff].[dbo].[TRSurvey_Values]
  where RespondentID Is Not Null
  
  UNION ALL
  
  SELECT 
Value2 as value,
4 as score,
Age,
Gender,
Department                   
                                                                              
  FROM [TestStuff].[dbo].[TRSurvey_Values]
  where RespondentID Is Not Null


  UNION ALL
  
  SELECT 
Value3 as value,
3 as score,
Age,
Gender,
Department                   
                                                                              
  FROM [TestStuff].[dbo].[TRSurvey_Values]
  where RespondentID Is Not Null


  UNION ALL
  
  SELECT 
Value4 as value,
2 as score,
Age,
Gender,
Department                   
                                                                              
  FROM [TestStuff].[dbo].[TRSurvey_Values]
  where RespondentID Is Not Null


  UNION ALL
  
  SELECT 
Value5 as value,
2 as score,
Age,
Gender,
Department                   
                                                                              
  FROM [TestStuff].[dbo].[TRSurvey_Values]
  where RespondentID Is Not Null
  
  
  Select Value, SUM(Score) as ScoreTotal from #ScoreTable
  Group by Value
  Order by SUM(Score) Desc
  
  Select Department, Value, SUM(Score) as ScoreTotal from #ScoreTable
  where Department Is Not Null
  Group by Department, Value
  Order by Department, SUM(Score) Desc
  
  Select AgeGroup, Value, SUM(Score) as ScoreTotal from #ScoreTable
  where AgeGroup Is Not Null
  Group by AgeGroup, Value
  Order by AgeGroup, SUM(Score) Desc
  
  Select Gender, Value, SUM(Score)   as ScoreTotal from #ScoreTable 
  where Gender Is Not Null
  Group by Gender, Value
  Order by Gender, SUM(Score) Desc