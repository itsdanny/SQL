SELECT	*
FROM		ENLocations
SELECT	*
FROM		Log ORDER BY	1 desc
--1st; 2nd; 3rd; 4th, 5th, 6th, 7th, 8th, 9th, 10th, 11th, x
SELECT	TOP 1000 *
FROM		service.ServiceData 
ORDER BY	1 DESC 
SELECT	SentDateTime, *
FROM		service.ServiceData 
WHERE		ServiceId IN (28)
ORDER BY	1 DESC  

---- RUN ALL OF THIS...
--UPDATE	service.ServiceData 
--SET		SentToClient = 1
--WHERE	ServiceId IN (24,25)EJ)ST-12
--AND		SentToClient IS NULL
--UPDATE	service.ServiceData 
--SET		SentToClient = null
--WHERE	ServiceId IN (24,25)
--AND		col2 = '15/04/2017 00:00:00'--TO start - 13TH ALL

