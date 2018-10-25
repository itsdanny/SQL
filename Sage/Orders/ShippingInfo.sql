/*SELECT 
       h.[alpha]
      ,h.[order_no]
      ,[address6]
      ,sum(d.despatched_qty * d.weight)
      ,[date_despatched]
      ,LTRIM(RTRIM(REPLACE(REPLACE(shipping_text, 'DI',''), 'DX','')))  as Shipping_Text
  FROM [syslive].[scheme].[opheadm] h WITH (NOLOCK) 
  INNER JOIN scheme.slcustm s WITH (NOLOCK)
  ON h.customer = s.customer
  INNER JOIN scheme.opdetm d WITH (NOLOCK)
  ON h.order_no = d.order_no
WHERE date_despatched between '2014/01/01' and getDate()
--and		h.order_no = '2E175591'
group by h.[alpha]
		,h.[order_no]
		,[address6]      
		,[date_despatched],
		shipping_text
ORDER BY date_despatched, alpha
*/

select		distinct h.*
FROM	   [syslive].[scheme].[opheadm] h WITH (NOLOCK) 
INNER JOIN scheme.slcustm s WITH (NOLOCK)
ON	       h.customer = s.customer
INNER JOIN scheme.opdetm d WITH (NOLOCK)
ON		   h.order_no = d.order_no
WHERE		h.order_no = '2E175591'
and h.alpha  = 'BOOTSOWN'
order by	h.[status]

select		d.*
FROM	   [syslive].[scheme].[opheadm] h WITH (NOLOCK) 
INNER JOIN scheme.slcustm s WITH (NOLOCK)
ON	       h.customer = s.customer
INNER JOIN scheme.opdetm d WITH (NOLOCK)
ON		   h.order_no = d.order_no
WHERE		h.order_no = '2E175591'
order by	h.[status]

select * from scheme.slcustm where alpha = 'RXALLIAN'