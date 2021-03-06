SELECT		CONVERT(datetime, Col2,103)
FROM		service.ServiceData WHERE		Col1 = 'C1'
GROUP BY	Col2, Col2, SentDateTime
RETURN


DECLARE @dts TABLE(TransDate datetime)
DECLARE @Row INT = 0, @Rows INT
DECLARE @StartDate DATETIME = '01-02-2017'
DECLARE @FromDate DATETIME = '01-02-2017'
SET @Rows = 270
WHILE @Row <= @Rows
BEGIN
	IF	DATEPART(DW, @FromDate + @Row) <> 1
	BEGIN
		INSERT INTO @dts select @FromDate + @Row	
	END
SET @Row = @Row + 1
END


SELECT		D.TransDate, s.col2 AS ENDates
FROM		@dts d
LEFT JOIN 	service.ServiceData s
ON			d.TransDate = CONVERT(datetime, s.Col2,103)
AND			Col1 = 'C1'
GROUP BY	D.TransDate, s.col2

SELECT	DATEPART(DW,GETDATE())