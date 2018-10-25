SELECT  b.position,*
FROM	msdb.dbo.backupset b 
JOIN msdb.dbo.backupmediafamily m ON b.media_set_id = m.media_set_id
WHERE	database_name = 'Insight'
order by b.position  desc
DECLARE @Position INT
SELECT  @Position = MAX(position)
FROM	msdb.dbo.backupset b 
JOIN msdb.dbo.backupmediafamily m ON b.media_set_id = m.media_set_id
WHERE	database_name = 'Insight'

DECLARE @DatabaseName nvarchar(50)
--Set the Database Name
SET @DatabaseName = N'InsightTest'
DECLARE @SQL varchar(max)
SET @SQL = ''

SELECT @SQL = @SQL + 'Kill ' + Convert(varchar, SPId) + ';'
FROM master.sys.SysProcesses
WHERE DBId = DB_ID(@DatabaseName) AND SPId <> @@SPId

--You can see the kill Processes ID

SELECT @SQL

--Kill the Processes

EXEC(@SQL)

RESTORE DATABASE [InsightTest] FROM  DISK = N'E:\MSSQL\Backup\Insight\Insight.bak' WITH  FILE = 63,  NOUNLOAD,  REPLACE,  STATS = 10
GO
