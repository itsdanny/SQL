select * from EXPEPOSNowCategoryInformation

truncate table EXPEPOSNowCategoryInformation

dbcc checkident(EXPEPOSNowCategoryInformation, reseed, 1)

truncate table [STKEPOSNowCategories]
dbcc checkident([STKEPOSNowCategories], reseed, 1)
GO
[sp_Sync_STKEPOSNowCategories]


UPDATE  dbo.STKHeader SET LongDescription = LongDescription
[dbo].[sp_Sync_STKHeader]
DELETE from EXPProductInformation WHERE ProductCode like 'PV%'

TRUNCATE TABLE STKHeader