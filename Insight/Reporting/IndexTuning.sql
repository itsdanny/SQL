USE Insight --Enter the name of the database you want to reindex 
GO

SELECT a.index_id, name, avg_fragmentation_in_percent
FROM   sys.dm_db_index_physical_stats (DB_ID(N'Insight'), null, NULL, NULL, 'DETAILED') AS a
    JOIN sys.indexes AS b ON a.object_id = b.object_id AND a.index_id = b.index_id; 
GO

DECLARE @SQL AS VARCHAR(100)
SET @SQL= 'ALTER INDEX ALL ON ? REBUILD WITH (FILLFACTOR = 80, SORT_IN_TEMPDB = ON)'
EXEC sp_msforeachtable @command1=@SQL
GO

SELECT a.index_id, name, avg_fragmentation_in_percent
FROM   sys.dm_db_index_physical_stats (DB_ID(N'Insight'), null, NULL, NULL, 'DETAILED') AS a
    JOIN sys.indexes AS b ON a.object_id = b.object_id AND a.index_id = b.index_id; 
GO
