
ALTER PROCEDURE sp_BrandSales
as 

DECLARE	@Results TABLE (PeriodDate DATETIME, Territory VARCHAR(6), RBM VARCHAR(50), Region VARCHAR(50), Brand VARCHAR(100), BrandSalesValue FLOAT, CompetitorSalesValue FLOAT,
						Q1TotalMarket FLOAT,  JanTotalMarket FLOAT,  FebTotalMarket FLOAT, MarTotalMarket FLOAT, Q2TotalMarket FLOAT, AprTotalMarket FLOAT, MayTotalMarket FLOAT, JunTotalMarket FLOAT, Q3TotalMarket FLOAT, JulTotalMarket FLOAT, AugTotalMarket FLOAT, SepTotalMarket FLOAT, Q4TotalMarket FLOAT, OctTotalMarket FLOAT, NovTotalMarket FLOAT, DecTotalMarket FLOAT,
						Q1MS FLOAT,  JanMS FLOAT,  FebMS FLOAT, MarMS FLOAT, Q2MS FLOAT, AprMS FLOAT, MayMS FLOAT, JunMS FLOAT, Q3MS FLOAT, JulMS FLOAT, AugMS FLOAT, SepMS FLOAT, Q4MS FLOAT, OctMS FLOAT, NovMS FLOAT, DecMS FLOAT)
	
INSERT INTO @Results(PeriodDate, Territory, RBM, Region, Brand, BrandSalesValue, CompetitorSalesValue)

SELECT		pd.PERIODDATE, 
			p.Territory, p.RBM, p.Region, b.Brand, 
			ROUND(SUM(CASE WHEN bp.BNFBrandId = 93 THEN NIC ELSE 0 END), 0) as BrandSalesValue, 
			ROUND(SUM(NIC), 0) as CompetitorSalesValue
			--SUM(NIC) /SUM(CASE WHEN vp.BNFBrandId = 93 THEN NIC ELSE 0 END) AS MS,
			FROM		BNFBrand b
INNER JOIN	BNFProducts bp WITH(NOLOCK)
ON			b.Id = bp.BNFBrandId
INNER JOIN	PracticeData pd WITH(NOLOCK)
ON			pd.BNF_CODE = bp.BNF_CODE
INNER JOIN  vw_Practice p WITH(NOLOCK)
ON			pd.PRACTICE = p.[Practice Code]
WHERE		b.Id IN (58,67,93,113,127,133,138,156,334,335,336,339)
AND			pd.PERIODDATE BETWEEN '2015-01-01' AND '2015-02-01'
AND			p.Territory IN ('G101', 'G102')
GROUP BY	p.Region, p.Territory, p.RBM, pd.PERIODDATE, b.Brand
ORDER BY	Brand

--SELECT * FROM @Results

IF (EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_SCHEMA = 'dbo' 
                 AND  TABLE_NAME = 'BrandSales'))
BEGIN
PRINT 'Drop it...'
DROP TABLE BrandSales

END
DECLARE @Territories TABLE (Id INT IDENTITY(1,1), Territory VARCHAR(6))
INSERT INTO @Territories SELECT DISTINCT Territory FROM @Results

DECLARE @Brands TABLE (Id INT IDENTITY(1,1), Brand VARCHAR(100))
INSERT INTO @Brands SELECT DISTINCT Brand FROM @Results

DECLARE @Periods TABLE (Id INT IDENTITY(1,1), PeriodDate DateTime)
INSERT INTO @Periods SELECT DISTINCT PeriodDate FROM @Results

DECLARE @Terr VARCHAR(6), @Brand VARCHAR(100), @Period DATETIME
DECLARE @TRow INT = 1
DECLARE @TRows INT = (SELECT COUNT(1) FROM @Territories)

DECLARE @BRow INT = 1
DECLARE @BRows INT = (SELECT COUNT(1) FROM @Brands)

DECLARE @PRow INT = 1
DECLARE @PRows INT = (SELECT COUNT(1) FROM @Periods)

DECLARE @Q1TotalMarket FLOAT,  @JanTotalMarket FLOAT,  @FebTotalMarket FLOAT, @MarTotalMarket FLOAT, @Q2TotalMarket FLOAT, @AprTotalMarket FLOAT, @MayTotalMarket FLOAT, @JunTotalMarket FLOAT, @Q3TotalMarket FLOAT, @JulTotalMarket FLOAT, @AugTotalMarket FLOAT, @SepTotalMarket FLOAT, @Q4TotalMarket FLOAT, @OctTotalMarket FLOAT, @NovTotalMarket FLOAT, @DecTotalMarket FLOAT

WHILE @PRow <= @PRows
BEGIN
	SELECT @Period = PeriodDate FROM @Periods WHERE Id = @PRow
	--WHILE @BRow <= @BRows
	--BEGIN
	--		SELECT @Brand = (SELECT MIN(Brand) FROM @Brands WHERE Id = @BRow)

			WHILE @TRow <= @TRows
			BEGIN
					SELECT @Terr = (SELECT MIN(Territory) FROM @Territories WHERE Id = @TRow)
					SELECT @Q1TotalMarket = 0,@JanTotalMarket = 0, @FebTotalMarket = 0, @MarTotalMarket = 0, @AprTotalMarket = 0, @MayTotalMarket = 0, @JunTotalMarket = 0, @JulTotalMarket = 0, @AugTotalMarket = 0, @SepTotalMarket = 0, @OctTotalMarket = 0, @NovTotalMarket = 0, @DecTotalMarket = 0
					-- GET ALL SALES AND SUM THEM UP BY
					-- Q1
					SET @Q1TotalMarket = ISNULL((SELECT SUM(CASE WHEN DATEPART(MONTH, PeriodDate) IN (1,2,3) Then CompetitorSalesValue END) FROM @Results WHERE Territory = @Terr AND PeriodDate = @Period), 0)
					SET @JanTotalMarket = ISNULL((SELECT SUM(CASE WHEN DATEPART(MONTH, PeriodDate) IN (1) Then CompetitorSalesValue END) FROM @Results WHERE Territory = @Terr AND PeriodDate = @Period), 0)
					SET @FebTotalMarket = ISNULL((SELECT SUM(CASE WHEN DATEPART(MONTH, PeriodDate) IN (2) Then CompetitorSalesValue END) FROM @Results WHERE Territory = @Terr AND PeriodDate = @Period), 0)
					SET @MarTotalMarket = ISNULL((SELECT SUM(CASE WHEN DATEPART(MONTH, PeriodDate) IN (3) Then CompetitorSalesValue END) FROM @Results WHERE Territory = @Terr AND PeriodDate = @Period), 0)

					-- Q2
					SET @Q2TotalMarket = ISNULL((SELECT SUM(CASE WHEN DATEPART(MONTH, PeriodDate) IN (4,5,6) Then CompetitorSalesValue END) FROM @Results WHERE Territory = @Terr AND PeriodDate = @Period), 0)
					SET @AprTotalMarket = ISNULL((SELECT SUM(CASE WHEN DATEPART(MONTH, PeriodDate) IN (4) Then CompetitorSalesValue END) FROM @Results WHERE Territory = @Terr AND PeriodDate = @Period), 0)
					SET @MayTotalMarket = ISNULL((SELECT SUM(CASE WHEN DATEPART(MONTH, PeriodDate) IN (5) Then CompetitorSalesValue END) FROM @Results WHERE Territory = @Terr AND PeriodDate = @Period), 0)
					SET @JunTotalMarket = ISNULL((SELECT SUM(CASE WHEN DATEPART(MONTH, PeriodDate) IN (6) Then CompetitorSalesValue END) FROM @Results WHERE Territory = @Terr AND PeriodDate = @Period), 0)

					-- Q3
					SET @Q3TotalMarket = ISNULL((SELECT SUM(CASE WHEN DATEPART(MONTH, PeriodDate) IN (7,8,9) Then CompetitorSalesValue END) FROM @Results WHERE Territory = @Terr AND PeriodDate = @Period), 0)
					SET @JulTotalMarket = ISNULL((SELECT SUM(CASE WHEN DATEPART(MONTH, PeriodDate) IN (7) Then CompetitorSalesValue END) FROM @Results WHERE Territory = @Terr AND PeriodDate = @Period), 0)
					SET @AugTotalMarket = ISNULL((SELECT SUM(CASE WHEN DATEPART(MONTH, PeriodDate) IN (8) Then CompetitorSalesValue END) FROM @Results WHERE Territory = @Terr AND PeriodDate = @Period), 0)
					SET @SepTotalMarket = ISNULL((SELECT SUM(CASE WHEN DATEPART(MONTH, PeriodDate) IN (9) Then CompetitorSalesValue END) FROM @Results WHERE Territory = @Terr AND PeriodDate = @Period), 0)

					-- Q4
					SET @Q4TotalMarket = ISNULL((SELECT SUM(CASE WHEN DATEPART(MONTH, PeriodDate) IN (10,11,12) Then CompetitorSalesValue END) FROM @Results WHERE Territory = @Terr AND PeriodDate = @Period), 0)
					SET @OctTotalMarket = ISNULL((SELECT SUM(CASE WHEN DATEPART(MONTH, PeriodDate) IN (10) Then CompetitorSalesValue END) FROM @Results WHERE Territory = @Terr AND PeriodDate = @Period), 0)
					SET @NovTotalMarket = ISNULL((SELECT SUM(CASE WHEN DATEPART(MONTH, PeriodDate) IN (11) Then CompetitorSalesValue END) FROM @Results WHERE Territory = @Terr AND PeriodDate = @Period), 0)
					SET @DecTotalMarket = ISNULL((SELECT SUM(CASE WHEN DATEPART(MONTH, PeriodDate) IN (12) Then CompetitorSalesValue END) FROM @Results WHERE Territory = @Terr AND PeriodDate = @Period), 0)


			UPDATE	@Results
			SET		Q1TotalMarket =		@Q1TotalMarket,
					JanTotalMarket =	@JanTotalMarket,
					JanMS =				ROUND(CASE WHEN @JanTotalMarket > 0 THEN CompetitorSalesValue/@JanTotalMarket ELSE 0 END, 4),
					FebTotalMarket =	@FebTotalMarket,
					FebMS =				ROUND(CASE WHEN @FebTotalMarket > 0 THEN CompetitorSalesValue/@FebTotalMarket ELSE 0 END, 4),		
					MarTotalMarket =	@MarTotalMarket,
					MarMS =				ROUND(CASE WHEN @MarTotalMarket > 0 THEN CompetitorSalesValue/@MarTotalMarket ELSE 0 END, 4),
					Q1MS =				ROUND(CASE WHEN @JanTotalMarket > 0 THEN CompetitorSalesValue/@JanTotalMarket ELSE 0 END, 4) + ROUND(CASE WHEN @FebTotalMarket > 0 THEN CompetitorSalesValue/@FebTotalMarket ELSE 0 END ,0) + ROUND(CASE WHEN @MarTotalMarket > 0 THEN CompetitorSalesValue/@MarTotalMarket ELSE 0 END, 4),
		
					Q2TotalMarket =		@Q2TotalMarket,
					AprTotalMarket =	@AprTotalMarket,
					AprMS =				ROUND(CASE WHEN @AprTotalMarket > 0 THEN CompetitorSalesValue/@AprTotalMarket ELSE 0 END, 4),
					MayTotalMarket =	@MayTotalMarket,
					MayMS =				ROUND(CASE WHEN @MayTotalMarket > 0 THEN CompetitorSalesValue/@MayTotalMarket ELSE 0 END, 4),		
					JunTotalMarket =	@JunTotalMarket,
					JunMS =				ROUND(CASE WHEN @JunTotalMarket > 0 THEN CompetitorSalesValue/@JunTotalMarket ELSE 0 END, 4),
					Q2MS =				ROUND(CASE WHEN @AprTotalMarket > 0 THEN CompetitorSalesValue/@AprTotalMarket ELSE 0 END, 4) + ROUND(CASE WHEN @MayTotalMarket > 0 THEN CompetitorSalesValue/@MayTotalMarket ELSE 0 END, 4) + ROUND(CASE WHEN @JunTotalMarket > 0 THEN CompetitorSalesValue/@JunTotalMarket ELSE 0 END, 4),
		
					Q3TotalMarket =		@Q3TotalMarket,
					JulTotalMarket =	@JulTotalMarket,
					JulMS =				ROUND(CASE WHEN @JulTotalMarket > 0 THEN CompetitorSalesValue/@JulTotalMarket ELSE 0 END, 4),
					AugTotalMarket=		@AugTotalMarket,
					AugMS =				ROUND(CASE WHEN @AugTotalMarket > 0 THEN CompetitorSalesValue/@AugTotalMarket ELSE 0 END, 4),		
					SepTotalMarket	=	@SepTotalMarket,
					SepMS =				ROUND(CASE WHEN @SepTotalMarket > 0 THEN CompetitorSalesValue/@SepTotalMarket ELSE 0 END, 4),
					Q3MS =				ROUND(CASE WHEN @JulTotalMarket > 0 THEN CompetitorSalesValue/@JulTotalMarket ELSE 0 END, 4) + ROUND(CASE WHEN @AugTotalMarket > 0 THEN CompetitorSalesValue/@AugTotalMarket ELSE 0 END, 4) + ROUND(CASE WHEN @SepTotalMarket > 0 THEN CompetitorSalesValue/@SepTotalMarket ELSE 0 END, 4),
		
					Q4TotalMarket =		@Q4TotalMarket,
					OctTotalMarket =	@OctTotalMarket,
					OctMS =				ROUND(CASE WHEN @OctTotalMarket > 0 THEN CompetitorSalesValue/@OctTotalMarket ELSE 0 END, 4),
					NovTotalMarket =	@NovTotalMarket,
					NovMS =				ROUND(CASE WHEN @NovTotalMarket > 0 THEN CompetitorSalesValue/@NovTotalMarket ELSE 0 END, 4),		
					DecTotalMarket =	@DecTotalMarket,
					DecMS =				ROUND(CASE WHEN @DecTotalMarket > 0 THEN CompetitorSalesValue/@DecTotalMarket ELSE 0 END, 4),
					Q4MS =				ROUND(CASE WHEN @OctTotalMarket > 0 THEN CompetitorSalesValue/@OctTotalMarket ELSE 0 END, 4) + ROUND(CASE WHEN @NovTotalMarket > 0 THEN CompetitorSalesValue/@NovTotalMarket ELSE 0 END, 4) + ROUND(CASE WHEN @DecTotalMarket > 0 THEN CompetitorSalesValue/@DecTotalMarket ELSE 0 END, 4)
			WHERE	Territory = @Terr 
			AND		PeriodDate = @Period

			SET @TRow = @TRow + 1
		END

	--	SET @BRow = @BRow + 1
	--END

	SET	@PRow = @PRow + 1
END

SELECT * INTO BrandSales FROM @Results
		

GO
exec sp_BrandSales

SELECT * FROM BrandSales ORDER BY Territory
