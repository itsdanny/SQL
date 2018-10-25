DECLARE @PO VARCHAR(6) = '066283'
SELECT * FROM scheme.poheadm WITH(NOLOCK) where order_no in (@PO) --AND status = 'C'
SELECT * FROM scheme.podetm WITH(NOLOCK)  where order_no in (@PO) --AND status = 'C'


UPDATE scheme.poheadm SET status = 'P' where order_no in (@PO) AND status IN ('C','R')
UPDATE scheme.podetm SET status = '' where order_no in (@PO) AND status  IN ('C','R')
/**/