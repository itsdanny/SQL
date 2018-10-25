DECLARE @ProdCodeUpdates TABLE (NewProd VARCHAR(20), CurProd VARCHAR(20))
INSERT INTO @ProdCodeUpdates
VALUES('SS-BAT-25R','FV-BAT-25R')
INSERT INTO @ProdCodeUpdates
VALUES('LG-BAT-HE4','FV-BAT-HE4')
INSERT INTO @ProdCodeUpdates
VALUES('LG-BAT-HG2','FV-BAT-HG2')
INSERT INTO @ProdCodeUpdates
VALUES('SUN-VCC-COT','FV-SUN-VCC-COT')
INSERT INTO @ProdCodeUpdates
VALUES('SUN-DRA-COT','FV-SUN-DRA-COT')
INSERT INTO @ProdCodeUpdates
VALUES('SY-BAT-VTC5','FV-BAT-VTC5')
INSERT INTO @ProdCodeUpdates
VALUES('FV-EJ-GD-15-03','FV-EJ-GD-15-03')
INSERT INTO @ProdCodeUpdates
VALUES('FV-EJ-SH-15-03','EJ-RL3-03')
INSERT INTO @ProdCodeUpdates
VALUES('FV-EJ-GD-15-03','EJ-RL6-03')
INSERT INTO @ProdCodeUpdates
VALUES('FV-EJ-EDIOI-15-03','EJ-RL9-03')
INSERT INTO @ProdCodeUpdates
VALUES('FV-EJ-MA-30-3','FV-EJ-MA-30-03')
INSERT INTO @ProdCodeUpdates
VALUES('FV-EJ-HE-30-6','FV-EJ-HE-30-06')
INSERT INTO @ProdCodeUpdates
VALUES('FV-EJ-ST-15-03','EJ-RL1-03')
INSERT INTO @ProdCodeUpdates
VALUES('FV-EJ-RI-15-03','EJ-RL4-03')
INSERT INTO @ProdCodeUpdates
VALUES('FV-EJ-MA-15-03','EJ-RL10-03')
INSERT INTO @ProdCodeUpdates
VALUES('FV-EJ-JF-15-03','EJ-RL7-03')

SELECT	*	
FROM		slam.scheme.stockm s
INNER JOIN	@ProdCodeUpdates u
ON			s.product = u.CurProd

UPDATE s SET s.product = u.NewProd
FROM		scheme.stockm s
INNER JOIN	@ProdCodeUpdates u
ON			s.product = u.CurProd

UPDATE s SET s.product = u.NewProd
FROM		scheme.stockxpgm s
INNER JOIN	@ProdCodeUpdates u
ON			s.product = u.CurProd

UPDATE s SET s.prod_code = u.NewProd
FROM		[scheme].[dcbarcmapm] s
INNER JOIN	@ProdCodeUpdates u
ON			s.prod_code= u.CurProd