/* SSMSBoost
Event: DocumentExecuted
Event date: 2015-08-23 21:25:38
Connection: trsagev3d1.master (WinAuth)
*/
RESTORE headeronly FROM  DISK = N'M:\VCDB.bak' WITH  FILE = 1,  

USE [master]

ALTER DATABASE	[archivesyslive] SET SINGLE_USER WITH ROLLBACK AFTER 1 -- AFTER 1, WAITS 1 SECOND TO ALLOW QUERIES TO COMMIT ETC
GO

RESTORE DATABASE [archivesyslive] FROM  DISK = N'M:\Oldsyslive\PeriodEndSyslive.bak' WITH  FILE = 1,  
MOVE N'syslive' TO N'M:\Oldsyslive\archivesyslive.mdf',  
MOVE N'syslivelog' TO N'M:\Oldsyslive\archivesyslive_log.ldf',  NOUNLOAD,  REPLACE,  STATS = 5

GO

ALTER DATABASE	[archivesyslive] SET MULTI_USER
go