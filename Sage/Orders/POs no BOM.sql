
DECLARE @LastOrdNum int


SET @LastOrdNum = (SELECT key_value
FROM scheme.sysdirm
WHERE (system_key = 'BMLASTWNO'))


SELECT		RIGHT('000'+ CONVERT(VARCHAR, ROW_NUMBER() OVER (ORDER BY scheme.stockm.product DESC)),3) AS tran_line, 
			RIGHT('00000'+ CONVERT(VARCHAR, @LastOrdNum + ROW_NUMBER() OVER (ORDER BY scheme.stockm.product DESC)),6) AS WorkOrderNo, 
			scheme.stockm.warehouse, 
			scheme.stockm.product, 
			scheme.stockm.warehouse AS Expr1, 
			scheme.stockm.product AS Expr2, '' AS RouteWarehouse, 
			'' AS RouteProduct, 
			'TPTY' + LTRIM(RTRIM(scheme.poheadm.order_no)) AS alpha, 
			'' AS Customer, 
			scheme.stockm.description, 
			'' AS instruction1, 
			'' AS instruction2, 
			'' AS instruction3, 
			'' AS instruction4,
			RIGHT('00' + LTRIM(STR(DATEPART(dd, scheme.poheadm.date_required))), 2) + '/' + RIGHT('00' + LTRIM(STR(DATEPART(mm, scheme.poheadm.date_required))), 2) + '/' + RIGHT('00' + LTRIM(STR(DATEPART(yy, scheme.poheadm.date_required))), 2) AS order_date, 
			RIGHT('00' + LTRIM(STR(DATEPART(dd, scheme.poheadm.date_required))), 2) + '/' + RIGHT('00' + LTRIM(STR(DATEPART(mm, scheme.poheadm.date_required))), 2) + '/' + RIGHT('00' + LTRIM(STR(DATEPART(yy, scheme.poheadm.date_required))), 2) AS due_date, 
			'A' AS wo_status, 
			'N' AS trail_order, 
			'' AS stage, 
			'' AS wo_priority, 
			scheme.stockm.drawing_number, 
			'' AS drawing_2, 
			'' AS drawing_3, 
			'' AS revision_1,
			'' AS revision_2, 
			'' AS revision_3, 
			'' AS issue_no, 
			'' AS security_ref, 
			'N' AS security_lev, 
			'' AS sales_order, 
			'' AS parent_wo, 
			'' AS dont_start,
			RIGHT('00' + LTRIM(STR(DATEPART(dd, scheme.poheadm.date_required))), 2) + '/' + RIGHT('00' + LTRIM(STR(DATEPART(mm, scheme.poheadm.date_required))), 2) + '/' + RIGHT('00' + LTRIM(STR(DATEPART(yy, scheme.poheadm.date_required))), 2) AS expected_date, 
			'N' AS do_job_costing, 
			'Y' AS include_in_mrp, 
			'N' AS firm_plan, 
			'N' AS reschedule,
			'N' AS internal_sched_pri, 
			scheme.stockm.selling_unit, 
			SUM(scheme.podetm.qty_ordered) AS qty_required, 
			0 AS nspare1,
			0 AS nspare2, 
			0 AS nspare3,
			0 AS nspare4, 
			0 AS nspare5
FROM        scheme.poheadm WITH (NOLOCK) 
INNER JOIN	scheme.podetm WITH (NOLOCK) 
ON			scheme.poheadm.order_no = scheme.podetm.order_no 
INNER JOIN	scheme.stockm WITH (NOLOCK) 
ON			scheme.podetm.product = scheme.stockm.product
AND			scheme.stockm.warehouse = 'FG' 
LEFT OUTER JOIN	scheme.bmwohm WITH (NOLOCK) 
ON			scheme.poheadm.order_no = RIGHT(scheme.bmwohm.alpha_code, 6)
WHERE       scheme.poheadm.order_no NOT IN (SELECT RIGHT(6, alpha_code) AS PONumber
											  FROM   scheme.bmwohm AS bmwohm_1
											  WHERE  (alpha_code = 'TPTY%'))
AND			(scheme.poheadm.date_required > '17 JUNE 2013 00:00:00') 
AND			(scheme.poheadm.status NOT IN ('C','9'))
AND			(scheme.podetm.status NOT IN ('C')) 
AND			(scheme.bmwohm.alpha_code IS NULL) 
AND			(scheme.stockm.analysis_a = 'TPTY')
GROUP BY	scheme.poheadm.order_no, scheme.stockm.warehouse, scheme.stockm.product, scheme.stockm.description, scheme.poheadm.date_required, scheme.stockm.drawing_number, scheme.stockm.selling_unit

