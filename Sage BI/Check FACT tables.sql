-- RUN THIS ON TRSAGEV3D1.SYSLIVE
select * from scheme.stkhstm where product = '087335' and warehouse ='FG'
And transaction_type = 'SALE' AND dated between '2014-01-01 00:00:00' and '2014-12-31 00:00:00'


--- THIS ON TRSERVSQL

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT *
  FROM [SalesLive].[dbo].[STA_opdetm] d
inner join [SalesLive].[dbo].STA_opheadm h
ON	d.order_no = h.order_no
  where product = '087335'
  and slyear = 2014  
  

  SELECT d.*, d.cost_of_sale
  FROM [SalesLive].[dbo].[STA_opdetm] d
inner join [SalesLive].[dbo].STA_opheadm h
ON	d.order_no = h.order_no
  where product = '087335'
  and date_despatched is not null
  

  SELECT        TOP (200) customer, warehouse, product, dated, quantity, val, cost, list_value, commission
FROM            STA_opsahistm
WHERE        (product = '087335') AND (cost = 0)

SELECT        customer, warehouse, product, dated, quantity, val, cost, list_value, commission, dateforload
FROM            DWH_FACT_SALES
WHERE        (product = '087335')

SELECT        TOP (200) customer, warehouse, product, dated, quantity, val, cost, list_value, commission, dateforload
FROM            STG_FACT_SALES
