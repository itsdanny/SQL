/* THIS FILE IS FOR THE TWO CREDIT NOTES, WHICH TRIED TO FIX TWO BAD SALES ORDERS, NEED TO PRODUCE TWO SALES ORDERS */

DECLARE @res TABLE(customer VARCHAR(3), TransactionDate Date, DailyDiscountValue FLOAT, DailyCardValue FLOAT, DailyCashValue FLOAT, DailyPettyCashValue FLOAT, ProductCode VARCHAR(20), Qty INT, Value FLOAT, LineDisount FLOAT)

INSERT INTO  @res
SELECT	DISTINCT	LTRIM(RTRIM(h.customer)), 
				'2019-07-30' AS TransactionDate,
				0 AS DailyDiscountValue,
				0 AS DailyCardValue,
				0 AS DailyCashValue,
				0 AS DailyPettyCashValue,
				LTRIM(RTRIM(d.product)) AS ProductCode,  
				SUM(CASE d.line_type WHEN 'S' THEN '1' ELSE order_qty END) AS Qty, /* SERVICE CODES HAVE 0 PRICE SO USE net_price instea */
				ROUND(MAX(d.val/d.order_qty),2) AS Value,
				0 AS LineDisount

	FROM		demo.scheme.opheadm h
	INNER JOIN 	demo.scheme.opdetm d
	ON			h.order_no = d.order_no
	WHERE		h.order_no IN ('CNA16471D','CNA16472D')
	AND			d.despatched_qty > 0
	AND			h.order_no	LIKE '%CN%'
	AND			d.line_type <> 'S'
	GROUP BY 	LTRIM(RTRIM(h.customer)), LTRIM(RTRIM(d.product)),d.line_type
	ORDER BY	1, 2


	UPDATE 	r
	SET		r.DailyDiscountValue = t.discount
	FROM	@res r, 
	(SELECT		SUM(d1.val) AS discount, h1.customer
				 FROM			demo.scheme.opheadm h1
			INNER JOIN 	demo.scheme.opdetm d1
			ON			h1.order_no = d1.order_no
			WHERE		h1.order_no IN ('CNA16471D','CNA1647D')
				AND			d1.order_no	LIKE '%CN%'
				AND			d1.line_type = 'S'
				GROUP BY	h1.customer)  t
			WHERE		t.customer = r.customer COLLATE Latin1_General_BIN
		
		UPDATE 	@res SET customer = Right(customer, 2)

		INSERT INTO VapeConnectTest.dbo.IMPDailySalesInformation (BranchCode, TransactionDate, DailyDiscountValue, DailyCardValue, DailyCashValue, DailyPettyCashValue, ProductCode, Quantity, Value, LineDiscount, Processed)
		SELECT	*, 0
		FROM		@res
		ORDER BY	customer
		RETURN 
		SELECT	*
		FROM		 VapeConnectTest.dbo.IMPDailySalesInformation

