USE TRServReportServer
GO
SELECT		*
 FROM [dbo].[Catalog] c
INNER JOIN	ExecutionLog e
ON			c.ItemID = e.ReportID
WHERE		path NOT LIKE '%insight%'
order by

SELECT		[Path], Name, 
			count(1) FROM [dbo].[Catalog] c
INNER JOIN	ExecutionLog e
ON			c.ItemID = e.ReportID
WHERE		path NOT LIKE '%insight%'
GROUP BY [Path], Name
ORDER BY COUNT(1) DESC
