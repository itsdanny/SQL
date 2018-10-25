SELECT	*
FROM		syslive.scheme.polistm WITH(NOLOCK)
WHERE	customer_code IN ('T4444','T5398') 
ORDER BY	customer_code

SELECT	*
FROM		SAPMigration.dbo.PIRSpecificationMasterData
WHERE		Product IN ( '005932','24242902')
ORDER BY	Product


SELECT	*
FROM		SAPMigration.dbo.ConditionsSales_105
WHERE		Material IN ( '005932','24242902')
ORDER BY	Material, Counter


SELECT	*
FROM		syslive.scheme.podscntm
WHERE		prod_disc_code IN ( '005932','242429')
