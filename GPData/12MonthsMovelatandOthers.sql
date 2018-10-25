/****** Script for SelectTopNRows command from SSMS  ******/		
--	select * from TopicalProducts ('Movelat','Ibuprofen','Piroxicam','Voltarol')	
DECLARE @MAXDATE DATETIME				
SELECT @MAXDATE = MAX([PERIODDATE])		
FROM [GPData].[dbo].[PracticeData]		
Select @MAXDATE		
		
SELECT		c.Name as CCG_Name		
			,pd.[PRACTICE]		
			,p.[Name]
			,p.[Address1]
			,p.[Address2]
			,p.[Address3]
			,p.[Address4]
			,p.[PostCode]
			,tp.[BNF_Brand]
			,SUM(pd.[ITEMS]) AS Items
			,sum(pd.[NIC]) as NIC
			,CASE WHEN t.Code IS NULL THEN 'No match' ELSE 'Targeted' END AS Targeted,
			DATEADD(MONTH,-11,@MAXDATE) As FromDate, @MAXDATE as ToEndOfMonthDate
FROM		[dbo].[CCGLookup] c		
INNER JOIN	PracticeData pd		
ON			c.Code = pd.PCT		
INNER JOIN	Practice p		
ON			pd.PRACTICE = p.Code		
LEFT JOIN	TargetPractices t		
ON			p.Code = t.Code		
INNER JOIN	TopicalProducts tp		
ON			pd.[BNF_CODE] = tp.BNF_CODE				
WHERE		tp.BNF_Brand IN ('Movelat','Ibuprofen','Piroxicam','Voltarol')		
AND			[PERIODDATE] between DATEADD(MONTH,-11,@MAXDATE) and @MAXDATE				
GROUP BY  c.Name,pd.[PRACTICE],p.[Name],p.[Address1],p.[Address2],p.[Address3],p.[Address4] ,p.[PostCode], tp.[BNF_Brand], t.Code, pd.[PRACTICE]		
ORDER BY  c.Name ,p.[Name]
