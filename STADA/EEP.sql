use StadaFactBook
-- FOR KPI 1

-- EEP
SELECT * FROM (SELECT resource_code, Speed, (TRDailyMins*Speed*TRDays) AS EEP, [Month]
FROM	WorkCentres,
		TEEPCalendar) X 
		PIVOT 
		(	
			SUM(EEP) FOR [Month] in ([January],[February],[March],[April],[May],[June],[July],[August],[September],[October],[November],[December])
		) T
	
/*	********************************************************************************************************************************************************* */

-- TEEP
SELECT * FROM (SELECT resource_code, Speed, (StadaMins*Speed*MonthDays) AS TEEP, [Month]
FROM	WorkCentres,
		TEEPCalendar) X 
		PIVOT 
		(	
			SUM(TEEP) FOR [Month] in ([January],[February],[March],[April],[May],[June],[July],[August],[September],[October],[November],[December])
		) T