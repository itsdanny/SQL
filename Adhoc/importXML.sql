/*drop table XMLwithOpenXML
CREATE TABLE XMLwithOpenXML
(
Id INT IDENTITY PRIMARY KEY,
XMLData XML,
LoadedDateTime DATETIME
)


INSERT INTO XMLwithOpenXML(XMLData, LoadedDateTime)
SELECT CONVERT(XML, BulkColumn) AS BulkColumn, GETDATE() 
FROM OPENROWSET(BULK 'm:\strava.xml', SINGLE_BLOB) AS x;


SELECT * FROM XMLwithOpenXML
*/
/*
DECLARE @XML AS XML, @hDoc AS INT, @SQL NVARCHAR (MAX)
SELECT @XML = XMLData FROM XMLwithOpenXML
EXEC sp_xml_preparedocument @hDoc OUTPUT, @XML

SELECT Id, lat, lon, ele, [time] --into #tmp
FROM OPENXML(@hDoc, 'trk/trkseg/trkpt')
WITH 
(
lat [varchar](50) '@lat',
lon [varchar](50) '@lon',
ele float 'ele',
[time] datetime 'time'
)


EXEC sp_xml_removedocument @hDoc
GO
alter table #tmp
add  
Id int identity(1,1)
*/
/*
DECLARE @Start DateTime  = (select min([time]) from #tmp)--2016-02-06 09:02:41.000
DECLARE @Row INT = 2, @Rows INT = 197
--
WHILE @Row <= @Rows
BEGIN
	set @Start = DATEADD(MILLISECOND, 8415, @Start)
	update #tmp set [time] = @Start where Id = (@Row)

SET @Row = @Row + 1
END


select *  from TMP order by Id desc;
*/
	declare @cmd nvarchar(255);
	select @cmd = ' bcp "select Lat, Lon, ele, [time] from InsightTest.dbo.tmp trkseg for xml auto, root(''trk''), elements" queryout "M:\STRAVAXPORT.xml" -S TRSAGEV3D1 -T -w -r -t';
	exec xp_cmdshell @cmd; 
	go