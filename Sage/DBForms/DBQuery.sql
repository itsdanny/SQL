select ltrim(rtrim(commodity))  from scheme.stockem WITH(NOLOCK) where (warehouse='FG' and product='070548') 


LET FLD_COMPONENT_CODE= EXECUTE(VAR_SQL + "\"set nocount on;select ltrim(rtrim(commodity)) from scheme.stockem WITH(NOLOCK) WHERE product='" +  TRIM(FLD_PRODUCT) + "' and warehouse = '" + FLD_WAREHOUSE +"'\"")

MESSAGE=832,1040,,UNI10,WHOLE(FLD_COMPONENT_CODE)

