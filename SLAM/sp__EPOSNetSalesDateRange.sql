USE [slam]
GO
/****** Object:  StoredProcedure [dbo].[sp__EPOSNetSales]    Script Date: 02/02/2019 16:24:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Stephen Houghton>
-- Create date: <8th March 2018 - estimated (as not filled in at time)>
-- Description:	<REPORT - SSRS Missed Epos Sales Report>
/*
Update: DMC: brought inn trans date to help with timed subcriptions
*/
-- =============================================
ALTER  PROCEDURE [dbo].[sp__EPOSNetSalesDateRange] 
	-- Add the parameters for the stored procedure here
@FromDate DATETIME,
@ToDate DATETIME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
DECLARE @Returns TABLE(ReturnDate DATE, BranchCode VARCHAR(4), BranchName VARCHAR(50), BranchReturnBin VARCHAR(10), ProductCode VARCHAR(25), ReturnReason VARCHAR(100), Quantity INT, ReturnVal FLOAT)
DECLARE @ReturnSummary TABLE(ReturnDate DATE, BranchCode VARCHAR(4),  ReturnVal FLOAT)
INSERT @Returns
EXEC	[sp_GetReturnsDateRange] @FromDate, @ToDate
INSERT INTO @ReturnSummary
SELECT	ReturnDate, BranchCode, ReturnVal
FROM	@Returns	
GROUP BY	BranchCode, ReturnDate,  ReturnVal



	SELECT		s.name, 
				s.customer, 
				o.date_entered,
				o.order_no,
				d.product,
				d.description,
				d.despatched_qty,
				d.val,
				d.net_price
				ISNULL(SUM(o.gross_value - ISNULL(r.ReturnVal, 0)) , 0)AS SalesLessReturns
	FROM		slam.scheme.slcustm s WITH(NOLOCK)
	INNER JOIN	slam.scheme.opheadm o WITH(NOLOCK)
	ON			s.customer = o.customer
	AND			o.date_entered  BETWEEN CAST(@FromDate AS DATE)  AND	CAST(@ToDate AS DATE)  
	AND			o.order_no LIKE 'SB%'
	INNER JOIN 	scheme.opdetm d WITH(NOLOCK)
	ON			o.order_no = d.order_no
	LEFT JOIN   @ReturnSummary r
	ON			LTRIM(RTRIM(s.customer)) = LTRIM(RTRIM(r.BranchCode))
	AND			o.date_entered = r.ReturnDate
	WHERE		s.customer LIKE '1%'
	AND			LEN(s.customer) = 3
	--AND			s.alpha NOT LIKE 'ZZZ%'
	AND			(s.name LIKE 'RETAIL%' OR	s.customer = '1MA')
	GROUP BY	s.name, s.customer
END 
	  



	  GO
	  
[sp__EPOSNetSalesDateRange] '2018-01-01', '2018-03-31'