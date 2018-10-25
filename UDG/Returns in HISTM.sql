/*
018406 	-- 	144/12
004944	--	120/132 (10/11) on retn
001619 -- not on retn
*/
select * from scheme.stkhstm  where product = '018406' and transaction_type ='RETN' AND comments ='RET2A193130' order by dated desc
select * from scheme.stkhstm  where product = '004944' and transaction_type ='RETN' AND comments ='RET2A193130'  order by dated desc
select * from scheme.stkhstm  where product = '001619' and transaction_type ='RETN' AND comments ='RET2A193130'  order by dated desc