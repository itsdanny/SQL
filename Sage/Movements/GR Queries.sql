SELECT		*
FROM		syslive.scheme.stkhstm WITH(NOLOCK)
WHERE		comments LIKE '080984%'
AND			batch_number IN ('Q11009')

-- pallet #5 2 boxes missing
-- pallet #6 1 box missin

SELECT		* 
FROM			syslive.scheme.stquem a WITH(NOLOCK)
INNER JOIN 		syslive.scheme.stqueam b WITH(NOLOCK)
ON				a.product = b.product
AND				a.warehouse = b.warehouse
AND				a.sequence_number = b.sequence_number
WHERE			a.batch_number = 'Q11009'
AND				a.prod_code = '247241'

SELECT		*
FROM	syslive.scheme.poheadm h WITH(NOLOCK)
INNER JOIN	syslive.scheme.podetm d WITH(NOLOCK)
ON		h.order_no = d.order_no
WHERE		h.order_no = '080984'