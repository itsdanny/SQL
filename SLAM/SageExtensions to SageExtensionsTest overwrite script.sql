PRINT GETDATE()
PRINT 'DO THE BACK UP '
USE [master]
BACKUP DATABASE SageExtensions TO  DISK = N'C:\MSSQL\Backup\demo\SageExtensions.bak' WITH NOFORMAT, INIT,  NAME = N'SageExtensions-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

USE [master]
PRINT GETDATE()
PRINT 'DO THE RESTORE'
ALTER DATABASE	SageExtensionsTest SET SINGLE_USER WITH ROLLBACK IMMEDIATE
RESTORE DATABASE SageExtensionsTest FROM  DISK = N'C:\MSSQL\Backup\demo\SageExtensionsTest.bak' WITH  FILE = 1,  
									 MOVE N'slam' TO N'C:\MSSQL\Data\SageExtensionsTest.mdf',  
									 MOVE N'slamlog' TO N'C:\MSSQL\Logs\SageExtensionsTest.ldf',  NOUNLOAD,  REPLACE,  STATS = 5
ALTER DATABASE SageExtensionsTest SET MULTI_USER
GO

PRINT 'RENAME THE LOGICAL FILE NAMES'
USE [master]
ALTER DATABASE SageExtensionsTest MODIFY FILE (NAME=N'SageExtensions', NEWNAME=N'SageExtensionsTest')
GO
ALTER DATABASE SageExtensionsTest MODIFY FILE (NAME=N'SageExtensions', NEWNAME=N'SageExtensionsTestlog')
GO