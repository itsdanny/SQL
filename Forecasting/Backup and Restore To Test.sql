USE [master]
ALTER DATABASE ForecastingTest SET SINGLE_USER WITH ROLLBACK IMMEDIATE
RESTORE DATABASE [ForecastingTest] FROM  DISK = N'M:\Daily\Forecasting.bak' WITH FILE = 1,  
	MOVE N'ForecastingOld'		TO N'F:\SQL Data\MSSQL10.MSSQLSERVER\MSSQL\DATA\ForecastingTest.mdf',  
	MOVE N'ForecastingOld_log'	TO N'F:\SQL Data\MSSQL10.MSSQLSERVER\MSSQL\DATA\ForecastingTest_log.ldf',  
NOUNLOAD,  REPLACE,  STATS = 5
ALTER DATABASE ForecastingTest SET MULTI_USER

GO


