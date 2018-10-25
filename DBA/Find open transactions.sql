--	kill 80
go
DBCC OPENTRAN

--	OR 

select * from sys.sysprocesses sp
cross apply sys.dm_exec_sql_text(sp.[sql_handle])as dest 
where open_tran > 1