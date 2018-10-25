SELECT TOP 1000 d.[warehouse]
      ,[product]
      ,[long_description]
      ,h.[alpha]
      ,h.[customer]
      ,h.[address1]
      ,h.[address2]
      ,h.[address3]
      ,h.[address4]
      ,h.[address5]
      ,c.[address6]
      ,[date_entered]
      ,[date_required]
      ,sum([order_qty]) as Order_Qty
      ,sum([despatched_qty]) as Despatched_Qty
  FROM [syslive].[scheme].[opdetm] d WITH(NOLOCK) 
  inner join scheme.opheadm h WITH(NOLOCK)
  ON d.order_no = h.order_no 
  inner join scheme.slcustm c WITH (NOLOCK)
  ON h.customer = c.customer
  WHERE product = '073628' and d.warehouse = 'FG' and date_entered between '01/01/2014' and getdate()
  GROUP BY d.[warehouse] ,[product] ,[long_description] ,h.[alpha] ,h.[customer] ,h.[address1] ,h.[address2] 
  ,h.[address3] ,h.[address4] ,h.[address5], c.[address6], [date_entered] ,[date_required]
