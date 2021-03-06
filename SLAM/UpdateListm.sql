/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 100 * FROM scheme.oplistm
SELECT * FROM scheme.oplistm WHERE		product_code <> ''

--	DELETE FROM scheme.oplistm WHERE		product_code <> ''

INSERT into  scheme.oplistm (price_list, product_code, sequence_number, customer_code, currency_code, description, price, new_price, unit_code, unit_code_group, vat_inclusive_flag, unit_qty_per_price, price_start_date, price_end_date)
SELECT	price_list, product_code,'' AS Seq,'' AS CustCode, '' AS currCode, 
		CASE price_list WHEN 'WB' THEN 'WEB PRICES' WHEN 'NED' THEN 'Netherlands' WHEN 'WS1' THEN 'Wholesale 1' WHEN 'WS2' THEN 'Wholesale 2' WHEN 'WS3' THEN 'Wholesale 3'  WHEN 'TEL' THEN 'TELEPHONE' WHEN 'SOC' THEN 'SOCLIALITES' ELSE price_list END,
		l.price, new_price, l.unit_code, l.unit_code_group, l.vat_inclusive_flag, l.unit_qty_per_price, l.price_start_date, l.price_end_date
	FROM	[slam].[dbo].[SlamPriceLists] l
  INNER JOIN 	scheme.stockm m 
  ON			l.product_code = m.product
