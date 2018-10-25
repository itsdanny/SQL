/****** Script for SelectTopNRows command from SSMS  ******/
SELECT		p.CCGCode as CCGCode, p.Name, Address1, Address2, Address3, Address4, PostCode, c.Code, c.Name, ShortName, NDM, Territory, RBM
FROM		CCGLookup c
LEFT JOIN	Practice p
ON			c.Code = p.CCGCode 
