 select * from scheme.opdetm where order_no = '2E223463'

SELECT  * FROM scheme.stunitdm with(NOLOCK) 
USE trdbform

SELECT * FROM [trdbform].[dbo].[tbl_printer_location] WHERE UPPER(Location) LIKE '%KYOCERA%'
/*
SELECT * FROM [tbl_printer_location] where id = 4
-- ACCOUNTS
--UPDATE [trdbform].[dbo].[tbl_printer_location] set Location = '\\trprint\SHARP_Accounts' where id = 4 --\\trprint\Kyocera_Accounts

-- EXPORT
--UPDATE [trdbform].[dbo].[tbl_printer_location] set Location = '\\trprint\TR01441' where id = 5 --\\trprint\Kyocera_Export

-- SALE
UPDATE [trdbform].[dbo].[tbl_printer_location] set Location = '\\trprint\TR01444' where id IN (3,6,7) --\\trprint\Kyocera_Sales

-- MARKETING
UPDATE [trdbform].[dbo].[tbl_printer_location] set Location = '\\trprint\Sharp_Marketing' where id = 23 -- \\trprint\Kyocera_Marketing

-- TRANSPORT
UPDATE [trdbform].[dbo].[tbl_printer_location] set Location = '\\trprint\Sharp_Transport' where id = 11 -- \\trprint\Kyocera_Transport

*/

use syslive
create view scheme.vstokcm
as
select * from scheme.stockm WITH(NOLOCK)
go
SELECT * FROM scheme.vstokcm