select * from scheme.stquem where quantity > 0 and warehouse = 'FG' and lot_number not in
(select recon.LotNumber from Integrate.dbo.FullStockRecon recon where recon.SKU = scheme.stquem.prod_code)