-- DIFF BACK UP: OVERWRITES LAST BACK UP WITH 'INIT' SET 'NOINIT' TO APPEND (ALL CHANGES TO THE FILE, THIS CAN GROW 200MB+ EACH TIME)

BACKUP DATABASE [syslive] TO DISK = N'M:\Daily\syslive_diff.bak' WITH DIFFERENTIAL, INIT, DESCRIPTION= N'syslive Diff back Up - use in the event of an emergency... good luck!', NAME=N'syslive-Differential Backup', COMPRESSION, STATS = 10
GO
/*
--RESTORE HEADERONLY FROM DISK='M:\Daily\syslive_diff.bak' -- WHAT THE INFO ON THE BACK UP

--ALTER DATABASE somedatabase  SET SINGLE_USER WITH ROLLBACK AFTER 60 -- AFTER 1, WAITS 1 SECOND TO ALLOW QUERIES TO COMMIT ETC
--GO
-- REPLACE 'SOMEDATABASE' WITH AN ACTUAL ONE --

--RESTORE DATABASE	somedatabase
--					FROM  DISK = N'M:\Daily\somedatabase.bak' 
--					WITH FILE = 1,					
--					NOUNLOAD, 
--					STATS = 5, REPLACE, NORECOVERY --force restore over specified database 

--RESTORE DATABASE somedatabase FROM  DISK = N'M:\Daily\somedatabase_diff.bak' WITH RECOVERY, FILE = 1
--ALTER DATABASE somedatabase SET MULTI_USER
GO
*/
--- wholey-crap this table is 35GB
--select top 50 * from scheme.stocka-- order by audit_reference desc 13482509, 13498011
