/****** Script for SelectTopNRows command from SSMS  ******/
SELECT *  FROM [TRConnect].[dbo].[ENLocations] order by SageRef
SELECT *  FROM [TRConnect].[dbo].[ENLocations] order by lastAccessed
SELECT *  FROM [TRConnect].[dbo].[ENLocations] WHERE IsLive = 1 order by ENLocationName

 null  ORDER BY LastAccessed desc
/*
  UPDATE [TRConnect].[dbo].[ENLocations] SET	IsLive = 0 WHERE		Id = 75
  UPDATE [TRConnect].[dbo].[ENLocations] SET	IsLive = 1 WHERE		APIKeyHash is NOT null AND	APIKeyHash <> '' AND	Id = 69
  UPDATE [TRConnect].[dbo].[ENLocations] SET	IsLive = 1 WHERE		APIKeyHash is NOT null AND	APIKeyHash <> '' AND	Id = 34
  UPDATE [TRConnect].[dbo].[ENLocations] SET	IsLive = 1 WHERE		APIKeyHash is NOT null AND	APIKeyHash <> '' AND	Id BETWEEN 10 AND	20
  delete FROM service.ServiceData WHERE		SentToClient is null


  SELECT DISTINCT col1 FROM service.ServiceData WHERE	col2 ='12/01/2017 00:00:00' order by id desc


  update ENLocations SET	LastAccessed = '2017-01-09 23:59:59.963'  WHERE Id IN (12,14,31,46,32,58,55) 
  */
  SELECT * FROM Log order by id desc

  SELECT * FROM service.ServiceData WHERE		SentToclient is null AND	Col1 = '	N4'
  /*
  SELECT * FROM ENLocations WHERE		ENLocationName LIKE	'%DART%' --Basic OFo3SUVZODE1OUpWTTBMUjZGR0NJWkVFSVZYMldaQUY6Wk1aUkwwQlJLQVhLREtIV1VMSFRROVlZTFpTUktUSzA= (32)
UPDATE ENLocations SET	APIKeyHash ='Basic OFo3SUVZODE1OUpWTTBMUjZGR0NJWkVFSVZYMldaQUY6Wk1aUkwwQlJLQVhLREtIV1VMSFRROVlZTFpTUktUSzA=', SageRef='L1' WHERE		Id = 74
UPDATE ENLocations SET	APIKeyHash = NULL WHERE		Id = 32

SELECT * FROM ENLocations WHERE		ENLocationName LIKE	'%CHELT%' --Basic WEkxQjA5ODhJWVQ5TlhINFlYOVRUUzJXTTdSNzIzTUk6OENQTkg1WDdETUYyTFpEUkwwMVlNOVRFNTE1NjZRV1I= (55)

SELECT * FROM ENLocations WHERE		ENLocationName LIKE	'%CHELT%' --Basic WEkxQjA5ODhJWVQ5TlhINFlYOVRUUzJXTTdSNzIzTUk6OENQTkg1WDdETUYyTFpEUkwwMVlNOVRFNTE1NjZRV1I= (55)
UPDATE ENLocations SET	APIKeyHash ='Basic WEkxQjA5ODhJWVQ5TlhINFlYOVRUUzJXTTdSNzIzTUk6OENQTkg1WDdETUYyTFpEUkwwMVlNOVRFNTE1NjZRV1I=', SageRef='K2', IsLive = 1 WHERE		Id = 75
UPDATE ENLocations SET	APIKeyHash = NULL WHERE		Id = 55

SELECT * FROM ENLocations WHERE		Id IN (32,74,55,75)


UPDATE ENLocations SET	APIKeyHash ='Basic OFo3SUVZODE1OUpWTTBMUjZGR0NJWkVFSVZYMldaQUY6Wk1aUkwwQlJLQVhLREtIV1VMSFRROVlZTFpTUktUSzA=' WHERE	Id = 32 -- 74(leeds)/32 (DART)
UPDATE ENLocations SET	APIKeyHash = NULL WHERE	Id = 74

UPDATE ENLocations SET	APIKeyHash ='Basic V1Q0Vjg1NDEySE1FNTI4SDFUT1dYNjlXNklFOUY3VVg6V01YVjVEV1JFNVFZTFFIQ0NDN1NQQUpDSUlPU1RONUs' WHERE	Id = 55 -- 55 (cheklt)/ 75(KINGLYNN)
UPDATE ENLocations SET	APIKeyHash = NULL WHERE	Id = 75


UPDATE ENLocations SET	APIKeyHash ='Basic TFlBQ01IWVFKT0hSNUZGMjcwVFNVVkhIMUpPRE9aRlo6NkFIWjRMMjMxWlg0UzdJWFMzRjlOVFZGUTFPV1FPSzU=' WHERE	Id = 74 -- 74/32
UPDATE ENLocations SET	APIKeyHash = NULL WHERE	Id = 32

UPDATE ENLocations SET	APIKeyHash ='Basic WEkxQjA5ODhJWVQ5TlhINFlYOVRUUzJXTTdSNzIzTUk6OENQTkg1WDdETUYyTFpEUkwwMVlNOVRFNTE1NjZRV1I=' WHERE	Id = 75 -- 55/75
UPDATE ENLocations SET	APIKeyHash = NULL WHERE	Id = 55
*/