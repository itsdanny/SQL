USE Integrate
GO
DENY  ON SCHEMA::dbo TO [THORNTONROSS\DanMcGregor]
GO

select * from dbo.SalesOrderHeader

select top 100  * from syslive.scheme.stockm