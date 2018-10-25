SELECT * FROM ForecastEvolution WHERE		ProductCode = '001015'
AND	SnapShotDate BETWEEN '2014-09-01 00:00:00' AND	'2016-12-31 00:00:00'

SELECT		p.long_description, p.SupplierCode, p.SupplierName, f.ProductCode,  
			CASE f.ForecastTypeId WHEN 1 THEN 'UK' ELSE 'EX' END AS ForecastType,
			SUM(CASE WHEN DATEPART(YEAR, SnapShotDate) = 2014 AND DATEPART(MONTH, SnapShotDate) = 9 THEN P13 ELSE 0 END) AS Jan15,
			SUM(CASE WHEN DATEPART(YEAR, SnapShotDate) = 2014 AND DATEPART(MONTH, SnapShotDate) = 10 THEN P14 ELSE 0 END) AS Feb15,
			SUM(CASE WHEN DATEPART(YEAR, SnapShotDate) = 2014 AND DATEPART(MONTH, SnapShotDate) = 11 THEN P15 ELSE 0 END) AS Mar15,
			SUM(CASE WHEN DATEPART(YEAR, SnapShotDate) = 2014 AND DATEPART(MONTH, SnapShotDate) = 12 THEN P16 ELSE 0 END) AS Apr15,
			SUM(CASE WHEN DATEPART(YEAR, SnapShotDate) = 2015 AND DATEPART(MONTH, SnapShotDate) = 1 THEN P5 ELSE 0 END) AS May15,
			SUM(CASE WHEN DATEPART(YEAR, SnapShotDate) = 2015 AND DATEPART(MONTH, SnapShotDate) = 2 THEN P6 ELSE 0 END) AS Jun15,
			SUM(CASE WHEN DATEPART(YEAR, SnapShotDate) = 2015 AND DATEPART(MONTH, SnapShotDate) = 3 THEN P7 ELSE 0 END) AS Jul15,
			SUM(CASE WHEN DATEPART(YEAR, SnapShotDate) = 2015 AND DATEPART(MONTH, SnapShotDate) = 4 THEN P8 ELSE 0 END) AS Aug15,
			SUM(CASE WHEN DATEPART(YEAR, SnapShotDate) = 2015 AND DATEPART(MONTH, SnapShotDate) = 5 THEN P9 ELSE 0 END) AS Sep15,
			SUM(CASE WHEN DATEPART(YEAR, SnapShotDate) = 2015 AND DATEPART(MONTH, SnapShotDate) = 6 THEN P10 ELSE 0 END) AS Oct15,
			SUM(CASE WHEN DATEPART(YEAR, SnapShotDate) = 2015 AND DATEPART(MONTH, SnapShotDate) = 7 THEN P11 ELSE 0 END) AS Nov15,
			SUM(CASE WHEN DATEPART(YEAR, SnapShotDate) = 2015 AND DATEPART(MONTH, SnapShotDate) = 8 THEN P12 ELSE 0 END) AS Dec15,			
			SUM(CASE WHEN DATEPART(YEAR, SnapShotDate) = 2016 AND DATEPART(MONTH, SnapShotDate) = 9 THEN P13 ELSE 0 END) AS Jan15,
			SUM(CASE WHEN DATEPART(YEAR, SnapShotDate) = 2016 AND DATEPART(MONTH, SnapShotDate) = 10 THEN P14 ELSE 0 END) AS Feb16,
			SUM(CASE WHEN DATEPART(YEAR, SnapShotDate) = 2016 AND DATEPART(MONTH, SnapShotDate) = 11 THEN P15 ELSE 0 END) AS Mar16,
			SUM(CASE WHEN DATEPART(YEAR, SnapShotDate) = 2016 AND DATEPART(MONTH, SnapShotDate) = 12 THEN P16 ELSE 0 END) AS Apr16,
			SUM(CASE WHEN DATEPART(YEAR, SnapShotDate) = 2016 AND DATEPART(MONTH, SnapShotDate) = 1 THEN P5 ELSE 0 END) AS May16,
			SUM(CASE WHEN DATEPART(YEAR, SnapShotDate) = 2016 AND DATEPART(MONTH, SnapShotDate) = 2 THEN P6 ELSE 0 END) AS Jun16,
			SUM(CASE WHEN DATEPART(YEAR, SnapShotDate) = 2016 AND DATEPART(MONTH, SnapShotDate) = 3 THEN P7 ELSE 0 END) AS Jul16,
			SUM(CASE WHEN DATEPART(YEAR, SnapShotDate) = 2016 AND DATEPART(MONTH, SnapShotDate) = 4 THEN P8 ELSE 0 END) AS Aug16,
			SUM(CASE WHEN DATEPART(YEAR, SnapShotDate) = 2016 AND DATEPART(MONTH, SnapShotDate) = 5 THEN P9 ELSE 0 END) AS Sep16,
			SUM(CASE WHEN DATEPART(YEAR, SnapShotDate) = 2016 AND DATEPART(MONTH, SnapShotDate) = 6 THEN P10 ELSE 0 END) AS Oct16,
			SUM(CASE WHEN DATEPART(YEAR, SnapShotDate) = 2016 AND DATEPART(MONTH, SnapShotDate) = 7 THEN P11 ELSE 0 END) AS Nov16,
			SUM(CASE WHEN DATEPART(YEAR, SnapShotDate) = 2016 AND DATEPART(MONTH, SnapShotDate) = 8 THEN P12 ELSE 0 END) AS Dec16
FROM		[dbo].[ForecastEvolution] f
INNER JOIN 	ProductsSuppliers p
ON			f.ProductCode = p.product
WHERE		F.SnapShotDate BETWEEN '2014-09-01 00:00:00' AND	'2016-12-31 00:00:00'
GROUP BY long_description, SupplierCode, SupplierName, ProductCode,  ForecastTypeId
order by ProductCode


SELECT		ISNULL(p.supplier,'') AS SupplierCode, 
			ISNULL(p.name, '') AS SupplierName, 
			m.product, m.description,			
			SUM(CASE WHEN DATEPART(YEAR, h.date_entered) = 2015 AND DATEPART(MONTH, h.date_entered) = 1 THEN d.despatched_qty ELSE 0 END) AS Jan15,
			SUM(CASE WHEN DATEPART(YEAR, h.date_entered) = 2015 AND DATEPART(MONTH, h.date_entered) = 2 THEN d.despatched_qty ELSE 0 END) AS Feb15,
			SUM(CASE WHEN DATEPART(YEAR, h.date_entered) = 2015 AND DATEPART(MONTH, h.date_entered) = 3 THEN d.despatched_qty ELSE 0 END) AS Mar15,
			SUM(CASE WHEN DATEPART(YEAR, h.date_entered) = 2015 AND DATEPART(MONTH, h.date_entered) = 4 THEN d.despatched_qty ELSE 0 END) AS Apr15,
			SUM(CASE WHEN DATEPART(YEAR, h.date_entered) = 2015 AND DATEPART(MONTH, h.date_entered) = 5 THEN d.despatched_qty ELSE 0 END) AS May15,
			SUM(CASE WHEN DATEPART(YEAR, h.date_entered) = 2015 AND DATEPART(MONTH, h.date_entered) = 6 THEN d.despatched_qty ELSE 0 END) AS Jun15,
			SUM(CASE WHEN DATEPART(YEAR, h.date_entered) = 2015 AND DATEPART(MONTH, h.date_entered) = 7 THEN d.despatched_qty ELSE 0 END) AS Jul15,
			SUM(CASE WHEN DATEPART(YEAR, h.date_entered) = 2015 AND DATEPART(MONTH, h.date_entered) = 8 THEN d.despatched_qty ELSE 0 END) AS Aug15,
			SUM(CASE WHEN DATEPART(YEAR, h.date_entered) = 2015 AND DATEPART(MONTH, h.date_entered) = 9 THEN d.despatched_qty ELSE 0 END) AS Sep15,
			SUM(CASE WHEN DATEPART(YEAR, h.date_entered) = 2015 AND DATEPART(MONTH, h.date_entered) = 10 THEN d.despatched_qty ELSE 0 END) AS Oct15,
			SUM(CASE WHEN DATEPART(YEAR, h.date_entered) = 2015 AND DATEPART(MONTH, h.date_entered) = 11 THEN d.despatched_qty ELSE 0 END) AS Nov15,
			SUM(CASE WHEN DATEPART(YEAR, h.date_entered) = 2015 AND DATEPART(MONTH, h.date_entered) = 12 THEN d.despatched_qty ELSE 0 END) AS Dec15,
			SUM(CASE WHEN DATEPART(YEAR, h.date_entered) = 2016 AND DATEPART(MONTH, h.date_entered) = 1 THEN d.despatched_qty ELSE 0 END) AS Jan16,
			SUM(CASE WHEN DATEPART(YEAR, h.date_entered) = 2016 AND DATEPART(MONTH, h.date_entered) = 2 THEN d.despatched_qty ELSE 0 END) AS Feb16,
			SUM(CASE WHEN DATEPART(YEAR, h.date_entered) = 2016 AND DATEPART(MONTH, h.date_entered) = 3 THEN d.despatched_qty ELSE 0 END) AS Mar16,
			SUM(CASE WHEN DATEPART(YEAR, h.date_entered) = 2016 AND DATEPART(MONTH, h.date_entered) = 4 THEN d.despatched_qty ELSE 0 END) AS Apr16,
			SUM(CASE WHEN DATEPART(YEAR, h.date_entered) = 2016 AND DATEPART(MONTH, h.date_entered) = 5 THEN d.despatched_qty ELSE 0 END) AS May16,
			SUM(CASE WHEN DATEPART(YEAR, h.date_entered) = 2016 AND DATEPART(MONTH, h.date_entered) = 6 THEN d.despatched_qty ELSE 0 END) AS Jun16,
			SUM(CASE WHEN DATEPART(YEAR, h.date_entered) = 2016 AND DATEPART(MONTH, h.date_entered) = 7 THEN d.despatched_qty ELSE 0 END) AS Jul16,
			SUM(CASE WHEN DATEPART(YEAR, h.date_entered) = 2016 AND DATEPART(MONTH, h.date_entered) = 8 THEN d.despatched_qty ELSE 0 END) AS Aug16,
			SUM(CASE WHEN DATEPART(YEAR, h.date_entered) = 2016 AND DATEPART(MONTH, h.date_entered) = 9 THEN d.despatched_qty ELSE 0 END) AS Sep16,
			SUM(CASE WHEN DATEPART(YEAR, h.date_entered) = 2016 AND DATEPART(MONTH, h.date_entered) = 10 THEN d.despatched_qty ELSE 0 END) AS Oct16,
			SUM(CASE WHEN DATEPART(YEAR, h.date_entered) = 2016 AND DATEPART(MONTH, h.date_entered) = 11 THEN d.despatched_qty ELSE 0 END) AS Nov16,
			SUM(CASE WHEN DATEPART(YEAR, h.date_entered) = 2016 AND DATEPART(MONTH, h.date_entered) = 12 THEN d.despatched_qty ELSE 0 END) AS Dec16
FROM		scheme.opdetm d WITH(NOLOCK)
INNER JOIN 	scheme.opheadm h WITH(NOLOCK)
ON			d.order_no = h.order_no
INNER JOIN 	scheme.stockm m WITH(NOLOCK)
ON			m.product = d.product
AND			m.warehouse = d.warehouse
LEFT JOIN 	scheme.plsuppm p WITH(NOLOCK)
ON			m.supplier = p.supplier
WHERE		h.date_entered between '2015-01-01' AND	'2016-12-31'
AND			m.warehouse ='FG'
group by	p.supplier, p.name, m.product, m.description
ORDER BY	m.product