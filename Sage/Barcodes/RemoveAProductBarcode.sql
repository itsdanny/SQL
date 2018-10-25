-- iF YOU NEED TO REMOVE A BARCODE FROM A PRODUCT, IF IT'S DEAD THEN...
select * from scheme.sttechm where page_number = 26 and product = '008567'

delete from scheme.sttechm where page_number = 26 and product = '008567'