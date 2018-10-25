sp__forecast_versus_demand_by_brand_manager "Denika Fletcher","UK", 2014,3,0


DECLARE	@username varchar(250)
DECLARE	@type varchar(3)
DECLARE	@year int
DECLARE	@period int
DECLARE	@forecastQuarterValue int

SET @year = 2014
SET @period = 3
SET @type = 'UK'
SET @forecastQuarterValue = 0
BEGIN
	DECLARE @BrandManagerId int
	
	SET @BrandManagerId = (SELECT Id FROM BrandManager WHERE Name = 'Denika Fletcher')

	DECLARE @CurrentPeriod int
	DECLARE @PeriodMinus1 int
	DECLARE @PeriodMinus2 int

	SET @CurrentPeriod = (SELECT Period.Id FROM Period WHERE (Period.Year = @year) AND (Period.Period = @period))
	SET @PeriodMinus1 = (@CurrentPeriod - 1)
	SET @PeriodMinus2 = (@CurrentPeriod - 2)
	
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
	
SELECT		BrandManagerProduct.BrandManagerId, Product.ProductCode, Product.Description,
                          (SELECT     TOP (1) Brand.Name
                            FROM          Brand INNER JOIN
                                                   BrandProduct ON Brand.Id = BrandProduct.BrandId
                            WHERE      (BrandProduct.ProductCode = Product.ProductCode)) AS BrandName, ISNULL
                          ((SELECT     SUM(Qty) AS Qty
                              FROM         Forecast
                              WHERE     (ProductCode = Product.ProductCode) AND (ForecastTypeId = @ForecastTypeId) AND (PeriodId = @CurrentPeriod)), 0) AS Forecast, ISNULL
                          ((SELECT     SUM(Qty) AS Qty
                              FROM         Forecast AS Forecast_5
                              WHERE     (ProductCode = Product.ProductCode) AND (ForecastTypeId = @DemandTypeId) AND (PeriodId = @CurrentPeriod)), 0) AS Demand, ISNULL
                          ((SELECT     SUM(Qty) AS Qty
                              FROM         Forecast AS Forecast_4
                              WHERE     (ProductCode = Product.ProductCode) AND (ForecastTypeId = @IssuesTypeId) AND (PeriodId = @CurrentPeriod)), 0) AS Issues, ISNULL
                          ((SELECT     SUM(Qty) AS Qty
                              FROM         Forecast AS Forecast_3
                              WHERE     (ProductCode = Product.ProductCode) AND (ForecastTypeId = @ForecastTypeId) AND (PeriodId IN (@CurrentPeriod, @PeriodMinus1, @PeriodMinus2))), 0) AS ForecastQtr, ISNULL
                          ((SELECT     SUM(Qty) AS Qty
                              FROM         Forecast AS Forecast_2
                              WHERE     (ProductCode = Product.ProductCode) AND (ForecastTypeId = @DemandTypeId) AND (PeriodId IN (@CurrentPeriod, @PeriodMinus1, @PeriodMinus2))), 0) AS DemandQtr, ISNULL
                          ((SELECT     SUM(Qty) AS Qty
                              FROM         Forecast AS Forecast_1
                              WHERE     (ProductCode = Product.ProductCode) AND (ForecastTypeId = @IssuesTypeId) AND (PeriodId IN (@CurrentPeriod, @PeriodMinus1, @PeriodMinus2))), 0) AS IssuesQtr


							,ISNULL((SELECT SUM(Qty) AS Qty FROM Forecast AS Forecast_12 WHERE (ProductCode = Product.ProductCode) AND (ForecastTypeId = @ForecastTypeId) AND (PeriodId = @PeriodMinus2)), 0) AS PeriodMinus2Forecast
							,ISNULL((SELECT SUM(Qty) AS Qty FROM Forecast AS Forecast_11 WHERE (ProductCode = Product.ProductCode) AND (ForecastTypeId = @DemandTypeId) AND (PeriodId = @PeriodMinus2)), 0) AS PeriodMinus2Demand
							,ISNULL((SELECT SUM(Qty) AS Qty FROM Forecast AS Forecast_10 WHERE (ProductCode = Product.ProductCode) AND (ForecastTypeId = @IssuesTypeId) AND (PeriodId = @PeriodMinus2)), 0) AS PeriodMinus2Issued
							
							,ISNULL((SELECT SUM(Qty) AS Qty FROM Forecast AS Forecast_9 WHERE (ProductCode = Product.ProductCode) AND (ForecastTypeId = @ForecastTypeId) AND (PeriodId = @PeriodMinus1)), 0) AS lastPeriodForecast
							,ISNULL((SELECT SUM(Qty) AS Qty FROM Forecast AS Forecast_8 WHERE (ProductCode = Product.ProductCode) AND (ForecastTypeId = @DemandTypeId) AND (PeriodId = @PeriodMinus1)), 0) AS lastPeriodDemand
							,ISNULL((SELECT SUM(Qty) AS Qty FROM Forecast AS Forecast_7 WHERE (ProductCode = Product.ProductCode) AND (ForecastTypeId = @IssuesTypeId) AND (PeriodId = @PeriodMinus1)), 0) AS lastPeriodIssued

							,ISNULL((SELECT SUM(Qty) AS Qty FROM  Forecast AS Forecast_6 WHERE (ProductCode = Product.ProductCode) AND (ForecastTypeId = @ForecastTypeId) AND (PeriodId = @CurrentPeriod)), 0) AS Forecast
							,ISNULL((SELECT SUM(Qty) AS Qty FROM Forecast AS Forecast_5 WHERE (ProductCode = Product.ProductCode) AND (ForecastTypeId = @DemandTypeId) AND (PeriodId = @CurrentPeriod)), 0) AS Demand
							,ISNULL((SELECT SUM(Qty) AS Qty FROM Forecast AS Forecast_4  WHERE (ProductCode = Product.ProductCode) AND (ForecastTypeId = @IssuesTypeId) AND (PeriodId = @CurrentPeriod)), 0) AS Issues

							,ISNULL((SELECT SUM(Qty) AS Qty FROM Forecast AS Forecast_3 WHERE (ProductCode = Product.ProductCode) AND (ForecastTypeId = @ForecastTypeId) AND (PeriodId IN (@CurrentPeriod, @PeriodMinus1, @PeriodMinus2))), 0) AS ForecastQtr
							,ISNULL((SELECT SUM(Qty) AS Qty FROM Forecast AS Forecast_2 WHERE (ProductCode = Product.ProductCode) AND (ForecastTypeId = @DemandTypeId) AND (PeriodId IN (@CurrentPeriod, @PeriodMinus1, @PeriodMinus2))), 0) AS DemandQtr
							,ISNULL((SELECT SUM(Qty) AS Qty FROM Forecast AS Forecast_1 WHERE  (ProductCode = Product.ProductCode) AND (ForecastTypeId = @IssuesTypeId) AND (PeriodId IN (@CurrentPeriod, @PeriodMinus1, @PeriodMinus2))), 0) AS IssuesQtr
FROM		Product INNER JOIN BrandManagerProduct ON Product.ProductCode = BrandManagerProduct.ProductCode
WHERE		(BrandManagerProduct.BrandManagerId = @BrandManagerId)
END

/*
SELECT * FROM BrandManagerProduct WHERE BrandManagerId = 21
'072117','072109','072125','072141','072133','072168','072001','072028'*/