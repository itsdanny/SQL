	-- CLEAN IT UP...
  DELETE FROM  [Budgets]

  DECLARE @Period DATETIME
  SET @Period = CAST(DATEPART(YEAR, GETDATE()) as varchar) + '-01-' + '01'
  INSERT INTO [dbo].[Budgets](BudgetType, Warehouse, Product, Quantity, BudgetPeriod)
  SELECT 'UK', 'FG', Product, Units, @Period
  FROM   dbo.fn_BudgetForMonth(@Period)  
  
  SET @Period = DATEADD(MONTH, 1, @Period)  
  INSERT INTO [dbo].[Budgets](BudgetType, Warehouse, Product, Quantity, BudgetPeriod)
   SELECT 'UK', 'FG', Product, Units, @Period
  FROM   dbo.fn_BudgetForMonth(@Period) 

  SET @Period = DATEADD(MONTH, 1, @Period)  
  INSERT INTO [dbo].[Budgets](BudgetType, Warehouse, Product, Quantity, BudgetPeriod)
   SELECT 'UK', 'FG', Product, Units, @Period
  FROM   dbo.fn_BudgetForMonth(@Period) 
  
  SET @Period = DATEADD(MONTH, 1, @Period)  
  INSERT INTO [dbo].[Budgets](BudgetType, Warehouse, Product, Quantity, BudgetPeriod)
   SELECT 'UK', 'FG', Product, Units, @Period
  FROM   dbo.fn_BudgetForMonth(@Period) 

  SET @Period = DATEADD(MONTH, 1, @Period)  
  INSERT INTO [dbo].[Budgets](BudgetType, Warehouse, Product, Quantity, BudgetPeriod)
  SELECT 'UK', 'FG', Product, Units, @Period
  FROM   dbo.fn_BudgetForMonth(@Period) 
 
  SET @Period = DATEADD(MONTH, 1, @Period)    
  INSERT INTO [dbo].[Budgets](BudgetType, Warehouse, Product, Quantity, BudgetPeriod)
  SELECT 'UK', 'FG', Product, Units, @Period
  FROM   dbo.fn_BudgetForMonth(@Period) 

  SET @Period = DATEADD(MONTH, 1, @Period)  
  INSERT INTO [dbo].[Budgets](BudgetType, Warehouse, Product, Quantity, BudgetPeriod)
  SELECT 'UK', 'FG', Product, Units, @Period
  FROM   dbo.fn_BudgetForMonth(@Period) 

  SET @Period = DATEADD(MONTH, 1, @Period)  
  INSERT INTO [dbo].[Budgets](BudgetType, Warehouse, Product, Quantity, BudgetPeriod)
  SELECT 'UK', 'FG', Product, Units, @Period
  FROM   dbo.fn_BudgetForMonth(@Period) 

  SET @Period = DATEADD(MONTH, 1, @Period)
  INSERT INTO [dbo].[Budgets](BudgetType, Warehouse, Product, Quantity, BudgetPeriod)
  SELECT 'UK', 'FG', Product, Units, @Period
  FROM   dbo.fn_BudgetForMonth(@Period) 

  SET @Period = DATEADD(MONTH, 1, @Period) 
  INSERT INTO [dbo].[Budgets](BudgetType, Warehouse, Product, Quantity, BudgetPeriod)
  SELECT 'UK', 'FG', Product, Units, @Period
  FROM   dbo.fn_BudgetForMonth(@Period) 

  SET @Period = DATEADD(MONTH, 1, @Period)  
  INSERT INTO [dbo].[Budgets](BudgetType, Warehouse, Product, Quantity, BudgetPeriod)
  SELECT 'UK', 'FG', Product, Units, @Period
  FROM   dbo.fn_BudgetForMonth(@Period) 
  
    SET @Period = DATEADD(MONTH, 1, @Period)  
  INSERT INTO [dbo].[Budgets](BudgetType, Warehouse, Product, Quantity, BudgetPeriod)
  SELECT 'UK', 'FG', Product, Units, @Period
  FROM   dbo.fn_BudgetForMonth(@Period) 

