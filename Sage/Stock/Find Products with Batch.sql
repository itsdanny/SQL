select * from scheme.stquem where product = '059005' and bin_number ='UDG01' AND 
lot_number IN ('JX88','KA9005','KA9016','KA9031')


select u.lot_number, u.bin_number, a.held_reason_code, a.stock_held_flag, a.product, a.sequence_number, a.warehouse, u.quantity, u.quantity_free, m.unit_code   
from scheme.stquem u
INNER JOIN scheme.stqueam a
ON			u.warehouse = a.warehouse
and			u.product = a.product
and			u.sequence_number = a.sequence_number
INNER JOIN scheme.stockm m
ON			u.warehouse = m.warehouse
and			u.product = m.product
where		u.product = '059005' 
and			u.quantity_free > 0
AND	    	lot_number IN ('JX88','KA9005','KA9016','KA9031')
AND			a.stock_held_flag <> 'y'
AND			u.bin_number ='UDG01' 



select * from scheme.stqueam where product = '059005' and stock_held_flag  = 'n' and sequence_number ='QT(\D"'
select * from scheme.stquem WHERE lot_number LIKE 'KK69%'

SELECT * FROM scheme.stockm WHERE product IN ('057401','057487')