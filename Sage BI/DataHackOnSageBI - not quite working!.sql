SELECT t.name AS table_name,
SCHEMA_NAME(schema_id) AS schema_name,
c.name AS column_name
FROM sys.tables AS t
INNER JOIN sys.columns c ON t.OBJECT_ID = c.OBJECT_ID
WHERE c.name LIKE '%cost%'
ORDER BY schema_name, table_name;

select cost
FROM [dbo].[DWH_FACT_SALES] 
where cost = 0
and warehouse ='FG'
AND product <> '-1'
and customer <> '-1' order by dated desc

select * from DWH_FACT_SALES where product = '019046'--  and cost = 0
select * from STA_opsahistm where product = '019046'-- and cost = 0
select * from STG_FACT_SALES where product = '019046' --and cost = 0
select * from STA_opdetm where product = '019046' and despatched_qty > 0

select cost_of_sale, * from DWH_SOPOrdersFact where product = '019046'
select cost_of_sale, * from STG_SOPOrdersFact where product = '019046'

opsadetm

update  DWH_FACT_SALES set cost = quantity*4.57 where product = '019046' and cost = 0
update  STA_opsahistm set cost = quantity*4.57 where product = '019046' and cost = 0
update  STG_FACT_SALES set cost = quantity*4.57 where product = '019046' and cost = 0
update  STA_opdetm set cost_of_sale = allocated_qty*4.57 where product = '019046' and despatched_qty > 0

select cost_of_sale, * from DWH_SOPOrdersFact where product = '019046'
select cost, * from STA_opsahistm where product = '019046'
select cost, * from STG_FACT_SALES where product = '019046'
select cost_of_sale, * from STG_SOPOrdersFact where product = '019046'

