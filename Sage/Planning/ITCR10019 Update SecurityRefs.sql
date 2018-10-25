-- this script is to update the security ref for IT change 10019
-- back up data
select * into scheme.bmwohm_10019 from scheme.bmwohm

select security_reference AS REF, CASE security_reference  WHEN 'AM' THEN '1' WHEN 'PM' THEN '2' WHEN 'NS' THEN '3' WHEN '' THEN '' END, * 
from scheme.bmwohm
WHERE	order_date > '2016-03-14'
AND		status in ('A','I')
and security_reference IS NOT NULL

UPDATE	scheme.bmwohm 
SET		security_reference = CASE security_reference  WHEN 'AM' THEN '1' WHEN 'PM' THEN '2' WHEN 'NS' THEN '3' WHEN '' THEN '' END
WHERE	order_date > '2016-03-14'
AND		status in ('A','I')