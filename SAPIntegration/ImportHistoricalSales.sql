--------------------------------------------------------------------
-- GETS Historical data from SAGE and enters into Qlikview Sales. --
--------------------------------------------------------------------
-- RUN ON TRDB03/PROD

-- PRE RUN STEPS BEFORE THIS SQL:
    -- 1. TRSAGEv3D1 modify the stored procedure SAPMigration.[dbo].[sp_BW_HistoricalSales]
    -- 2. TRSAGEv3D1 run the Stored Procedure above.
    -- 3. TRSAGEv3D1 > SELECT * FROM  SAPMigration.dbo.Historicalsales
    -- 4. TRDB03/PROD DB: SAPIntegration - tasks and import [TRSAGEv3D1 > SAPMigration.dbo.Historicalsales] TO [TRDB03/PROD > SAPIntegration.dbo.Historicalsales]  

-- ============================================================
-- == STAGE ONE - Check correct number of rows are returned. ==
-- ============================================================
DECLARE @Cal TABLE(Id INT, PeriodYear varchar(8))
	INSERT INTO @Cal
	SELECT        MIN(Id), FiscalPeriod
	FROM          Calendar			--WHERE              YearNumber IN (2016)
	GROUP BY      FiscalPeriod
	ORDER BY      1
SELECT             m.Id, c.Id, s.Id, [gross sales], [quantity by sales unit], [COGS: material at STD]
	FROM        dbo.Historicalsales h
	INNER JOIN MaterialMaster m
	ON                 h.Material = m.Material
	INNER JOIN Customers c
	ON                 h.customer = c.CustomerCode
	INNER JOIN @Cal s
	ON                 h.[Period/Year] = REPLACE(s.PeriodYear, '.','')
	ORDER BY    Year
--SELECT             m.Id, c.Id, s.Id, [gross sales], [quantity by sales unit], [COGS: material at STD]
RETURN;

-- ==============================
-- == STAGE TWO - Run Updates. ==
-- ==============================
DECLARE @Cal2 TABLE(Id INT, PeriodYear varchar(8))
	INSERT INTO @Cal2
	SELECT        MIN(Id), FiscalPeriod
	FROM          Calendar			--WHERE              YearNumber IN (2016)
	GROUP BY      FiscalPeriod
	ORDER BY      1
INSERT INTO  SalesOrders (MaterialId, CustomerId, CalendarId, SalesValue, SalesQty, COGS, OrderStatus)
	SELECT        m.Id, c.Id, s.Id, [gross sales], [quantity by sales unit], [COGS: material at STD], 'F'
	FROM          dbo.Historicalsales h
	INNER JOIN    MaterialMaster m
	ON                   h.Material = m.Material
	INNER JOIN    Customers c
	ON                   h.customer = c.CustomerCode
	INNER JOIN    @Cal2 s
	ON                   h.[Period/Year] = REPLACE(s.PeriodYear, '.','')
RETURN;

-- ======================================================
-- == STAGE THREE - Clear down Historical Sales Table. ==
-- ======================================================
DELETE FROM SAPIntegration.dbo.Historicalsales