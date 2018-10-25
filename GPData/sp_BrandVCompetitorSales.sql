
ALTER PROCEDURE sp_BrandVCompetitorSales
AS 

TRUNCATE TABLE BrandSales
-- Varous Tables
DECLARE	@Results TABLE (ReportSection INT, Territory VARCHAR(20), RBM VARCHAR(50), Region VARCHAR(50), Brand VARCHAR(100),
						JanBrandSales INT, FebBrandSales INT, MarBrandSales INT, AprBrandSales INT, MayBrandSales INT, JunBrandSales INT, JulBrandSales INT, AugBrandSales INT, SepBrandSales INT, OctBrandSales INT, NovBrandSales INT, DecBrandSales INT,
						--JanTotalMarket INT, FebTotalMarket INT, MarTotalMarket INT, AprTotalMarket INT, MayTotalMarket INT, JunTotalMarket INT, JulTotalMarket INT, AugTotalMarket INT, SepTotalMarket INT, OctTotalMarket INT, NovTotalMarket INT, DecTotalMarket INT,
						JanMS FLOAT, FebMS FLOAT, MarMS FLOAT, AprMS FLOAT, MayMS FLOAT, JunMS FLOAT, JulMS FLOAT, AugMS FLOAT, SepMS FLOAT, OctMS FLOAT, NovMS FLOAT, DecMS FLOAT,
						JanTrgt INT, FebTrgt INT, MarTrgt INT, AprTrgt INT, MayTrgt INT, JunTrgt INT, JulTrgt INT, AugTrgt INT, SepTrgt INT, OctTrgt INT, NovTrgt INT, DecTrgt INT,
						Q1BrandSales INT, Q2BrandSales INT, Q3BrandSales INT, Q4BrandSales INT, 
						Q1TotalMarket INT, Q2TotalMarket INT, Q3TotalMarket INT, Q4TotalMarket INT,
						Q1MS FLOAT, Q2MS FLOAT, Q3MS FLOAT, Q4MS FLOAT)

DECLARE @Brands TABLE(ID INT IDENTITY(1,1), ReportSection INT, BrandId INT, KeepThis VARCHAR(20))

DECLARE @Territories TABLE (Id INT IDENTITY(1,1), Territory VARCHAR(20))

DECLARE @AllBrands TABLE (Id INT IDENTITY(1,1), Brand VARCHAR(100),ReportSection INT)

-- Variables
DECLARE @Q1Total FLOAT, @Mon1 FLOAT, @Mon2 FLOAT, @Mon3 FLOAT, @Q2Total FLOAT, @Mon4 FLOAT, @Mon5 FLOAT, @Mon6 FLOAT, @Q3Total FLOAT, @Mon7 FLOAT, @Mon8 FLOAT, @Mon9 FLOAT, @Q4Total FLOAT, @Mon10 FLOAT, @Mon11 FLOAT, @Mon12 FLOAT

DECLARE @TRows INT = 0, @BRows INT = 0

DECLARE @BRow INT = 1, @TRow INT = 1

DECLARE @Terr VARCHAR(6) = 1, @Brand VARCHAR(100) = ''

DECLARE @JanLvl FLOAT 
DECLARE @FebLvl FLOAT 
DECLARE @MarLvl FLOAT 
DECLARE @AprLvl FLOAT 
DECLARE @MayLvl FLOAT 
DECLARE @JunLvl FLOAT 
DECLARE @JulLvl FLOAT 
DECLARE @AugLvl FLOAT 
DECLARE @SepLvl FLOAT 
DECLARE @OctLvl FLOAT 
DECLARE @NovLvl FLOAT 
DECLARE @DecLvl FLOAT 


INSERT INTO @Brands
--Cetraben Creams:
SELECT 1, Id, 'Cetraben Cream' FROM BNFBrand WHERE Id IN (58,67,93,113,127,133,138,156,334,335,336,339) -- 'Cetraben Cream'
UNION
--Cetraben Bath:
SELECT 2, Id, 'Cetraben Bath' FROM BNFBrand WHERE Id IN (66,92,112,254,340,341) -- 'Cetraben Bath'
UNION
--Cetraben Lotions:
SELECT 3, Id, 'Cetraben Lotion' FROM BNFBrand WHERE Id IN (70,94,114,142) -- 'Cetraben Lotion'
UNION
--Cetraben Ointments:
SELECT 4, Id,'Cetraben Ointment' FROM BNFBrand WHERE Id IN (128,157,188,337,360) -- 'Cetraben Ointment'
UNION
--	Cetraben Total: 
SELECT 5, Id, 'CETRABEN TOTAL' FROM BNFBrand WHERE Id IN (66,92,112,254,340,341,58,67,93,113,127,133,138,156,334,335,336,339,70,94,114,142,128,157,188,337,360) -- 'Cetraben Total'
UNION
--Flexitol:
SELECT 6, Id, 'FLEXTITOL TOTAL' FROM BNFBrand WHERE Id IN (53,86,111,166,180,182) -- 'Flextitol'
UNION
--Topicals (Movelat):
SELECT 7, Id, 'MOVELAT TOTAL' FROM BNFBrand WHERE Id IN (48,204,242,243,244,245,273,327,328) -- Movelat

DECLARE @ReportSectionRow INT, @ReportSectionRows INT

SELECT @ReportSectionRow = 1, @ReportSectionRows = (select MAX(ReportSection) from @Brands)

WHILE @ReportSectionRow <= @ReportSectionRows
BEGIN

DELETE FROM @Results
IF		@ReportSectionRow < 5 
BEGIN
INSERT INTO @Results(ReportSection, Territory, RBM, Region, Brand, 
					JanBrandSales, FebBrandSales, MarBrandSales, AprBrandSales, 
					MayBrandSales, JunBrandSales, JulBrandSales, AugBrandSales,
					SepBrandSales, OctBrandSales, NovBrandSales, DecBrandSales,
					Q1BrandSales, Q2BrandSales, Q3BrandSales, Q4BrandSales)

SELECT		@ReportSectionRow, p.Territory, p.RBM, p.Region, 
			Brand, 			
			SUM(CASE WHEN DATEPART(MONTH, PERIODDATE) IN (1) then NIC ELSE 0 END) AS JanSales,
			SUM(CASE WHEN DATEPART(MONTH, PERIODDATE) IN (2) then NIC ELSE 0 END) AS FebSales,
			SUM(CASE WHEN DATEPART(MONTH, PERIODDATE) IN (3) then NIC ELSE 0 END) AS MarSales,		
			SUM(CASE WHEN DATEPART(MONTH, PERIODDATE) IN (4) then NIC ELSE 0 END) AS AprSales,
			SUM(CASE WHEN DATEPART(MONTH, PERIODDATE) IN (5) then NIC ELSE 0 END) AS MaySales,
			SUM(CASE WHEN DATEPART(MONTH, PERIODDATE) IN (6) then NIC ELSE 0 END) AS JunSales,		
			SUM(CASE WHEN DATEPART(MONTH, PERIODDATE) IN (7) then NIC ELSE 0 END) AS JulSales,
			SUM(CASE WHEN DATEPART(MONTH, PERIODDATE) IN (8) then NIC ELSE 0 END) AS AugSales,
			SUM(CASE WHEN DATEPART(MONTH, PERIODDATE) IN (8) then NIC ELSE 0 END) AS SepSales,		
			SUM(CASE WHEN DATEPART(MONTH, PERIODDATE) IN (10) then NIC ELSE 0 END) AS OctSales,
			SUM(CASE WHEN DATEPART(MONTH, PERIODDATE) IN (11) then NIC ELSE 0 END) AS NovSales,
			SUM(CASE WHEN DATEPART(MONTH, PERIODDATE) IN (12) then NIC ELSE 0 END) AS DecSales,
			SUM(CASE WHEN DATEPART(MONTH, PERIODDATE) IN (1,2,3) then NIC ELSE 0 END) AS Q1Sales,
			SUM(CASE WHEN DATEPART(MONTH, PERIODDATE) IN (4,5,6) then NIC ELSE 0 END) AS Q2Sales,
			SUM(CASE WHEN DATEPART(MONTH, PERIODDATE) IN (7,8,9) then NIC ELSE 0 END) AS Q3Sales,
			SUM(CASE WHEN DATEPART(MONTH, PERIODDATE) IN (10,11,12) then NIC ELSE 0 END) AS Q4Sales
FROM		BNFBrand b
INNER JOIN	BNFProducts bp WITH(NOLOCK)
ON			b.Id = bp.BNFBrandId
INNER JOIN	PracticeData pd WITH(NOLOCK)
ON			pd.BNF_CODE = bp.BNF_CODE
INNER JOIN  vw_Practice p WITH(NOLOCK)
ON			pd.PRACTICE = p.[Practice Code]
WHERE		b.Id IN (select BrandId from @Brands where ReportSection = @ReportSectionRow)
AND			pd.PERIODDATE BETWEEN DATEADD(yy, DATEDIFF(yy,0,getdate()), 0) AND GETDATE() -- YTD
--AND			p.Territory IN ('G101','G102','G103')
GROUP BY	 p.Region, p.Territory, p.RBM, b.Brand
ORDER BY	Brand
END
ELSE
BEGIN

INSERT INTO @Results(ReportSection, Territory, RBM, Region, Brand, 
					JanBrandSales, FebBrandSales, MarBrandSales, AprBrandSales, 
					MayBrandSales, JunBrandSales, JulBrandSales, AugBrandSales,
					SepBrandSales, OctBrandSales, NovBrandSales, DecBrandSales,
					Q1BrandSales, Q2BrandSales, Q3BrandSales, Q4BrandSales)

SELECT		@ReportSectionRow, 
			p.Territory, p.RBM, p.Region, 
			CASE WHEN UPPER(b.Brand) LIKE 'FLEXITOL%' THEN 'FLEXITOL TOTAL' 
			WHEN UPPER(b.Brand) LIKE 'MOVELAT%'  THEN 'MOVELAT TOTAL' 
			WHEN UPPER(b.Brand) LIKE 'CETRABEN%' Then 'CETRABEN TOTAL'
			ELSE b.Brand 
			END AS  Brand, 			
			SUM(CASE WHEN DATEPART(MONTH, PERIODDATE) IN (1) then NIC ELSE 0 END) AS JanSales,
			SUM(CASE WHEN DATEPART(MONTH, PERIODDATE) IN (2) then NIC ELSE 0 END) AS FebSales,
			SUM(CASE WHEN DATEPART(MONTH, PERIODDATE) IN (3) then NIC ELSE 0 END) AS MarSales,		
			SUM(CASE WHEN DATEPART(MONTH, PERIODDATE) IN (4) then NIC ELSE 0 END) AS AprSales,
			SUM(CASE WHEN DATEPART(MONTH, PERIODDATE) IN (5) then NIC ELSE 0 END) AS MaySales,
			SUM(CASE WHEN DATEPART(MONTH, PERIODDATE) IN (6) then NIC ELSE 0 END) AS JunSales,		
			SUM(CASE WHEN DATEPART(MONTH, PERIODDATE) IN (7) then NIC ELSE 0 END) AS JulSales,
			SUM(CASE WHEN DATEPART(MONTH, PERIODDATE) IN (8) then NIC ELSE 0 END) AS AugSales,
			SUM(CASE WHEN DATEPART(MONTH, PERIODDATE) IN (8) then NIC ELSE 0 END) AS SepSales,		
			SUM(CASE WHEN DATEPART(MONTH, PERIODDATE) IN (10) then NIC ELSE 0 END) AS OctSales,
			SUM(CASE WHEN DATEPART(MONTH, PERIODDATE) IN (11) then NIC ELSE 0 END) AS NovSales,
			SUM(CASE WHEN DATEPART(MONTH, PERIODDATE) IN (12) then NIC ELSE 0 END) AS DecSales,
			SUM(CASE WHEN DATEPART(MONTH, PERIODDATE) IN (1,2,3) then NIC ELSE 0 END) AS Q1Sales,
			SUM(CASE WHEN DATEPART(MONTH, PERIODDATE) IN (4,5,6) then NIC ELSE 0 END) AS Q2Sales,
			SUM(CASE WHEN DATEPART(MONTH, PERIODDATE) IN (7,8,9) then NIC ELSE 0 END) AS Q3Sales,
			SUM(CASE WHEN DATEPART(MONTH, PERIODDATE) IN (10,11,12) then NIC ELSE 0 END) AS Q4Sales
FROM		BNFBrand b
INNER JOIN	BNFProducts bp WITH(NOLOCK)
ON			b.Id = bp.BNFBrandId
INNER JOIN	PracticeData pd WITH(NOLOCK)
ON			pd.BNF_CODE = bp.BNF_CODE
INNER JOIN vw_Practice p WITH(NOLOCK)
ON			pd.PRACTICE = p.[Practice Code]
WHERE		b.Id IN (select BrandId from @Brands where ReportSection = @ReportSectionRow)
AND			pd.PERIODDATE BETWEEN DATEADD(yy, DATEDIFF(yy,0,getdate()), 0)  AND   GETDATE() -- YTD
--AND			p.Territory IN ('G101','G102','G103')
GROUP BY	 p.Territory, p.RBM, p.Region, CASE 
				  WHEN UPPER(b.Brand) LIKE 'FLEXITOL%' THEN 'FLEXITOL TOTAL' 
				  WHEN UPPER(b.Brand) LIKE 'MOVELAT%'  THEN 'MOVELAT TOTAL' 
				  WHEN UPPER(b.Brand) LIKE 'CETRABEN%' Then 'CETRABEN TOTAL'
				  ELSE b.Brand 
		     END
ORDER BY	Brand




END

SET @Terr = (SELECT MIN(Id) FROM @Territories)
--PRINT 'Clear the Territories table'
--DELETE FROM @Territories

--PRINT 'Fill the Territories table'
IF (SELECT COUNT(1) FROM @Territories) = 0
BEGIN
	INSERT INTO @Territories SELECT DISTINCT Territory FROM @Results
	SET @TRows = (SELECT COUNT(1) FROM @Territories)
END

SET @TRow = (SELECT MIN(Id) FROM @Territories)

--PRINT 'Clear the @AllBrands table'
DELETE FROM @AllBrands

PRINT 'Fill the @AllBrands table'
INSERT INTO @AllBrands SELECT DISTINCT Brand, @ReportSectionRow FROM @Results

--SET @BRow = 1
SET @BRows = @BRows + (SELECT COUNT(1) FROM @AllBrands)
	
	--SELECT @Terr Terr, @Brand Brand, @BRows NoOfBrands, @BRow BrandRow, @TRows NoOfTerritories, @TRow Territory, @ReportSectionRow ReportSection

WHILE @TRow <= @TRows
	BEGIN
		
	SELECT @Terr = Territory FROM @Territories WHERE Id = @TRow
	SELECT @BRow = MIN(Id) from @AllBrands where ReportSection = @ReportSectionRow
	
	WHILE @BRow <= @BRows
	BEGIN
		SELECT @Brand = Brand FROM @AllBrands WHERE Id = @BRow
		
		--IF @ReportSectionRow > 4 
		--BEGIN		
		--	--SELECT @Terr Terr, @TRows NoOfTerritories, @TRow Territory, @Brand Brand, @BRows NoOfBrands, @BRow BrandRow, @ReportSectionRow ReportSection
		--	--SELECT * FROM @Territories			
		--	--SELECT * FROM @AllBrands
		--END
		
		-- Get Territory total by brand
		SELECT 
				@Mon1 = SUM(JanBrandSales),
				@Mon2 = SUM(FebBrandSales),
				@Mon3 = SUM(MarBrandSales),
				@Mon4 = SUM(AprBrandSales),
				@Mon5 = SUM(MayBrandSales),
				@Mon6 = SUM(JunBrandSales),
				@Mon7 = SUM(JulBrandSales),
				@Mon8 = SUM(AugBrandSales),
				@Mon9 = SUM(SepBrandSales),
				@Mon10 = SUM(OctBrandSales),
				@Mon11 = SUM(NovBrandSales),
				@Mon12 = SUM(DecBrandSales),
				@Q1Total = SUM(Q1BrandSales),
				@Q2Total = SUM(Q2BrandSales),
				@Q3Total = SUM(Q3BrandSales),
				@Q4Total = SUM(Q4BrandSales)				
		FROM	@Results
		WHERE	Territory = @Terr
		
		UPDATE @Results
		SET		
				JanMS = CASE WHEN @Mon1 > 0 THEN JanBrandSales/@Mon1 ELSE 0 END,
				FebMS = CASE WHEN @Mon2 > 0 THEN FebBrandSales/@Mon2 ELSE 0 END ,
				MarMS = CASE WHEN @Mon3 > 0 THEN MarBrandSales/@Mon3 ELSE 0 END ,
				AprMS = CASE WHEN @Mon4 > 0 THEN AprBrandSales/@Mon4 ELSE 0 END ,
				MayMS = CASE WHEN @Mon5 > 0 THEN MayBrandSales/@Mon5 ELSE 0 END ,
				JunMS = CASE WHEN @Mon6 > 0 THEN JunBrandSales/@Mon6 ELSE 0 END ,
				JulMS = CASE WHEN @Mon7 > 0 THEN JulBrandSales/@Mon7 ELSE 0 END ,
				AugMS = CASE WHEN @Mon8 > 0 THEN AugBrandSales/@Mon8 ELSE 0 END ,
				SepMS = CASE WHEN @Mon9 > 0 THEN SepBrandSales/@Mon9 ELSE 0 END ,
				OctMS = CASE WHEN @Mon10 > 0 THEN OctBrandSales/@Mon10 ELSE 0 END ,
				NovMS = CASE WHEN @Mon12 > 0 THEN NovBrandSales/@Mon11 ELSE 0 END ,
				DecMS = CASE WHEN @Mon12 > 0 THEN DecBrandSales/@Mon12 ELSE 0 END ,
				Q1MS = (CASE WHEN @Mon1 > 0 THEN JanBrandSales/@Mon1 ELSE 0 END + CASE WHEN @Mon2 > 0 THEN FebBrandSales/@Mon2 ELSE 0 END + CASE WHEN @Mon3 > 0 THEN MarBrandSales/@Mon3 ELSE 0 END) / 3 ,
				Q2MS = (CASE WHEN @Mon4 > 0 THEN AprBrandSales/@Mon4 ELSE 0 END + CASE WHEN @Mon5 > 0 THEN MayBrandSales/@Mon5 ELSE 0 END + CASE WHEN @Mon6 > 0 THEN JunBrandSales/@Mon6 ELSE 0 END) / 3 ,
				Q3MS = (CASE WHEN @Mon7 > 0 THEN JulBrandSales/@Mon7 ELSE 0 END + CASE WHEN @Mon8 > 0 THEN AugBrandSales/@Mon8 ELSE 0 END + CASE WHEN @Mon9 > 0 THEN SepBrandSales/@Mon9 ELSE 0 END) / 3 ,
				Q4MS = (CASE WHEN @Mon10 > 0 THEN OctBrandSales/@Mon10 ELSE 0 END + CASE WHEN @Mon11 > 0 THEN NovBrandSales/@Mon11 ELSE 0 END + CASE WHEN @Mon12 > 0 THEN DecBrandSales/@Mon12 ELSE 0 END) / 3 
		WHERE	Territory = @Terr
		AND		Brand = @Brand
		
		SET		@BRow = @BRow + 1
	END
	
	SET @TRow = @TRow + 1
	
END

PRINT 'Get rid of brands not to display'
IF @ReportSectionRow < 5
BEGIN
	DELETE FROM @Results WHERE Brand NOT IN (SELECT Brand FROM BNFBrand WHERE Id IN(92,93,94,360,180,182,242,243,244,245))
END
ELSE
BEGIN
	DELETE FROM @Results WHERE UPPER(Brand) NOT IN ('MOVELAT TOTAL','FLEXITOL TOTAL','CETRABEN TOTAL')
END

SET @JanLvl = (SELECT AVG(JanMS) FROM @Results)
SET @FebLvl = (SELECT AVG(FebMS) FROM @Results) 
SET @MarLvl = (SELECT AVG(MarMS) FROM @Results) 
SET @AprLvl = (SELECT AVG(AprMS) FROM @Results) 
SET @MayLvl = (SELECT AVG(MayMS) FROM @Results) 
SET @JunLvl = (SELECT AVG(JunMS) FROM @Results) 
SET @JulLvl = (SELECT AVG(JulMS) FROM @Results) 
SET @AugLvl = (SELECT AVG(AugMS) FROM @Results) 
SET @SepLvl = (SELECT AVG(SepMS) FROM @Results) 
SET @OctLvl = (SELECT AVG(OctMS) FROM @Results) 
SET @NovLvl = (SELECT AVG(NovMS) FROM @Results) 
SET @DecLvl = (SELECT AVG(DecMS) FROM @Results) 

INSERT INTO BrandSales (Region, Territory, RBM, Brand, JanBrandSales, FebBrandSales, MarBrandSales, AprBrandSales, MayBrandSales, JunBrandSales, JulBrandSales, AugBrandSales, SepBrandSales, OctBrandSales, NovBrandSales, DecBrandSales, Q1BrandSales, Q2BrandSales, Q3BrandSales, Q4BrandSales, JanMS, FebMS, MarMS, AprMS, MayMS, JunMS, JulMS, AugMS, SepMS, OctMS, NovMS, DecMS, Q1MS, Q2MS, Q3MS, Q4MS, JanLvl, FebLvl, MarLvl, AprLvl, MayLvl, JunLvl, JulLvl, AugLvl, SepLvl, OctLvl, NovLvl, DecLvl, Q1Lvl, Q2Lvl, Q3Lvl, Q4Lvl)			
SELECT		Region, Territory, RBM, 
			Brand,
			JanBrandSales,
			FebBrandSales,
			MarBrandSales,
			AprBrandSales,
			MayBrandSales,
			JunBrandSales,
			JulBrandSales,
			AugBrandSales,
			SepBrandSales,
			OctBrandSales,
			NovBrandSales,
			DecBrandSales,
			Q1BrandSales,
			Q2BrandSales,
			Q3BrandSales,
			Q4BrandSales,
			CEILING(JanMS * 100) AS JanMS,
			CEILING(FebMS * 100) AS FebMS,
			CEILING(MarMS * 100) AS MarMS,
			CEILING(AprMS * 100) AS AprMS,
			CEILING(MayMS * 100) AS MayMS,
			CEILING(JunMS * 100) AS JunMS,
			CEILING(JulMS * 100) AS JulMS,
			CEILING(AugMS * 100) AS AugMS,
			CEILING(SepMS * 100) AS SepMS,
			CEILING(OctMS * 100) AS OctMS,
			CEILING(NovMS * 100) AS NovMS,
			CEILING(DecMS * 100) AS DecMS,		
			CEILING(JanMS * 100)+CEILING(FebMS * 100)+CEILING(MarMS * 100)/3 AS Q1MS,	
			CEILING(AprMS * 100)+CEILING(MayMS * 100)+CEILING(JunMS * 100)/3 AS Q2MS,	
			CEILING(JulMS * 100)+CEILING(AugMS * 100)+CEILING(SepMS * 100)/3 AS Q3MS,	
			CEILING(OctMS * 100)+CEILING(NovMS * 100)+CEILING(DecMS * 100)/3 AS Q4MS,	
			CASE WHEN @JanLvl > 0 THEN CEILING((JanMS/@JanLvl)*100) ELSE 0 END AS JanLvl,
			CASE WHEN @FebLvl > 0 THEN CEILING((FebMS/@FebLvl)*100) ELSE 0 END AS FebLvl, 
			CASE WHEN @MarLvl > 0 THEN CEILING((MarMS/@MarLvl)*100) ELSE 0 END AS MarLvl, 
			CASE WHEN @AprLvl > 0 THEN CEILING((AprMS/@AprLvl)*100) ELSE 0 END AS AprLvl,
			CASE WHEN @MayLvl > 0 THEN CEILING((MayMS/@MayLvl)*100) ELSE 0 END AS MayLvl, 
			CASE WHEN @JunLvl > 0 THEN CEILING((JunMS/@JunLvl)*100) ELSE 0 END AS JunLvl, 
			CASE WHEN @JulLvl > 0 THEN CEILING((JulMS/@JulLvl)*100) ELSE 0 END AS JulLvl, 
			CASE WHEN @AugLvl > 0 THEN CEILING((AugMS/@AugLvl)*100) ELSE 0 END AS AugLvl, 
			CASE WHEN @SepLvl > 0 THEN CEILING((SepMS/@SepLvl)*100) ELSE 0 END AS SepLvl, 
			CASE WHEN @OctLvl > 0 THEN CEILING((OctMS/@OctLvl)*100) ELSE 0 END AS OctLvl, 
			CASE WHEN @NovLvl > 0 THEN CEILING((NovMS/@NovLvl)*100) ELSE 0 END AS NovLvl, 
			CASE WHEN @DecLvl > 0 THEN CEILING((DecMS/@DecLvl)*100) ELSE 0 END AS DecLvl,
			(CASE WHEN @JanLvl > 0 THEN CEILING((JanMS/@JanLvl)*100) ELSE 0 END + CASE WHEN @FebLvl > 0 THEN CEILING((FebMS/@FebLvl)*100) ELSE 0 END + CASE WHEN @MarLvl > 0 THEN CEILING((MarMS/@MarLvl)*100) ELSE 0 END) / 3 AS Q1Lvl,
			(CASE WHEN @AprLvl > 0 THEN CEILING((AprMS/@AprLvl)*100) ELSE 0 END + CASE WHEN @MayLvl > 0 THEN CEILING((MayMS/@MayLvl)*100) ELSE 0 END + CASE WHEN @JunLvl > 0 THEN CEILING((JunMS/@JunLvl)*100) ELSE 0 END) / 3 AS Q2Lvl,
			(CASE WHEN @JulLvl > 0 THEN CEILING((JulMS/@JulLvl)*100) ELSE 0 END + CASE WHEN @AugLvl > 0 THEN CEILING((AugMS/@AugLvl)*100) ELSE 0 END + CASE WHEN @SepLvl > 0 THEN CEILING((SepMS/@SepLvl)*100) ELSE 0 END) / 3 AS Q3Lvl,
			(CASE WHEN @OctLvl > 0 THEN CEILING((OctMS/@OctLvl)*100) ELSE 0 END + CASE WHEN @NovLvl > 0 THEN CEILING((NovMS/@NovLvl)*100) ELSE 0 END + CASE WHEN @DecLvl > 0 THEN CEILING((DecMS/@DecLvl)*100) ELSE 0 END) / 3 AS Q4Lvl			
FROM		@Results

SET @ReportSectionRow = @ReportSectionRow + 1
END

update		bs
SET			bs.JanSalesTarget = bst.Jan,
			bs.FebSalesTarget = bst.Feb,
			bs.MarSalesTarget = bst.Mar,
			bs.AprSalesTarget = bst.Apr,
			bs.MaySalesTarget = bst.May,
			bs.JunSalesTarget = bst.Jun,
			bs.JulSalesTarget = bst.Jul,
			bs.AugSalesTarget = bst.Aug,
			bs.SepSalesTarget = bst.Sep,
			bs.OctSalesTarget = bst.Oct,
			bs.NovSalesTarget = bst.Nov,
			bs.DecSalesTarget = bst.[Dec]
FROM		BrandSales bs
INNER JOIN	BrandSalesTargets bst
ON			bs.Territory = bst.Territory
WHERE		UPPER(bst.Brand) = 'CETRABEN'
AND			bs.Brand = 'CETRABEN TOTAL'

update		bs
SET			bs.JanSalesTarget = bst.Jan,
			bs.FebSalesTarget = bst.Feb,
			bs.MarSalesTarget = bst.Mar,
			bs.AprSalesTarget = bst.Apr,
			bs.MaySalesTarget = bst.May,
			bs.JunSalesTarget = bst.Jun,
			bs.JulSalesTarget = bst.Jul,
			bs.AugSalesTarget = bst.Aug,
			bs.SepSalesTarget = bst.Sep,
			bs.OctSalesTarget = bst.Oct,
			bs.NovSalesTarget = bst.Nov,
			bs.DecSalesTarget = bst.[Dec]
FROM		BrandSales bs
INNER JOIN	BrandSalesTargets bst
ON			bs.Territory = bst.Territory
WHERE		UPPER(bst.Brand) = 'FLEXITOL'
AND			bs.Brand = 'FLEXITOL TOTAL'

update		bs
SET			bs.JanSalesTarget = bst.Jan,
			bs.FebSalesTarget = bst.Feb,
			bs.MarSalesTarget = bst.Mar,
			bs.AprSalesTarget = bst.Apr,
			bs.MaySalesTarget = bst.May,
			bs.JunSalesTarget = bst.Jun,
			bs.JulSalesTarget = bst.Jul,
			bs.AugSalesTarget = bst.Aug,
			bs.SepSalesTarget = bst.Sep,
			bs.OctSalesTarget = bst.Oct,
			bs.NovSalesTarget = bst.Nov,
			bs.DecSalesTarget = bst.[Dec]
FROM		BrandSales bs
INNER JOIN	BrandSalesTargets bst
ON			bs.Territory = bst.Territory
WHERE		UPPER(bst.Brand) = 'MOVELAT'
AND			bs.Brand = 'MOVELAT TOTAL'


/*

SELECT * INTO BrandSales FROM (
SELECT		1 AS Id, Region, Territory, RBM, 'Sales £' AS Measure, Brand,
			JanBrandSales AS Jan,
			FebBrandSales AS Feb,
			MarBrandSales AS Mar,
			AprBrandSales AS Apr,
			MayBrandSales AS May,
			JunBrandSales AS Jun,
			JulBrandSales AS Jul,
			AugBrandSales AS Aug,
			SepBrandSales AS Sep,
			OctBrandSales AS Oct,
			NovBrandSales AS Nov,
			DecBrandSales AS [Dec]--,
			--Q1BrandSales AS Q1,
			--Q2BrandSales AS Q2,
			--Q3BrandSales AS Q3,
			--Q4BrandSales AS Q4					 
FROM		@Results 
UNION
SELECT		2 AS Id, Region, Territory, RBM, 'MS %' AS Measure, Brand,
			CEILING(JanMS * 100) AS Jan,
			CEILING(FebMS * 100) AS Feb,
			CEILING(MarMS * 100) AS Mar,
			CEILING(AprMS * 100) AS Apr,
			CEILING(MayMS * 100) AS May,
			CEILING(JunMS * 100) AS Jun,
			CEILING(JulMS * 100) AS Jul,
			CEILING(AugMS * 100) AS Aug,
			CEILING(SepMS * 100) AS Sep,
			CEILING(OctMS * 100) AS Oct,
			CEILING(NovMS * 100) AS Nov,
			CEILING(DecMS * 100) AS [Dec]--,
			--Q1MS * 100 AS Q1,
			--Q2MS * 100 AS Q2,
			--Q3MS * 100 AS Q3,
			--Q4MS * 100 AS Q4					 
FROM		@Results 
UNION
SELECT		3 AS Id, Region, Territory, RBM, 'Level' AS Measure, Brand,
			CASE WHEN @JanLvl > 0 THEN CEILING((JanMS/@JanLvl)*100) ELSE 0 END AS Jan,
			CASE WHEN @FebLvl > 0 THEN CEILING((FebMS/@FebLvl)*100) ELSE 0 END AS Feb, 
			CASE WHEN @MarLvl > 0 THEN CEILING((MarMS/@MarLvl)*100) ELSE 0 END AS Mar, 
			CASE WHEN @AprLvl > 0 THEN CEILING((AprMS/@AprLvl)*100) ELSE 0 END AS Apr,
			CASE WHEN @MayLvl > 0 THEN CEILING((MayMS/@MayLvl)*100) ELSE 0 END AS May, 
			CASE WHEN @JunLvl > 0 THEN CEILING((JunMS/@JunLvl)*100) ELSE 0 END AS Jun, 
			CASE WHEN @JulLvl > 0 THEN CEILING((JulMS/@JulLvl)*100) ELSE 0 END AS Jul, 
			CASE WHEN @AugLvl > 0 THEN CEILING((AugMS/@AugLvl)*100) ELSE 0 END AS Aug, 
			CASE WHEN @SepLvl > 0 THEN CEILING((SepMS/@SepLvl)*100) ELSE 0 END AS Sep, 
			CASE WHEN @OctLvl > 0 THEN CEILING((OctMS/@OctLvl)*100) ELSE 0 END AS Oct, 
			CASE WHEN @NovLvl > 0 THEN CEILING((NovMS/@NovLvl)*100) ELSE 0 END AS Nov, 
			CASE WHEN @DecLvl > 0 THEN CEILING((DecMS/@DecLvl)*100) ELSE 0 END AS [Dec]			
FROM		@Results) s
*/
GO

sp_BrandVCompetitorSales
/*

select * from BrandSales where Territory = 'G101'
select * from BrandSalesTargets where Territory = 'G101'
*/

select Territory from Territory order by Territory
select distinct RBM from CCGLookup WHERE RBM IS NOT NULL ORDER BY RBM

select DISTINCT Territory from CCGLookup WHERE RBM = 'Dale Layman' ORDER BY Territory

drop  PROCEDURE sp__getBrandSales
@RBM VARCHAR(50) = null,
@Territory VARCHAR(50) = NULL
AS 
--SET @Region = 'Tony Kelly'
--SET @Territory = 'G101'
SELECT	* 
FROM	BrandSales 
WHERE	(Region IN (@RBM))
AND		(Territory IN (@Territory))

drop PROCEDURE sp__getTerritories
@RBM VARCHAR(50) = NULL
as 
SELECT  DISTINCT Territory from CCGLookup WHERE (@RBM IS NULL OR RBM in (@RBM)) ORDER BY Territory