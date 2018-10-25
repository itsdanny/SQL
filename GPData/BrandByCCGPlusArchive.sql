-- This script brings all data by a given brand, by CCG and date
SELECT * FROM
(SELECT		b.Brand, c.Name, pd.PERIODDATE, SUM(pd.ITEMS) as Items, SUM(pd.NIC) as Cash
FROM		BNFBrand b
INNER JOIN	BNFProducts p
ON			b.Id = p.BNFBrandId
INNER JOIN	PracticeData pd
ON			p.BNF_CODE = pd.BNF_CODE
INNER JOIN	Practice pr
ON			pr.Code = pd.PRACTICE
INNER JOIN	CCGLookup c
ON			pr.CCGCode = c.Code
WHERE		UPPER(b.Brand) like 'CETRA%'
GROUP BY	b.Brand, c.Name, pd.PERIODDATE
UNION
SELECT		b.Brand, c.Name, pd.PERIODDATE, SUM(pd.ITEMS) as Items, SUM(pd.NIC) as Cash
FROM		BNFBrand b
INNER JOIN	BNFProducts p
ON			b.Id = p.BNFBrandId
INNER JOIN	PracticeDataArchive pd
ON			p.BNF_CODE = pd.BNF_CODE
INNER JOIN	Practice pr
ON			pr.Code = pd.PRACTICE
INNER JOIN	CCGLookup c
ON			pr.CCGCode = c.Code
WHERE		UPPER(b.Brand) like 'CETRA%'
GROUP BY	b.Brand, c.Name, pd.PERIODDATE) r
ORDER BY	PERIODDATE, Name

