--select distinct transaction_type from scheme.stkhstm order by transaction_type

select batch_number, * from scheme.stkhstm with (nolock) where warehouse = 'FG' and product = '002003' order by movement_date desc
select batch_number, * from scheme.stkhstm with (nolock) where warehouse = 'FG' and product = '072516' order by movement_date desc
--select * from scheme.stkhstm  where warehouse = 'FG' and product = '002003' and movement_date = '20141015' and batch_number = '584758' and to_bin_number = 'QCH' and movement_quantity = '36'

