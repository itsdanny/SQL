select * from scheme.stquem as sage where sage.warehouse = 'FG' and sage.quantity > 0 and sage.bin_number not like 'UDG%' and LEFT(sage.lot_number, len(sage.lot_number)-2) in

(select LEFT(UDG.LotNumber, len(UDG.LotNumber)-2) from Integrate.dbo.FullStockRecon UDG where sage.product = UDG.SKU) 