DECLARE @cols NVARCHAR(MAX) 
DECLARE @query NVARCHAR(MAX) 

--SELECT  @cols = STUFF(( SELECT DISTINCT TOP 100 PERCENT 
--                                '],[' + t.PERIOD 
--                        FROM    RawDataFile AS t 
--						WHERE convert(datetime, PERIOD + '01', 101) >= DATEADD(month, -15, GETDATE()) AND "BNF CODE" like '130201%' 
--                        --ORDER BY ' , ' + t.PERIOD
--                        FOR XML PATH('') 
--                      ), 1, 2, '') + ']' 
SELECT  @cols = STUFF(( SELECT DISTINCT TOP 100 PERCENT 
                                '],[' + REPLACE(BNF_NAME, '''','') FROM PracticeData pd inner join BNFProducts bp on pd.BNF_CODE = bp.BNF_CODE
                        --ORDER BY ' , ' + t.PERIOD
                        FOR XML PATH('') 
                      ), 1, 2, '') + ']' 
--SELECT DISTINCT BNF_NAME FROM PracticeData pd inner join BNFProducts bp on pd.BNF_CODE = bp.BNF_CODE
-- now we have the values as columns...
--select @cols

SET @query = N'SELECT * FROM (SELECT PRACTICE, BNF_NAME, COALESCE(SUM(CAST(ITEMS AS FLOAT)),0) as ITEMS 
				FROM		PracticeData 
				WHERE		CONVERT(DATETIME, PERIOD  + ''01'', 101) >= DATEADD(month, -15, GETDATE())
				GROUP BY	PRACTICE, BNF_NAME) 			
	x PIVOT (
				SUM(ITEMS) FOR  BNF_NAME IN ('+ @cols +') 
				) p
				GROUP BY PRACTICE, ' + @cols

EXECUTE(@query)
