SELECT		c.alpha, c.customer, name, c.address1, c.address2, c.address3, c.address4, c.address5, c.address6, c.credit_category, c.export_indicator, c.cust_disc_code, c.territory
FROM		syslive.scheme.slcustm c
INNER JOIN 	vw_SapCustomers v
ON			c.customer = v.Customer
LEFT JOIN	[SAPMigration].dbo.LookupDistributionChannel dc
ON			c.class = dc.SageDistributionGroupCode
LEFT JOIN	[SAPMigration].[dbo].[LookUpSAGESAPIndustryCodes] ic
ON			c.analysis_code_6 = ic.[SageTypeCode]

union all
SELECT		DISTINCT c.alpha, c.customer, name, c.address1, c.address2, c.address3, c.address4, c.address5, c.address6, c.credit_category, c.export_indicator, c.cust_disc_code, c.territory
FROM		lcmlive.scheme.opdetm d WITH (NOLOCK)
INNER JOIN  lcmlive.scheme.opheadm h  with (NOLOCK)
ON			d.order_no = h.order_no 
INNER JOIN	lcmlive.scheme.slcustm c WITH(NOLOCK)
ON			h.customer = c.customer
LEFT JOIN	[SAPMigration].dbo.LookupDistributionChannel dc
ON			c.class = dc.SageDistributionGroupCode
LEFT JOIN	[SAPMigration].[dbo].[LookUpSAGESAPIndustryCodes] ic
ON			c.analysis_code_6 = ic.[SageTypeCode]
WHERE		h.date_entered > DATEADD(MONTH, -18, GETDATE())


SELECT * FROM vw_SapCustomers v WHERE		Customer NOT IN (SELECT		DISTINCT c.customer
FROM		syslive.scheme.slcustm c
INNER JOIN 	vw_SapCustomers v
ON			c.customer = v.Customer)