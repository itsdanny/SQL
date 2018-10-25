-- get invoice customer 
DECLARE @INVCustomers TABLE (customer VARCHAR(10))
INSERT INTO @INVCustomers(customer)
SELECT		distinct 
			c.invoice_customer			
FROM		scheme.slcustm c WITH(NOLOCK)
LEFT JOIN	scheme.slcustem ce WITH(NOLOCK)
ON			c.customer = ce.customer
INNER JOIN	scheme.opheadm h WITH(NOLOCK)
ON			c.customer = h.customer
INNER JOIN	scheme.opdetm d WITH(NOLOCK)
ON			h.order_no = d.order_no
LEFT JOIN	[SAPMigration].dbo.LookupDistributionChannel sp
ON			c.class = sp.SageDistributionGroupCode
LEFT JOIN	[SAPMigration].dbo.LookupCustomerType ct
ON			c.analysis_code_6 = ct.SageTypeCode
WHERE		h.date_entered >= DATEADD(month, -18, getdate())
AND			c.customer LIKE 'T00%'
AND			c.invoice_customer <> ''


SELECT * FROM 
(SELECT		distinct 
			'Invoice Customer' as CustomerType,
			c.territory,
			c.cust_disc_code,
	c.customer,
			c.invoice_customer,
			c.name as Customer_Name,
			c.address1,
			c.address2,
			c.address3,
			c.address4,
			ce.vatstate as Country,
			c.address6,
			c.address5 AS Telephone,
			c.email,
			c.btx [btx Not Migrated],
			c.fax,
			c.telex [Telex Not Migrated],
			REPLACE(sp.SageDistributionGroupCode, CHAR(9),'') AS SageDistributionGroupCode, 
			REPLACE(sp.SageDistributionGroupDescription, CHAR(9),' ') AS SageDistributionGroupDescription,
			ct.SageTypeCode, 
			REPLACE(ct.SageTypeDescription, CHAR(9),' ') AS SageTypeDescription
FROM		scheme.slcustm c WITH(NOLOCK)
INNER JOIN	@INVCustomers ic
ON			c.customer = ic.customer
LEFT JOIN	scheme.slcustem ce WITH(NOLOCK)
ON			c.customer = ce.customer
INNER JOIN	scheme.opheadm h WITH(NOLOCK)
ON			c.customer = h.customer
INNER JOIN	scheme.opdetm d WITH(NOLOCK)
ON			h.order_no = d.order_no
LEFT JOIN	[SAPMigration].dbo.LookupDistributionChannel sp
ON			c.class = sp.SageDistributionGroupCode
LEFT JOIN	[SAPMigration].dbo.LookupCustomerType ct
ON			c.analysis_code_6 = ct.SageTypeCode
WHERE		h.date_entered >= DATEADD(month, -18, getdate())
UNION ALL
SELECT		distinct 
			'Shipping Customer' as CustomerType,
			c.territory,
			c.cust_disc_code,
			c.customer,
			c.invoice_customer,
			c.name as Customer_Name,
			c.address1,
			c.address2,
			c.address3,
			c.address4,
			ce.vatstate as Country,
			c.address6,
			c.address5 AS Telephone,
			c.email,
			c.btx [btx Not Migrated],
			c.fax,
			c.telex [Telex Not Migrated],
			REPLACE(sp.SageDistributionGroupCode, CHAR(9),'') AS SageDistributionGroupCode, 
			REPLACE(sp.SageDistributionGroupDescription, CHAR(9),' ') AS SageDistributionGroupDescription,
			ct.SageTypeCode, ct.SageTypeDescription			
FROM		scheme.slcustm c WITH(NOLOCK)
LEFT JOIN	scheme.slcustem ce WITH(NOLOCK)
ON			c.customer = ce.customer
INNER JOIN	scheme.opheadm h WITH(NOLOCK)
ON			c.customer = h.customer
INNER JOIN	scheme.opdetm d WITH(NOLOCK)
ON			h.order_no = d.order_no
LEFT JOIN	[SAPMigration].dbo.LookupDistributionChannel sp
ON			c.class = sp.SageDistributionGroupCode
LEFT JOIN	[SAPMigration].dbo.LookupCustomerType ct
ON			c.analysis_code_6 = ct.SageTypeCode
WHERE		h.date_entered >= DATEADD(month, -18, getdate())
AND			c.customer  LIKE 'T00%') C
ORDER BY	Customer_Name, invoice_customer

SELECT		DISTINCT c.territory,
			c.cust_disc_code,
			c.customer,
			c.invoice_customer,
			c.name as Customer_Name,
			c.address1,
			c.address2,
			c.address3,
			c.address4,			
			c.address6,
			c.address5 AS Telephone,
			c.email,
			c.btx [btx Not Migrated],
			c.fax,
			c.telex [Telex Not Migrated],
			REPLACE(sp.SageDistributionGroupCode, CHAR(9),'') AS SageDistributionGroupCode, 
			REPLACE(sp.SageDistributionGroupDescription, CHAR(9),' ') AS SageDistributionGroupDescription,
			ct.SageTypeCode, ct.SageTypeDescription			
FROM		syslive.scheme.slcustm c
INNER JOIN 	syslive.scheme.slitemm i
ON			c.customer = i.customer
LEFT JOIN	[SAPMigration].dbo.LookupDistributionChannel sp
ON			c.class = sp.SageDistributionGroupCode
LEFT JOIN	[SAPMigration].dbo.LookupCustomerType ct
ON			c.analysis_code_6 = ct.SageTypeCode
WHERE		i.dated  >= DATEADD(month, -18, getdate())
AND			(c.customer LIKE 'T000%S' OR	c.customer LIKE 'T000%I')