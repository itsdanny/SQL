DECLARE @cols NVARCHAR(2000) 
DECLARE @query NVARCHAR(4000) 

SELECT  @cols = STUFF(( SELECT DISTINCT TOP 100 PERCENT 
                                '],[' + t.PERIOD 
                        FROM    RawDataFile AS t 
						WHERE convert(datetime, PERIOD + '01', 101) >= DATEADD(month, -24, GETDATE()) AND "BNF CODE" like '130201%' 
                        --ORDER BY ' , ' + t.PERIOD
                        FOR XML PATH('') 
                      ), 1, 2, '') + ']' 

-- now we have the values as columns...

SET @query = N'SELECT * FROM (SELECT PRACTICE, PERIOD, [BNF NAME], SUM(CAST(ITEMS AS FLOAT)) as ITEMS FROM 
				GPData.dbo.RawDataFile 
				WHERE CONVERT(DATETIME, PERIOD  + ''01'', 101) >= DATEADD(month, -24, GETDATE()) AND[BNF CODE]  like ''130201%''
				GROUP BY PERIOD, PRACTICE, [BNF NAME]) 			
	x PIVOT (
				SUM(ITEMS) FOR PERIOD IN ('+ @cols +') 
				) p
				GROUP BY PRACTICE, [BNF NAME],' + @cols

EXECUTE(@query)


