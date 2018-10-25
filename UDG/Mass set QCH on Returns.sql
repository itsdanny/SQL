SELECT		a.warehouse, a.product, a.lot_number2, a.pallet_number, a.stock_held_flag, a.held_reason_code, b.batch_number, b.bin_number,b.lot_number
FROM		scheme.stqueam a
INNER JOIN	scheme.stquem b
ON			a.product = b.product
AND			a.sequence_number = b.sequence_number
WHERE		b.bin_number = 'UDG01'
AND			a.held_reason_code <> 'BS'
AND			a.held_reason_code <> ''
order by	a.held_reason_code


/*
SELECT   scheme.stquem.product, scheme.stquem.lot_number, stqueam.sequence_number-- into #tmp
FROM            scheme.stquem INNER JOIN
                         scheme.stqueam ON scheme.stquem.warehouse = scheme.stqueam.warehouse AND scheme.stquem.product = scheme.stqueam.product AND 
                         scheme.stquem.sequence_number = scheme.stqueam.sequence_number
WHERE        (scheme.stquem.bin_number = 'UDG08') AND (scheme.stquem.quantity > 0) AND (scheme.stqueam.stock_held_flag = 'n')

alter table #tmp
add Id Int Identity(1,1)

DECLARE	@Warehouse varchar(2)
DECLARE	@Product varchar(20)
DECLARE @LotNumber varchar(10)
DECLARE @Inspected varchar(1)
DECLARE @SequenceNumber char(6)
DECLARE @HeldStatus varchar(6)
DECLARE @IsStockHeld char(1)
DECLARE @UDGUpdate bit	

DECLARE @Rows int = (SELECT COUNT(1) FROM #tmp)
DECLARE @CurRow int = 1
WHILE @CurRow <= @Rows
BEGIN
select @Warehouse = 'FG', @Product = product, @LotNumber = lot_number, @Inspected = 'N', @SequenceNumber =sequence_number, @HeldStatus = 'QCH', @IsStockHeld ='y', @UDGUpdate = 0  from #tmp where Id = @CurRow

--SELECT @Warehouse, @Product, @LotNumber, @Inspected, @SequenceNumber, @HeldStatus, @IsStockHeld, @UDGUpdate
-- sp__integrate_stock_held 'FG','072117', '4128413','N','QI<f0!', 'QCH', 'y', 0

 exec sp__integrate_stock_held 'FG', @Product, @LotNumber,'N', @SequenceNumber, 'QCH', 'y', 0

SET @CurRow = @CurRow + 1
END



*/

select ProductCode, LotNumber, ExpiryDate from StockReconciliation where BinNumber in ('UDG08','UDG01','UDG03') and ProductCode in ('005576','005932','00622X','019046','024384','044490','055026','056049','059013','059129','060560','067571','072257','088412','088676','089311')


select ProductCode, LotNumber, ExpiryDate, BinNumber into #TMP from Integrate.dbo.StockReconciliation --where BinNumber in ('UDG08','UDG01','UDG03') and ProductCode in ('005576','005932','00622X','019046','024384','044490','055026','056049','059013','059129','060560','067571','072257','088412','088676','089311')



SELECT		a.expiry_date OurDate, t.ExpiryDate as UDGDate, a.*
FROM		scheme.stquem  a
INNER JOIN  Integrate.dbo.StockReconciliation t
ON			a.product = t.ProductCode
AND			a.lot_number = t.LotNumber
AND			a.expiry_date <> t.ExpiryDate
AND			a.bin_number = t.BinNumber
AND			a.quantity_free > 0
WHERE		a.batch_number NOT LIKE 'R%'
--WHERE		t.StatusReason = 'QCH'
ORDER BY	a.product

update		a
SET			a.expiry_date = t.ExpiryDate
FROM		scheme.stquem  a
INNER JOIN  Integrate.dbo.StockReconciliation t
ON			a.product = t.ProductCode
AND			a.lot_number = t.LotNumber
AND			a.expiry_date <> t.ExpiryDate
AND			a.bin_number = t.BinNumber
--AND			a.quantity_free > 0
--WHERE		a.prod_code = '086126'
WHERE		t.StatusReason = 'QCH'


drop table #TMP

alter table #TMP
add Id Int Identity(1,1)
089508
use syslive

select * from #TMP
DECLARE	@Product varchar(20)
DECLARE @LotNumber varchar(10)
DECLARE @EXP DATETIME

DECLARE @Rows int = (SELECT COUNT(1) FROM #TMP)
DECLARE @CurRow int = 1

WHILE @CurRow <= @Rows
BEGIN
	select @Product = ProductCode, @LotNumber = LotNumber, @EXP = ExpiryDate from #TMP where Id = @CurRow

	select product, lot_number, expiry_date, @EXP from scheme.stquem  where product = @Product and lot_number like @LotNumber+'%' AND bin_number like 'UDG%' and expiry_date <> @EXP

	--UPDATE scheme.stquem SET expiry_date = @EXP  where product = @Product and lot_number like @LotNumber+'%' AND bin_number like 'UDG%'  and expiry_date <> @EXP
	
SET @CurRow = @CurRow + 1
END

select * from Errors order by Id desc
select * from Log order by Id desc
select * from [dbo].[ReturnsAdjustment] order by Id desc