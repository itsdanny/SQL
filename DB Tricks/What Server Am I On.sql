
-- This will run on D2 DON'T CHANGE THE LOGIC
IF @@SERVERNAME = 'TRSAGEV3D2'
BEGIN
	PRINT '*** This code will execute ***'
	-- SOME CODE HERE THAT YOU ONLY WANT TO RUN ON D2
	
END
ELSE
PRINT 'Not running this on Live, no way baby!' 
