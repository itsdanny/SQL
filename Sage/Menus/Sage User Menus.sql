/****** Script for SelectTopNRows command from SSMS  ******/ 
/****** Script for SelectTopNRows command from SSMS  ******/ 
SELECT		DISTINCT LTRIM(RTRIM(start_menu_list)) AS Menu, LTRIM(RTRIM(name)) AS Usern
FROM		csmaster.scheme.usermastm u
WHERE		start_menu_list != 'Blank_Menu'
ORDER BY	1

--return
--SELECT	* 
--FROM		csmaster.scheme.usermastm u
--WHERE		LTRIM(RTRIM(start_menu_list))  IN ('Buying_Menu','Buying_MenuSup','Distribution_Menu', 'Field_Sales_Menu','General_Menu','Blank_Menu','','py_3_mth', 
--'IT_Basic', 'KeyAccount_Menu','Lab_menu','ManLab_Menu', 'Marketing_Menu','OPD_Menu', 'OPD_MenuSup','PCO_Menu', 'PCO_MenuSup','PCO_MenuSup2', 'Packing_Menu','Packing_Menu2', 'Pco_main_menu','Pco_main_menu_SAP',
--'Reg_Enq_Menu', 'Route_Menu','Route_Menu2', 'Sales_MenuJDB','Sales_MenuJDB1', 'Sales_MenuJT','Sales_MenuOff', 'Sales_MenuSup','Top_Menu', 'Transfer_menu','Wages_2Menu', 'Wages_Menu','Wages_Menu_SAP', 'Ware_Menu','Ware_MenuSup', 'hr_py_menu','main_2', 'packing_menu2','py_3_wk', 'test_menu', 'tetramenu')

--AND		name NOT IN ('kmoore', 'jdaltonb','dmcgrego','gadams','markc','manager','mcarlile','rhenders','rspencer','pdunn')
--ORDER BY	1

--UPDATE 	csmaster.scheme.usermastm SET start_menu_list = 'Blank_Menu'
--WHERE		LTRIM(RTRIM(start_menu_list)) IN ('Buying_Menu','Buying_MenuSup','Distribution_Menu', 'Field_Sales_Menu','General_Menu','Blank_Menu','','py_3_mth', 
--'IT_Basic', 'KeyAccount_Menu','Lab_menu','ManLab_Menu', 'Marketing_Menu','OPD_Menu', 'OPD_MenuSup','PCO_Menu', 'PCO_MenuSup','PCO_MenuSup2', 'Packing_Menu','Packing_Menu2', 'Pco_main_menu','Pco_main_menu_SAP',
--'Reg_Enq_Menu', 'Route_Menu','Route_Menu2', 'Sales_MenuJDB','Sales_MenuJDB1', 'Sales_MenuJT','Sales_MenuOff', 'Sales_MenuSup','Top_Menu', 'Transfer_menu','Wages_2Menu', 'Wages_Menu','Wages_Menu_SAP', 'Ware_Menu','Ware_MenuSup', 'hr_py_menu','main_2', 'packing_menu2','py_3_wk', 'test_menu', 'tetramenu')

--and	name  not  IN ('kmoore', 'jdaltonb','dmcgrego','gadams','markc','manager','mcarlile','rhenders','rspencer','pdunn','auto','admin','system','ver1')



SELECT		UPPER(LTRIM(RTRIM(b.name))) AS SageUser, b.start_menu_list
FROM		[csmaster].[scheme].[usermastm_MENUBACKUP] b
INNER JOIN 	[csmaster].[scheme].usermastm u
ON			b.name = u.name
WHERE		UPPER(u.name) LIKE ('CBELL%')

UPDATE 		u 
SET			u.start_menu_list = b.start_menu_list
FROM		[csmaster].[scheme].[__bkup_usermastm] b
INNER JOIN 	[csmaster].[scheme].usermastm u
ON			b.name = u.name
WHERE		UPPER(u.name) IN ('CNISBET','CBELLAMY')
AND			1 = 2

