use syslive
DROP TABLE [scheme].[bk_faaudcm]
DROP TABLE [scheme].[bk_facatm]
DROP TABLE [scheme].[bk_faccam]
DROP TABLE [scheme].[bk_fachistm]
DROP TABLE [scheme].[bk_fadeftpm]
DROP TABLE [scheme].[bk_fadepm]--6
DROP TABLE [scheme].[bk_fahistm]--209301
DROP TABLE [scheme].[bk_famastcm]
DROP TABLE [scheme].[bk_famastctm]
DROP TABLE [scheme].[bk_famastm]--2059
DROP TABLE [scheme].[bk_fanlcatm]--11
DROP TABLE [scheme].[bk_fardgm]
DROP TABLE [scheme].[bk_fatempam]
DROP TABLE [scheme].[bk_fatempm] --3


SELECT * INTO [scheme].[bk_faaudcm] FROM [scheme].[faaudcm]
SELECT * INTO [scheme].[bk_facatm] FROM [scheme].[facatm]
SELECT * INTO [scheme].[bk_faccam] FROM [scheme].[faccam]
SELECT * INTO [scheme].[bk_fachistm] FROM [scheme].[fachistm]
SELECT * INTO [scheme].[bk_fadeftpm] FROM [scheme].[fadeftpm]
SELECT * INTO [scheme].[bk_fadepm] FROM [scheme].[fadepm] -- 12 ROWS
SELECT * INTO [scheme].[bk_fahistm] FROM [scheme].[fahistm] -- 209301
SELECT * INTO [scheme].[bk_famastcm] FROM [scheme].[famastcm] 
SELECT * INTO [scheme].[bk_famastctm] FROM [scheme].[famastctm]
SELECT * INTO [scheme].[bk_famastm] FROM [scheme].[famastm] --2059
SELECT * INTO [scheme].[bk_fanlcatm] FROM [scheme].[fanlcatm] -- 11
SELECT * INTO [scheme].[bk_fardgm] FROM [scheme].[fardgm]
SELECT * INTO [scheme].[bk_fatempam] FROM [scheme].[fatempam]
SELECT * INTO [scheme].[bk_fatempm] FROM [scheme].[fatempm] -- 3 