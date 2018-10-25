DECLARE @PROD VARCHAR(8) = '126410'
DECLARE @LOT VARCHAR(6) = 'RY79%'
DECLARE @PrintDateStr VARCHAR(100) = '21/07/16'
DECLARE @ExpDateStr VARCHAR(100) = '28/07/16'
DECLARE @DateComplete DATETIME = '2016-07-21 00:00:00.000'
DECLARE @ManufacturedDateTime DATETIME = '2016-07-21 21:05:28.000'
DECLARE @Comments CHAR(60) = 'WCI1.01.02,21/07/16,21:05:28,M8'
DECLARE @PrintId INT = 142040
DECLARE @DateKey CHAR(28) = 'BK126410              042578' -- SELECT DATEDIFF(D,'1900-01-01 00:00:00', GETDATE())
/*
SELECT * FROM syslive.scheme.fsprdatam WITH (NOLOCK) WHERE print_id in (SELECT print_id FROM [syslive].[scheme].[fsprdatam] WITH (NOLOCK) WHERE print_str like @LOT) order by print_id desc
SELECT * FROM dbo.Def_DefCap_BKManufacturingDate WITH (NOLOCK) WHERE  product_code = @PROD AND lot_number LIKE @LOT
SELECT * FROM scheme.stquem WITH (NOLOCK) WHERE product = @PROD AND lot_number LIKE @LOT
SELECT * FROM scheme.stkhstm WITH (NOLOCK) WHERE product = @PROD AND lot_number LIKE @LOT
*/

select movement_date, @DateComplete as NewMvmtDate, expiry_date, DATEADD(D, 7, @DateComplete) as NewExpDate, comments, @Comments as NewComments from scheme.stkhstm  WHERE product = @PROD AND lot_number LIKE @LOT
select expiry_date, DATEADD(D, 7, @DateComplete) as NewExpDate from scheme.stquem WHERE product = @PROD AND lot_number LIKE @LOT
select manufactured_dt, @ManufacturedDateTime NewManufactureDate from dbo.Def_DefCap_BKManufacturingDate WHERE lot_number LIKE @LOT AND product_code = @PROD
select print_str, @PrintDateStr NewprintStr from scheme.[fsprdatam] WHERE print_id = @PrintId AND print_field = 'date_created'
select print_str, @ExpDateStr NewExpDate from scheme.[fsprdatam] WHERE print_id = @PrintId AND print_field = 'expiry_date'

/*
UPDATE scheme.stkhstm SET movement_date = @DateComplete, expiry_date = @DateComplete, comments = @Comments WHERE product = @PROD AND lot_number = @LOT
-- PROB EASIER TO DO THIS ONE VIA THE EDIT TOP 200 ROUTE (!!! USE THE ABOVE SELECT !!!)
UPDATE scheme.stquem SET date_received = @DateComplete, inspection_date = @DateComplete, sell_by_date =DATEADD(D, 7, @DateComplete), expiry_date = DATEADD(D, 7, @DateComplete) WHERE product = @PROD AND lot_number LIKE @LOT
UPDATE dbo.Def_DefCap_BKManufacturingDate SET manufactured_dt = @ManufacturedDateTime WHERE lot_number LIKE @LOT AND product_code = @PROD
UPDATE scheme.[fsprdatam] SET print_str = @PrintDateStr WHERE print_id = @PrintId AND print_field = 'date_created'
UPDATE scheme.[fsprdatam] SET print_str = @ExpDateStr WHERE print_id = @PrintId AND print_field = 'expiry_date'

*/
