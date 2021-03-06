
-- CATEGORIES
TRUNCATE TABLE EXPCategoryInformation
DBCC CHECKIDENT(EXPCategoryInformation, reseed, 1)

UPDATE		STKCategories SET Category = Category
SELECT * FROM EXPCategoryInformation


-- PROMOTIONS - HEADER
TRUNCATE TABLE BRAPromotions
DBCC CHECKIDENT(BRAPromotions, reseed, 1)


TRUNCATE TABLE EXPOfferMasterInformation
DBCC CHECKIDENT(EXPOfferMasterInformation, reseed, 1)
SELECT * FROM EXPOfferMasterInformation order by BranchCode, OfferCode

TRUNCATE TABLE EXPOfferSlabInformation
DBCC CHECKIDENT(EXPOfferSlabInformation, reseed, 1)

SELECT * FROM EXPOfferSlabInformation

TRUNCATE TABLE EXPOfferProductInformation
DBCC CHECKIDENT(EXPOfferProductInformation, reseed, 1)

SELECT *  FROM EXPOfferProductInformation

-- LOOP THROUGH EACH PROMO
DECLARE @PRO INT = 1
DECLARE @maxPRO INT = (SELECT MAX(Id) from PROHeader)
WHILE @PRO <= @maxPRO
BEGIN
	UPDATE PROHeader SET ProTypeId = ProTypeId where Id = @PRO
	SET @PRO = @PRO + 1
END	
	
SET @PRO = 1
WHILE @PRO <= @maxPRO
BEGIN
	UPDATE [dbo].[PROLeftSTKHeaders] SET PROHeaderId = PROHeaderId where PROHeaderId = 5 
	SET @PRO = @PRO + 1
END

SET @PRO = 1
WHILE @PRO <= @maxPRO
BEGIN
	UPDATE [dbo].PRORightSTKHeaders SET PROHeaderId = PROHeaderId where PROHeaderId = 10
	SET @PRO = @PRO + 1
END


SELECT * FROM PRORightSTKHeaders