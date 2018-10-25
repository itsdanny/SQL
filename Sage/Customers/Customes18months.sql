--select		DISTINCT c.* 
--from		scheme.slcustm c with(nolock) 
--inner join	scheme.opheadm o with(nolock)
--ON			c.customer = o.customer
--WHERE		o.date_entered > DATEADD(month,-18, getdate())
--AND			c.customer NOT LIKE 'T00%'
--AND			c.alpha ='ALLIANCE'
--ORDER BY	c.alpha

select * from scheme.slcustm where date_last_issue > DATEADD(month,-18, getdate())
select * from scheme.slcustm where alpha in(
select		alpha-- , COUNT(customer) 
FROM		scheme.slcustm 
where		customer in (select DISTINCT c.customer
from		scheme.slcustm c with(nolock) 
inner join	scheme.opheadm o with(nolock)
ON			c.customer = o.customer
WHERE		o.date_entered > DATEADD(month,-18, getdate())
AND			c.customer NOT LIKE 'T00%')
group by	alpha having count(customer) > 1)
order by	alpha