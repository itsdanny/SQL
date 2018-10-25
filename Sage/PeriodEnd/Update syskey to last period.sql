-- ONLY USE IF THE PERIOD END BACK ON D2, HAS BEEN LATE IN GETTING THERE, E.G. AFTER ALL THE PE STUFFF HAS RUN.
/*
	SELECT * FROM scheme.sysdirm WHERE system_key IN ('PLPERIOD', 'SLPERIOD', 'STPERIOD', 'POPERIOD')


	UPDATE	scheme.sysdirm  
	SET		key_value = '07' 
	WHERE	system_key IN ('PLPERIOD', 'SLPERIOD', 'STPERIOD', 'POPERIOD')
*/
use syslive
select * from scheme.stkaudm order by transaction_date desc

