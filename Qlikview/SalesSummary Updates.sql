
SELECT *, LEN(Code) AS CodeLen, LEN(TextSpare1) as sparelen from tblQlikViewExtension WHERE Id IN (1015,1016,1017,1018)

UPDATE tblQlikViewExtension SET Code = 'FLEXITLOTC', TextSpare1 ='FlexitlOTC' WHERE Id = 1016

select *, LEN(Code) AS CodeLen, LEN(TextSpare1) as sparelen
from tblQlikViewExtension
where (Kind = 330)
and ((Code LIKE 'CETRA%')
or  (Code LIKE 'FLEXI%')
or  (Code LIKE 'MOVE%'))



INSERT INTO tblQlikViewExtension 
select  top 1 Title, Kind, 'MOVELATRX', TextSpare1+'RX', TextSpare2, TextSpare3, TextSpare4, TextSpare5, NumberSpare1, NumberSpare2, NumberSpare3, NumberSpare4, NumberSpare5 from tblQlikViewExtension
where	Kind = 330
AND		Code LIKE 'MOVELAT%'

--CETRABEN RX
select * from scheme.stockxpgm 
where product in ('070017','070130','070440','070432','070459','070475','070149','070165','070173','070033','070068','070076','070084','070467','070610','070629')

--CETRABEN OTC
select * from scheme.stockxpgm 
where product in ('070556','070548','070564','070572','070483','070491')

update scheme.stockxpgm set analysis_d = 'CETRABNOTC'
where product in ('070556','070548','070564','070572','070483','070491')

-- FLEXITOL RX
select * from scheme.stockxpgm 
where product in ('076503','076465','076473','076384','076481','076635','076643','076651','076678','076139')

-- FLEXITOL OTC
select * from scheme.stockxpgm 
where product in ('076317','076309','076376','076457','076449','076406','076392','076422','076600','076627','076430','076619','076104','076112','076007','076236','076201','076228','076147','076414','076368','076341','076333','076325')

UPDATE scheme.stockxpgm set analysis_d = 'FLEXITLOTC'
where product in ('076317','076309','076376','076457','076449','076406','076392','076422','076600','076627','076430','076619','076104','076112','076007','076236','076201','076228','076147','076414','076368','076341','076333','076325')



-- SHOW AS UNKNOWNS
select * from scheme.stockxpgm where product in ('070386','070394','070408','070416','070424')
select * from scheme.stockxpgm where product in ('076791','076805','076813','076821','076775')

-- SkinProEmo
UPDATE scheme.stockxpgm SET analysis_d = 'CETRABEN'
where product in ('070386','070394','070408','070416','070424')


select * from scheme.stockxpgm where analysis_d LIKE 'CETRABEN%'
UPDATE scheme.stockxpgm SET analysis_d = 'CETRABENOTC'
where product in ('070556','070548','070564','070572','070483','070491')

22366038230