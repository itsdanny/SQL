USE [slam]
GO
/****** Object:  StoredProcedure [dbo].[sp_GetReturns_V2]    Script Date: 02/02/2019 16:39:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[sp_GetReturnsDateRange] 
@FromDate DATETIME,
@ToDate DATETIME
AS
BEGIN
	SET NOCOUNT ON --added to prevent extra result sets from
	-- interfering with SELECT statements.

	SELECT		h.dated AS ReturnDate,
				c.customer BranchCode, 
				c.name BranchName,
				h.to_bin_number AS BranchReturnBin, 
				h.product ProductCode, 
				comments ReturnReason, 
				movement_quantity Quantity,
				(SELECT		SUM(o.gross_value)
				 FROM		scheme.opheadm o WITH(NOLOCK)
				WHERE		o.date_entered = h.dated
				AND			o.customer = c.customer				
				AND			o.order_no LIKE 'CN%') AS ReturnVal
	FROM		scheme.stkhstm h WITH(NOLOCK)
	INNER JOIN 	scheme.slcustm c
	ON			RIGHT(LTRIM(RTRIM(c.customer)),2) = LEFT (h.to_bin_number, 2)
	AND			c.customer LIKE '1%'
	WHERE		h.transaction_type = 'ADJ'
	AND			(UPPER(h.comments) LIKE '%FAULTY%' OR	UPPER(h.comments) LIKE '%RETURN%' OR	UPPER(h.comments) LIKE '%RESELL%')
	AND			h.dated  BETWEEN CAST(@FromDate AS DATE)  AND	CAST(@ToDate AS DATE)  
	--AND			c.customer = '1AC'
	ORDER BY	2,1
END

