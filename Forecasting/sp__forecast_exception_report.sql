USE [Forecasting]
GO
/****** Object:  StoredProcedure [dbo].[sp__forecast_exception_report]    Script Date: 07/09/2014 10:20:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp__ForecastData] 
-- =============================================
-- Author:		Dan McGregor
-- Create date: 16th March 2011
-- Description:	This stored proceedure gives you export sales and forecast for the year -1 and ytd on the year passed in
-- =============================================
	@year int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	
	SELECT		p.ProductCode, p.Description, 
				CASE f.ForecastTypeId WHEN 4 THEN f.Qty ELSE 0 END AS ForecastQty, 
				CASE f.ForecastTypeId WHEN 6 THEN f.Qty ELSE 0 END AS IssuedQty, 
				pd.Period, pd.Year into #Results
	FROM		Product p
	INNER JOIN	Forecast f
	ON			p.ProductCode = f.ProductCode
	INNER JOIN	Period pd
	ON			pd.Id = f.PeriodId
	WHERE		((pd.Year = @year -1)
	OR			(pd.Year = @year) AND pd.Period <= DATEPART(MONTH, GETDATE()))
	AND			f.ForecastTypeId in (4,6)

	SELECT		ProductCode, Description, Period, Year, sum(ForecastQty) AS Forecast, SUM(IssuedQty) as Issued
	FROM		#Results 
	GROUP BY	ProductCode, Description, Period, Year
	ORDER BY	ProductCode, Description, YEAR, Period

END

GO


