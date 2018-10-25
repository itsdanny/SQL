-- Packing Hall
select TOP 1 * from syslive.scheme.wsskm where code LIKE 'PFG%' order by code asc

--HPD
select TOP 1 * from syslive.scheme.wsskm where code LIKE 'HPG%' order by code asc

--MANLAB
select TOP 1 * from syslive.scheme.wsskm where code LIKE 'MN%' order by code asc


select w.std_labour_rate as Rate from Area a inner join syslive.scheme.wsskm w ON a.CostCentreCode = w.code collate Latin1_General_BIN