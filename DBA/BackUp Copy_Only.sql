-- back up the db
declare @DB nvarchar(50) = 'Insight_test'
declare @local nvarchar(50) ='\\trsagev3d1\m$\' + @DB + '_copy_only.bak'
declare @remote nvarchar(50) ='\\trsagev3d2\m$\' + @DB + '_copy_only.bak'
DECLARE @copypath nvarchar(50) = @local +  ' ' + @remote 
backup database @DB to disk=@local with init, copy_only, compression
print @copypath
GO
--copy it to remote server manually
go
-- LOG ON TO REMOTE SERVER AND EXEC THIS 
-- copy to wherever and restore that bad boy
--restore database @DB from disk=@remote with recovery