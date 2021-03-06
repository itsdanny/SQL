/****** Script for SelectTopNRows command from SSMS  ******/
SELECT	 d.component_code,	d.stage as CurStage, ISNULL(u.stage1,'') AS FutureStage
FROM		syslive.dbo.BMASSDMUpload u
INNER JOIN	syslive.scheme.bmassdm d
ON			u.assembly_warehouse = d.assembly_warehouse
AND			u.component_code = d.component_code
AND			u.product_code = d.product_code
AND			u.expiry_date = d.expiry_date
AND			u.component_code = d.component_code
AND			u.sequence_number = d.sequence_number
AND			u.component_code ='130000'
/*
select * into scheme.bmassdm_13062016 from syslive.scheme.bmassdm

UPDATE		d
SET			d.stage = ISNULL(u.stage1,'')
FROM		syslive.dbo.BMASSDMUpload u
INNER JOIN	scheme.bmassdm d
ON			u.assembly_warehouse = d.assembly_warehouse
AND			u.component_code = d.component_code
AND			u.product_code = d.product_code
AND			u.expiry_date = d.expiry_date
AND			u.component_code = d.component_code
AND			u.sequence_number = d.sequence_number

*/