
select component_whouse, component_code, component_unit, usage_quantity from syslive.scheme.bmassdm where product_code in ('016306','016462') and component_whouse = 'BK'
select component_whouse, component_code, component_unit, usage_quantity,* from syslive.scheme.bmassdm where product_code = '006696' and component_whouse = 'BK'
select component_whouse, component_code, component_unit, usage_quantity from syslive.scheme.bmassdm where product_code = '127255' and component_whouse = 'BK'

SELECT * FROM scheme.