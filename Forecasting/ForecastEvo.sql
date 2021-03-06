/****** Script for SelectTopNRows command from SSMS  ******/
SELECT		p.ProductCode, p.Description, fe.SnapShotDate, fe.p1, fe.p2, fe.p3, fe.p4, fe.p5, fe.p6, fe.p7, fe.p8, fe.p9, fe.p10, fe.p11, fe.p12, fe.p13, fe.p14, fe.p15, fe.p16, fe.p17, fe.p18
FROM		ForecastEvolution fe
INNER JOIN	Product p
ON			fe.ProductCode = p.ProductCode
WHERE		fe.SnapShotDate > '2013-12-31'
AND			fe.ForecastTypeId = 4
ORDER BY	fe.ProductCode, SnapShotDate