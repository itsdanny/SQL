/* SSMSBoost
Event: DocumentExecuted
Event date: 2015-08-23 21:25:38
Connection: trsagev3d1.master (WinAuth)
*/

USE [master]
go
ALTER DATABASE	sysliveJune2017 SET SINGLE_USER WITH ROLLBACK AFTER 1 -- AFTER 1, WAITS 1 SECOND TO ALLOW QUERIES TO COMMIT ETC
GO

RESTORE DATABASE sysliveJune2017 FROM  DISK = N'r:\periodend_syslive.bak' WITH  FILE = 1,  
MOVE N'syslive' TO N'r:\JUNESYSLIVE\Data\sysliveJune2017.mdf',  
MOVE N'syslivelog' TO N'r:\JUNESYSLIVE\Logs\sysliveJune2017_log.ldf',  NOUNLOAD,  REPLACE,  STATS = 5

GO

ALTER DATABASE	sysliveJune2017 SET MULTI_USER
GO

