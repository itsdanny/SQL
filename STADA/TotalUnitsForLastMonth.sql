
use syslive

SELECT		TOP 50 a.product_code, a.description, sum(a.quantity_finished * u.spare) AS TopUnits
FROM		scheme.bmwohm a
INNER JOIN	scheme.stunitdm u
ON			u.unit_code = a.finish_prod_unit
WHERE		a.completion_date between StadaFactBook.dbo.fn_StartOfYear() and StadaFactBook.dbo.fn_EndOfYear()
AND			a.warehouse = 'FG'
group by	a.product_code, a.description
order by	sum(a.quantity_finished * u.spare) DESC

