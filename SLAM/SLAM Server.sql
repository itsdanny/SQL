-- THIS SCRIPT TAKES A BACK UP OF LIVE AND RESTORES IT OVER TEST
BACKUP DATABASE [VapeConnect] TO  DISK = N'C:\MSSQL\Backup\VapeConnect\VapeConnect_BackUp.bak' WITH NOFORMAT, NOINIT,  NAME = N'VapeConnect-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

USE [master]
ALTER DATABASE	VapeConnectTest SET SINGLE_USER WITH ROLLBACK AFTER 1 -- AFTER 1, WAITS 1 SECOND TO ALLOW QUERIES TO COMMIT ETC
GO

RESTORE DATABASE VapeConnectTest FROM  DISK = N'C:\MSSQL\Backup\VapeConnect\VapeConnect_BackUp.bak' WITH  FILE = 1,  
MOVE N'VapeConnect' TO N'C:\MSSQL\Data\VapeConnectTest.mdf',  
MOVE N'VapeConnect_log' TO N'C:\MSSQL\Logs\VapeConnectTest_log.ldf',  NOUNLOAD,  REPLACE,  STATS = 5

GO

-- set "Result to Text" mode by pressing Ctrl+T
SET NOCOUNT ON

DECLARE @sqlToRun VARCHAR(1000), @searchFor VARCHAR(100), @replaceWith VARCHAR(100)

-- text to search for
SET @searchFor = 'slam.scheme.'
-- text to replace with
SET @replaceWith = 'demo.scheme.'

-- this will hold stored procedures text
DECLARE @temp TABLE (spText VARCHAR(MAX), ID int identity(1,1))

DECLARE curHelp CURSOR FAST_FORWARD
FOR
-- get text of all stored procedures that contain search string
-- I am using custom escape character here since i need to espape [ and ] in search string
SELECT DISTINCT 'sp_helptext '''+OBJECT_SCHEMA_NAME(id)+'.'+OBJECT_NAME(id)+''' ' 
FROM syscomments WHERE TEXT LIKE '%' + REPLACE(REPLACE(@searchFor,']','\]'),'[','\[') + '%' ESCAPE '\'
ORDER BY 'sp_helptext '''+OBJECT_SCHEMA_NAME(id)+'.'+OBJECT_NAME(id)+''' '

OPEN curHelp

FETCH next FROM curHelp INTO @sqlToRun

WHILE @@FETCH_STATUS = 0
BEGIN
   --insert stored procedure text into a temporary table
   INSERT INTO @temp
   EXEC (@sqlToRun)
   
   -- add GO after each stored procedure
   INSERT INTO @temp
   VALUES ('GO')
   
   FETCH next FROM curHelp INTO @sqlToRun
END

CLOSE curHelp
DEALLOCATE curHelp

-- find and replace search string in stored procedures 
-- also replace CREATE PROCEDURE with ALTER PROCEDURE
UPDATE @temp
SET spText = REPLACE(REPLACE(spText,'CREATE PROCEDURE', 'ALTER PROCEDURE'),@searchFor, @replaceWith)

UPDATE @temp
SET spText = REPLACE(REPLACE(spText,'CREATE FUNCTION', 'ALTER FUNCTION'),@searchFor, @replaceWith)

UPDATE @temp 
SET spText = REPLACE(REPLACE(spText,'CREATE VIEW', 'ALTER VIEW'),@searchFor, @replaceWith)


SELECT spText FROM @temp ORDER BY ID
-- now copy and paste result into new window
-- then make sure everything looks good and run

GO
