/*
	SW02
	100-104
*/

SELECT		*
FROM		[Integrate].[dbo].[WorkOrderCompletion]
WHERE		BatchId = 'SW02'
ORDER BY	1 desc

  update [Integrate].[dbo].[WorkOrderCompletion]
   SET	BatchId = LEFT (BatchId, 4)   WHERE		BatchId = 'SW021'
		