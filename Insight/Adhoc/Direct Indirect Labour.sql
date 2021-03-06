-- Total Labour	
	SELECT *
	FROM		AreaLabourLog  al
	INNER JOIN	Area a
	ON			al.AreaId = a.Id
	WHERE	    (a.Id = 3)
	AND			al.FinishDateTime IS NULL

	-- Direct Man Lab Labour
	SELECT *
	FROM		Area a
	INNER JOIN	ManufacturingJobLog mjl
	ON			a.Id = mjl.AreaId
	WHERE		(mjl.FinishDateTime IS NULL) AND (a.Id = 3)	
	
	-- Direct Area Labour
	SELECT *
	FROM		Area a
	INNER JOIN  WorkCentre wc
	ON			a.Id = wc.AreaId
	INNER JOIN	WorkCentreJob wcj
	ON			wc.Id = wcj.WorkCentreId
	INNER JOIN	WorkCentreJobLog wcjl
	ON			wcj.Id = wcjl.WorkCentreJobId
	INNER JOIN  WorkCentreJobLogLabourDetail wcjlld
	ON			wcjl.Id = wcjlld.WorkCentreJobLogId
	WHERE		(wcjlld.FinishDateTime IS NULL) AND (a.Id= 2)