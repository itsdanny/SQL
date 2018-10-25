USE syslive
-- Clear the Q5 table
DELETE FROM  scheme.fscontq5m where fs_id <> '0000'
-- reset the Q5 table
UPDATE scheme.fscontq5m set fs_status = 'R' where fs_id = '0000'  and fs_status = 'E'

-- Sort Licensing
UPDATE scheme.sysdirm SET key_value = 'UYMTTERhiGj0' WHERE system_key = 'DEF_PASSWD'
UPDATE scheme.sysdirm SET key_value = '000005' WHERE system_key = 'DEF_SITENO'
UPDATE scheme.sysdirm SET key_value = 'NO' WHERE system_key = 'AU_ON'


