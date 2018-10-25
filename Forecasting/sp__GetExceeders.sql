-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Dan McGregor
-- Create date: 02/Feb/2015
-- Description:	Gets exceeders for forecasting
-- =============================================
CREATE PROCEDURE sp__GetExceeders
	
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT        REPLACE(BrandManager.Name, ' ', '') + '@thorntonross.com' AS EmailAddress, BrandProduct.ProductCode, LTRIM(RTRIM(Product.Description)) AS Description, 
(
	SELECT         ' Qty: ' +  CONVERT(varchar(10), ISNULL(SUM(Forecast.Qty), 0))   AS Total
	FROM            Forecast INNER JOIN
							 Period ON Forecast.PeriodId = Period.Id
	WHERE        (Period.Period =
								 (SELECT        TOP (1) Period
								   FROM            Calendar)) AND (Period.Year =
								 (SELECT        TOP (1) Year
								   FROM            Calendar AS Calendar_1)) AND (Forecast.ForecastTypeId = 1) AND (Forecast.ProductCode = BrandProduct.ProductCode)
) AS Forecast, 
(
	SELECT        ' Qty: ' +  CONVERT(varchar(10), ISNULL(SUM(Forecast.Qty), 0))  AS Total
	FROM            Forecast INNER JOIN
							 Period ON Forecast.PeriodId = Period.Id
	WHERE        (Period.Period =
								 (SELECT        TOP (1) Period
								   FROM            Calendar)) AND (Period.Year =
								 (SELECT        TOP (1) Year
								   FROM            Calendar AS Calendar_1)) AND (Forecast.ForecastTypeId = 3) AND (Forecast.ProductCode = BrandProduct.ProductCode)
) AS Invoiced
FROM            Brand INNER JOIN
                         BrandProduct ON Brand.Id = BrandProduct.BrandId INNER JOIN
                         BrandManagerProduct ON BrandProduct.ProductCode = BrandManagerProduct.ProductCode INNER JOIN
                         BrandManager ON BrandManagerProduct.BrandManagerId = BrandManager.Id INNER JOIN 					 Product ON BrandProduct.ProductCode = Product.ProductCode
WHERE        (BrandProduct.ProductCode IN
                             (SELECT        ProductCode
                               FROM            Forecast
                               WHERE        (PeriodId =
                                                             (SELECT        TOP (1) Period.Id
                                                               FROM            Calendar INNER JOIN
                                                                                         Period ON Calendar.Year = Period.Year AND Calendar.Period = Period.Period)) AND (ForecastTypeId = 1) AND (Qty <
                                                             (SELECT        Qty
                                                               FROM            Forecast AS Forecast_1
                                                               WHERE        (PeriodId =
                                                                                             (SELECT        TOP (1) Period_1.Id
                                                                                               FROM            Calendar AS Calendar_1 INNER JOIN
                                                                                                                         Period AS Period_1 ON Calendar_1.Year = Period_1.Year AND Calendar_1.Period = Period_1.Period)) AND 
                                                                                         (ForecastTypeId = 3) AND (forecast.productCode = ProductCode)))))
GROUP BY BrandManager.Name, BrandProduct.ProductCode, Product.Description
END
GO
