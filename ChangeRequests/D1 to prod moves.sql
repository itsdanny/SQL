BACKUP DATABASE [SAPIntegration] TO  DISK = N'M:\SAPIntegration.bak' WITH NOFORMAT, INIT,  NAME = N'SAPIntegration-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

BACKUP DATABASE Insight TO  DISK = N'M:\Insight.bak' WITH NOFORMAT, INIT,  NAME = N'Insight-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

------------------


USE [master]
RESTORE DATABASE [Insight] FROM  DISK = N'M:\DBs\Insight.bak' WITH  FILE = 1,  
		MOVE N'Insight' TO N'E:\MSSQL2016\PROD\DATA\Insight.mdf',  
		MOVE N'Insight_log' TO N'F:\MSSQL2016\PROD\LOGS\Insight_log.ldf',  
		NOUNLOAD,  REPLACE,  STATS = 5

GO


USE [master]
RESTORE DATABASE [SAPIntegration] FROM  DISK = N'M:\DBs\SAPIntegration.bak' WITH  FILE = 1, 
		 MOVE N'SAPIntergration' TO N'E:\MSSQL2016\PROD\DATA\SAPIntergration.mdf',  
		 MOVE N'SAPIntergration_log' TO N'F:\MSSQL2016\PROD\LOGS\SAPIntergration_log.ldf',  
		 NOUNLOAD,  REPLACE,  STATS = 5

GO

