select * from BrandManager with (nolock)

select * from BrandManagerProduct where BrandManagerId = 4
select * from BrandManagerProduct where BrandManagerId = 8
/*
insert into BrandManagerProduct (ProductCode, BrandManagerId)
select ProductCode, 4 from Product where ProductCode in ('076007','076104','076112','076139','076201','076228','076309','076317','076325','076333','076341','076368','076376','076384','076392','076406','076414','076422','076430','076449','076457','076465','076473','076481','076503','076600','076619','076627','076643','076651','076678')

*/