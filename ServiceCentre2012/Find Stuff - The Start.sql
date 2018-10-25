-- DANS, STUFF TO TRY AND FIND WHERE INCIDENTS AND THE LIKE LIVE, BREATH AND DIE!
USE [OMDWDataMart]
/****** Script for SelectTopNRows command from SSMS  ******/
SELECT * FROM [dbo].[IncidentDim]  WHERE DisplayName = 'TR_IR4450 - Very slow running PC.'
SELECT * FROM [dbo].[EntityDim] WHERE [DisplayName] = 'TR_IR4450 - Very slow running PC.'
SELECT * FROM [dbo].[WorkItemDim] WHERE [Title] = 'Very slow running PC.'

USE [DWStagingAndConfig]

SELECT * FROM [inbound].[BaseManagedEntity] WHERE [DisplayName] ='TR_IR4450 - Very slow running PC.' 


-- DANS, STUFF TO TRY AND FIND WHERE INCIDENTS AND THE LIKE LIVE, BREATH AND DIE!

DECLARE @STR VARCHAR(50) = '%TR_SR4781%'

USE		OMDWDataMart
SELECT * FROM IncidentDim  WHERE DisplayName LIKE @STR
SELECT * FROM EntityDim WHERE DisplayName LIKE @STR
SELECT * FROM WorkItemDim WHERE Title LIKE @STR

USE		DWStagingAndConfig
SELECT * FROM inbound.BaseManagedEntity WHERE DisplayName LIKE @STR