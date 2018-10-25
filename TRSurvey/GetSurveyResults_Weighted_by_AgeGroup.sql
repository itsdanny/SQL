/****** Script for SelectTopNRows command from SSMS  ******/
-- This uses TRSERVSQL -> TestStuff

SELECT '18 - 24' as AgeRange,count(RespondentId) as Total, SUM(
      CASE WHEN Value1  = 'Commitment' then 5 else 0 END + 
      CASE WHEN Value2  = 'Commitment' then 4 else 0 END + 
      CASE WHEN Value3  = 'Commitment' then 3 else 0 END + 
      CASE WHEN Value4 = 'Commitment' then 2 else 0 END + 
      CASE WHEN Value5  = 'Commitment' then 1 else 0 END)
      as [Commitment_Count],
SUM(CASE WHEN Value1  = 'Customer focussed' then 5 else 0 END + 
      CASE WHEN Value2  = 'Customer focussed' then 4 else 0 END + 
      CASE WHEN Value3  = 'Customer focussed' then 3 else 0 END + 
      CASE WHEN Value4 = 'Customer focussed' then 2 else 0 END + 
      CASE WHEN Value5  = 'Customer focussed' then 1 else 0 END)
      as [Customer_focussed_Count],
      
SUM(CASE WHEN Value1  = 'Consistency' then 5 else 0 END + 
      CASE WHEN Value2  = 'Consistency' then 4 else 0 END + 
      CASE WHEN Value3  = 'Consistency' then 3 else 0 END + 
      CASE WHEN Value4 = 'Consistency' then 2 else 0 END + 
      CASE WHEN Value5  = 'Consistency' then 1 else 0 END)
      as [Consistency_Count],
      
SUM(CASE WHEN Value1  = 'Empathy' then 5 else 0 END + 
      CASE WHEN Value2  = 'Empathy' then 4 else 0 END + 
      CASE WHEN Value3  = 'Empathy' then 3 else 0 END + 
      CASE WHEN Value4 = 'Empathy' then 2 else 0 END + 
      CASE WHEN Value5  = 'Empathy' then 1 else 0 END)
      as [Empathy_Count],
      
SUM(CASE WHEN Value1  = 'Excellence' then 5 else 0 END + 
      CASE WHEN Value2  = 'Excellence' then 4 else 0 END + 
      CASE WHEN Value3  = 'Excellence' then 3 else 0 END + 
      CASE WHEN Value4 = 'Excellence' then 2 else 0 END + 
      CASE WHEN Value5  = 'Excellence' then 1 else 0 END)
      as [Excellence_Count],
      
SUM(CASE WHEN Value1  = 'Focussed' then 5 else 0 END + 
      CASE WHEN Value2  = 'Focussed' then 4 else 0 END + 
      CASE WHEN Value3  = 'Focussed' then 3 else 0 END + 
      CASE WHEN Value4 = 'Focussed' then 2 else 0 END + 
      CASE WHEN Value5  = 'Focussed' then 1 else 0 END)
      as [Focussed_Count],

SUM(CASE WHEN Value1  = 'Fun' then 5 else 0 END + 
      CASE WHEN Value2  = 'Fun' then 4 else 0 END + 
      CASE WHEN Value3  = 'Fun' then 3 else 0 END + 
      CASE WHEN Value4 = 'Fun' then 2 else 0 END + 
      CASE WHEN Value5  = 'Fun' then 1 else 0 END)
      as [Fun_Count],
     
SUM(CASE WHEN Value1  = 'Honesty' then 5 else 0 END + 
      CASE WHEN Value2  = 'Honesty' then 4 else 0 END + 
      CASE WHEN Value3  = 'Honesty' then 3 else 0 END + 
      CASE WHEN Value4 = 'Honesty' then 2 else 0 END + 
      CASE WHEN Value5  = 'Honesty' then 1 else 0 END)
      as [Honesty_Count],
   
SUM(CASE WHEN Value1  = 'Innovative' then 5 else 0 END + 
      CASE WHEN Value2  = 'Innovative' then 4 else 0 END + 
      CASE WHEN Value3  = 'Innovative' then 3 else 0 END + 
      CASE WHEN Value4 = 'Innovative' then 2 else 0 END + 
      CASE WHEN Value5  = 'Innovative' then 1 else 0 END)
      as [Innovative_Count],
        
SUM(CASE WHEN Value1  = 'Integrity' then 5 else 0 END + 
      CASE WHEN Value2  = 'Integrity' then 4 else 0 END + 
      CASE WHEN Value3  = 'Integrity' then 3 else 0 END + 
      CASE WHEN Value4 = 'Integrity' then 2 else 0 END + 
      CASE WHEN Value5  = 'Integrity' then 1 else 0 END)
      as [Integrity_Count],
      
SUM(CASE WHEN Value1  = 'Openness' then 5 else 0 END + 
      CASE WHEN Value2  = 'Openness' then 4 else 0 END + 
      CASE WHEN Value3  = 'Openness' then 3 else 0 END + 
      CASE WHEN Value4 = 'Openness' then 2 else 0 END + 
      CASE WHEN Value5  = 'Openness' then 1 else 0 END)
      as [Openness_Count],

SUM(CASE WHEN Value1  = 'Optimism' then 5 else 0 END + 
      CASE WHEN Value2  = 'Optimism' then 4 else 0 END + 
      CASE WHEN Value3  = 'Optimism' then 3 else 0 END + 
      CASE WHEN Value4 = 'Optimism' then 2 else 0 END + 
      CASE WHEN Value5  = 'Optimism' then 1 else 0 END)
      as [Optimism_Count],

SUM(CASE WHEN Value1  = 'Organised' then 5 else 0 END + 
      CASE WHEN Value2  = 'Organised' then 4 else 0 END + 
      CASE WHEN Value3  = 'Organised' then 3 else 0 END + 
      CASE WHEN Value4 = 'Organised' then 2 else 0 END + 
      CASE WHEN Value5  = 'Organised' then 1 else 0 END)
      as [Organised_Count],

SUM(CASE WHEN Value1  = 'Professional' then 5 else 0 END + 
      CASE WHEN Value2  = 'Professional' then 4 else 0 END + 
      CASE WHEN Value3  = 'Professional' then 3 else 0 END + 
      CASE WHEN Value4 = 'Professional' then 2 else 0 END + 
      CASE WHEN Value5  = 'Professional' then 1 else 0 END)
      as [Professional_Count],

SUM(CASE WHEN Value1  = 'Reliability' then 5 else 0 END + 
      CASE WHEN Value2  = 'Reliability' then 4 else 0 END + 
      CASE WHEN Value3  = 'Reliability' then 3 else 0 END + 
      CASE WHEN Value4 = 'Reliability' then 2 else 0 END + 
      CASE WHEN Value5  = 'Reliability' then 1 else 0 END)
      as [Reliability_Count],
                                   
SUM(CASE WHEN Value1  = 'Respect' then 5 else 0 END + 
      CASE WHEN Value2  = 'Respect' then 4 else 0 END + 
      CASE WHEN Value3  = 'Respect' then 3 else 0 END + 
      CASE WHEN Value4 = 'Respect' then 2 else 0 END + 
      CASE WHEN Value5  = 'Respect' then 1 else 0 END)
      as [Respect_Count],

SUM(CASE WHEN Value1  = 'Responsibility' then 5 else 0 END + 
      CASE WHEN Value2  = 'Responsibility' then 4 else 0 END + 
      CASE WHEN Value3  = 'Responsibility' then 3 else 0 END + 
      CASE WHEN Value4 = 'Responsibility' then 2 else 0 END + 
      CASE WHEN Value5  = 'Responsibility' then 1 else 0 END)
      as [Responsibility_Count],

SUM(CASE WHEN Value1  = 'Results oriented' then 5 else 0 END + 
      CASE WHEN Value2  = 'Results oriented' then 4 else 0 END + 
      CASE WHEN Value3  = 'Results oriented' then 3 else 0 END + 
      CASE WHEN Value4 = 'Results oriented' then 2 else 0 END + 
      CASE WHEN Value5  = 'Results oriented' then 1 else 0 END)
      as [Results_oriented_Count],

SUM(CASE WHEN Value1  = 'Safety' then 5 else 0 END + 
      CASE WHEN Value2  = 'Safety' then 4 else 0 END + 
      CASE WHEN Value3  = 'Safety' then 3 else 0 END + 
      CASE WHEN Value4 = 'Safety' then 2 else 0 END + 
      CASE WHEN Value5  = 'Safety' then 1 else 0 END)
      as [Safety_Count],            
             
SUM(CASE WHEN Value1  = 'Teamwork' then 5 else 0 END + 
      CASE WHEN Value2  = 'Teamwork' then 4 else 0 END + 
      CASE WHEN Value3  = 'Teamwork' then 3 else 0 END + 
      CASE WHEN Value4 = 'Teamwork' then 2 else 0 END + 
      CASE WHEN Value5  = 'Teamwork' then 1 else 0 END)
      as [Teamwork_Count], 
      
SUM(CASE WHEN Value1  = 'Trust' then 5 else 0 END + 
      CASE WHEN Value2  = 'Trust' then 4 else 0 END + 
      CASE WHEN Value3  = 'Trust' then 3 else 0 END + 
      CASE WHEN Value4 = 'Trust' then 2 else 0 END + 
      CASE WHEN Value5  = 'Trust' then 1 else 0 END)
      as [Trust_Count]              
                                               
                                                                              
  FROM [TestStuff].[dbo].[TRSurvey_Values]
  where RespondentID Is Not Null
  and Age = '18 to 24'

UNION

SELECT '25 to 34' as AgeRange, count(RespondentId) as Total,SUM(
      CASE WHEN Value1  = 'Commitment' then 5 else 0 END + 
      CASE WHEN Value2  = 'Commitment' then 4 else 0 END + 
      CASE WHEN Value3  = 'Commitment' then 3 else 0 END + 
      CASE WHEN Value4 = 'Commitment' then 2 else 0 END + 
      CASE WHEN Value5  = 'Commitment' then 1 else 0 END)
      as [Commitment_Count],
SUM(CASE WHEN Value1  = 'Customer focussed' then 5 else 0 END + 
      CASE WHEN Value2  = 'Customer focussed' then 4 else 0 END + 
      CASE WHEN Value3  = 'Customer focussed' then 3 else 0 END + 
      CASE WHEN Value4 = 'Customer focussed' then 2 else 0 END + 
      CASE WHEN Value5  = 'Customer focussed' then 1 else 0 END)
      as [Customer_focussed_Count],
      
SUM(CASE WHEN Value1  = 'Consistency' then 5 else 0 END + 
      CASE WHEN Value2  = 'Consistency' then 4 else 0 END + 
      CASE WHEN Value3  = 'Consistency' then 3 else 0 END + 
      CASE WHEN Value4 = 'Consistency' then 2 else 0 END + 
      CASE WHEN Value5  = 'Consistency' then 1 else 0 END)
      as [Consistency_Count],
      
SUM(CASE WHEN Value1  = 'Empathy' then 5 else 0 END + 
      CASE WHEN Value2  = 'Empathy' then 4 else 0 END + 
      CASE WHEN Value3  = 'Empathy' then 3 else 0 END + 
      CASE WHEN Value4 = 'Empathy' then 2 else 0 END + 
      CASE WHEN Value5  = 'Empathy' then 1 else 0 END)
      as [Empathy_Count],
      
SUM(CASE WHEN Value1  = 'Excellence' then 5 else 0 END + 
      CASE WHEN Value2  = 'Excellence' then 4 else 0 END + 
      CASE WHEN Value3  = 'Excellence' then 3 else 0 END + 
      CASE WHEN Value4 = 'Excellence' then 2 else 0 END + 
      CASE WHEN Value5  = 'Excellence' then 1 else 0 END)
      as [Excellence_Count],
      
SUM(CASE WHEN Value1  = 'Focussed' then 5 else 0 END + 
      CASE WHEN Value2  = 'Focussed' then 4 else 0 END + 
      CASE WHEN Value3  = 'Focussed' then 3 else 0 END + 
      CASE WHEN Value4 = 'Focussed' then 2 else 0 END + 
      CASE WHEN Value5  = 'Focussed' then 1 else 0 END)
      as [Focussed_Count],

SUM(CASE WHEN Value1  = 'Fun' then 5 else 0 END + 
      CASE WHEN Value2  = 'Fun' then 4 else 0 END + 
      CASE WHEN Value3  = 'Fun' then 3 else 0 END + 
      CASE WHEN Value4 = 'Fun' then 2 else 0 END + 
      CASE WHEN Value5  = 'Fun' then 1 else 0 END)
      as [Fun_Count],
     
SUM(CASE WHEN Value1  = 'Honesty' then 5 else 0 END + 
      CASE WHEN Value2  = 'Honesty' then 4 else 0 END + 
      CASE WHEN Value3  = 'Honesty' then 3 else 0 END + 
      CASE WHEN Value4 = 'Honesty' then 2 else 0 END + 
      CASE WHEN Value5  = 'Honesty' then 1 else 0 END)
      as [Honesty_Count],
   
SUM(CASE WHEN Value1  = 'Innovative' then 5 else 0 END + 
      CASE WHEN Value2  = 'Innovative' then 4 else 0 END + 
      CASE WHEN Value3  = 'Innovative' then 3 else 0 END + 
      CASE WHEN Value4 = 'Innovative' then 2 else 0 END + 
      CASE WHEN Value5  = 'Innovative' then 1 else 0 END)
      as [Innovative_Count],
        
SUM(CASE WHEN Value1  = 'Integrity' then 5 else 0 END + 
      CASE WHEN Value2  = 'Integrity' then 4 else 0 END + 
      CASE WHEN Value3  = 'Integrity' then 3 else 0 END + 
      CASE WHEN Value4 = 'Integrity' then 2 else 0 END + 
      CASE WHEN Value5  = 'Integrity' then 1 else 0 END)
      as [Integrity_Count],
      
SUM(CASE WHEN Value1  = 'Openness' then 5 else 0 END + 
      CASE WHEN Value2  = 'Openness' then 4 else 0 END + 
      CASE WHEN Value3  = 'Openness' then 3 else 0 END + 
      CASE WHEN Value4 = 'Openness' then 2 else 0 END + 
      CASE WHEN Value5  = 'Openness' then 1 else 0 END)
      as [Openness_Count],

SUM(CASE WHEN Value1  = 'Optimism' then 5 else 0 END + 
      CASE WHEN Value2  = 'Optimism' then 4 else 0 END + 
      CASE WHEN Value3  = 'Optimism' then 3 else 0 END + 
      CASE WHEN Value4 = 'Optimism' then 2 else 0 END + 
      CASE WHEN Value5  = 'Optimism' then 1 else 0 END)
      as [Optimism_Count],

SUM(CASE WHEN Value1  = 'Organised' then 5 else 0 END + 
      CASE WHEN Value2  = 'Organised' then 4 else 0 END + 
      CASE WHEN Value3  = 'Organised' then 3 else 0 END + 
      CASE WHEN Value4 = 'Organised' then 2 else 0 END + 
      CASE WHEN Value5  = 'Organised' then 1 else 0 END)
      as [Organised_Count],

SUM(CASE WHEN Value1  = 'Professional' then 5 else 0 END + 
      CASE WHEN Value2  = 'Professional' then 4 else 0 END + 
      CASE WHEN Value3  = 'Professional' then 3 else 0 END + 
      CASE WHEN Value4 = 'Professional' then 2 else 0 END + 
      CASE WHEN Value5  = 'Professional' then 1 else 0 END)
      as [Professional_Count],

SUM(CASE WHEN Value1  = 'Reliability' then 5 else 0 END + 
      CASE WHEN Value2  = 'Reliability' then 4 else 0 END + 
      CASE WHEN Value3  = 'Reliability' then 3 else 0 END + 
      CASE WHEN Value4 = 'Reliability' then 2 else 0 END + 
      CASE WHEN Value5  = 'Reliability' then 1 else 0 END)
      as [Reliability_Count],
                                   
SUM(CASE WHEN Value1  = 'Respect' then 5 else 0 END + 
      CASE WHEN Value2  = 'Respect' then 4 else 0 END + 
      CASE WHEN Value3  = 'Respect' then 3 else 0 END + 
      CASE WHEN Value4 = 'Respect' then 2 else 0 END + 
      CASE WHEN Value5  = 'Respect' then 1 else 0 END)
      as [Respect_Count],

SUM(CASE WHEN Value1  = 'Responsibility' then 5 else 0 END + 
      CASE WHEN Value2  = 'Responsibility' then 4 else 0 END + 
      CASE WHEN Value3  = 'Responsibility' then 3 else 0 END + 
      CASE WHEN Value4 = 'Responsibility' then 2 else 0 END + 
      CASE WHEN Value5  = 'Responsibility' then 1 else 0 END)
      as [Responsibility_Count],

SUM(CASE WHEN Value1  = 'Results oriented' then 5 else 0 END + 
      CASE WHEN Value2  = 'Results oriented' then 4 else 0 END + 
      CASE WHEN Value3  = 'Results oriented' then 3 else 0 END + 
      CASE WHEN Value4 = 'Results oriented' then 2 else 0 END + 
      CASE WHEN Value5  = 'Results oriented' then 1 else 0 END)
      as [Results_oriented_Count],

SUM(CASE WHEN Value1  = 'Safety' then 5 else 0 END + 
      CASE WHEN Value2  = 'Safety' then 4 else 0 END + 
      CASE WHEN Value3  = 'Safety' then 3 else 0 END + 
      CASE WHEN Value4 = 'Safety' then 2 else 0 END + 
      CASE WHEN Value5  = 'Safety' then 1 else 0 END)
      as [Safety_Count],            
             
SUM(CASE WHEN Value1  = 'Teamwork' then 5 else 0 END + 
      CASE WHEN Value2  = 'Teamwork' then 4 else 0 END + 
      CASE WHEN Value3  = 'Teamwork' then 3 else 0 END + 
      CASE WHEN Value4 = 'Teamwork' then 2 else 0 END + 
      CASE WHEN Value5  = 'Teamwork' then 1 else 0 END)
      as [Teamwork_Count], 
      
SUM(CASE WHEN Value1  = 'Trust' then 5 else 0 END + 
      CASE WHEN Value2  = 'Trust' then 4 else 0 END + 
      CASE WHEN Value3  = 'Trust' then 3 else 0 END + 
      CASE WHEN Value4 = 'Trust' then 2 else 0 END + 
      CASE WHEN Value5  = 'Trust' then 1 else 0 END)
      as [Trust_Count]              
                                               
                                                                              
  FROM [TestStuff].[dbo].[TRSurvey_Values]
  where RespondentID Is Not Null
  and Age = '25 to 34'

UNION 

SELECT '35 to 44' as AgeRange, count(RespondentId) as Total,SUM(
      CASE WHEN Value1  = 'Commitment' then 5 else 0 END + 
      CASE WHEN Value2  = 'Commitment' then 4 else 0 END + 
      CASE WHEN Value3  = 'Commitment' then 3 else 0 END + 
      CASE WHEN Value4 = 'Commitment' then 2 else 0 END + 
      CASE WHEN Value5  = 'Commitment' then 1 else 0 END)
      as [Commitment_Count],
SUM(CASE WHEN Value1  = 'Customer focussed' then 5 else 0 END + 
      CASE WHEN Value2  = 'Customer focussed' then 4 else 0 END + 
      CASE WHEN Value3  = 'Customer focussed' then 3 else 0 END + 
      CASE WHEN Value4 = 'Customer focussed' then 2 else 0 END + 
      CASE WHEN Value5  = 'Customer focussed' then 1 else 0 END)
      as [Customer_focussed_Count],
      
SUM(CASE WHEN Value1  = 'Consistency' then 5 else 0 END + 
      CASE WHEN Value2  = 'Consistency' then 4 else 0 END + 
      CASE WHEN Value3  = 'Consistency' then 3 else 0 END + 
      CASE WHEN Value4 = 'Consistency' then 2 else 0 END + 
      CASE WHEN Value5  = 'Consistency' then 1 else 0 END)
      as [Consistency_Count],
      
SUM(CASE WHEN Value1  = 'Empathy' then 5 else 0 END + 
      CASE WHEN Value2  = 'Empathy' then 4 else 0 END + 
      CASE WHEN Value3  = 'Empathy' then 3 else 0 END + 
      CASE WHEN Value4 = 'Empathy' then 2 else 0 END + 
      CASE WHEN Value5  = 'Empathy' then 1 else 0 END)
      as [Empathy_Count],
      
SUM(CASE WHEN Value1  = 'Excellence' then 5 else 0 END + 
      CASE WHEN Value2  = 'Excellence' then 4 else 0 END + 
      CASE WHEN Value3  = 'Excellence' then 3 else 0 END + 
      CASE WHEN Value4 = 'Excellence' then 2 else 0 END + 
      CASE WHEN Value5  = 'Excellence' then 1 else 0 END)
      as [Excellence_Count],
      
SUM(CASE WHEN Value1  = 'Focussed' then 5 else 0 END + 
      CASE WHEN Value2  = 'Focussed' then 4 else 0 END + 
      CASE WHEN Value3  = 'Focussed' then 3 else 0 END + 
      CASE WHEN Value4 = 'Focussed' then 2 else 0 END + 
      CASE WHEN Value5  = 'Focussed' then 1 else 0 END)
      as [Focussed_Count],

SUM(CASE WHEN Value1  = 'Fun' then 5 else 0 END + 
      CASE WHEN Value2  = 'Fun' then 4 else 0 END + 
      CASE WHEN Value3  = 'Fun' then 3 else 0 END + 
      CASE WHEN Value4 = 'Fun' then 2 else 0 END + 
      CASE WHEN Value5  = 'Fun' then 1 else 0 END)
      as [Fun_Count],
     
SUM(CASE WHEN Value1  = 'Honesty' then 5 else 0 END + 
      CASE WHEN Value2  = 'Honesty' then 4 else 0 END + 
      CASE WHEN Value3  = 'Honesty' then 3 else 0 END + 
      CASE WHEN Value4 = 'Honesty' then 2 else 0 END + 
      CASE WHEN Value5  = 'Honesty' then 1 else 0 END)
      as [Honesty_Count],
   
SUM(CASE WHEN Value1  = 'Innovative' then 5 else 0 END + 
      CASE WHEN Value2  = 'Innovative' then 4 else 0 END + 
      CASE WHEN Value3  = 'Innovative' then 3 else 0 END + 
      CASE WHEN Value4 = 'Innovative' then 2 else 0 END + 
      CASE WHEN Value5  = 'Innovative' then 1 else 0 END)
      as [Innovative_Count],
        
SUM(CASE WHEN Value1  = 'Integrity' then 5 else 0 END + 
      CASE WHEN Value2  = 'Integrity' then 4 else 0 END + 
      CASE WHEN Value3  = 'Integrity' then 3 else 0 END + 
      CASE WHEN Value4 = 'Integrity' then 2 else 0 END + 
      CASE WHEN Value5  = 'Integrity' then 1 else 0 END)
      as [Integrity_Count],
      
SUM(CASE WHEN Value1  = 'Openness' then 5 else 0 END + 
      CASE WHEN Value2  = 'Openness' then 4 else 0 END + 
      CASE WHEN Value3  = 'Openness' then 3 else 0 END + 
      CASE WHEN Value4 = 'Openness' then 2 else 0 END + 
      CASE WHEN Value5  = 'Openness' then 1 else 0 END)
      as [Openness_Count],

SUM(CASE WHEN Value1  = 'Optimism' then 5 else 0 END + 
      CASE WHEN Value2  = 'Optimism' then 4 else 0 END + 
      CASE WHEN Value3  = 'Optimism' then 3 else 0 END + 
      CASE WHEN Value4 = 'Optimism' then 2 else 0 END + 
      CASE WHEN Value5  = 'Optimism' then 1 else 0 END)
      as [Optimism_Count],

SUM(CASE WHEN Value1  = 'Organised' then 5 else 0 END + 
      CASE WHEN Value2  = 'Organised' then 4 else 0 END + 
      CASE WHEN Value3  = 'Organised' then 3 else 0 END + 
      CASE WHEN Value4 = 'Organised' then 2 else 0 END + 
      CASE WHEN Value5  = 'Organised' then 1 else 0 END)
      as [Organised_Count],

SUM(CASE WHEN Value1  = 'Professional' then 5 else 0 END + 
      CASE WHEN Value2  = 'Professional' then 4 else 0 END + 
      CASE WHEN Value3  = 'Professional' then 3 else 0 END + 
      CASE WHEN Value4 = 'Professional' then 2 else 0 END + 
      CASE WHEN Value5  = 'Professional' then 1 else 0 END)
      as [Professional_Count],

SUM(CASE WHEN Value1  = 'Reliability' then 5 else 0 END + 
      CASE WHEN Value2  = 'Reliability' then 4 else 0 END + 
      CASE WHEN Value3  = 'Reliability' then 3 else 0 END + 
      CASE WHEN Value4 = 'Reliability' then 2 else 0 END + 
      CASE WHEN Value5  = 'Reliability' then 1 else 0 END)
      as [Reliability_Count],
                                   
SUM(CASE WHEN Value1  = 'Respect' then 5 else 0 END + 
      CASE WHEN Value2  = 'Respect' then 4 else 0 END + 
      CASE WHEN Value3  = 'Respect' then 3 else 0 END + 
      CASE WHEN Value4 = 'Respect' then 2 else 0 END + 
      CASE WHEN Value5  = 'Respect' then 1 else 0 END)
      as [Respect_Count],

SUM(CASE WHEN Value1  = 'Responsibility' then 5 else 0 END + 
      CASE WHEN Value2  = 'Responsibility' then 4 else 0 END + 
      CASE WHEN Value3  = 'Responsibility' then 3 else 0 END + 
      CASE WHEN Value4 = 'Responsibility' then 2 else 0 END + 
      CASE WHEN Value5  = 'Responsibility' then 1 else 0 END)
      as [Responsibility_Count],

SUM(CASE WHEN Value1  = 'Results oriented' then 5 else 0 END + 
      CASE WHEN Value2  = 'Results oriented' then 4 else 0 END + 
      CASE WHEN Value3  = 'Results oriented' then 3 else 0 END + 
      CASE WHEN Value4 = 'Results oriented' then 2 else 0 END + 
      CASE WHEN Value5  = 'Results oriented' then 1 else 0 END)
      as [Results_oriented_Count],

SUM(CASE WHEN Value1  = 'Safety' then 5 else 0 END + 
      CASE WHEN Value2  = 'Safety' then 4 else 0 END + 
      CASE WHEN Value3  = 'Safety' then 3 else 0 END + 
      CASE WHEN Value4 = 'Safety' then 2 else 0 END + 
      CASE WHEN Value5  = 'Safety' then 1 else 0 END)
      as [Safety_Count],            
             
SUM(CASE WHEN Value1  = 'Teamwork' then 5 else 0 END + 
      CASE WHEN Value2  = 'Teamwork' then 4 else 0 END + 
      CASE WHEN Value3  = 'Teamwork' then 3 else 0 END + 
      CASE WHEN Value4 = 'Teamwork' then 2 else 0 END + 
      CASE WHEN Value5  = 'Teamwork' then 1 else 0 END)
      as [Teamwork_Count], 
      
SUM(CASE WHEN Value1  = 'Trust' then 5 else 0 END + 
      CASE WHEN Value2  = 'Trust' then 4 else 0 END + 
      CASE WHEN Value3  = 'Trust' then 3 else 0 END + 
      CASE WHEN Value4 = 'Trust' then 2 else 0 END + 
      CASE WHEN Value5  = 'Trust' then 1 else 0 END)
      as [Trust_Count]              
                                               
                                                                              
  FROM [TestStuff].[dbo].[TRSurvey_Values]
  where RespondentID Is Not Null
  and Age = '35 to 44'

UNION

SELECT '45 to 54' as AgeRange,count(RespondentId) as Total, SUM(
      CASE WHEN Value1  = 'Commitment' then 5 else 0 END + 
      CASE WHEN Value2  = 'Commitment' then 4 else 0 END + 
      CASE WHEN Value3  = 'Commitment' then 3 else 0 END + 
      CASE WHEN Value4 = 'Commitment' then 2 else 0 END + 
      CASE WHEN Value5  = 'Commitment' then 1 else 0 END)
      as [Commitment_Count],
SUM(CASE WHEN Value1  = 'Customer focussed' then 5 else 0 END + 
      CASE WHEN Value2  = 'Customer focussed' then 4 else 0 END + 
      CASE WHEN Value3  = 'Customer focussed' then 3 else 0 END + 
      CASE WHEN Value4 = 'Customer focussed' then 2 else 0 END + 
      CASE WHEN Value5  = 'Customer focussed' then 1 else 0 END)
      as [Customer_focussed_Count],
      
SUM(CASE WHEN Value1  = 'Consistency' then 5 else 0 END + 
      CASE WHEN Value2  = 'Consistency' then 4 else 0 END + 
      CASE WHEN Value3  = 'Consistency' then 3 else 0 END + 
      CASE WHEN Value4 = 'Consistency' then 2 else 0 END + 
      CASE WHEN Value5  = 'Consistency' then 1 else 0 END)
      as [Consistency_Count],
      
SUM(CASE WHEN Value1  = 'Empathy' then 5 else 0 END + 
      CASE WHEN Value2  = 'Empathy' then 4 else 0 END + 
      CASE WHEN Value3  = 'Empathy' then 3 else 0 END + 
      CASE WHEN Value4 = 'Empathy' then 2 else 0 END + 
      CASE WHEN Value5  = 'Empathy' then 1 else 0 END)
      as [Empathy_Count],
      
SUM(CASE WHEN Value1  = 'Excellence' then 5 else 0 END + 
      CASE WHEN Value2  = 'Excellence' then 4 else 0 END + 
      CASE WHEN Value3  = 'Excellence' then 3 else 0 END + 
      CASE WHEN Value4 = 'Excellence' then 2 else 0 END + 
      CASE WHEN Value5  = 'Excellence' then 1 else 0 END)
      as [Excellence_Count],
      
SUM(CASE WHEN Value1  = 'Focussed' then 5 else 0 END + 
      CASE WHEN Value2  = 'Focussed' then 4 else 0 END + 
      CASE WHEN Value3  = 'Focussed' then 3 else 0 END + 
      CASE WHEN Value4 = 'Focussed' then 2 else 0 END + 
      CASE WHEN Value5  = 'Focussed' then 1 else 0 END)
      as [Focussed_Count],

SUM(CASE WHEN Value1  = 'Fun' then 5 else 0 END + 
      CASE WHEN Value2  = 'Fun' then 4 else 0 END + 
      CASE WHEN Value3  = 'Fun' then 3 else 0 END + 
      CASE WHEN Value4 = 'Fun' then 2 else 0 END + 
      CASE WHEN Value5  = 'Fun' then 1 else 0 END)
      as [Fun_Count],
     
SUM(CASE WHEN Value1  = 'Honesty' then 5 else 0 END + 
      CASE WHEN Value2  = 'Honesty' then 4 else 0 END + 
      CASE WHEN Value3  = 'Honesty' then 3 else 0 END + 
      CASE WHEN Value4 = 'Honesty' then 2 else 0 END + 
      CASE WHEN Value5  = 'Honesty' then 1 else 0 END)
      as [Honesty_Count],
   
SUM(CASE WHEN Value1  = 'Innovative' then 5 else 0 END + 
      CASE WHEN Value2  = 'Innovative' then 4 else 0 END + 
      CASE WHEN Value3  = 'Innovative' then 3 else 0 END + 
      CASE WHEN Value4 = 'Innovative' then 2 else 0 END + 
      CASE WHEN Value5  = 'Innovative' then 1 else 0 END)
      as [Innovative_Count],
        
SUM(CASE WHEN Value1  = 'Integrity' then 5 else 0 END + 
      CASE WHEN Value2  = 'Integrity' then 4 else 0 END + 
      CASE WHEN Value3  = 'Integrity' then 3 else 0 END + 
      CASE WHEN Value4 = 'Integrity' then 2 else 0 END + 
      CASE WHEN Value5  = 'Integrity' then 1 else 0 END)
      as [Integrity_Count],
      
SUM(CASE WHEN Value1  = 'Openness' then 5 else 0 END + 
      CASE WHEN Value2  = 'Openness' then 4 else 0 END + 
      CASE WHEN Value3  = 'Openness' then 3 else 0 END + 
      CASE WHEN Value4 = 'Openness' then 2 else 0 END + 
      CASE WHEN Value5  = 'Openness' then 1 else 0 END)
      as [Openness_Count],

SUM(CASE WHEN Value1  = 'Optimism' then 5 else 0 END + 
      CASE WHEN Value2  = 'Optimism' then 4 else 0 END + 
      CASE WHEN Value3  = 'Optimism' then 3 else 0 END + 
      CASE WHEN Value4 = 'Optimism' then 2 else 0 END + 
      CASE WHEN Value5  = 'Optimism' then 1 else 0 END)
      as [Optimism_Count],

SUM(CASE WHEN Value1  = 'Organised' then 5 else 0 END + 
      CASE WHEN Value2  = 'Organised' then 4 else 0 END + 
      CASE WHEN Value3  = 'Organised' then 3 else 0 END + 
      CASE WHEN Value4 = 'Organised' then 2 else 0 END + 
      CASE WHEN Value5  = 'Organised' then 1 else 0 END)
      as [Organised_Count],

SUM(CASE WHEN Value1  = 'Professional' then 5 else 0 END + 
      CASE WHEN Value2  = 'Professional' then 4 else 0 END + 
      CASE WHEN Value3  = 'Professional' then 3 else 0 END + 
      CASE WHEN Value4 = 'Professional' then 2 else 0 END + 
      CASE WHEN Value5  = 'Professional' then 1 else 0 END)
      as [Professional_Count],

SUM(CASE WHEN Value1  = 'Reliability' then 5 else 0 END + 
      CASE WHEN Value2  = 'Reliability' then 4 else 0 END + 
      CASE WHEN Value3  = 'Reliability' then 3 else 0 END + 
      CASE WHEN Value4 = 'Reliability' then 2 else 0 END + 
      CASE WHEN Value5  = 'Reliability' then 1 else 0 END)
      as [Reliability_Count],
                                   
SUM(CASE WHEN Value1  = 'Respect' then 5 else 0 END + 
      CASE WHEN Value2  = 'Respect' then 4 else 0 END + 
      CASE WHEN Value3  = 'Respect' then 3 else 0 END + 
      CASE WHEN Value4 = 'Respect' then 2 else 0 END + 
      CASE WHEN Value5  = 'Respect' then 1 else 0 END)
      as [Respect_Count],

SUM(CASE WHEN Value1  = 'Responsibility' then 5 else 0 END + 
      CASE WHEN Value2  = 'Responsibility' then 4 else 0 END + 
      CASE WHEN Value3  = 'Responsibility' then 3 else 0 END + 
      CASE WHEN Value4 = 'Responsibility' then 2 else 0 END + 
      CASE WHEN Value5  = 'Responsibility' then 1 else 0 END)
      as [Responsibility_Count],

SUM(CASE WHEN Value1  = 'Results oriented' then 5 else 0 END + 
      CASE WHEN Value2  = 'Results oriented' then 4 else 0 END + 
      CASE WHEN Value3  = 'Results oriented' then 3 else 0 END + 
      CASE WHEN Value4 = 'Results oriented' then 2 else 0 END + 
      CASE WHEN Value5  = 'Results oriented' then 1 else 0 END)
      as [Results_oriented_Count],

SUM(CASE WHEN Value1  = 'Safety' then 5 else 0 END + 
      CASE WHEN Value2  = 'Safety' then 4 else 0 END + 
      CASE WHEN Value3  = 'Safety' then 3 else 0 END + 
      CASE WHEN Value4 = 'Safety' then 2 else 0 END + 
      CASE WHEN Value5  = 'Safety' then 1 else 0 END)
      as [Safety_Count],            
             
SUM(CASE WHEN Value1  = 'Teamwork' then 5 else 0 END + 
      CASE WHEN Value2  = 'Teamwork' then 4 else 0 END + 
      CASE WHEN Value3  = 'Teamwork' then 3 else 0 END + 
      CASE WHEN Value4 = 'Teamwork' then 2 else 0 END + 
      CASE WHEN Value5  = 'Teamwork' then 1 else 0 END)
      as [Teamwork_Count], 
      
SUM(CASE WHEN Value1  = 'Trust' then 5 else 0 END + 
      CASE WHEN Value2  = 'Trust' then 4 else 0 END + 
      CASE WHEN Value3  = 'Trust' then 3 else 0 END + 
      CASE WHEN Value4 = 'Trust' then 2 else 0 END + 
      CASE WHEN Value5  = 'Trust' then 1 else 0 END)
      as [Trust_Count]              
                                               
                                                                              
  FROM [TestStuff].[dbo].[TRSurvey_Values]
  where RespondentID Is Not Null
  and Age = '45 to 54'

UNION

SELECT '55+' as AgeRange, count(RespondentId) as Total,SUM(
      CASE WHEN Value1  = 'Commitment' then 5 else 0 END + 
      CASE WHEN Value2  = 'Commitment' then 4 else 0 END + 
      CASE WHEN Value3  = 'Commitment' then 3 else 0 END + 
      CASE WHEN Value4 = 'Commitment' then 2 else 0 END + 
      CASE WHEN Value5  = 'Commitment' then 1 else 0 END)
      as [Commitment_Count],
SUM(CASE WHEN Value1  = 'Customer focussed' then 5 else 0 END + 
      CASE WHEN Value2  = 'Customer focussed' then 4 else 0 END + 
      CASE WHEN Value3  = 'Customer focussed' then 3 else 0 END + 
      CASE WHEN Value4 = 'Customer focussed' then 2 else 0 END + 
      CASE WHEN Value5  = 'Customer focussed' then 1 else 0 END)
      as [Customer_focussed_Count],
      
SUM(CASE WHEN Value1  = 'Consistency' then 5 else 0 END + 
      CASE WHEN Value2  = 'Consistency' then 4 else 0 END + 
      CASE WHEN Value3  = 'Consistency' then 3 else 0 END + 
      CASE WHEN Value4 = 'Consistency' then 2 else 0 END + 
      CASE WHEN Value5  = 'Consistency' then 1 else 0 END)
      as [Consistency_Count],
      
SUM(CASE WHEN Value1  = 'Empathy' then 5 else 0 END + 
      CASE WHEN Value2  = 'Empathy' then 4 else 0 END + 
      CASE WHEN Value3  = 'Empathy' then 3 else 0 END + 
      CASE WHEN Value4 = 'Empathy' then 2 else 0 END + 
      CASE WHEN Value5  = 'Empathy' then 1 else 0 END)
      as [Empathy_Count],
      
SUM(CASE WHEN Value1  = 'Excellence' then 5 else 0 END + 
      CASE WHEN Value2  = 'Excellence' then 4 else 0 END + 
      CASE WHEN Value3  = 'Excellence' then 3 else 0 END + 
      CASE WHEN Value4 = 'Excellence' then 2 else 0 END + 
      CASE WHEN Value5  = 'Excellence' then 1 else 0 END)
      as [Excellence_Count],
      
SUM(CASE WHEN Value1  = 'Focussed' then 5 else 0 END + 
      CASE WHEN Value2  = 'Focussed' then 4 else 0 END + 
      CASE WHEN Value3  = 'Focussed' then 3 else 0 END + 
      CASE WHEN Value4 = 'Focussed' then 2 else 0 END + 
      CASE WHEN Value5  = 'Focussed' then 1 else 0 END)
      as [Focussed_Count],

SUM(CASE WHEN Value1  = 'Fun' then 5 else 0 END + 
      CASE WHEN Value2  = 'Fun' then 4 else 0 END + 
      CASE WHEN Value3  = 'Fun' then 3 else 0 END + 
      CASE WHEN Value4 = 'Fun' then 2 else 0 END + 
      CASE WHEN Value5  = 'Fun' then 1 else 0 END)
      as [Fun_Count],
     
SUM(CASE WHEN Value1  = 'Honesty' then 5 else 0 END + 
      CASE WHEN Value2  = 'Honesty' then 4 else 0 END + 
      CASE WHEN Value3  = 'Honesty' then 3 else 0 END + 
      CASE WHEN Value4 = 'Honesty' then 2 else 0 END + 
      CASE WHEN Value5  = 'Honesty' then 1 else 0 END)
      as [Honesty_Count],
   
SUM(CASE WHEN Value1  = 'Innovative' then 5 else 0 END + 
      CASE WHEN Value2  = 'Innovative' then 4 else 0 END + 
      CASE WHEN Value3  = 'Innovative' then 3 else 0 END + 
      CASE WHEN Value4 = 'Innovative' then 2 else 0 END + 
      CASE WHEN Value5  = 'Innovative' then 1 else 0 END)
      as [Innovative_Count],
        
SUM(CASE WHEN Value1  = 'Integrity' then 5 else 0 END + 
      CASE WHEN Value2  = 'Integrity' then 4 else 0 END + 
      CASE WHEN Value3  = 'Integrity' then 3 else 0 END + 
      CASE WHEN Value4 = 'Integrity' then 2 else 0 END + 
      CASE WHEN Value5  = 'Integrity' then 1 else 0 END)
      as [Integrity_Count],
      
SUM(CASE WHEN Value1  = 'Openness' then 5 else 0 END + 
      CASE WHEN Value2  = 'Openness' then 4 else 0 END + 
      CASE WHEN Value3  = 'Openness' then 3 else 0 END + 
      CASE WHEN Value4 = 'Openness' then 2 else 0 END + 
      CASE WHEN Value5  = 'Openness' then 1 else 0 END)
      as [Openness_Count],

SUM(CASE WHEN Value1  = 'Optimism' then 5 else 0 END + 
      CASE WHEN Value2  = 'Optimism' then 4 else 0 END + 
      CASE WHEN Value3  = 'Optimism' then 3 else 0 END + 
      CASE WHEN Value4 = 'Optimism' then 2 else 0 END + 
      CASE WHEN Value5  = 'Optimism' then 1 else 0 END)
      as [Optimism_Count],

SUM(CASE WHEN Value1  = 'Organised' then 5 else 0 END + 
      CASE WHEN Value2  = 'Organised' then 4 else 0 END + 
      CASE WHEN Value3  = 'Organised' then 3 else 0 END + 
      CASE WHEN Value4 = 'Organised' then 2 else 0 END + 
      CASE WHEN Value5  = 'Organised' then 1 else 0 END)
      as [Organised_Count],

SUM(CASE WHEN Value1  = 'Professional' then 5 else 0 END + 
      CASE WHEN Value2  = 'Professional' then 4 else 0 END + 
      CASE WHEN Value3  = 'Professional' then 3 else 0 END + 
      CASE WHEN Value4 = 'Professional' then 2 else 0 END + 
      CASE WHEN Value5  = 'Professional' then 1 else 0 END)
      as [Professional_Count],

SUM(CASE WHEN Value1  = 'Reliability' then 5 else 0 END + 
      CASE WHEN Value2  = 'Reliability' then 4 else 0 END + 
      CASE WHEN Value3  = 'Reliability' then 3 else 0 END + 
      CASE WHEN Value4 = 'Reliability' then 2 else 0 END + 
      CASE WHEN Value5  = 'Reliability' then 1 else 0 END)
      as [Reliability_Count],
                                   
SUM(CASE WHEN Value1  = 'Respect' then 5 else 0 END + 
      CASE WHEN Value2  = 'Respect' then 4 else 0 END + 
      CASE WHEN Value3  = 'Respect' then 3 else 0 END + 
      CASE WHEN Value4 = 'Respect' then 2 else 0 END + 
      CASE WHEN Value5  = 'Respect' then 1 else 0 END)
      as [Respect_Count],

SUM(CASE WHEN Value1  = 'Responsibility' then 5 else 0 END + 
      CASE WHEN Value2  = 'Responsibility' then 4 else 0 END + 
      CASE WHEN Value3  = 'Responsibility' then 3 else 0 END + 
      CASE WHEN Value4 = 'Responsibility' then 2 else 0 END + 
      CASE WHEN Value5  = 'Responsibility' then 1 else 0 END)
      as [Responsibility_Count],

SUM(CASE WHEN Value1  = 'Results oriented' then 5 else 0 END + 
      CASE WHEN Value2  = 'Results oriented' then 4 else 0 END + 
      CASE WHEN Value3  = 'Results oriented' then 3 else 0 END + 
      CASE WHEN Value4 = 'Results oriented' then 2 else 0 END + 
      CASE WHEN Value5  = 'Results oriented' then 1 else 0 END)
      as [Results_oriented_Count],

SUM(CASE WHEN Value1  = 'Safety' then 5 else 0 END + 
      CASE WHEN Value2  = 'Safety' then 4 else 0 END + 
      CASE WHEN Value3  = 'Safety' then 3 else 0 END + 
      CASE WHEN Value4 = 'Safety' then 2 else 0 END + 
      CASE WHEN Value5  = 'Safety' then 1 else 0 END)
      as [Safety_Count],            
             
SUM(CASE WHEN Value1  = 'Teamwork' then 5 else 0 END + 
      CASE WHEN Value2  = 'Teamwork' then 4 else 0 END + 
      CASE WHEN Value3  = 'Teamwork' then 3 else 0 END + 
      CASE WHEN Value4 = 'Teamwork' then 2 else 0 END + 
      CASE WHEN Value5  = 'Teamwork' then 1 else 0 END)
      as [Teamwork_Count], 
      
SUM(CASE WHEN Value1  = 'Trust' then 5 else 0 END + 
      CASE WHEN Value2  = 'Trust' then 4 else 0 END + 
      CASE WHEN Value3  = 'Trust' then 3 else 0 END + 
      CASE WHEN Value4 = 'Trust' then 2 else 0 END + 
      CASE WHEN Value5  = 'Trust' then 1 else 0 END)
      as [Trust_Count]              
                                               
                                                                              
  FROM [TestStuff].[dbo].[TRSurvey_Values]
  where RespondentID Is Not Null
  and Age = '55+'



UNION

SELECT 'N/A' as AgeRange, count(RespondentId) as Total,SUM(
      CASE WHEN Value1  = 'Commitment' then 5 else 0 END + 
      CASE WHEN Value2  = 'Commitment' then 4 else 0 END + 
      CASE WHEN Value3  = 'Commitment' then 3 else 0 END + 
      CASE WHEN Value4 = 'Commitment' then 2 else 0 END + 
      CASE WHEN Value5  = 'Commitment' then 1 else 0 END)
      as [Commitment_Count],
SUM(CASE WHEN Value1  = 'Customer focussed' then 5 else 0 END + 
      CASE WHEN Value2  = 'Customer focussed' then 4 else 0 END + 
      CASE WHEN Value3  = 'Customer focussed' then 3 else 0 END + 
      CASE WHEN Value4 = 'Customer focussed' then 2 else 0 END + 
      CASE WHEN Value5  = 'Customer focussed' then 1 else 0 END)
      as [Customer_focussed_Count],
      
SUM(CASE WHEN Value1  = 'Consistency' then 5 else 0 END + 
      CASE WHEN Value2  = 'Consistency' then 4 else 0 END + 
      CASE WHEN Value3  = 'Consistency' then 3 else 0 END + 
      CASE WHEN Value4 = 'Consistency' then 2 else 0 END + 
      CASE WHEN Value5  = 'Consistency' then 1 else 0 END)
      as [Consistency_Count],
      
SUM(CASE WHEN Value1  = 'Empathy' then 5 else 0 END + 
      CASE WHEN Value2  = 'Empathy' then 4 else 0 END + 
      CASE WHEN Value3  = 'Empathy' then 3 else 0 END + 
      CASE WHEN Value4 = 'Empathy' then 2 else 0 END + 
      CASE WHEN Value5  = 'Empathy' then 1 else 0 END)
      as [Empathy_Count],
      
SUM(CASE WHEN Value1  = 'Excellence' then 5 else 0 END + 
      CASE WHEN Value2  = 'Excellence' then 4 else 0 END + 
      CASE WHEN Value3  = 'Excellence' then 3 else 0 END + 
      CASE WHEN Value4 = 'Excellence' then 2 else 0 END + 
      CASE WHEN Value5  = 'Excellence' then 1 else 0 END)
      as [Excellence_Count],
      
SUM(CASE WHEN Value1  = 'Focussed' then 5 else 0 END + 
      CASE WHEN Value2  = 'Focussed' then 4 else 0 END + 
      CASE WHEN Value3  = 'Focussed' then 3 else 0 END + 
      CASE WHEN Value4 = 'Focussed' then 2 else 0 END + 
      CASE WHEN Value5  = 'Focussed' then 1 else 0 END)
      as [Focussed_Count],

SUM(CASE WHEN Value1  = 'Fun' then 5 else 0 END + 
      CASE WHEN Value2  = 'Fun' then 4 else 0 END + 
      CASE WHEN Value3  = 'Fun' then 3 else 0 END + 
      CASE WHEN Value4 = 'Fun' then 2 else 0 END + 
      CASE WHEN Value5  = 'Fun' then 1 else 0 END)
      as [Fun_Count],
     
SUM(CASE WHEN Value1  = 'Honesty' then 5 else 0 END + 
      CASE WHEN Value2  = 'Honesty' then 4 else 0 END + 
      CASE WHEN Value3  = 'Honesty' then 3 else 0 END + 
      CASE WHEN Value4 = 'Honesty' then 2 else 0 END + 
      CASE WHEN Value5  = 'Honesty' then 1 else 0 END)
      as [Honesty_Count],
   
SUM(CASE WHEN Value1  = 'Innovative' then 5 else 0 END + 
      CASE WHEN Value2  = 'Innovative' then 4 else 0 END + 
      CASE WHEN Value3  = 'Innovative' then 3 else 0 END + 
      CASE WHEN Value4 = 'Innovative' then 2 else 0 END + 
      CASE WHEN Value5  = 'Innovative' then 1 else 0 END)
      as [Innovative_Count],
        
SUM(CASE WHEN Value1  = 'Integrity' then 5 else 0 END + 
      CASE WHEN Value2  = 'Integrity' then 4 else 0 END + 
      CASE WHEN Value3  = 'Integrity' then 3 else 0 END + 
      CASE WHEN Value4 = 'Integrity' then 2 else 0 END + 
      CASE WHEN Value5  = 'Integrity' then 1 else 0 END)
      as [Integrity_Count],
      
SUM(CASE WHEN Value1  = 'Openness' then 5 else 0 END + 
      CASE WHEN Value2  = 'Openness' then 4 else 0 END + 
      CASE WHEN Value3  = 'Openness' then 3 else 0 END + 
      CASE WHEN Value4 = 'Openness' then 2 else 0 END + 
      CASE WHEN Value5  = 'Openness' then 1 else 0 END)
      as [Openness_Count],

SUM(CASE WHEN Value1  = 'Optimism' then 5 else 0 END + 
      CASE WHEN Value2  = 'Optimism' then 4 else 0 END + 
      CASE WHEN Value3  = 'Optimism' then 3 else 0 END + 
      CASE WHEN Value4 = 'Optimism' then 2 else 0 END + 
      CASE WHEN Value5  = 'Optimism' then 1 else 0 END)
      as [Optimism_Count],

SUM(CASE WHEN Value1  = 'Organised' then 5 else 0 END + 
      CASE WHEN Value2  = 'Organised' then 4 else 0 END + 
      CASE WHEN Value3  = 'Organised' then 3 else 0 END + 
      CASE WHEN Value4 = 'Organised' then 2 else 0 END + 
      CASE WHEN Value5  = 'Organised' then 1 else 0 END)
      as [Organised_Count],

SUM(CASE WHEN Value1  = 'Professional' then 5 else 0 END + 
      CASE WHEN Value2  = 'Professional' then 4 else 0 END + 
      CASE WHEN Value3  = 'Professional' then 3 else 0 END + 
      CASE WHEN Value4 = 'Professional' then 2 else 0 END + 
      CASE WHEN Value5  = 'Professional' then 1 else 0 END)
      as [Professional_Count],

SUM(CASE WHEN Value1  = 'Reliability' then 5 else 0 END + 
      CASE WHEN Value2  = 'Reliability' then 4 else 0 END + 
      CASE WHEN Value3  = 'Reliability' then 3 else 0 END + 
      CASE WHEN Value4 = 'Reliability' then 2 else 0 END + 
      CASE WHEN Value5  = 'Reliability' then 1 else 0 END)
      as [Reliability_Count],
                                   
SUM(CASE WHEN Value1  = 'Respect' then 5 else 0 END + 
      CASE WHEN Value2  = 'Respect' then 4 else 0 END + 
      CASE WHEN Value3  = 'Respect' then 3 else 0 END + 
      CASE WHEN Value4 = 'Respect' then 2 else 0 END + 
      CASE WHEN Value5  = 'Respect' then 1 else 0 END)
      as [Respect_Count],

SUM(CASE WHEN Value1  = 'Responsibility' then 5 else 0 END + 
      CASE WHEN Value2  = 'Responsibility' then 4 else 0 END + 
      CASE WHEN Value3  = 'Responsibility' then 3 else 0 END + 
      CASE WHEN Value4 = 'Responsibility' then 2 else 0 END + 
      CASE WHEN Value5  = 'Responsibility' then 1 else 0 END)
      as [Responsibility_Count],

SUM(CASE WHEN Value1  = 'Results oriented' then 5 else 0 END + 
      CASE WHEN Value2  = 'Results oriented' then 4 else 0 END + 
      CASE WHEN Value3  = 'Results oriented' then 3 else 0 END + 
      CASE WHEN Value4 = 'Results oriented' then 2 else 0 END + 
      CASE WHEN Value5  = 'Results oriented' then 1 else 0 END)
      as [Results_oriented_Count],

SUM(CASE WHEN Value1  = 'Safety' then 5 else 0 END + 
      CASE WHEN Value2  = 'Safety' then 4 else 0 END + 
      CASE WHEN Value3  = 'Safety' then 3 else 0 END + 
      CASE WHEN Value4 = 'Safety' then 2 else 0 END + 
      CASE WHEN Value5  = 'Safety' then 1 else 0 END)
      as [Safety_Count],            
             
SUM(CASE WHEN Value1  = 'Teamwork' then 5 else 0 END + 
      CASE WHEN Value2  = 'Teamwork' then 4 else 0 END + 
      CASE WHEN Value3  = 'Teamwork' then 3 else 0 END + 
      CASE WHEN Value4 = 'Teamwork' then 2 else 0 END + 
      CASE WHEN Value5  = 'Teamwork' then 1 else 0 END)
      as [Teamwork_Count], 
      
SUM(CASE WHEN Value1  = 'Trust' then 5 else 0 END + 
      CASE WHEN Value2  = 'Trust' then 4 else 0 END + 
      CASE WHEN Value3  = 'Trust' then 3 else 0 END + 
      CASE WHEN Value4 = 'Trust' then 2 else 0 END + 
      CASE WHEN Value5  = 'Trust' then 1 else 0 END)
      as [Trust_Count]              
                                               
                                                                              
  FROM [TestStuff].[dbo].[TRSurvey_Values]
  where RespondentID Is Not Null
  and Age is Null












