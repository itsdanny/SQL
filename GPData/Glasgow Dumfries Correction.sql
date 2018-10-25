SELECT * FROM BNFBrand WHERE UPPER(Brand) like '%CETRA%'
select * from Countries
select * from CCGLookup where Name like '%GLAS%' order by Name
select * from CCGLookup where Name like '%DUMFRIES%' order by Name

SELECT sum(NIC) FROM Practice p
inner join PracticeData pd
ON		p.Code = pd.PRACTICE
INNER JOIN BNFProducts bp
ON		pd.BNF_CODE = bp.BNF_CODE
where p.CountryId = 3
AND		p.CCGCode = 'SY9'
AND		pd.PERIOD = '201409'
AND		bp.BNFBrandId in (92,93,94,360)

SELECT sum(NIC) FROM Practice p
inner join PracticeData pd
ON		p.Code = pd.PRACTICE
INNER JOIN BNFProducts bp
ON		pd.BNF_CODE = bp.BNF_CODE
where p.CountryId = 3
AND		p.CCGCode = 'SJ9'
AND		pd.PERIOD = '201409'
AND		bp.BNFBrandId in (92,93,94,360)


SELECT * FROM CCGLookup c
INNER JOIN Practice p
on				c.Code = p.CCGCode
where p.CountryId = 3
select * from Practice where Code  LIKE '%52260'
select * from Practice where CCGCode ='SY9' 
select * from Practice where CCGCode ='SJ9'

/*
update Practice set CCGCode ='SJ9' where CCGCode ='SJ9D' 
update Practice set CCGCode ='SY9' where CCGCode ='SY9D' 
*/
select * from Practice where CCGCode ='SJ9'
