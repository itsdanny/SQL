  update [dbo].[EXPBranchInformation]		set Processed = 1, ProcessedDateTime = GETDATE() where BranchCode <> 'TESTVILLE'
  update [dbo].[EXPCategoryInformation]		set Processed = 1, ProcessedDateTime = GETDATE() where BranchCode <> 'TESTVILLE'
  update [dbo].[EXPOfferMasterInformation]	set Processed = 1, ProcessedDateTime = GETDATE() where BranchCode <> 'TESTVILLE'
  update [dbo].[EXPOfferProductInformation]	set Processed = 1, ProcessedDateTime = GETDATE() where BranchCode <> 'TESTVILLE'
  update [dbo].[EXPOfferSlabInformation]	set Processed = 1, ProcessedDateTime = GETDATE() where BranchCode <> 'TESTVILLE'
  update [dbo].[EXPProductInformation]		set Processed = 1, ProcessedDateTime = GETDATE() where BranchCode <> 'TESTVILLE' 
  update [dbo].[EXPProductPriceInformation]	set Processed = 1, ProcessedDateTime = GETDATE() where BranchCode <> 'TESTVILLE'



--SELECT * FROM [EXPBranchInformation]	where BranchCode = 'TESTVILLE' -- 
--SELECT * FROM [EXPCategoryInformation]	where BranchCode = 'TESTVILLE' --
--SELECT * FROM [EXPProductInformation]	where BranchCode = 'TESTVILLE' --
--SELECT * FROM [EXPOfferMasterInformation]	where BranchCode = 'TESTVILLE'
--SELECT * FROM [EXPOfferSlabInformation]		where BranchCode = 'TESTVILLE'
SELECT * FROM [EXPOfferProductInformation]	where BranchCode = 'TESTVILLE' and Side = 'Right'
SELECT * FROM [EXPProductPriceInformation]	where BranchCode = 'TESTVILLE'
