
select 
PRACTICE,BNF_CODE,PERIOD
  FROM PracticeData with(NOLOCK)
  --where PRACTICE not like 'S000%'
  Group by PRACTICE,BNF_CODE,PERIOD
    having COUNT(Id) > 1
  