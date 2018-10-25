select *, LEN(Brand) from BNFBrand where UPPER(Brand) LIKE 'BAL%'

select * from BNFProducts where BNFBrandId in (75,76)

SELECT * FROM BNFProducts  where BNF_CODE like '1302011M0AAAGAG'

update BNFProducts set  ZeroCompareBrandId = NULL, ZeroPercent = NULL where BNF_CODE ='1302011M0AAAGAG'
update BNFProducts set BNFBrandId = 75 where BNF_CODE ='130201100BBAEAA'



select distinct BNF_NAME,BNF_CODE from PracticeData where BNF_CODE in ('130201100AAAMAM','1302010F0AAAAAA')

select * from [dbo].[vEmollientProductDim]  where BNF_CODE ='130201000AACDCD'

Balneum Bath
Balneum Bath                  
