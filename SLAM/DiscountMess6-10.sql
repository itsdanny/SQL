
DECLARE @StartCN INT = 114

DECLARE @res  TABLE(Id INT IDENTITY(1,1), SageRef varchar(10), DiscountAdjustment FLOAT, defDate VARCHAR(8))
INSERT INTO @res
SELECT SageRef, Value, datecol FROM CNA WHERE	datecol <> '06/01/17'

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