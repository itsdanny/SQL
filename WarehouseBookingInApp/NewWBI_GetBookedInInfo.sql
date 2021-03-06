/****** Script for SelectTopNRows command from SSMS  ******/
SELECT COUNT(sequence_no) as labels, product, movement_reference, lot_number
  FROM [syslive].[scheme].[stkhstm]
  where warehouse = 'IG' and transaction_type = 'RECP' and lot_number like '061471%'
  group by movement_reference, lot_number, product