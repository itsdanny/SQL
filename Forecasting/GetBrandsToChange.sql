use [Forecasting]

SELECT TOP 1000 [BrandManagerProduct].[Id]
      ,[BrandId]
      ,[BrandProduct].[ProductCode]
	  ,[Brand].[Name]
	  ,[BrandManagerId]
      ,[BrandManager].[Name] as Brand_Manager
  FROM [dbo].[BrandProduct]
  inner join [dbo].[Brand]
  on   [BrandProduct].[BrandId] = [Brand].[Id]
  inner join [dbo].[BrandManagerProduct]
  on   [BrandProduct].[ProductCode] = [dbo].[BrandManagerProduct].[ProductCode]
  inner join [BrandManager]
  on [BrandManagerProduct].[BrandManagerId] = [dbo].[BrandManager].[Id]
  WHERE [Brand].name in ('Acriflex', 'Cerumol', 'Crampex', 'GALCODINE','GALENPHOL', 'GALFER','GALPSEUD', 'GALSUD', 'Mycota', 'Setlers', 'Virasorb','EUCRYL','CARE')
 --AND BrandManagerId = 4
  