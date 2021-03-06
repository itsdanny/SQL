USE [master]

PRINT '1) BACK UP LIVE'

DECLARE @DT_TM VARCHAR(30) = CAST(DATEPART(YEAR, GETDATE()) AS varchar)+CAST(DATEPART(MONTH, GETDATE()) AS varchar)+CAST(DATEPART(DAY, GETDATE()) AS varchar)+'_'+CAST(DATEPART(HH, GETDATE()) AS varchar)+CAST(DATEPART(MINUTE, GETDATE()) AS varchar)+CAST(DATEPART(SS, GETDATE()) AS varchar)
DECLARE @SLAMFILE VARCHAR(100) = 'C:\MSSQL\Backup\slam\slam_' + @DT_TM + '.bak' 

-- DO THE BACK UP
BACKUP DATABASE [slam] TO  DISK = @SLAMFILE WITH NOFORMAT, INIT,  NAME = N'slam-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10

DECLARE @DEMOFILE VARCHAR(100) = 'C:\MSSQL\Backup\demo\demo_' + @DT_TM + '.bak' 
--BACKUP DATABASE demo TO  DISK = @DEMOFILE WITH NOFORMAT, INIT,  NAME = N'demo-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10


PRINT '2) RESTORE LIVE OVER DEMO'

ALTER DATABASE demo SET SINGLE_USER WITH ROLLBACK IMMEDIATE

RESTORE DATABASE demo FROM  DISK = @SLAMFILE WITH  FILE = 1,  MOVE N'demo' TO N'C:\MSSQL\Data\demo.mdf',  MOVE N'demolog' TO N'C:\MSSQL\Logs\demolog.ldf',  NOUNLOAD,  REPLACE,  STATS = 5

PRINT '3) NEED TO RENAME THE LOGICAL FILE NAMES'

ALTER DATABASE demo MODIFY FILE ( NAME = slam, NEWNAME = demo );
ALTER DATABASE demo MODIFY FILE ( NAME = slamlog, NEWNAME = demolog );


PRINT '4) UPDATE AND ORDERS OR INVOICES'
USE demo
UPDATE	scheme.poinvhm
SET		pl_company='demo'

UPDATE	scheme.poheadm
SET		pl_company='demo'

ALTER DATABASE demo SET MULTI_USER

