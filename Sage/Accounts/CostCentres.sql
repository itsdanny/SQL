select * from scheme.nlcostm where cost_code = '1-100'     
select * from vw_qlikview_costcentregrouping
select * from scheme.nlmastm where nominal_code like '1-100%' and revalue ='Y' 

ORDER BY nominal_code


SELECT nominal_code AS NOM_CODE, REPLACE(description,'TR IT          ',''),	*
FROM	scheme.nlmastm 
WHERE	(nominal_code like '1-110%' 
AND		(element3 liKE '2100%' 
OR		element3 LIKE '2130%' 
OR		element3 LIKE '2180%' 
OR		element3 LIKE '2205%'
OR		element3 LIKE '2210%' 
OR		element3 LIKE '2215%' 
OR		element3 LIKE '2235%' 
OR		element3 LIKE '2275%' 
OR		element3 LIKE '2310%'
OR		element3 LIKE '3100%'))
or		nominal_code IN ('1-900-2100-70','1-100-2215-04','1-198-2210-04')
ORDER BY element3

SELECT	* FROM	scheme.nlmastm WHERE description like '%WAN%'