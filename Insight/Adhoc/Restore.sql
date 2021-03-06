DECLARE @Position INT
SELECT @Position = MAX(position)
from	msdb.dbo.backupset b join msdb.dbo.backupmediafamily m ON b.media_set_id = m.media_set_id
where database_name = 'Insight'

RESTORE DATABASE [InsightTest] FROM  DISK = N'E:\MSSQL\Backup\Insight.bak' WITH  FILE = @Position,  NOUNLOAD,  REPLACE,  STATS = 10
GO