
--Data dump for Actis, it's a lot of data...
SELECT		REPLACE(REPLACE(pd.PRACTICE,'NI000',''),'S000','') AS Account_Id, 
			bp.BNF_Name,
			'ThorntonRoss' AS Supplier,
			pd.PERIODDATE AS Date,
			CAST(ITEMS AS INT) AS Units,
			CAST(NIC AS FLOAT) AS Value
FROM		PracticeData pd
INNER JOIN	BNFProducts bp
ON			pd.BNF_CODE = bp.BNF_CODE
WHERE		pd.PERIODDATE between '2013-03-31' and '2015-04-30'
ORDER BY	pd.PERIODDATE

SELECT		* 
FROM		BNFProducts 
WHERE		UPPER(SubCategory) IN('CREAM','BATH','LOTION','OINTMENT','OINTMENTS','TOPICALS')
ORDER BY	SubCategory
