-- AFTER THE RESTORE RUN THIS SET THE USERS BACK UP AS THEY DON'T GET RESTORED
--- EXEC THIS ON D2...

-- This will run on D2 DON'T CHANGE THE LOGIC
IF @@SERVERNAME = 'SAFESERVERNAMEHERE_TRSAGEV3D2'
BEGIN
--	'*** This code will execute ***'
PRINT getdate()
'_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER'
									'BREAKTHISHERESTOPTHESCRIPTAS_NOT_SURE_IT_ACTUALLY_WORKS'
'_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER'

/*
RESTORE DATABASE	syslive_shrink
					FROM  DISK = N'M:\Backups\syslive\periodend_syslive.bak' 
					WITH FILE = 1,
					MOVE N'syslive' TO N'M:\sysliveShrinkTest\syslive_shrink.mdf', 
					MOVE N'syslivelog' TO N'M:\sysliveShrinkTest\syslive_shrink.ldf', 
					NOUNLOAD, 
					STATS = 5, REPLACE, RECOVERY --force restore over specified database 
					*/

'_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER'
									'BREAKTHISHERESTOPTHESCRIPTAS_NOT_SURE_IT_ACTUALLY_WORKS'
'_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER_DANGER'
PRINT getdate()
	
END
ELSE
	PRINT 'Not running this on Live, no way baby!' 

GO
