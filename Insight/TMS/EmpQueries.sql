use mfdata
Declare @Emp varchar(4) = '0572'
SELECT * FROM TMSCLK where EMPREF = @Emp 
SELECT * FROM TMSCLK where EMPREF = @Emp  and CAST(CLKDT as date) >= '2015-05-19' order by CLKDT desc

SELECT TOP 1 CLKDT FROM TMSCLK WHERE EMPREF = @Emp AND DIR  = 'O' ORDER BY CLKDT DESC

select * from tmsemp where  SURNAME = 'singh' and FIRSTNAMES = ''


SELECT		'('+t.EMPREF+')'as emprref , TITLE, KNOWNBY as FIRSTNAMES, SURNAME, INITIALS, 
			CAST(CASE WHEN j.JOBTITLE IN('154', '147', '275') THEN 1 ELSE 0 END AS BIT) AS ReportAccess, 
			CAST(CASE WHEN j.JOBTITLE IN('141') THEN 1 ELSE 0 END AS BIT) AS IsEngineer
FROM		TMSEMP AS t WITH (NOLOCK) 
LEFT JOIN	JD AS j WITH (NOLOCK) 
ON			t.EMPREF = j.EMPREF

WHERE j.EMPREF in ('0794','0506','7022','0501','0089')


