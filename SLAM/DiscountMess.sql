/****** Script for SelectTopNRows command from SSMS  ******/
	-- 


--SELECT SageRef, MIN(TransactionDate), MAX(TransactionDate) FROM [TRConnect].[dbo].[EndOfDays] group by SageRef
-- WHERE		SageRef ='N1'  order by TransactionDate


DECLARE @OldDiscounts TABLE(Id INT IDENTITY(1,1), TranDate DATETIME, Branch varchar(10), OldDiscount FLOAT, ServiceId INT, defDate VARCHAR(8))
INSERT INTO @OldDiscounts 
SELECT	DISTINCT	CONVERT(datetime,SUBSTRING(Col2,7,4)+SUBSTRING(Col2,4,2) +LEFT(Col2,2)) TranDate, Col1 AS Branch, Col3 AS Discount, ServiceId, LEFT(Col2,2) +'/'+SUBSTRING(Col2,4,2)+'/'+SUBSTRING(Col2,9,2)
FROM	service.ServiceData WHERE	ServiceId in (24)


SELECT		o.ServiceId,
			e.BranchName, 
			e.SageRef, 
			e.TransactionDate, 
			e.DiscountValue, o.OldDiscount, 
			ROUND((e.DiscountValue - o.OldDiscount), 2) AS DiscountDiff			
FROM		[TRConnect].[dbo].[EndOfDays] e
INNER JOIN 	@OldDiscounts o
ON			o.Branch = e.SageRef
AND			o.TranDate  = e.TransactionDate
WHERE		(e.DiscountValue - o.OldDiscount) <> 0
AND			e.DiscountValue < 0
AND			e.TransactionDate = '2017-01-23 00:00:00.000'
ORDER		BY TransactionDate
return
DECLARE @StartCN INT = 502

DECLARE @res  TABLE(Id INT IDENTITY(1,1), SageRef varchar(10), TranDate DATETIME,  DiscountAdjustment FLOAT, defDate VARCHAR(8))
INSERT INTO @res
SELECT		e.SageRef, 
			e.TransactionDate, 			
			ROUND((e.DiscountValue - o.OldDiscount), 2) AS DiscountDiff, defDate			
FROM		[TRConnect].[dbo].[EndOfDays] e
INNER JOIN 	@OldDiscounts o
ON			o.Branch = e.SageRef
AND			o.TranDate  = e.TransactionDate
WHERE		(e.DiscountValue - o.OldDiscount) <> 0
AND			(e.TransactionDate = '2017-01-23 00:00:00.000')
--AND			(e.TransactionDate between '2017-01-11 00:00:00.000' AND	'2017-01-22 00:00:00.000' OR	e.TransactionDate = '2017-01-25 00:00:00.000')
ORDER		BY TransactionDate

-- 03 HEADER LINE
DECLARE @DataHeader TABLE (Id INT IDENTITY(1,1), DATASTRING VARCHAR(MAX))
INSERT INTO @DataHeader
SELECT '00|SRNXY|SOCREATE|Credit Notes|'
DECLARE @Row INT = 1, @Rows INT

SET @Rows = (SELECT COUNT(1) FROM @res)

WHILE @Row <= @Rows
BEGIN	
		INSERT INTO @DataHeader
		SELECT		'03|0|=CNA000'+REPLACE(STR(@StartCN, 3), SPACE(1), '0')+'|3|1'+SageRef+'|12|'+defDate+'|13|'+defDate+'|14|'+defDate+'|15|'+defDate+'|16|'+defDate+'|24|4|25|N|26|N|32|0|34|0|35|0|36|0|37|0|38|0|39|0|41|N|45|1|46|N|85|0|86|0|87|0|'			
		FROM		@res
		WHERE		Id = @Row
		
		INSERT INTO @DataHeader
		SELECT '04|0|=CNA000'+REPLACE(STR(@StartCN, 3), SPACE(1), '0')+'|2|   1|3|GENDISCODE|4|S|5||9||20|-1|21|-1|22|-1|24|' + CAST(DiscountAdjustment AS VARCHAR(10)) + '|25|0|30|N|'
		FROM	@res
		WHERE	Id = @Row

		SET	@StartCN = @StartCN+1
		SET @Row = @Row + 1
END


SELECT DATASTRING FROM @DataHeader


