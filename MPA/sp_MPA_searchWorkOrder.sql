--SELECT distinct machine_group FROM syslive.scheme.wswopm r
USE [syslive]
GO
/****** Object:  StoredProcedure [scheme].[sp_MPA_searchWorkOrder]    Script Date: 09/03/2016 14:14:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [scheme].[sp_MPA_searchWorkOrder]

@SearchText	VARCHAR(20) 
AS 

	SELECT		order_date as OrderDate, wc.SageRef, wc.Id AS WorkCentreId, wc.GroupId, g.UserId
--	SELECT		*
	FROM			scheme.bmwohm h
	INNER JOIN	scheme.bmwodm d
	ON			h.works_order = d.works_order
	INNER JOIN	syslive.scheme.wswopm r WITH(NOLOCK)  
	ON			(h.works_order = r.works_order) 
	INNER JOIN	MPA.dbo.WorkCentre wc
	ON			r.machine_group = wc.SageRef
	INNER JOIN	MPA.dbo.WorkCentreGroups g
	ON			g.Id = wc.GroupId
	WHERE		h.works_order = LTRIM(RTRIM(@SearchText))
	AND			d.warehouse ='BK'
-- [sp_MPA_searchWorkOrder]'RB62B'

GO

syslive.[scheme].[sp_MPA_searchWorkOrder]  'NA28'




