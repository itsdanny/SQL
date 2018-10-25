
select distinct product, analysis_a, m.analysis_x_ref, m.nominal_key, m.purchase_key 
from slam.scheme.stockm as m WITH(NOLOCK) where warehouse = 'SL' ORDER BY  analysis_a
AND analysis_a ='BATTERY'	
*/

select distinct analysis_a from slam.scheme.stockm as m where warehouse = 'SL' order by analysis_a

DECLARE @VAL VARCHAR(3) = '1AC'
update slam.scheme.stockm set analysis_x_ref = @VAL, nominal_key = @VAL, purchase_key = @VAL where warehouse ='SL'and analysis_a = 'ACCESSORY'
set @VAL = '1BA'
update slam.scheme.stockm set analysis_x_ref = @VAL, nominal_key = @VAL, purchase_key = @VAL where warehouse ='SL'and analysis_a = 'BATTERY'
set @VAL = '1CA'
update slam.scheme.stockm set analysis_x_ref = @VAL, nominal_key = @VAL, purchase_key = @VAL where warehouse ='SL'and analysis_a = 'CARTOMIZER'
set @VAL = '1CO'
update slam.scheme.stockm set analysis_x_ref = @VAL, nominal_key = @VAL, purchase_key = @VAL where warehouse ='SL'and analysis_a = 'COILS'
set @VAL = '1DI'
update slam.scheme.stockm set analysis_x_ref = @VAL, nominal_key = @VAL, purchase_key = @VAL where warehouse ='SL'and analysis_a = 'DISPOSABLE'
set @VAL = '1EL'
update slam.scheme.stockm set analysis_x_ref = @VAL, nominal_key = @VAL, purchase_key = @VAL where warehouse ='SL'and analysis_a = 'E-LIQUID'
set @VAL = '1HV'
update slam.scheme.stockm set analysis_x_ref = @VAL, nominal_key = @VAL, purchase_key = @VAL where warehouse ='SL'and analysis_a = 'HIGH VG'
set @VAL = '1KI'
update slam.scheme.stockm set analysis_x_ref = @VAL, nominal_key = @VAL, purchase_key = @VAL where warehouse ='SL'and analysis_a = 'KITS'
set @VAL = '1SV'
update slam.scheme.stockm set analysis_x_ref = @VAL, nominal_key = @VAL, purchase_key = @VAL where warehouse ='SL'and analysis_a = 'SUBVAPES'
set @VAL = '1SU'
update slam.scheme.stockm set analysis_x_ref = @VAL, nominal_key = @VAL, purchase_key = @VAL where warehouse ='SL'and analysis_a = 'SUNDRIES'
set @VAL = '1TA'
update slam.scheme.stockm set analysis_x_ref = @VAL, nominal_key = @VAL, purchase_key = @VAL where warehouse ='SL'and analysis_a = 'TANKS'
