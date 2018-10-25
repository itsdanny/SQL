SELECT * FROM scheme.stockm WITH(NOLOCK) WHERE (warehouse= 'BK') AND (product= '127492')
SELECT * FROM scheme.stockm WITH(NOLOCK) WHERE (warehouse= 'IG') AND (product= '127522')
SELECT * FROM scheme.bmassdm WITH(NOLOCK) WHERE (component_code = '117144')
SELECT * FROM scheme.bmassdm WITH(NOLOCK) WHERE (component_whouse = 'BK') AND (component_code = '127492')
SELECT * FROM scheme.bmassdm WITH(NOLOCK) WHERE (component_whouse = 'BK') AND (component_code = '127476')




SELECT * FROM scheme.bmassdm WITH(NOLOCK) WHERE (component_whouse = 'IG') AND (component_code = '127522')
SELECT assembly_warehouse, product_code, usage_quantity, component_unit FROM scheme.bmassdm WITH(NOLOCK) WHERE (component_whouse = 'IG') AND (component_code = '127522')


SELECT * FROM scheme.bmassdm WITH(NOLOCK) WHERE (component_whouse = 'IG') AND (lower(component_unit) ='g')
SELECT * FROM scheme.bmassdm WITH(NOLOCK) WHERE (component_whouse = 'IG') AND (lower(component_unit) ='kg')

sp__IGStockFigures

select * from IGWeeklyStockLevelsReport

select 13611136.28/1000