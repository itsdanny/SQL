SELECT * FROM ReportCategories WHERE Id in (5,3)
select * from dbo.BNFBrand where BrandGroupId = 3
select * from dbo.BNFBrand where Id in(475,476,53,77,78,86,111,160,165,166,167,168,171,172,180,181,182,183,208,312,313) ORDER BY Brand
update dbo.BNFBrand set BrandGroupId = NULL where Id in(475,476)--,53,77,78,86,111,160,165,166,167,168,171,172,180,181,182,183,208,312,313) 
update dbo.BNFBrand set ReportCategoryId = null, SixInOne = null, EightInOne= 1 where Id in(475,476)
update dbo.BNFBrand set ReportCategoryId = 5, SixInOne = 1, EightInOne= 1 where Id in(475,476)
SELECT * FROM BrandGroup