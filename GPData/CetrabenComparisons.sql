SELECT SUM(CAST(NIC as float(8))) as TotalBathOil
  FROM [GPData].[dbo].[ImportRawDataEnglish]
  where [BNF CODE] = '1302011L0BFAAAE' 
  
  SELECT SUM(CAST(NIC as float(8))) as TotalCream
  FROM [GPData].[dbo].[ImportRawDataEnglish]
  where [BNF CODE] in
  ('130201000AAA2A2',
'130201000BBJTCF',
'21220000233',
'21220000234',
'21220000235',
'21220000236',
'130201000AACFCF')