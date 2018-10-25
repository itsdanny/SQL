USE SLAM
SELECT	*
FROM		VapeConnect.dbo.IMPDailySalesInformation
WHERE		TransactionDate = '2017-11-27'
AND			BranchCode = 'K2'

SELECT		*
FROM		demo.scheme.opheadm h WITH(NOLOCK)
INNER JOIN 	demo.scheme.opdetm d WITH(NOLOCK)
ON			h.order_no = d.order_no
WHERE		h.customer = '1K2'
AND			h.date_entered = '2017-11-27'
ORDER BY	1
--SB018397
--CNA00535D 
SELECT		*
FROM		slam.scheme.opheadm h WITH(NOLOCK)
INNER JOIN 	slam.scheme.opdetm d WITH(NOLOCK)
ON			h.order_no = d.order_no
WHERE		h.order_no = 'CNA00536'
ORDER BY	order_line_no

DECLARE @res  TABLE(Id INT IDENTITY(1,1), SageRef varchar(10), ProductCode VARCHAR(20), Quantity VARCHAR(4), CreditQty FLOAT, defDate VARCHAR(8))
INSERT INTO @res
SELECT	DISTINCT	LTRIM(RTRIM(h.customer)), LTRIM(RTRIM(d.product)) AS prod,  SUM(d.despatched_qty*-1) AS Qty, 
			SUM(CASE list_price WHEN 0 THEN val ELSE net_price END) AS SumCreditAmount, 
			MAX(CASE list_price WHEN 0 THEN val ELSE net_price END) AS CreditAmount, 
			'27/11/17' CreditNoteDate
FROM		slam.scheme.opheadm h
INNER JOIN 	slam.scheme.opdetm d
ON			h.order_no = d.order_no
WHERE		h.order_no  IN ('SB018397')
AND			d.despatched_qty > 0
AND			order_line_no > 29
GROUP BY 	LTRIM(RTRIM(h.customer)), LTRIM(RTRIM(d.product))

DECLARE @NextCNNumber INT = (SELECT		TOP 1 LEFT (RIGHT(LTRIM(RTRIM(order_no)),4),3)+1
FROM		slam.scheme.opheadm h WITH(NOLOCK)
WHERE		h.order_no LIKE 'CNA%'
AND			customer LIKE '1%'
AND			ISNUMERIC(LEFT(RIGHT(LTRIM(RTRIM(order_no)),4),3)) = 1
ORDER BY	1 desc)
print @NextCNNumber
-- 03 HEADER LINE
DECLARE @DataHeader TABLE (Id INT IDENTITY(1,1), DATASTRING VARCHAR(MAX))
INSERT INTO @DataHeader
SELECT '00|SRNXY|SOCREATE|Credit Notes|'
DECLARE @Row INT = 1, @Rows INT

SET @Rows = (SELECT COUNT(1) FROM @res)
INSERT INTO @DataHeader
		SELECT		'03|0|=CNA'+REPLACE(STR(@NextCNNumber, 5), SPACE(1), '0')+'D|3|'+SageRef+'|12|'+defDate+'|13|'+defDate+'|14|'+defDate+'|15|'+defDate+'|16|'+defDate+'|24|4|25|N|26|N|32|0|34|0|35|0|36|0|37|0|38|0|39|0|41|N|45|'+CAST(@Rows AS varchar(4))+'|46|N|85|0|86|0|87|0|'			
		FROM		@res
		WHERE		Id = @Row
WHILE @Row <= @Rows
BEGIN			
		INSERT INTO @DataHeader
		SELECT '04|0|=CNA'+REPLACE(STR(@NextCNNumber, 5), SPACE(1), '0')+'D|2|'  + REPLACE(STR(CAST(@Row AS VARCHAR(5)), 4), SPACE(1), ' ')+'|3|'+ProductCode+'|4|'+
			CASE WHEN ProductCode LIKE	'GEN%' THEN 'S|5|' else 'P|5|SL' END +'|9||20|'+Quantity+'|21|'+Quantity+'|22|'+Quantity+'|24|' + CAST(CreditQty AS VARCHAR(10)) + '|25|0|30|N|'
		FROM	@res
		WHERE	Id = @Row
				
		SET @Row = @Row + 1
END

-- CREDIT NOT FILE
SELECT DATASTRING FROM @DataHeader

-- STOCK ADJ FILE
SELECT		'00|SR1|000000|Stock Adj|'
UNION ALL
SELECT		'24|1|SL|2|'+LTRIM(RTRIM(d.product))+'|3|'+CAST(SUM(d.order_qty) AS VARCHAR(4))+'|4|27/11/17|6||8|BACK ORDERS|9|'+RIGHT(LTRIM(RTRIM(h.customer)),2)+'|16||21||'
FROM		slam.scheme.opheadm h
INNER JOIN 	slam.scheme.opdetm d
ON			h.order_no = d.order_no
WHERE		h.order_no  IN ('SB018435')
AND			d.order_line_no > 40
AND			d.product NOT LIKE 'GENDIS%'
GROUP BY	LTRIM(RTRIM(d.product)), RIGHT(LTRIM(RTRIM(h.customer)),2)
