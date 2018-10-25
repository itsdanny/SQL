-- 1 need a brand
SELECT  * FROM dbo.tblQlikViewExtension WHERE  Kind = 312--UPPER(Code) LIKE 'FLEX%' and
-- 2 need a brand group
union all
SELECT Id, Title, Code, TextSpare1 FROM dbo.tblQlikViewExtension WHERE Kind = 330--UPPER(Code) LIKE 'FLEX%' and 


-- 1 need a brand
SELECT * FROM dbo.tblQlikViewExtension WHERE  Kind = 312--UPPER(Code) LIKE 'FLEX%' and
-- 2 need a brand group
SELECT * FROM dbo.tblQlikViewExtension WHERE Kind = 330--UPPER(Code) LIKE 'FLEX%' and 

-- 1 need a brand
SELECT * FROM dbo.tblQlikViewExtension WHERE UPPER(Code) LIKE '%KY%'and Kind = 312--330 
-- 2 need a brand group
SELECT * FROM dbo.tblQlikViewExtension WHERE UPPER(Code) LIKE '%KY%' and Kind = 330 

/*

select  analysis_b, product from scheme.stockm where (product in('075280','077836','072397','074691','071587','071501') OR analysis_b = 'KYJELLY') AND warehouse ='FG'--KYJELLY
select  analysis_d,analysis_e, product from scheme.stockxpgm where (product in('075280','077836','072397','074691','071587','071501') OR analysis_d = 'KYJELLY') AND warehouse ='FG'--KYJELLY|

-- 1 need a brand
SELECT * FROM dbo.tblQlikViewExtension WHERE UPPER(Code) LIKE '%KY%'and Kind = 312--330 
-- 2 need a brand group
SELECT * FROM dbo.tblQlikViewExtension WHERE UPPER(Code) LIKE '%KY%' and Kind = 330 

select  analysis_b, product from scheme.stockm where (product in('075280','077836','072397','074691','071587','071501') OR analysis_b = 'KYJELLY') AND warehouse ='FG'--KYJELLY
select  analysis_d,analysis_e, product from scheme.stockxpgm where (product in('075280','077836','072397','074691','071587','071501') OR analysis_d = 'KYJELLY') AND warehouse ='FG'--KYJELLY|

--	
update tblQlikViewExtension set Code = upper(Code) where Id = 1029
*/


SELECT		s.warehouse, s.product, s.analysis_b, t.Title, t.Code, t.Kind, t.TextSpare1 
FROM		scheme.stockm s
INNER JOIN	dbo.tblQlikViewExtension t
ON			s.analysis_b = t.Code
INNER JOIN	scheme.stockxpgm g
ON			g.product = s.product
AND			g.warehouse = s.warehouse
WHERE		t.Kind = '312'
AND			s.warehouse = 'FG'
AND			UPPER(Code) LIKE 'FLEX%' 
ORDER BY	t.Kind, s.analysis_b, TextSpare1

SELECT		product_group, dsc 
FROM		scheme.stkpgm g 
inner join	scheme.stockm s 
on			g.product_group = s.analysis_b
where		s.warehouse = 'FG'

