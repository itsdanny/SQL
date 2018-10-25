select customer, alpha, name, address1, address2, address3, address4, address5, address6, town_city, region from scheme.slcustm
where customer like '2%'
and [name] like 'RETAIL%'