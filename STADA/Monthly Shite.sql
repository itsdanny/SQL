use SAPMigration
--GO

--SELECT	DISTINCT '2274' AS [SAP Company Code],
--			cs.customer AS[Sage Customer No.],
--			'31.12.2017' AS [Posting Date Data Takeover],
--			CASE s.kind WHEN 'INV' THEN '01' WHEN 'JRN' THEN 
--				CASE WHEN s.unall_curr_amount < 0 THEN '14' ELSE '04' END  
--			WHEN 'CSH' THEN 
--				CASE WHEN s.unall_curr_amount < 0 THEN '15' ELSE '05' END  
--			ELSE '11' END AS [SAP Posting Key], 
--			CONVERT(VARCHAR, s.effective_date, 104) AS [Sage Invoice Date], 
--			CASE cs.currency WHEN '' THEN 'GBP' ELSE cs.currency END AS [Currency],
--			'S2000' AS [SAP SEG Code for Brands],
--			 ABS(s.unall_curr_amount) AS [Amount in document CCY Brand],
--			CASE cs.currency WHEN '' THEN '/' ELSE CAST(ABS(s.unall_amount) AS VARCHAR) END AS [Amount In GBP For Brand],
--			'S1000' AS [SAP SEG Code for Generics],
--			'/' AS [Amount in document CCY Generics],
--			'/' AS [Amount In GBP For Generics],
--			s.item_no AS [Sage Invoice Number],
--			CASE s.kind WHEN 'INV' THEN 'INVOICE' WHEN 'CRN' THEN 'CREDIT NOTE' WHEN 'CSH' THEN 'CASH' WHEN 'JRN' THEN 'JOURNAL' END AS [Sage Posting text],
--			CONVERT(VARCHAR, s.due_date, 104) AS [Payment Baseline Date],
--			'/' AS [Days granted],
--			'/' AS [Cash Discount %], 
--			'/' AS [Partner Bank Type],
--			'/' AS [SAP Payment Block Key],
--			tr.journal_number [SAGE Accounting Doc No.],
--			--CASE WHEN CONVERT(VARCHAR, s.due_date, 104) IS NULL THEN '/' ELSE 
--			--	CASE WHEN DATEDIFF(D, s.due_date, '2015-12-31') < 14 THEN '1' 
--			--		 WHEN DATEDIFF(D, s.due_date, '2015-12-31') > 28 THEN '3' ELSE '2' END END AS [Reminder Level],
--			'/' AS [Reminder Level],
--			'/' [Last Reminder Date],
--			'/' [SAP Reminder Block Key],
--			'/' [SCB Indicator],
--			'/' [End Of Line Code] INTO CustomerOpenItems
--FROM		syslive.scheme.slitemm s WITH(NOLOCK)
--INNER JOIN	syslive.scheme.slcustm cs WITH(NOLOCK)
--ON			cs.customer = s.customer
--LEFT JOIN	syslive.scheme.nltranm tr WITH(NOLOCK)
--ON			s.item_no = tr.journal_number		
--LEFT JOIN	syslive.scheme.opheadm h WITH(NOLOCK)
--ON			h.order_no = s.refernce
----LEFT JOIN	SAPMigration.[dbo].[LookUpPaymentDays] pds
----ON			cs.credit_category = pds.SageCode
--WHERE		UPPER(s.open_indicator) in ('O')
--AND			(s.unall_curr_amount <> 0
--OR			s.unall_amount <> 0)
----	sp_CustomerOpenItems


SELECT		c.Customer, c.[Name 1], c.Country, c.[Industry code], p.[Risk Class],
			m.item_no,
			m.kind AS DocType,
			ABS(m.unall_curr_amount) AS Amount,
			CASE  s.currency WHEN '' THEN 'GBP' ELSE s.currency END AS [Currency],
			m.dated,
			m.due_date,
			g.[Customer Cr. Grp]

FROM		syslive.scheme.slitemm m
INNER JOIN 	CustomerBasicData c
ON			m.customer = c.Customer
INNER JOIN 	[dbo].[CustProfileData] p
ON			m.customer = p.PARTNER
INNER JOIN 	syslive.scheme.slcustm s
ON			c.Customer = s.customer
INNER JOIN 	CustCreditGroup g
ON			c.Customer = g.customer
WHERE		m.open_indicator = 'O'
