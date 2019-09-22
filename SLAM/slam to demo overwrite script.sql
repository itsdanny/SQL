PRINT GETDATE()
PRINT 'DO THE BACK UP '
USE [master]
BACKUP DATABASE [slam] TO  DISK = N'C:\MSSQL\Backup\slam\slam.bak' WITH NOFORMAT, INIT,  NAME = N'slam-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

USE [master]
PRINT GETDATE()
PRINT 'DO THE RESTORE'
ALTER DATABASE	[demo] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
RESTORE DATABASE [demo] FROM  DISK = N'C:\MSSQL\Backup\demo\slam_to_demo.bak' WITH  FILE = 1,  
									 MOVE N'slam' TO N'C:\MSSQL\Data\demo.mdf',  
									 MOVE N'slamlog' TO N'C:\MSSQL\Logs\demolog.ldf',  NOUNLOAD,  REPLACE,  STATS = 5
ALTER DATABASE [demo] SET MULTI_USER
GO

PRINT 'RENAME THE LOGICAL FILE NAMES'
USE [master]
ALTER DATABASE demo MODIFY FILE (NAME=N'slam', NEWNAME=N'demo')
GO
ALTER DATABASE demo MODIFY FILE (NAME=N'slamlog', NEWNAME=N'demolog')
GO
--	select * from  demo.scheme.sysdirm where system_key like 'FS%'
--	SELECT * FROM  demo.scheme.fscontq1m 
-- Sort the DEFACTO Licensing


PRINT GETDATE()
SELECT	*
FROM		scheme.sysdirm where  system_key like 'DEF_%'
--
PRINT 'SET	THE KEYS'
USE demo
UPDATE demo.scheme.sysdirm SET key_value = '11/04/20'  WHERE system_key = 'DEF_EXPIRY' -- 
UPDATE demo.scheme.sysdirm SET key_value = 'UQMTegJiVkUI'  WHERE system_key = 'DEF_PASSWD' -- 
UPDATE demo.scheme.sysdirm SET key_value = '000001' WHERE system_key = 'DEF_SITENO'
UPDATE demo.scheme.sysdirm SET key_value = 'c:\csserver\demo\DEF\fail\' WHERE system_key = 'FSFAILDIR'
UPDATE demo.scheme.sysdirm SET key_value = 'c:\csserver\demo\DEF\move\' WHERE system_key = 'FSMOVEDIR'
UPDATE demo.scheme.fscontq1m SET	fs_filename = 'c:\csserver\demo\DEF\in', fs_status ='X' WHERE		fs_id ='0000'
PRINT GETDATE()
