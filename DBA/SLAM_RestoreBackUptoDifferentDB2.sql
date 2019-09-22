
USE [master]
DECLARE @bakFile VARCHAR(200)
SET @bakFile = (SELECT
      TOP 1  bmf.physical_device_name
FROM
    msdb.dbo.backupmediafamily bmf     JOIN    msdb.dbo.backupset bs ON bs.media_set_id = bmf.media_set_id
WHERE    bs.database_name = 'slam'
AND	bmf.physical_device_name LIKE '%C:\MSSQL%.bak'
ORDER BY    bmf.media_set_id DESC)


ALTER DATABASE [demo] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
RESTORE DATABASE [demo] FROM  DISK = @bakfile WITH  FILE = 1,  MOVE N'slam' TO N'C:\MSSQL\Data\demo.mdf',  MOVE N'slamlog' TO N'C:\MSSQL\Logs\demolog.ldf',  NOUNLOAD,  REPLACE,  STATS = 5
ALTER DATABASE [demo] SET MULTI_USER

GO

USE demo
UPDATE demo.scheme.sysdirm SET key_value = '11/04/20'  WHERE system_key = 'DEF_EXPIRY' -- 
UPDATE demo.scheme.sysdirm SET key_value = 'UQMTegJiVkUI'  WHERE system_key = 'DEF_PASSWD' -- 
UPDATE demo.scheme.sysdirm SET key_value = '000001' WHERE system_key = 'DEF_SITENO'
UPDATE demo.scheme.sysdirm SET key_value = 'c:\csserver\demo\DEF\fail\' WHERE system_key = 'FSFAILDIR'
UPDATE demo.scheme.sysdirm SET key_value = 'c:\csserver\demo\DEF\move\' WHERE system_key = 'FSMOVEDIR'
UPDATE demo.scheme.fscontq1m SET	fs_filename = 'c:\csserver\demo\DEF\in', fs_status ='X' WHERE		fs_id ='0000'
print getdate()


USE [master]
DECLARE @bakFile VARCHAR(200)
SET @bakFile = (SELECT
      TOP 1  bmf.physical_device_name
FROM
    msdb.dbo.backupmediafamily bmf     JOIN    msdb.dbo.backupset bs ON bs.media_set_id = bmf.media_set_id
WHERE    bs.database_name = 'VapeConnect'
AND	bmf.physical_device_name LIKE '%C:\MSSQL%.bak'
ORDER BY    bmf.media_set_id DESC)

ALTER DATABASE [VapeConnectTest] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
RESTORE DATABASE [VapeConnectTest] FROM  DISK = @bakFile WITH  FILE = 1,  MOVE N'VapeConnect' TO N'C:\MSSQL\Data\VapeConnectTest.mdf',  MOVE N'VapeConnect_log' TO N'C:\MSSQL\Logs\VapeConnectTestlog.ldf',  NOUNLOAD,  REPLACE,  STATS = 5
ALTER DATABASE [VapeConnectTest] SET MULTI_USER

GO
RETURN 

SELECT
      TOP 1  bmf.physical_device_name
FROM
    msdb.dbo.backupmediafamily bmf     JOIN    msdb.dbo.backupset bs ON bs.media_set_id = bmf.media_set_id
WHERE    bs.database_name = 'slam'
AND	bmf.physical_device_name LIKE '%C:\MSSQL%.bak'
ORDER BY    bmf.media_set_id DESC;