

INSERT INTO Users
SELECT		98, User_PrimaryChannelId, 'dmcgregor', 'McGregor','Dan', User_Language, 'IT' User_Department, User_Phone, '276' User_Extension, User_Pager, User_Homephone, User_MobilePhone, User_Fax, 
			'danmcgregor@thornonross.com' User_EmailAddress, User_LastLogin, User_User1, 
			'plaster'User_Password, 
			User_CreatedBy, User_CreatedDate, User_UpdatedBy, User_UpdatedDate, User_TimeStamp, User_Deleted, User_Per_ContactInsert, User_Per_ContactUpdate, User_Per_Communication, User_Per_Opportunity, User_Per_Case, User_Per_ToDo, User_Per_Channels, User_Per_Reports, User_Per_Admin, User_Per_Team, User_Per_TeamUpdate, User_Per_TeamSensitive, User_Solo_SeedMin, User_Solo_SeedMax, User_Solo_MachineName, User_ProfileEnabled, User_Profile, User_ProfileLastSyncDate, User_LastEntitySyncOutcome, User_RecentList, User_MustChangePassword, User_CannotChangePassword, User_PasswordUpdateDate, User_PasswordNeverExpires, User_SMSNotification, User_CTIDeviceName, User_Disabled, User_Resource, User_Per_CompAssign, User_Per_EntityMerge, User_SecurityProfile, User_SegmentID, User_ExternalLogonAllowed, User_PrimaryTerritory, User_IsTerritoryManager, User_TerritoryProfile, User_Per_User, User_Per_Product, User_Per_Currency, User_Per_Data, User_OfflineAccessAllowed, user_MobileEmail, user_per_tree, user_rollupto, user_forecastcurrency, user_per_customise, User_MinMemory, User_MaxMemory, User_ForecastSecurity, user_title, user_location, user_deskid, User_Per_InfoAdmin, User_Device_MachineName, User_Per_Solutions, User_OffLineSecurity, User_IsTemplate, User_TemplateName, User_WebServiceEnabled, user_MasterPersID, User_AccountLockedOut, User_CTIEnabled, User_CTICallScreen, user_GroupAccess, User_LastServer, user_EnableDoNotReprice, User_Logons, User_ShowSurvey, User_LastSurveyTaken, user_soloProfileID, user_licencetype, User_TerritoriesFK, User_DefaultLandingPage
FROM		Users
WHERE		UPPER(User_LastName) LIKE '%Morri%'


