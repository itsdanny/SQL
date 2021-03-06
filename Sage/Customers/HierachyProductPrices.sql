DECLARE @Res TABLE([Product Disc Band] VARCHAR(3), product VARCHAR(10), long_description VARCHAR(40), unit_code VARCHAR(5), price FLOAT , TRListPrice FLOAT , CustPrice FLOAT , [Discount %] VARCHAR(5))
INSERT INTO @Res
SELECT		DISTINCT	
			s.discount [Product Disc Band], s.product, s.long_description, s.unit_code, s.price, '' TRListPrice, 			
			CAST(replace(c.Price, ',','.') AS FLOAT) AS CustPrice,
			'' [Discount %] 
FROM		CustomerConditions_A943_100 c
INNER JOIN 	syslive.[scheme].stockm s WITH(NOLOCK)
ON			c.[material number] = s.product
INNER JOIN 	syslive.scheme.oplistm l WITH(NOLOCK)
ON			s.product = l.product_code
WHERE		[Customer hierarchy] ='09'
AND			s.warehouse = 'FG'

INSERT INTO @Res
SELECT		DISTINCT	
			ProdDiscCode AS [Product Disc Band], s.product, s.long_description, s.unit_code, 
			s.price StandardPrice, l.price TRListPrice,
			l.price	*(100-CAST(replace([Rate (condition amount or percentage) where no scale exists], ',','.') AS FLOAT))/100 AS [% Discount Price],
			CAST(replace([Rate (condition amount or percentage) where no scale exists], ',','.') AS FLOAT) AS [Discount%]
FROM		SalesConditions_98 c
INNER JOIN 	syslive.[scheme].stockm s WITH(NOLOCK)
ON			c.ProdDiscCode = s.discount
INNER JOIN 	syslive.scheme.oplistm l WITH(NOLOCK)
ON			s.product = l.product_code
WHERE		[Customer hierarchy] = '09'
AND			l.price_list ='TR'
AND			s.warehouse = 'FG'
AND			s.product NOT IN (SELECT	product
   			                  FROM		@Res)

SELECT	*
FROM		@Res

sp_getFutureWorkCentreJobs



