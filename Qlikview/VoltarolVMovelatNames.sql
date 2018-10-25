SELECT DISTINCT BNF_NAME, BNF_CODE
  FROM [GPData].[dbo].[PracticeData] with (NOLOCK)
  where lower(BNF_NAME) like '%movel%' and PERIOD = '201406'
  
  SELECT DISTINCT BNF_NAME, BNF_CODE
  FROM [GPData].[dbo].[PracticeData] with (NOLOCK)
  where lower(BNF_NAME) like '%volta%' and PERIOD = '201406'
  
  SELECT DISTINCT [BNF NAME], [BNF CODE]
  FROM [GPData].[dbo].ImportDataEnglish with (NOLOCK)
  where lower([BNF NAME]) like '%movel%' and PERIOD = '201406'
  
  SELECT DISTINCT [BNF NAME], [BNF CODE]
  FROM [GPData].[dbo].ImportDataEnglish with (NOLOCK)
  where lower([BNF NAME]) like '%volta%' and PERIOD = '201406'