-- THIS SCRIPT SEARCHES A DATABASE FOR A COLUMN NAME

DECLARE @COL VARCHAR(50) = 'ANA_CODE'

SELECT t.name AS table_name,
SCHEMA_NAME(schema_id) AS schema_name,
c.name AS column_name
FROM sys.tables AS t
INNER JOIN sys.columns c ON t.OBJECT_ID = c.OBJECT_ID
WHERE UPPER(c.name) LIKE UPPER('%'+@COL+'%')
ORDER BY schema_name, table_name;

--select * from TR WHERE EMPREF = 2403
