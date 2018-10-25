USE InsightTest 
SELECT MAX(r.resource_code) AS line, warehouse, product_code, works_order, wo.description, quantity_required, 
SUM(time_per_batchsize) As StandardRunTime,r.operator_code as operator_code FROM syslive.scheme.bmwohm wo WITH(NOLOCK) 
INNER JOIN syslive.scheme.wsroutdm r ON (wo.warehouse + wo.product_code = r.code) WHERE (works_order = 'BW34D') 
group by  warehouse, product_code, works_order, wo.description, quantity_required, r.operator_code  order by StandardRunTime desc

SELECT r.* FROM syslive.scheme.bmwohm r WHERE  r.works_order ='JM53A'
SELECT r.quantity_finished, finish_prod_unit FROM syslive.scheme.bmwohm r WHERE  r.works_order ='JM07'
SELECT r.* FROM syslive.scheme.wsroutdm r WHERE code LIKE '%002003%'

select * from InsightErrors order by ErrorDate desc

KC97A

USE Insight 
select * from ManufacturingJob where WorkOrderNumber = 'KC97A'
select * from ManufacturingJobLog where ManufacturingJobId = 1782
select * from ManLabSummary where WorkOrder = 'KC97A'

use MachineTracker
select * from [dbo].[WorkCentre] order by Description

use syslive
select distinct resource_code from syslive.scheme.wsroutdm r where resource_code  collate Latin1_General_CI_AS in
(SELECT SageRef FROM Insight.dbo.WorkCentre)