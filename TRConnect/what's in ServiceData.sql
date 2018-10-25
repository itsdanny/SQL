use TRConnect
SELECT TOP 4000 * FROM service.ServiceData 
where ServiceId IN (24,25) 
and	senttoclient is null
OR	SentDateTime > GETDATE()
order by SentDateTime DESC 

SELECT * FROM Log order by Id desc
SELECT * FROM LogTypes order by Id desc
SELECT * FROM service.Services


SELECT * FROM ENLocations
UPDATE 	service.servicedata	SET  senttoclient = NULL 	where ServiceId IN (24,25) 
and	senttoclient is null
OR	SentDateTime > GETDATE()
--update ENLocations set LastAccessed = '2016-12-09 20:20:12.103' where id> 5

SELECT * FROM service.ServiceData order by Id desc
--delete FROM  service.ServiceData  where col2= '10/12/2016 00:00:00'
