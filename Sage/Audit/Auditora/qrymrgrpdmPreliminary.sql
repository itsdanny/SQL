create view qrymrgrpdmPreliminary
as 
--SELECT scheme_mrgrpdm.warehouse & scheme_mrgrpdm.product AS Product, scheme_mrgrpdm.warehouse, scheme_mrgrpdm.product, Sum(scheme_mrgrpdm.quantity_required) AS SumOfquantity_required, tblWeek.PERIOD, 
--scheme_stockm1.long_description, tblFGunitslookup.[Numerical Eq], scheme_stockm1.unit_code
--FROM ((scheme_mrgrpdm 
--INNER JOIN	tblWeek	
--ON			scheme_mrgrpdm.date_required = tblWeek.DATE) 
--INNER JOIN	scheme_stockm1 
--ON			(scheme_mrgrpdm.product = scheme_stockm1.product) 
--AND			(scheme_mrgrpdm.warehouse = scheme_stockm1.warehouse)) 
--INNER JOIN	tblFGunitslookup 
--ON			scheme_stockm1.unit_code = tblFGunitslookup.Units
--GROUP BY	scheme_mrgrpdm.warehouse & scheme_mrgrpdm.product, scheme_mrgrpdm.warehouse, scheme_mrgrpdm.product, tblWeek.PERIOD, scheme_stockm1.long_description, tblFGunitslookup.[Numerical Eq], scheme_stockm1.unit_code
--HAVING (((tblWeek.PERIOD)>=[From Period ie P111201] And (tblWeek.PERIOD)<=[To Period ie P111212]));
select * from scheme.mrgrpdm WITH(NOLOCK)

SELECT scheme_mrgrpdm.warehouse + scheme_mrgrpdm.product AS Product, scheme_mrgrpdm.warehouse, scheme_mrgrpdm.product, Sum(scheme_mrgrpdm.quantity_required) AS SumOfquantity_required, tblWeek.Week as Period,
scheme_stockm1.long_description, tblFGunitslookup.spare, scheme_stockm1.unit_code
FROM		scheme.mrgrpdm as scheme_mrgrpdm WITH(NOLOCK)
INNER JOIN	tblWeek	
--ON		scheme_mrgrpdm.date_required  BETWEEN '2015-01-01 00:00:00' AND '2015-12-31 00:00:00') 
ON			scheme_mrgrpdm.date_required = tblWeek.Date 
INNER JOIN	scheme.stockm AS scheme_stockm1 WITH(NOLOCK)
ON			(scheme_mrgrpdm.product = scheme_stockm1.product) 
AND			(scheme_mrgrpdm.warehouse = scheme_stockm1.warehouse) 
INNER JOIN	scheme.stunitdm as tblFGunitslookup WITH(NOLOCK)
ON			scheme_stockm1.unit_code = tblFGunitslookup.unit_code
--WHERE		scheme_mrgrpdm.date_required  BETWEEN '2015-01-01 00:00:00' AND '2015-12-31 00:00:00'
GROUP BY	scheme_mrgrpdm.warehouse + scheme_mrgrpdm.product, scheme_mrgrpdm.warehouse, scheme_mrgrpdm.product, scheme_stockm1.long_description, tblFGunitslookup.spare, scheme_stockm1.unit_code,tblWeek.Week
--HAVING		((tblWeek.Period)>= '2015-01-01 00:00:00' And (tblWeek.Period) <= '2015-12-31 00:00:00');
go

-- qrymrgpmForecasts
create view qrymrgpmForecasts as
SELECT	qrymrgrpdmPreliminary.product, Sum(qrymrgrpdmPreliminary.SumOfquantity_required) AS SumOfSumOfquantity_required, Left([product],2) AS WH, SUBSTRING([product],3,6) AS Code, 
		qrymrgrpdmPreliminary.long_description, qrymrgrpdmPreliminary.unit_code, qrymrgrpdmPreliminary.spare
FROM	qrymrgrpdmPreliminary
GROUP BY qrymrgrpdmPreliminary.product, Left([product],2), SUBSTRING([product],3,6), qrymrgrpdmPreliminary.long_description, qrymrgrpdmPreliminary.unit_code, qrymrgrpdmPreliminary.spare


go

-- qryYearEndSlowMovePrelim
declare @Results Table (Res money)
insert into @Results
SELECT		--q.warehouse, q.product, s.description, q.lot_number, Sum(q.quantity) AS SumOfquantity, qrymrgpmForecasts.SumOfSumOfquantity_required, q.expiry_date, q.quantity*s.standard_cost AS ShortValue
			--Sum(q.quantity) AS SumOfquantity,
			sum(q.quantity*s.standard_cost) AS ShortValue 
FROM		(scheme.stockm AS s WITH(NOLOCK)
LEFT JOIN	scheme.stquem as q WITH(NOLOCK)
ON			(s.warehouse = q.warehouse) 
AND			(s.product = q.product)) 
LEFT JOIN	qrymrgpmForecasts 
ON			(s.warehouse = qrymrgpmForecasts.WH) 
AND			(s.product = qrymrgpmForecasts.Code)
GROUP BY	q.warehouse, q.product, s.description, q.lot_number, qrymrgpmForecasts.SumOfSumOfquantity_required, q.expiry_date, q.quantity*s.standard_cost
HAVING		(((q.warehouse)='FG') AND ((Sum(q.quantity)) > 0) 
AND ((q.expiry_date) <= '2016-09-30 00:00:00')
);


SELECT SUM(Res) FROM @Results

-- OCT 16 437771.4378
-- NOV 16 575526.4079
drop view qrymrgrpdmPreliminary
drop view qrymrgpmForecasts