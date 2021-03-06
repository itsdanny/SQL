USE [Forecasting]
GO
/****** Object:  StoredProcedure [dbo].[sp__forecast_versus_demand_by_brand_manager]    Script Date: 19/09/2014 12:51:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Mark Carlile
-- Create date: 16th March 2011
-- Description:	This stored proceedure is used by the Forecast Exception Report By Brand Manager
-- =============================================
ALTER PROCEDURE [dbo].[sp__issued_versus_demand_by_brand_manager]
	@username varchar(250) = NULL,
	@type varchar(3),
	@year int,
	@period int,
	@forecastQuarterValue int

AS
BEGIN

-- sp__issued_versus_demand_by_brand_manager 'Nathan Mooney' ,'EX', 2014, 9,0
	SET NOCOUNT ON;
	
	DECLARE @BrandManagerId int
	IF @username IS NOT NULL
	SET @BrandManagerId = (SELECT Id FROM BrandManager WHERE Name = @username)
	
	DECLARE @CurrentPeriod int
	DECLARE @PeriodPlus1 int
	DECLARE @PeriodPlus2 int
	DECLARE @PeriodPlus3 int

	SET @CurrentPeriod = (SELECT Period.Id FROM Period WHERE (Period.Year = @year) AND (Period.Period = @period))
	SET @PeriodPlus1 = (@CurrentPeriod + 1)
	SET @PeriodPlus2 = (@CurrentPeriod + 2)
	SET @PeriodPlus3 = (@CurrentPeriod + 3)
	
	DECLARE @ForecastTypeId int
	DECLARE @DemandTypeId int
	DECLARE @IssuesTypeId int
		
	IF @type = 'UK'
	BEGIN
		SET @ForecastTypeId = (SELECT Id FROM ForecastType WHERE (Type = 'FUK'))
		SET @DemandTypeId = (SELECT Id FROM ForecastType WHERE (Type = 'DUK'))
		SET @IssuesTypeId = (SELECT Id FROM ForecastType WHERE (Type = 'IUK'))
	END
	ELSE
	BEGIN
		SET @ForecastTypeId = (SELECT Id FROM ForecastType WHERE (Type = 'FEX'))
		SET @DemandTypeId = (SELECT Id FROM ForecastType WHERE (Type = 'DEX'))
		SET @IssuesTypeId = (SELECT Id FROM ForecastType WHERE (Type = 'IEX'))
	END

					SELECT		Product.ProductCode, Product.Description,
                          (SELECT     TOP (1) Brand.Name
                            FROM          Brand INNER JOIN BrandProduct ON Brand.Id = BrandProduct.BrandId
                            WHERE      (BrandProduct.ProductCode = Product.ProductCode)) AS BrandName
							
							,ISNULL((SELECT SUM(Qty) AS Qty FROM Forecast AS Forecast_15 WHERE (ProductCode = Product.ProductCode) AND (ForecastTypeId = @ForecastTypeId) AND (PeriodId = @PeriodPlus3)), 0) AS PeriodPlus3Forecast
							,ISNULL((SELECT SUM(Qty) AS Qty FROM Forecast AS Forecast_14 WHERE (ProductCode = Product.ProductCode) AND (ForecastTypeId = @DemandTypeId) AND (PeriodId = @PeriodPlus3)), 0) AS PeriodPlus3Demand
							--,ISNULL((SELECT SUM(Qty) AS Qty FROM Forecast AS Forecast_13 WHERE (ProductCode = Product.ProductCode) AND (ForecastTypeId = @IssuesTypeId) AND (PeriodId = @PeriodPlus3)), 0) AS PeriodPlus3Issued

							,ISNULL((SELECT SUM(Qty) AS Qty FROM Forecast AS Forecast_12 WHERE (ProductCode = Product.ProductCode) AND (ForecastTypeId = @ForecastTypeId) AND (PeriodId = @PeriodPlus2)), 0) AS PeriodPlus2Forecast
							,ISNULL((SELECT SUM(Qty) AS Qty FROM Forecast AS Forecast_11 WHERE (ProductCode = Product.ProductCode) AND (ForecastTypeId = @DemandTypeId) AND (PeriodId = @PeriodPlus2)), 0) AS PeriodPlus2Demand
						--	,ISNULL((SELECT SUM(Qty) AS Qty FROM Forecast AS Forecast_10 WHERE (ProductCode = Product.ProductCode) AND (ForecastTypeId = @IssuesTypeId) AND (PeriodId = @PeriodPlus2)), 0) AS PeriodPlus2Issued
							
							,ISNULL((SELECT SUM(Qty) AS Qty FROM Forecast AS Forecast_9 WHERE (ProductCode = Product.ProductCode) AND (ForecastTypeId = @ForecastTypeId) AND (PeriodId = @PeriodPlus1)), 0) AS nextPeriodForecast
							,ISNULL((SELECT SUM(Qty) AS Qty FROM Forecast AS Forecast_8 WHERE (ProductCode = Product.ProductCode) AND (ForecastTypeId = @DemandTypeId) AND (PeriodId = @PeriodPlus1)), 0) AS nextPeriodDemand
							--,ISNULL((SELECT SUM(Qty) AS Qty FROM Forecast AS Forecast_7 WHERE (ProductCode = Product.ProductCode) AND (ForecastTypeId = @IssuesTypeId) AND (PeriodId = @PeriodPlus1)), 0) AS nextPeriodIssued

							,ISNULL((SELECT SUM(Qty) AS Qty FROM  Forecast AS Forecast_6 WHERE (ProductCode = Product.ProductCode) AND (ForecastTypeId = @ForecastTypeId) AND (PeriodId = @CurrentPeriod)), 0) AS Forecast
							,ISNULL((SELECT SUM(Qty) AS Qty FROM Forecast AS Forecast_5 WHERE (ProductCode = Product.ProductCode) AND (ForecastTypeId = @DemandTypeId) AND (PeriodId = @CurrentPeriod)), 0) AS Demand
							--,ISNULL((SELECT SUM(Qty) AS Qty FROM Forecast AS Forecast_4  WHERE (ProductCode = Product.ProductCode) AND (ForecastTypeId = @IssuesTypeId) AND (PeriodId = @CurrentPeriod)), 0) AS Issues

							,ISNULL((SELECT SUM(Qty) AS Qty FROM Forecast AS Forecast_3 WHERE (ProductCode = Product.ProductCode) AND (ForecastTypeId = @ForecastTypeId) AND (PeriodId IN (@CurrentPeriod, @PeriodPlus1, @PeriodPlus2))), 0) AS ForecastQtr
							,ISNULL((SELECT SUM(Qty) AS Qty FROM Forecast AS Forecast_2 WHERE (ProductCode = Product.ProductCode) AND (ForecastTypeId = @DemandTypeId) AND (PeriodId IN (@CurrentPeriod, @PeriodPlus1, @PeriodPlus2))), 0) AS DemandQtr
						--	,ISNULL((SELECT SUM(Qty) AS Qty FROM Forecast AS Forecast_1 WHERE  (ProductCode = Product.ProductCode) AND (ForecastTypeId = @IssuesTypeId) AND (PeriodId IN (@CurrentPeriod, @PeriodPlus1, @PeriodPlus2))), 0) AS IssuesQtr
							into #For
FROM		Product LEFT JOIN BrandManagerProduct 
ON			Product.ProductCode = BrandManagerProduct.ProductCode
WHERE		(BrandManagerProduct.BrandManagerId  IS NULL OR BrandManagerProduct.BrandManagerId = @BrandManagerId)

SELECT * FROM #For
END
go

 sp__issued_versus_demand_by_brand_manager NULL, 'EX', 2014, 9,0
