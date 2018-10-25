select distinct c.customer, c.name, c.address1, c.address2, c.address3, c.address4, c.address6, c.account_type, h.*


FROM		[syslive].[scheme].[opheadm] h WITH (NOLOCK) inner join 
[syslive].[scheme].[slcustm] c with (NOLOCK) 
on c.customer = h.customer
where (c.customer like 'S%' or c.customer like 'T%') and (c.customer not like '%I' and c.customer not like '%S') and h.date_received >= '08/01/2013' and c.account_type like '%UK'
