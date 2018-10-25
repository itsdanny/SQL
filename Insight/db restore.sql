-- RESTORE INSIGHT
USE Insight
go
DECLARE @DoBackUp bit = 1
IF @DoBackUp = 1 -- else it will use last nights back up
BEGIN

	BACKUP DATABASE Insight
	TO DISK = 'M:\Daily\Insight\Insight.bak' WITH NOFORMAT, MEDIANAME = 'Insight', NAME = 'Full Backup of Insight', COMPRESSION, INIT;
END
GO

--BACKUP DATABASE InsightTest TO DISK = N'M:\Daily\Insignht\InsightTest_diff.bak' WITH  DIFFERENTIAL, INIT,  NAME = N'InsightTest-Diff Backup', COMPRESSION,  STATS = 10
--PRINT GETDATE()

	--RESTORE HEADERONLY FROM DISK='M:\Daily\Insight\Insight.bak'
/*
USE [master](0121)

ALTER DATABASE	 [InsightTest] SET OFFLINE  WITH ROLLBACK IMMEDIATE
ALTER DATABASE	 [InsightTest] SET ONLINE  WITH ROLLBACK IMMEDIATE
*/
GO

ALTER DATABASE	[InsightTest] SET SINGLE_USER WITH ROLLBACK AFTER 1 -- AFTER 1, WAITS 1 SECOND TO ALLOW QUERIES TO COMMIT ETC
GO
RESTORE DATABASE	[InsightTest]
					FROM  DISK = N'M:\Daily\Insight\Insight.bak'
					WITH FILE = 1,
					MOVE N'Insight' TO N'E:\MSSQL\Data\InsightTest.mdf',
					MOVE N'Insight_log' TO N'F:\MSSQL\Data\InsightTest_log.ldf',
					NOUNLOAD, 
					STATS = 5, REPLACE, RECOVERY --force restore over specified database 

ALTER DATABASE	[InsightTest] SET MULTI_USER
GO
--PRINT GETdate()

USE Insight
GO
