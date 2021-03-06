USE [VapeConnect]
GO
/****** Object:  StoredProcedure [dbo].[sp_GetSKUPriceWithoutVAT]    Script Date: 20/02/2017 10:15:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp_GetSKUPriceWithoutVAT]
		@Mode varchar(2),
		@SKU varchar(20),
		@PriceWithVAT float,
		@CustomerVATType varchar(5),
		@PriceWithoutVAT float OUTPUT
AS

DECLARE @SKUVATCode varchar(5)
DECLARE @VATRate float

-- First Look up Product / SKU Vat Code
Select @SKUVATCode = VATCode from dbo.STKHeader where SKU = @SKU

-- Now look  up VAT Rate from both Customer and SKU code
Select @VATRate = [Percentage] from dbo.SYSVAT where VatCode = @SKUVATCode and VatType = @CustomerVATType

If @VATRate IS Null
	BEGIN
		Select @VATRate = KeyValue from SYSSettings where KeyRef = 'SOPVATRATE'
	END

-- Finally, calculate the price WITHOUT VAT
Set @PriceWithoutVAT = (@PriceWithVAT / (100 + @VATRate)) * 100

GO

SELECT (2.00 / (100 + 20)) * 100
SELECT (5.00 / (100 + 20)) * 100

SELECT 2.00 / 1.20
SELECT 5.00 / 1.20



SELECT product, description, long_description, price, analysis_c AS Strength FROM slam.scheme.stockm WHERE		description LIKE	'%USA%EJ%'
