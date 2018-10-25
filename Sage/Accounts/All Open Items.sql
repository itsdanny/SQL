use syslive2015;
go
ALTER procedure sp_CustomerOpenItems
as
SELECT	DISTINCT '2274' [SAP Company Code],
			cs.customer [Sage Customer No.],
			'31.12.2017' [Posting Date Data Takeover],
			CASE s.kind WHEN 'INV' THEN '01' WHEN 'JRN' THEN '14' WHEN 'CSH' THEN '15' ELSE '11' END [SAP Posting Key], -- MORE INFO REQUIRED ON TYPES
			CONVERT(VARCHAR, s.effective_date, 104) [Sage Invoice Date], -- format this date DD.MM.YYYY
			CASE cs.currency WHEN '' THEN 'GBP' ELSE cs.currency END [Currency], -- GK
			'S2000' [SAP SEG Code for Brands],
			s.unall_curr_amount [Amount in document CCY Brand],
			s.unall_amount [Amount In GBP For Brand],
			'S1000' [SAP SEG Code for Generics],
			'0' [Amount in document CCY Generics],
			'0' [Amount In GBP For Generics],
			s.item_no [Sage Invoice Number],
			CASE s.kind WHEN 'INV' THEN 'INVOICE' WHEN 'CRN' THEN 'CREDIT NOTE' WHEN 'CSH' THEN 'CASH' WHEN 'JRN' THEN 'JOURNAL' END [Sage Posting text],
			CASE WHEN CONVERT(VARCHAR, h.date_despatched, 104) IS NULL THEN CONVERT(VARCHAR, s.effective_date, 104)  ELSE CONVERT(VARCHAR, h.date_despatched, 104) END [Payment Baseline Date], -- GK
			pd.SAPCodes AS [Days granted],-- GK
			'0.00' [Cash Discount %], -- GK
			'/' [Partner Bank Type],
			'/' [SAP Payment Block Key],
			tr.journal_number [SAGE Accounting Doc No.],
			'' [Reminder Level], --	GK
			'' [Last Reminder Date], -- GK
			'/' [SAP Reminder Block Key],
			'/' [SCB Indicator],
			'/' [End Of Line Code]
FROM		scheme.slitemm s WITH(NOLOCK)
INNER JOIN	scheme.slcustm cs WITH(NOLOCK)
ON			cs.customer = s.customer
LEFT JOIN	scheme.nltranm tr WITH(NOLOCK)
ON			s.item_no = tr.journal_number		
LEFT JOIN	scheme.opheadm h WITH(NOLOCK)
ON			h.order_no = s.refernce
LEFT JOIN	SAPMigration.[dbo].[LookUpPaymentDays] pd
ON			cs.credit_category = pd.SageCode
WHERE	UPPER(s.open_indicator) in ('O')
--AND		cs.customer = 'T000058' 

--LEFT JOIN	SAPMigration.dbo.SAPCustomerPaymentTerms

/*
select * from SAPMigration.dbo.SAPCustomerPaymentTerms
select distinct credit_category from scheme.slcustm 
select distinct kind from scheme.slitemm 
--ORDER BY	cs.name, s.due_date
*/


select s.* FROM	
scheme.slitemm s WITH(NOLOCK)
INNER JOIN	scheme.slcustm cs WITH(NOLOCK)
ON			cs.customer = s.customer where  UPPER(open_indicator) in ('O')

--select * from scheme.opheadm where customer = 'T000058'