-- USE THIS TO RESTORE FROM A BACK UP IF THE USER HAS UPDATED THE PARTIAL/FULL TABLE
select * into oplistm_live from scheme.oplistm with(nolock) where price_list >= '32B'
select * from scheme.oplistm with(nolock) where price_list >= '32B' and new_price > 0 ORDER BY price_list

-- this table to load the data into from the back up (NEEDS CREATING)
drop table oplistm_back
select * from oplistm_live

SELECT		*
FROM		scheme.oplistm a
INNER JOIN	oplistm_back b
ON			a.product_code = b.product_code
AND			a.price_list = b.price_list
WHERE		a.new_price = 0
/*
begin tran
update		a
set			a.new_price = b.new_price
from		scheme.oplistm a
inner join	oplistm_back b
ON			a.product_code = b.product_code
and			a.price_list = b.price_list
WHERE		a.new_price = 0
rollback
*/

select customer, cust_disc_code from scheme.slcustm where cust_disc_code <> ''