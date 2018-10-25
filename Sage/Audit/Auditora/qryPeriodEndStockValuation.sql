use syslive
go
/*
Stock valuation – qryPeriodEndStockValuation

Looking for a figure of £19,760,121.27 (Year-end total) 
*/
CREATE VIEW qryPeriodEndStockValBIIndicator
as 
/*
SELECT IIf(scheme_stockm1!make_or_buy="B","BI","MAN") AS MorB, scheme_stockm1.product, scheme_stockm1.warehouse, scheme_stockm1.description
FROM scheme_stockm1;
*/
select  a.product, a.warehouse, a.description, make_or_buy as MorB
FROM scheme.stockm as a WITH(NOLOCK)


go
DECLARE @Results Table(warehouse VARCHAR(2), product VARCHAR(10), FullCost FLOAT, ReducedValue FLOAT, OHAdj FLOAT)
INSERT INTO @Results
SELECT s.warehouse, s.product,
SUM(Round(s.physical_qty*s.standard_cost,2)) AS FullCost, 
SUM(Round(s.physical_qty*(s.standard_material+s.standard_labour),4)) AS FullCost, 
SUM(Round(s.physical_qty*(s.standard_overhead+s.standard_subcontra),4)) AS OHAdj
FROM scheme.stockm as s 
INNER JOIN qryPeriodEndStockValBIIndicator as v
ON (s.warehouse = v.warehouse) 
AND (s.product = v.product)
group by s.warehouse, s.product


SELECT SUM(FullCost) AS FC, SUM(ReducedValue) AS ReducedValue, SUM(OHAdj) AS OHAdj  FROM @Results
go


DROP VIEW qryPeriodEndStockValBIIndicator
