-- Bob rings up to re-opena a job, getDate()the job ID and set IsConfirmed as NULL
select * from Job where JobId = 991

update Job set IsConfirmed = NULL where JobId = 991

