--	CLEAN IT UP...
  DELETE FROM  [Budgets]
	
  DELETE FROM [dbo].[BudgetForecastingImport]

  DECLARE @Period DATETIME
  SET @Period = CAST(DATEPART(YEAR, GETDATE()) as varchar) + '-01-' + '01'
  INSERT INTO [dbo].[Budgets](BudgetType, Warehouse, Product, Quantity, BudgetPeriod)
  SELECT 'UK', 'FG', Product, Jan, @Period
  FROM   [StadaFactBook].[dbo].[BudgetImport]  
  WHERE  Jan > 1

  SET @Period = DATEADD(MONTH, 1, @Period)  
  INSERT INTO [dbo].[Budgets](BudgetType, Warehouse, Product, Quantity, BudgetPeriod)
  SELECT 'UK', 'FG', Product, Feb, @Period
  FROM   [StadaFactBook].[dbo].[BudgetImport]
  WHERE  Feb > 1

  SET @Period = DATEADD(MONTH, 1, @Period)  
  INSERT INTO [dbo].[Budgets](BudgetType, Warehouse, Product, Quantity, BudgetPeriod)
  SELECT 'UK', 'FG', Product, Mar, @Period
  FROM   [StadaFactBook].[dbo].[BudgetImport]
  WHERE  Mar > 1
  
  SET @Period = DATEADD(MONTH, 1, @Period)  
  INSERT INTO [dbo].[Budgets](BudgetType, Warehouse, Product, Quantity, BudgetPeriod)
  SELECT 'UK', 'FG', Product, Apr, @Period
  FROM   [StadaFactBook].[dbo].[BudgetImport]
  WHERE  Apr > 1

  SET @Period = DATEADD(MONTH, 1, @Period)  
  INSERT INTO [dbo].[Budgets](BudgetType, Warehouse, Product, Quantity, BudgetPeriod)
  SELECT 'UK', 'FG', Product, May, @Period
  FROM   [StadaFactBook].[dbo].[BudgetImport]
  WHERE  May > 1
   
  SET @Period = DATEADD(MONTH, 1, @Period)    
  INSERT INTO [dbo].[Budgets](BudgetType, Warehouse, Product, Quantity, BudgetPeriod)
  SELECT 'UK', 'FG', Product, Jun, @Period
  FROM   [StadaFactBook].[dbo].[BudgetImport]
  WHERE  Jun > 1
  
  SET @Period = DATEADD(MONTH, 1, @Period)  
  INSERT INTO [dbo].[Budgets](BudgetType, Warehouse, Product, Quantity, BudgetPeriod)
  SELECT 'UK', 'FG', Product, Jul, @Period
  FROM   [StadaFactBook].[dbo].[BudgetImport]
  WHERE  Jul > 1
  
  SET @Period = DATEADD(MONTH, 1, @Period)  
  INSERT INTO [dbo].[Budgets](BudgetType, Warehouse, Product, Quantity, BudgetPeriod)
  SELECT 'UK', 'FG', Product, Aug, @Period
  FROM   [StadaFactBook].[dbo].[BudgetImport]
  WHERE  Aug > 1
  
  SET @Period = DATEADD(MONTH, 1, @Period)
  INSERT INTO [dbo].[Budgets](BudgetType, Warehouse, Product, Quantity, BudgetPeriod)
  SELECT 'UK', 'FG', Product, Sep, @Period
  FROM   [StadaFactBook].[dbo].[BudgetImport]
  WHERE  Sep > 1
  
  SET @Period = DATEADD(MONTH, 1, @Period) 
  INSERT INTO [dbo].[Budgets](BudgetType, Warehouse, Product, Quantity, BudgetPeriod)
  SELECT 'UK', 'FG', Product, Oct,  @Period
  FROM   [StadaFactBook].[dbo].[BudgetImport]
  WHERE  Oct > 1
  
  SET @Period = DATEADD(MONTH, 1, @Period)  
  INSERT INTO [dbo].[Budgets](BudgetType, Warehouse, Product, Quantity, BudgetPeriod)
  SELECT 'UK', 'FG', Product, Nov, @Period
  FROM   [StadaFactBook].[dbo].[BudgetImport]
  WHERE  Nov > 1
  
  SET @Period = DATEADD(MONTH, 1, @Period)  
  INSERT INTO [dbo].[Budgets](BudgetType, Warehouse, Product, Quantity, BudgetPeriod)
  SELECT 'UK', 'FG', Product, [Dec], @Period
  FROM   [StadaFactBook].[dbo].[BudgetImport]
  WHERE  [Dec] > 1
  

  