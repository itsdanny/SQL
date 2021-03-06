update [TRConnect].[service].[ServiceData] set SentToClient = NULL, SentDateTime = NULL where ServiceId = 26-- and Id = 234

return
exec [service].[sp_WebServiceGetUnprocessedData] 26

update [TRConnect].[service].[ServiceData] set SentToClient = 1, SentDateTime = getDAte() where ServiceId = 24
update [TRConnect].[service].[ServiceData]  set Col13 = Col3 where ServiceId = 26
update [TRConnect].[service].[ServiceData]  set Col3 = LEFT(Col3,28) where ServiceId = 26
update [TRConnect].[service].[ServiceData] set Col1 = 'D1' WHERE Col1= 'DONCASTER'
update [TRConnect].[service].[ServiceData] set Col1 = 'B1' WHERE Col1= 'BARNSLEY'

delete FROM [TRConnect].[service].[ServiceData] where  Id = 3
SELECT * FROM [TRConnect].[service].[ServiceData] where  ServiceId = 27 order by Col4

SELECT * FROM [TRConnect].[service].[ServiceData] where   SentToClient IS NULL AND SentDateTime IS NULL order by Id desc

select * from service.ServiceColumnMappings where ServiceId = 26 order by TableColumnPosition
SELECT * FROM [TRConnect].[service].[ServiceData] where  ServiceId = 26 order by Id desc
SELECT * FROM [TRConnect].[service].[ServiceData] where  ServiceId = 26 AND Col4  like 'DD%' order by Id desc

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT * FROM [TRConnect].[service].[Services] 
select * from [service].[DirectoryFilePaths]
select * from service.ServiceColumnMappings where ServiceId = 26 order by TableColumnName

select * from LogTypes
select * from Log

--	TRUNCATE TABLE service.ServiceData
DBCC CHECKIDENT('service.ServiceData', RESEED, 1)

exec [service].[sp_WebServiceGetUnprocessedData] 26

insert into service.ServiceColumnMappings SELECT  ServiceId, FileColumnPosition, TableColumnPosition, TableColumnName, TableColumnAlias from service.ServiceColumnMappings where ServiceId = 6 

