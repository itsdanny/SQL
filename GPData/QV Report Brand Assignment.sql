
select * from BNFBrand WHERE Id in(58,67,93,113,127,133,138,156,334,335,336,339, 66,92,112,254,340,341,70,94,114,142,53,86,111,166,180,182,48,204,242,243,244,245,273,327,328) order by Brand

update BNFBrand set SixInOne = 1 WHERE Id in(58,67,93,113,127,133,138,156,334,335,336,339, 66,92,112,254,340,341,70,94,114,142,53,86,111,166,180,182,48,204,242,243,244,245,273,327,328,337)
update BNFBrand set EightInOne = 1 WHERE Id in(58,75,127,138,157,188,259,311,334,335,336,339,340,341,337,338,342,310,474,54,218)

SELECT * 
FROM		BNFBrand b 
INNER JOIN	BNFProducts p
ON			b.Id = p.BNFBrandId
WHERE Id	IN(58,67,93,113,127,133,138,156,334,335,336,339, 66,92,112,254,340,341,70,94,114,142,53,86,111,166,180,182,48,204,242,243,244,245,273,327,328)

SELECT * FROM dbo.ReportCategories


SELECT 1, Id, 'Cetraben Cream' FROM BNFBrand WHERE Id IN (58,67,93,113,127,133,138,156,334,335,336,339) -- 'Cream'
UNION
--Cetraben Bath:
SELECT 2, Id, 'Cetraben Bath' FROM BNFBrand WHERE Id IN (66,92,112,254,340,341) -- 'Bath'
UNION
--Cetraben Lotions:
SELECT 3, Id, 'Cetraben Lotion' FROM BNFBrand WHERE Id IN (70,94,114,142) -- 'Lotion'
UNION
--Cetraben Ointments:
SELECT 4, Id,'Cetraben Ointment' FROM BNFBrand WHERE Id IN (128,157,188,337,360) -- 'Ointment'
UNION
--	Cetraben Total: 
--Flexitol:
SELECT 6, Id, 'FLEXTITOL TOTAL' FROM BNFBrand WHERE Id IN (53,86,111,166,180,182) -- 'Flexitol'
UNION
--Topicals (Movelat):
SELECT 7, Id, 'MOVELAT TOTAL' FROM BNFBrand WHERE Id IN (48,204,242,243,244,245,273,327,328) -- Movelat
select * from BNFBrand where EightInOne = 1 or SixInOne = 1 order by Brand
select * from BNFProducts where BNFBrandId in ()


UPDATE BNFProducts
SET BNFBrandId = 483
WHERE BNFBrandId in (242,244,245)

UPDATE BNFProducts
SET BNFBrandId = 484
WHERE BNFBrandId in (327,328)

UPDATE BNFProducts
SET BNFBrandId = 485
WHERE BNFBrandId in (254,259)


update b set 
b.
from BrandUpdateImport i 
INNER JOIN BNFBrand b
ON		i.Id = b.Id

SELECT		b.Brand, case b.SixInOne when 1 then 'Y' ELSE '' end AS SixInOne,
			case b.EightInOne when 1 then 'Y' ELSE '' end AS EightInOne,
			ISNULL(r.BrandCategory, '') as ReportCategory
FROM		BNFBrand b
LEFT JOIN	ReportCategories r
ON			b.ReportCategoryId = r.Id
ORDER BY	b.Brand

select * from BNFBrand order by Brand
SELECT * FROM BNFBrand WHERE Id IN (66,92,112,254,340,341) -- 'Bath'

select * from CompareBrands c
INNER JOIN	BNFBrand b
ON		c.CompareBrandId = b.Id

