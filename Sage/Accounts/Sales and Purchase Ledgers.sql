use syslive
-- NOMINAL LEDGERS
--select * from scheme.nltranm WITH(NOLOCK) where transaction_date > '2016-01-01 00:00:00'

-- SALES LEDGERS
select 'T&R' AS [Company Code], customer as [Debtor ID], item_no AS [Voicher ID], dated as IssueDate, due_date as DueDate, 'GBP' AS currency, amount
--SELECT *
 from scheme.slitemm WITH(NOLOCK) WHERE UPPER(open_indicator) ='O'
AND customer IN('T990103','T990044','T990101','T990129','T990033','T311525S','T100945S','S664075','T180425S','T070845S','T990041','T262439S','T423345S','T441006S','S325077','T300607','T263403S','T073245','S302175','T732400','T422045S','T990048','T131445S')
AND due_date BETWEEN '2015-12-01 00:00:00' AND '2016-02-29'