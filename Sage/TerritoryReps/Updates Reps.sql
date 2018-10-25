-- use these queries to amend and existing rep
SELECT	* 
FROM	dbo.tblQlikViewExtension where Kind = '325'
ORDER BY Code

SELECT	* 
FROM	scheme.cesagebim where kind = '325'
ORDER BY code

SELECT	* 
FROM	scheme.rwmiscm where sub_table ='rep_codes'
ORDER BY sub_table_key
