
UPDATE 	c
      SET    c.[comp_sap_company_code] = isnull(m.Customer, '')
	  FROM	[Company] c
	  INNER JOIN 	[CRM_Test].[dbo].SAPMasterCustomerLookup m
	  ON		c.comp_dcl_accountnumber = m.[Identification number]




UPDATE 		p
SET			p.[prod_sap_product_code] = ISNULL(m.Material, '')
FROM		NewProduct p
INNER JOIN 	[CRM_Test].[dbo].SAPMasterMaterialLookup m
ON			p.prod_code = m.[Mat# Identificationnumber]


ALTER VIEW [dbo].[vNewProducts] AS  SELECT * FROM NewProduct where Prod_deleted is null

