USE syslive
go
/*
	RUN THIS IF THE DEFACTO MODULE  HAS 'STALLED'. STALL CAUSED BY AN ERROR.
	-- SCANNER STATUS...
	SELECT *, 'Q1' AS Q1 FROM scheme.fscontq1m where  fs_id = '0000'
	SELECT *, 'Q2' AS Q2 FROM scheme.fscontq2m where  fs_id = '0000'
	SELECT *, 'Q3' AS Q3  FROM scheme.fscontq3m where  fs_id = '0000'
	SELECT *, 'Q4' AS Q4  FROM scheme.fscontq4m where  fs_id = '0000'
	SELECT *, 'Q5' AS Q5  FROM scheme.fscontq5m where  fs_id = '0000'

*/
-- q table...
--	SELECT * FROM scheme.fscontq1m order by fs_id
--	SELECT * FROM scheme.fscontq2m order by fs_id
--	SELECT * FROM scheme.fscontq3m order by fs_id
--	SELECT * FROM scheme.fscontq4m order by fs_id
--	SELECT * FROM scheme.fscontq5m order by fs_id desc
--	SELECT * FROM scheme.fscontq5m where  fs_id = '0000'
--	SELECT * FROM scheme.fscontq5m where fs_status = 'E' order by fs_id

/*
	-- CLEAR IT OUT AND REST IT TO GET IT GOING AGAIN..
	DELETE FROM  scheme.fscontq3m where fs_id <> '0000'

	DELETE FROM  scheme.fscontq5m where fs_id <> '0000'

	UPDATE scheme.fscontq5m set fs_status = 'R' where fs_id = '0000'  and fs_status = 'E'
	UPDATE scheme.fscontq5m set fs_status = 'E' where fs_id = '0000'

*/
