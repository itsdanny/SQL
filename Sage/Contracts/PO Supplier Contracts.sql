SELECT       complete, *
FROM            scheme.poschddcm
WHERE        (num = 'C000535')

SELECT        complete, *
FROM            scheme.poschdcm
WHERE        (num = 'C000535')


select * from scheme.poheadm WHERE order_no in ('056981','060125')
select * from scheme.podetm WHERE order_no in ('056981','060125')




EXEC [syslive].[dbo].[sp__po_contract_number] '056981'
go
EXEC [syslive].[dbo].[sp__po_contract_number] '060125'

select * from scheme.poconpom where order_no in ('060125','056981')
select * from scheme.poconpom order by order_no desc



EXEC [syslive].[dbo].[sp__po_contract_number] '060125'

