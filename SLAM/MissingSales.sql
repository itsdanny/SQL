DECLARE @Dates TABLE(Id INT IDENTITY(1,1), TranDate DATE)
DECLARE @NoSalesData TABLE(Id INT IDENTITY(1,1), BranchCode  VARCHAR(10), BranchName VARCHAR(60), TranDate DATE)

INSERT INTO @Dates
SELECT		DISTINCT s.TransactionDate 
FROM		[dbo].[IMPDailySalesInformation] s
WHERE		TransactionDate between '2017-03-01' AND	'2017-03-30'
ORDER BY	TransactionDate

DECLARE @Row INT = 1, @Rows INT

SET @Rows = (SELECT COUNT(1) FROM @Dates)
DECLARE @TranDate DATE
WHILE @Row <= @Rows
BEGIN

		SELECT	@TranDate = TranDate
		FROM	@Dates 
		WHERE	Id = @Row	

		PRINT @TranDate
		IF		DATEPART(WEEKDAY,@TranDate) = 1 -- SOME STORES NOT OPEN SUNDAYS
		BEGIN
			INSERT INTO @NoSalesData
		SELECT		BranchSageCode, br.BranchName, @TranDate
		FROM		[dbo].[SYSBranchData] br
		WHERE		br.BranchSageCode NOT IN (
		SELECT		DISTINCT b.BranchSageCode
		FROM		[dbo].[SYSBranchData] b
		LEFT JOIN	[dbo].[IMPDailySalesInformation] s
		ON			b.BranchSageCode = s.BranchCode
		WHERE		s.TransactionDate = @TranDate)
		AND			BranchSageCode NOT IN ('B9','S4','S6','S7','SL001','EC001','E3','H4','B7','C1','C2','C3','C5','M3','M5','W1','H7','F2','G7')
		END
		ELSE
		INSERT INTO @NoSalesData
		SELECT		BranchSageCode, br.BranchName, @TranDate
		FROM		[dbo].[SYSBranchData] br
		WHERE		br.BranchSageCode NOT IN (
		SELECT		DISTINCT b.BranchSageCode
		FROM		[dbo].[SYSBranchData] b
		LEFT JOIN	[dbo].[IMPDailySalesInformation] s
		ON			b.BranchSageCode = s.BranchCode
		WHERE		s.TransactionDate = @TranDate)
		AND			BranchSageCode NOT IN ('B9','S4','S6','S7','SL001','EC001','E3','H4')

SET @Row = @Row + 1
END

SELECT	*
FROM		@NoSalesData