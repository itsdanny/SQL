BACKUP DATABASE [VapeConnect] TO  DISK = N'C:\MSSQL\Backup\VapeConnect\VapeConnect.bak' WITH NOFORMAT, NOINIT,  
NAME = N'VapeConnect-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO


USE [master]


ALTER DATABASE [VapeConnectTest] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
RESTORE DATABASE [VapeConnectTest] FROM  DISK = N'C:\MSSQL\Backup\VapeConnect\VapeConnect.bak' WITH  FILE = 1,  
MOVE N'VapeConnect' TO N'C:\MSSQL\Data\VapeConnectTest.mdf',  
MOVE N'VapeConnect_log' TO N'C:\MSSQL\Logs\VapeConnectTestlog.ldf',  NOUNLOAD,  REPLACE,  STATS = 5
ALTER DATABASE [VapeConnectTest] SET MULTI_USER

USE [master]
ALTER DATABASE [VapeConnectTest] MODIFY FILE (NAME=N'VapeConnect', NEWNAME=N'VapeConnectTest')
GO
ALTER DATABASE [VapeConnectTest] MODIFY FILE (NAME=N'VapeConnect_log', NEWNAME=N'VapeConnectTest_log')
GO



GO

