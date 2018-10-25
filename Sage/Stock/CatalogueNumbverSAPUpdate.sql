
UPDATE 	syslive.scheme.stockm SET catalogue_number = '' WHERE			1=1 

UPDATE 			b
SET				b.catalogue_number = m.Material
FROM			syslive.scheme.stockm b WITH(NOLOCK) 
INNER JOIN 		SAPMasterMaterialLookup m
ON				m.[Mat# Identificationnumber]= b.product
--AND				m.MTyp = dbo.fn_material_type(b.warehouse, b.product)
WHERE			b.catalogue_number <> m.Material

UPDATE 	syslive.scheme.stockm SET catalogue_number = '' WHERE	analysis_a = 'ZZZZ'  AND	catalogue_number != ''
UPDATE 	syslive.scheme.stockm SET catalogue_number = '' WHERE	analysis_a = 'TPTY' AND	warehouse = 'IG'  AND	catalogue_number != ''
UPDATE 	syslive.scheme.stockm SET catalogue_number = '' WHERE	warehouse IN ('RY','JS')  AND	catalogue_number != ''

