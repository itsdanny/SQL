USE [Forecasting]
GO
/****** Object:  StoredProcedure [dbo].[sp__forecast_versus_actual_exceptions]    Script Date: 07/09/2014 10:25:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Mark Carlile
-- Create date: 16th March 2011
-- Description:	This stored proceedure is used by the Forecast Exception Report By Brand Manager
-- =============================================
ALTER PROCEDURE [dbo].[sp__forecast_versus_actual_exceptions]

	@username varchar(250)= NULL,
	@type varchar(3)= NULL,
	@year int,
	@period int,
	@forecastQuarterValue int

AS
BEGIN
	--SET NOCOUNT ON;
	
	DECLARE @BrandManagerId int
	
	IF @username is not null
	BEGIN
		SET @BrandManagerId = (SELECT Id FROM BrandManager WHERE Name = @username)
	END	
	
	DECLARE @CurrentPeriod int
	DECLARE @PeriodMinus1 int
	DECLARE @PeriodMinus2 int

	SET @CurrentPeriod = (SELECT Period.Id FROM Period WHERE (Period.Year = @year) AND (Period.Period = @period))
	SET @PeriodMinus1 = (@CurrentPeriod - 1)
	SET @PeriodMinus2 = (@CurrentPeriod - 2)
	
	DECLARE @currentmonth varchar (12)
	DECLARE @lastmonth varchar(12)
	DECLARE @lastmonthminusone varchar(12)
	
	DECLARE @DATE DATETIME = CAST(CAST(@year AS varchar) + '-' + CAST(@period AS varchar) + '-' + CAST(1 AS varchar) AS DATETIME)

	SET  @currentmonth = DATENAME(month, @DATE)
	SET  @lastmonth = DATENAME(month, DATEADD(month, -1,@DATE))
	SET  @lastmonthminusone = DATENAME(month, DATEADD(month, -2,@DATE))
		
	DECLARE @ForecastTypeId int
	DECLARE @IssuesTypeId int
	
	DECLARE @Types Table(ForecastTypeId Int, IssuesTypeId Int)
			
	IF @type = 'UK'
	BEGIN
		--SET @ForecastTypeId = (SELECT Id FROM ForecastType WHERE (Type = 'FUK'))
		--SET @IssuesTypeId = (SELECT Id FROM ForecastType WHERE (Type = 'IUK'))
		insert into @Types(ForecastTypeId) (SELECT Id FROM ForecastType WHERE (Type = ('FUK')))
		insert into @Types (IssuesTypeId) (SELECT Id FROM ForecastType WHERE (Type = ('IUK')))
		
	END
	ELSE IF @type is not null
	BEGIN
		insert into @Types (ForecastTypeId) (SELECT Id FROM ForecastType WHERE (Type = ('FEX')))
		insert into @Types (IssuesTypeId) (SELECT Id FROM ForecastType WHERE (Type = ('IEX')))
	END
	ELSE 
	BEGIN
		insert into @Types (ForecastTypeId) (SELECT Id FROM ForecastType WHERE (Type IN ('FUK','FEX')))
		insert into @Types (IssuesTypeId) (SELECT Id FROM ForecastType WHERE (Type IN ('IUK','IEX')))
	END
	
SELECT	Product.ProductCode, Product.Description,
                          (SELECT     TOP (1) Brand.Name
                            FROM          Brand INNER JOIN
                                                   BrandProduct ON Brand.Id = BrandProduct.BrandId
                            WHERE      (BrandProduct.ProductCode = Product.ProductCode)) AS BrandName, 
                           ISNULL((SELECT     SUM(Qty) AS Qty
                              FROM         Forecast
                              WHERE     (ProductCode = Product.ProductCode) AND (ForecastTypeId IN (SELECT ForecastTypeId FROM @Types)) AND (PeriodId = @CurrentPeriod)), 0) AS Forecast, 
                           ISNULL((SELECT     SUM(Qty) AS Qty
                              FROM         Forecast 
                              WHERE     (ProductCode = Product.ProductCode) AND (ForecastTypeId IN (SELECT IssuesTypeId FROM @Types)) AND (PeriodId = @CurrentPeriod)), 0) AS Issues, 
                           ISNULL((SELECT     SUM(Qty) AS Qty
                              FROM         Forecast
                              WHERE     (ProductCode = Product.ProductCode) AND (ForecastTypeId IN (SELECT ForecastTypeId FROM @Types)) AND (PeriodId IN (@PeriodMinus1))), 0) AS lastPeriodForecast, 
                           ISNULL((SELECT     SUM(Qty) AS Qty
                              FROM         Forecast AS Forecast_1
                              WHERE     (ProductCode = Product.ProductCode) AND (ForecastTypeId IN (SELECT IssuesTypeId FROM @Types)) AND (PeriodId IN (@PeriodMinus1))), 0) AS lastPeriodIssued,
						   ISNULL((SELECT     SUM(Qty) AS Qty
                              FROM         Forecast AS Forecast_3
                              WHERE     (ProductCode = Product.ProductCode) AND (ForecastTypeId IN (SELECT ForecastTypeId FROM @Types)) AND (PeriodId IN (@PeriodMinus2))), 0) AS PeriodMinus2Forecast, 
                           ISNULL((SELECT     SUM(Qty) AS Qty
                              FROM         Forecast AS Forecast_1
                              WHERE     (ProductCode = Product.ProductCode) AND (ForecastTypeId IN (SELECT IssuesTypeId FROM @Types)) AND (PeriodId IN (@PeriodMinus2))), 0) AS PeriodMinus2Issued,
							  @currentmonth as CurrentMonth, @lastmonth as LastMonth, @lastmonthminusone as LastMonthMinusOne
							--,ISNULL((SELECT SUM(Qty) AS Qty FROM Forecast AS Forecast_12 WHERE (ProductCode = Product.ProductCode) AND (ForecastTypeId = @ForecastTypeId) AND (PeriodId = @PeriodMinus2)), 0) AS PeriodMinus2Forecast
							--,ISNULL((SELECT SUM(Qty) AS Qty FROM Forecast AS Forecast_10 WHERE (ProductCode = Product.ProductCode) AND (ForecastTypeId = @IssuesTypeId) AND (PeriodId = @PeriodMinus2)), 0) AS PeriodMinus2Issued
							
							--,ISNULL((SELECT SUM(Qty) AS Qty FROM Forecast AS Forecast_9 WHERE (ProductCode = Product.ProductCode) AND (ForecastTypeId = @ForecastTypeId) AND (PeriodId = @PeriodMinus1)), 0) AS lastPeriodForecast
							--,ISNULL((SELECT SUM(Qty) AS Qty FROM Forecast AS Forecast_7 WHERE (ProductCode = Product.ProductCode) AND (ForecastTypeId = @IssuesTypeId) AND (PeriodId = @PeriodMinus1)), 0) AS lastPeriodIssued

							--,ISNULL((SELECT SUM(Qty) AS Qty FROM  Forecast AS Forecast_6 WHERE (ProductCode = Product.ProductCode) AND (ForecastTypeId = @ForecastTypeId) AND (PeriodId = @CurrentPeriod)), 0) AS Forecast
							--,ISNULL((SELECT SUM(Qty) AS Qty FROM Forecast AS Forecast_4  WHERE (ProductCode = Product.ProductCode) AND (ForecastTypeId = @IssuesTypeId) AND (PeriodId = @CurrentPeriod)), 0) AS Issues

FROM		Product INNER JOIN BrandManagerProduct ON Product.ProductCode = BrandManagerProduct.ProductCode
WHERE		(BrandManagerProduct.BrandManagerId = @BrandManagerId or @BrandManagerId is null)
END
