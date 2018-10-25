--select * from dbo.ContDrugsImport

SELECT	year_to_date01,year_to_date02,year_to_date03,year_to_date04,year_to_date05, year_to_date06, year_to_date07,year_to_date08,year_to_date09, year_to_date10, 
		month_to_date01,month_to_date02,month_to_date03,month_to_date04,month_to_date05, month_to_date06, month_to_date07,month_to_date08,month_to_date09, month_to_date10,
		period_issue_qty01,	period_issue_qty02,	period_issue_qty03,	period_issue_qty04, period_issue_qty05,period_issue_qty06,period_issue_qty07,period_issue_qty08,period_issue_qty09,period_issue_qty10,period_issue_qty11,period_issue_qty12,period_issue_qty13
FROM	scheme.stockm 
WHERE	product = '002119' 
AND		warehouse = 'FG'


SELECT	year_to_date01,year_to_date02,year_to_date03,year_to_date04,year_to_date05, year_to_date06, year_to_date07,year_to_date08,year_to_date09, year_to_date10, 
		month_to_date01,month_to_date02,month_to_date03,month_to_date04,month_to_date05, month_to_date06, month_to_date07,month_to_date08,month_to_date09, month_to_date10,
		period_issue_qty01,	period_issue_qty02,	period_issue_qty03,	period_issue_qty04, period_issue_qty05,period_issue_qty06,period_issue_qty07,period_issue_qty08,period_issue_qty09,period_issue_qty10,period_issue_qty11,period_issue_qty12,period_issue_qty13
FROM	scheme.stockm 
WHERE	product = '100349' 
AND		warehouse = 'IG'
