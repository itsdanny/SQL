SELECT quem.warehouse
	  ,quem.product
	  ,stockm.long_description
	  ,SUM(quem.quantity) AS Qty
	  ,stockm.selling_unit
	  ,quem.batch_number
	,MIN(quem.lot_number) AS lot_number
	  --,quem.source_code
	  ,quem.date_received
	  ,stockm.safety_days - isnull(stockm.dspare03,0) as safety_days
	  ,(SELECT Date
		FROM(SELECT ROW_NUMBER() OVER (ORDER BY [Date] ASC) AS SrNo, [Date]
			 FROM [syslive].[dbo].[MRPCalendar] with(NOLOCK)
			 WHERE Date > (SELECT TOP 1 [date_received]
							FROM [syslive].[scheme].[stquem] AS sub_quem WITH (NOLOCK)
							WHERE sub_quem.product = quem.product AND sub_quem.batch_number = quem.batch_number
							ORDER BY sub_quem.date_received) AND MRPValue != 'N') AS MRPCal
		WHERE SrNo = (stockm.safety_days -  isnull(stockm.dspare03,0))
      ) AS Revised_available_date
	  ,MAX(LOWER(queam.stock_held_flag)) AS stock_held_flag
	  ,MAX(LOWER(queam.held_reason_code)) AS held_reason_code
FROM scheme.stquem AS quem WITH (NOLOCK) INNER JOIN scheme.stqueam AS queam WITH (NOLOCK) ON
	quem.warehouse = queam.warehouse AND 
	quem.product = queam.product AND 
	quem.sequence_number = queam.sequence_number
	INNER JOIN scheme.stockm WITH (NOLOCK) ON
	quem.warehouse = scheme.stockm.warehouse AND 
	quem.product = scheme.stockm.product
  WHERE quem.warehouse = 'FG' AND stockm.analysis_a = 'TPTY' AND LOWER(quem.passed_inspection) != 'y' AND quem.quantity > 0
  GROUP BY quem.warehouse
		,quem.product
		,stockm.long_description
		,stockm.selling_unit
		,quem.batch_number
		--,quem.source_code
	    ,quem.date_received
	    ,stockm.safety_days
		,stockm.dspare03
		--,scheme.stquem.lot_number
		,quem.lot_number
		,quem.passed_inspection
		--,queam.held_reason_code
  ORDER BY Revised_available_date, product, lot_number