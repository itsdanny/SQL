-- GETS SUPPLS WHERE SUPP = CUST AND WITH OPEN ITEMS
DECLARE @Supps TABLE(Supplier VARCHAR(10), SupplierName varchar(50), Address1 varchar(50))

INSERT INTO @Supps
SELECT		DISTINCT s.supplier, s.name, s.address1,  c.customer, c.name, c.address1 
FROM		scheme.slcustm c
INNER JOIN	scheme.plsuppm s
ON			c.name = s.name
and			c.address1 = s.address1
-- USE SUPPLIER 
-- PLITEM FOR OPEN ITEMS
SELECT		s.Supplier, s.SupplierName, s.Address1, p.due_date, p.kind, p.local_amount
FROM		scheme.plitemm p
INNER JOIN	@Supps s
ON			p.supplier = s.Supplier
AND			p.open_indicator IN ('O')
where		p.hold_indicator = ''

