ALTER PROCEDURE sp_rpt_IGBKFGControlledDrugsYields
@FromDate	DATETIME = NULL,
@ToDate		DATETIME = NULL
AS

IF @FromDate IS NULL
SET @FromDate = DATEADD(yy, DATEDIFF(yy,0,getdate())-1, 0)

IF @ToDate IS NULL
SET @ToDate =  DATEADD(yy, DATEDIFF(yy,0,getdate()), 0)-1

DECLARE @CONTDRUGS  TABLE(Warehouse VARCHAR(2), Product VARCHAR(10), BaseProductCode VARCHAR(8), BaseDescription VARCHAR(40), Alpha VARCHAR(10), unit_code VARCHAR(5), PackSize INT, LongDescription VARCHAR(40), 
						 analysis_c VARCHAR(10),
						 Base_g FLOAT,			
						 FGYieldQty FLOAT,  
						 FGYield_g FLOAT						 
						 )


	INSERT INTO @CONTDRUGS(Warehouse, Product, Alpha, unit_code, LongDescription, BaseProductCode, BaseDescription, Base_g, PackSize) 
	SELECT		s.warehouse, FGCode, s.alpha, s.unit_code, c.FGProductDescription, IGCode, c.IGProductDescription, FGBase_g, u.spare
	FROM		ContDrugsImport c 
	INNER JOIN	scheme.stockm s WITH(NOLOCK)
	ON			c.FGCode = s.product 
	INNER JOIN	scheme.stunitdm u WITH(NOLOCK)
	ON			s.unit_code = u.unit_code	
	--WHERE		c.IGCode IN ('073709','100349')
	AND			s.warehouse = 'FG'

	SELECT * FROM @CONTDRUGS

	GO
