SELECT *
FROM sysobjects 
WHERE id IN ( SELECT id 
              FROM syscolumns 
              WHERE name like '%special_price%')
and			xtype = 'U' ORDER BY name
