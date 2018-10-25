USE syslive
/*
select * from MachineTracker.dbo.Department where DepartmentCode in ('HPD','PFD','MNL')
SELECT * FROM syslive.scheme.wsskm WHERE no_of_operators = 1
*/
--	qry2015StdCost
go
CREATE VIEW qry2015StdCost
AS
/*
SELECT dbo_Product.ProductCode, dbo_Product.Description, dbo_Department.DepartmentCode, dbo_Process.ID, dbo_Process.Crew, dbo_OperationName.Description, dbo_Product.UOM, 

IIf([dbo_Product]![Warehouse]="FG",(1/([dbo_Process]![CostStandard]*60))*[dbo_Product]![UOM],IIf([dbo_Department!DepartmentCode]="PFD",1/([dbo_Process]![CostStandard]*60),([dbo_Process]![CostStandard]/60)/[dbo_Product]![EOQ])) AS RT, 
[RT]*[Crew] AS ManTime, 
[Dept New CO Rate for 2015]![ChargeoutRate]*[RT]*[Crew] AS Cost, dbo_Process.line_number, dbo_Process.ProcessGroupID, dbo_WorkCentre.WorkCentreCode, dbo_WorkCentre.Description, dbo_Product.Warehouse
FROM (((((dbo_Product INNER JOIN dbo_Process ON dbo_Product.ID = dbo_Process.ProductID) INNER JOIN dbo_ProcessGroup ON dbo_Process.ProcessGroupID = dbo_ProcessGroup.ID) INNER JOIN dbo_WorkCentre ON dbo_ProcessGroup.WorkCentreID = dbo_WorkCentre.ID) INNER JOIN dbo_Department ON dbo_WorkCentre.DepartmentID = dbo_Department.ID) INNER JOIN dbo_OperationName ON dbo_Process.OperationNameID = dbo_OperationName.ID) INNER JOIN [Dept New CO Rate for 2015] ON dbo_Department.DepartmentCode = [Dept New CO Rate for 2015].Department
WHERE (((dbo_Product.ProductCode) Like "0*") AND ((dbo_OperationName.Description) Not Like "*Washout*" And (dbo_OperationName.Description) Not Like "Batch*" And (dbo_OperationName.Description) Not Like "*Size*") AND ((dbo_Process.IsCosting)=True)) OR (((dbo_Product.ProductCode) Like "1*") AND ((dbo_OperationName.Description) Not Like "*Washout*" And (dbo_OperationName.Description) Not Like "Batch*" And (dbo_OperationName.Description) Not Like "*Size*") AND ((dbo_Process.IsCosting)=True))
ORDER BY dbo_Product.ProductCode;

DROP VIEW qry2015StdCost
select * from qry2015StdCost

*/

SELECT	pr.ProductCode, pr.Description as ProductDescription, d.DepartmentCode, pr.ID, ps.Crew, opn.Description as OperationDescription, pr.UOM, 
		--	IIf([dbo_Product]![Warehouse]="FG",(1/([dbo_Process]![CostStandard]*60))*[dbo_Product]![UOM],
		--	IIf([dbo_Department!DepartmentCode]="PFD",1/([dbo_Process]![CostStandard]*60),
		--	([dbo_Process]![CostStandard]/60)/[dbo_Product]![EOQ])) AS RT, 
		CASE pr.Warehouse WHEN 'FG' THEN (1/(ps.CostStandard * 60) * pr.UOM) ELSE CASE d.DepartmentCode WHEN 'PFD' THEN (1/ps.CostStandard * 60) ELSE (ps.[CostStandard]/60)/pr.[EOQ] END END AS RT, 
		--pr.Warehouse,
		--ps.CostStandard,		
		--pr.EOQ,

		--[RT]*[Crew] AS Mantime,
		CASE pr.Warehouse WHEN 'FG' THEN (1/(ps.CostStandard * 60) * pr.UOM) ELSE CASE d.DepartmentCode WHEN 'PFD' THEN (1/ps.CostStandard * 60) ELSE (ps.[CostStandard]/60)/pr.[EOQ] END END * Crew as ManTime,
		wk.std_labour_rate * (CASE pr.Warehouse WHEN 'FG' THEN (1/(ps.CostStandard * 60) * pr.UOM) ELSE CASE d.DepartmentCode WHEN 'PFD' THEN (1/ps.CostStandard * 60) ELSE (ps.[CostStandard]/60)/pr.[EOQ] END END) *[Crew] AS Cost, 
		ps.line_number, ps.ProcessGroupID, w.WorkCentreCode, w.Description, pr.Warehouse
FROM		(((((MachineTracker.dbo.Product	pr
INNER JOIN	MachineTracker.dbo.Process as ps
ON			pr.ID = ps.ProductID) 
INNER JOIN	MachineTracker.dbo.ProcessGroup  as pg
ON			ps.ProcessGroupID = pg.ID) 
INNER JOIN	MachineTracker.dbo.WorkCentre as w
ON			pg.WorkCentreID = w.ID) 
INNER JOIN	MachineTracker.dbo.Department as d
ON			w.DepartmentID = d.ID) 
INNER JOIN	MachineTracker.dbo.OperationName as opn
ON			ps.OperationNameID =opn.ID) 
--INNER JOIN	[Dept New CO Rate for 2015] 
--ON			d.DepartmentCode = [Dept New CO Rate for 2015].Department
INNER JOIN	syslive.scheme.wsskm wk
ON			CASE wk.code WHEN 'HPG1' THEN 'HPD' WHEN 'MNG1' THEN 'MNL' WHEN 'PFG1' THEN 'PFD' END = d.DepartmentCode
AND			no_of_operators = 1
--WHERE (((dbo_Product.ProductCode) Like "0*") AND ((dbo_OperationName.Description) Not Like "*Washout*" And (dbo_OperationName.Description) Not Like "Batch*" And (dbo_OperationName.Description) Not Like "*Size*") AND ((dbo_Process.IsCosting)=True)) OR (((dbo_Product.ProductCode) Like "1*") AND ((dbo_OperationName.Description) Not Like "*Washout*" And (dbo_OperationName.Description) Not Like "Batch*" And (dbo_OperationName.Description) Not Like "*Size*") AND ((dbo_Process.IsCosting)=True))
WHERE  (((pr.ProductCode) Like '0%') AND ((opn.Description) Not Like '%Washout%' And (opn.Description) Not Like 'Batch%' And (opn.Description) Not Like '%Size%') AND ((ps.IsCosting)=1)) 
	OR (((pr.ProductCode) Like '1%') AND ((opn.Description) Not Like '%Washout%' And (opn.Description) Not Like 'Batch%' And (opn.Description) Not Like '%Size%') AND ((ps.IsCosting)=1))
GO

create view qryPeriodEndQtyComplete
as
--	DROP VIEW qryPeriodEndQtyComplete

SELECT	scheme.bmhstm.works_order, scheme.bmhstm.actual_warehouse + scheme.bmhstm.actual_prod_code AS ProdCode, scheme.bmwohm.description, Sum(scheme.bmhstm.quantity_finished) AS SumOfquantity_finished, 
		tblWeek.Period, scheme.bmwohm.alpha_code, scheme.bmwohm.warehouse, scheme.bmwohm.product_code, scheme.bmwohm.finish_prod_unit, tblWeek.Week
FROM		(scheme.bmhstm LEFT JOIN scheme.bmwohm 
ON			scheme.bmhstm.works_order = scheme.bmwohm.works_order) 
INNER JOIN	tblWeek 
ON			scheme.bmhstm.event_date = tblWeek.Date
GROUP BY	scheme.bmhstm.works_order, scheme.bmhstm.actual_warehouse + scheme.bmhstm.actual_prod_code, scheme.bmwohm.description, tblWeek.Period, scheme.bmwohm.alpha_code, 
			scheme.bmwohm.warehouse, scheme.bmwohm.product_code, scheme.bmwohm.finish_prod_unit, tblWeek.Week
--ORDER BY scheme.bmhstm.works_order;

/*

SELECT        TOP (100) PERCENT scheme.bmhstm.works_order, scheme.bmhstm.actual_warehouse + scheme.bmhstm.actual_prod_code AS ProdCode, 
                         scheme.bmwohm.description, SUM(scheme.bmhstm.quantity_finished) AS SumOfquantity_finished, dbo.tblWeek.Period, scheme.bmwohm.alpha_code, 
                         scheme.bmwohm.warehouse, scheme.bmwohm.product_code, scheme.bmwohm.finish_prod_unit, dbo.tblWeek.Week
FROM            scheme.bmhstm LEFT OUTER JOIN
                         scheme.bmwohm ON scheme.bmhstm.works_order = scheme.bmwohm.works_order INNER JOIN
                         dbo.tblWeek ON scheme.bmhstm.event_date = dbo.tblWeek.Date
GROUP BY scheme.bmhstm.works_order, scheme.bmhstm.actual_warehouse + scheme.bmhstm.actual_prod_code, scheme.bmwohm.description, dbo.tblWeek.Period, 
                         scheme.bmwohm.alpha_code, scheme.bmwohm.warehouse, scheme.bmwohm.product_code, scheme.bmwohm.finish_prod_unit, dbo.tblWeek.Week
ORDER BY scheme.bmhstm.works_order
*/
GO

-- MAIN QTY
-- qryPeriodEndStdRecoveryByDeptWk
/*
SELECT qry2015StdCost.DepartmentCode, qryPeriodEndQtyComplete.ProdCode, qry2015StdCost.ID, qry2015StdCost.dbo_Product.Description AS Expr1, qryPeriodEndQtyComplete.description, qryPeriodEndQtyComplete.works_order, 
qryPeriodEndQtyComplete.SumOfquantity_finished, 
[qryPeriodEndQtyComplete]![SumOfquantity_finished]*[qry2015StdCost]![ManTime] AS TotTime, 
[qryPeriodEndQtyComplete]![SumOfquantity_finished]*[qry2015StdCost]![Cost] AS TotCost, 
qryPeriodEndQtyComplete.Week
FROM qryPeriodEndQtyComplete INNER JOIN qry2015StdCost ON qryPeriodEndQtyComplete.product_code = qry2015StdCost.ProductCode
WHERE (((qryPeriodEndQtyComplete.SumOfquantity_finished)>0) AND ((qryPeriodEndQtyComplete.Week)>=[Week From ie W48] And (qryPeriodEndQtyComplete.Week)<=[Week To ie W48]) AND ((qryPeriodEndQtyComplete.PERIOD)=[Enter Period ie P201501]))
ORDER BY qry2015StdCost.DepartmentCode, qry2015StdCost.dbo_Product.Description, qryPeriodEndQtyComplete.works_order;

*/

--select * from qryPeriodEndQtyComplete
SELECT		q.DepartmentCode, c.ProdCode, q.ID, q.ProductDescription,
			c.description, c.works_order, c.SumOfquantity_finished,
			--q.[ManTime],
			--q.Cost,
			c.[SumOfquantity_finished]*q.[ManTime] AS TotTime, 
			c.[SumOfquantity_finished]*q.[Cost] AS TotCost,
			c.Week
FROM		qryPeriodEndQtyComplete c
INNER JOIN	qry2015StdCost q 
ON			c.product_code = q.ProductCode collate Latin1_General_CI_AS
WHERE		((c.SumOfquantity_finished)>0) 
AND			(c.Week)>='W31'
And			(c.Week)<='W31'
AND			(c.Period='P201510')
--AND			c.ProdCode  in ('FG016365','BK130442')
ORDER BY	q.DepartmentCode, q.ProductDescription, c.works_order;


drop view qryPeriodEndQtyComplete
DROP VIEW qry2015StdCost
RETURN

select * from qryPeriodEndQtyComplete
select * from qry2015StdCost