-- SET A DATE TO N MONTHS AGO
DECLARE @Months Integer = 18
-- THIS WORKS
DECLARE @DT AS DATETIME = CONVERT(DATETIME, (CAST(datepart(YEAR,(DATEADD(month, -@Months, getdate()))) AS varchar(4))) + '-0'+CAST(datepart(MONTH,(DATEADD(month, -@Months, getdate()))) AS varchar(2)) + '-01 00:00:00:000')
SELECT @DT

-- THIS DOES NOT
SELECT @DT = 'CONVERT(DATETIME, (CAST(datepart(YEAR,(DATEADD(month, -18, getdate()))) AS varchar(4))) + ''-''+CAST(datepart(MONTH,(DATEADD(month, -18, getdate()))) AS varchar(2)) + ''-01 00:00:00:000'')'
SELECT @DT