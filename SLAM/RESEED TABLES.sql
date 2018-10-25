exec VapeConnectTest..sp_Sync_STKHeader
DECLARE @SKU VARCHAR(20) = 'EJ-FVTEST-09'
select drawing_number from demo.scheme.stockm where product = @SKU
SELECT  * FROM STKHeader WHERE SKU = @SKU
select * from VapeConnectTest.dbo.EXPProductInformation where ProductCode = @SKU

USE VapeConnectTest
TRUNCATE TABLE EXPBranchInformation
TRUNCATE TABLE EXPCategoryInformation
TRUNCATE TABLE EXPOfferMasterInformation
TRUNCATE TABLE EXPOfferProductInformation
TRUNCATE TABLE EXPOfferSlabInformation
TRUNCATE TABLE EXPProductInformation
TRUNCATE TABLE EXPProductPriceInformation
TRUNCATE TABLE EXPWebSocInvUpdate
TRUNCATE TABLE EXPWebSocPrcUpdate


DBCC CHECKIDENT(EXPBranchInformation, RESEED,1)
DBCC CHECKIDENT(EXPCategoryInformation, RESEED,1)
DBCC CHECKIDENT(EXPOfferMasterInformation, RESEED,1)
DBCC CHECKIDENT(EXPOfferProductInformation, RESEED,1)
DBCC CHECKIDENT(EXPOfferSlabInformation, RESEED,1)
DBCC CHECKIDENT(EXPProductInformation, RESEED,1)
DBCC CHECKIDENT(EXPProductPriceInformation, RESEED,1)
DBCC CHECKIDENT(EXPWebSocInvUpdate, RESEED,1)
DBCC CHECKIDENT(EXPWebSocPrcUpdate, RESEED,1)

select * from STKCategories WHERE BrandId = 1
SELECT * FROM BRAHeader  WHERE Id = 1
SELECT * FROM BRACategories WHERE BRAHeaderId = 1 
SELECT * FROM BRACategories WHERE STKCategoryId = 91
SELECT * FROM BRACategories WHERE BRAHeaderId = 1 AND [STKCategoryId] = 91

SELECT * FROM [dbo].[EXPCategoryInformation] ORDER BY Id DESC-- SELECT * NOT WORKING.

truncate table BRACategories
dbcc checkident(BRACategories,reseed,1)

truncate table [EXPCategoryInformation]
dbcc checkident([EXPCategoryInformation], reseed,1)


select * from EXPProductInformation