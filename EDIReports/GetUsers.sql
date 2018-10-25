SELECT territory, customer, name, invoice, dated, order_no, date_entered, customer_order_no FROM InvoicesByTerritory1  with(nolock)
 WHERE (dated BETWEEN '25 November 2014 00:00:00' AND '27 November 2014 23:59:29') AND (territory = '11') GROUP BY territory, customer, name, invoice, dated, order_no, date_entered, customer_order_no


 use Insight
 select * from InsightErrors where ErrorMessage like '%email%' order by ErrorDate desc
 use syslive
 SELECT sub_table_key, column_1, column_2 FROM scheme.rwmiscm with(nolock) WHERE sub_table = 'rep_codes' AND NOT sub_table_key = ''