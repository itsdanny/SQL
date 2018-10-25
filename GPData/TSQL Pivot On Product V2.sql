DECLARE @cols NVARCHAR(MAX) 
DECLARE @query NVARCHAR(MAX) 

SELECT  @cols = STUFF(( SELECT DISTINCT TOP 100 PERCENT 
                                '],[' + REPLACE(BNF_NAME, '''','') FROM PracticeData pd inner join BNFProducts bp on pd.BNF_CODE = bp.BNF_CODE
                        --ORDER BY ' , ' + t.PERIOD
                        FOR XML PATH('') 
                      ), 1, 2, '') + ']' 

-- now we have the values as columns...


SET @query = N'SELECT  * FROM (SELECT COALESCE(max(tb.Territory), '''') as Territory, COALESCE(c.Name, '''') AS CCG, PRACTICE, p.Name As PracticeName, p.Address1, p.Address2, p.Address3, PostCode, BNF_NAME, 
				CASE WHEN tp.Code IS NULL THEN ''No Match'' ELSE ''Target'' END AS Tarted, COALESCE(SUM(CAST(NIC AS FLOAT)), 0) as NIC 
FROM        dbo.PracticeData pd WITH(NOLOCK)
INNER JOIN  dbo.Practice p WITH(NOLOCK)
ON			pd.PRACTICE = p.Code
LEFT JOIN	TargetPractices tp WITH(NOLOCK)
ON			p.Code = tp.Code
LEFT JOIN	dbo.CCGLookup c WITH(NOLOCK)
ON			p.CCGCode = c.Code
INNER JOIN	dbo.TerritoryBrick tb WITH(NOLOCK)
ON			LEFT(p.PostCode, LEN(tb.Brick)) = tb.Brick		
--WHERE       pd.PERIODDATE >= DATEADD(month, -16, GETDATE())
WHERE       pd.PERIODDATE between DATEADD(month, -28, GETDATE()) and DATEADD(month, -15, GETDATE())
GROUP BY     PRACTICE, p.Address1, p.Address2, p.Address3, PostCode, BNF_NAME, tp.Code, c.Name,p.Name)                 
       x PIVOT (
                SUM(NIC) FOR BNF_NAME IN ('+ @cols +') 
                ) p
                GROUP BY PRACTICE, Address1, Address2, Address3, PostCode, Tarted,CCG,Territory,PracticeName,' + @cols +'
				ORDER BY Territory, CCG, PRACTICE
				
				'
                                                                                                   --print @query



EXECUTE(@query)

