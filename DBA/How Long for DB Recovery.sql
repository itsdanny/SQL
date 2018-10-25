-- This shows the status of the DB
use Insight
--	
SELECT database_id, name, user_access_desc, is_read_only, state_desc, recovery_model_desc FROM sys.databases where name in ('syslive')

-- This runs (very quick) to tell you approx how long the recovery will take
DECLARE @DBName VARCHAR(64) = 'syslive'
DECLARE @ErrorLog AS TABLE([LogDate] datetime, [ProcessInfo] VARCHAR(64), [Text] VARCHAR(MAX)) 
INSERT INTO @ErrorLog
EXEC sys.xp_readerrorlog 0, 1, null, 'syslive',NULL, NULL, 'DESC'
 select * from @ErrorLog where ProcessInfo <> 'Logon' and Text like '%syslive%'

SELECT		[LogDate], SUBSTRING([Text], CHARINDEX(') is ', [Text]) + 4,CHARINDEX(' complete (', [Text]) - CHARINDEX(') is ', [Text]) - 4) AS PercentComplete
			,round(CAST(SUBSTRING([Text], CHARINDEX('approximately', [Text]) + 13,CHARINDEX(' seconds remain', [Text]) - CHARINDEX('approximately', [Text]) - 13) AS FLOAT)/60.0, 2) AS MinutesRemaining
			,CAST(SUBSTRING([Text], CHARINDEX('approximately', [Text]) + 13,CHARINDEX(' seconds remain', [Text]) - CHARINDEX('approximately', [Text]) - 13) AS FLOAT)/60.0/60.0 AS HoursRemaining
			,[Text]
FROM		@ErrorLog 
--WHERE		LogDate > '2015-08-20'


GO

-- OR JUST GIVE ME EVERYTHING DESC....

--	EXEC sys.xp_readerrorlog 0, 1, NULL, NULL, NULL, NULL, 'DESC'

EXEC sys.xp_readerrorlog 0, 1, null, 'syslive',NULL, NULL, 'DESC'

RESTORE DATABASE syslive WITH RECOVERY

select * from syslive.scheme.stockm
USE master
ALTER DATABASE syslive SET OFFLINE WITH ROLLBACK IMMEDIATE

ALTER DATABASE syslive SET ONLINE

RESTORE DATABASE syslive WITH RECOVERY


ALTER DATABASE syslive SET OFFLINE WITH
ROLLBACK IMMEDIATE
GO
