/****** 

Script for SelectTopNRows command from SSMS  

Check the user master table to see who has what start menu
  
  Select * 
  FROM [csmaster].[scheme].[usermastm]
  where start_menu_list <> ''
  order by start_menu_list

******/

-- 1st level:  'wo_order_entry'

-- 2nd level:
-- wo_task_4           
-- womenu     

-- 3rd level:
-- wo_3                
-- wo_3WAR                    
  
-- 4th level:
-- Ware_MenuSup        
-- manufacturing_2     
  
-- 5th level:
-- main_1              
-- main_2              
-- main_france         
-- tetramenu           
  
DECLARE @optionname VARCHAR(20)
SET @optionname = 'tetramenu'
SELECT *
  FROM [csmaster].[scheme].[menum] with (nolock)
  where 
( [menu_option01] like @optionname + '%'
      OR [menu_option02] like @optionname + '%'
      OR [menu_option03] like @optionname + '%'
      OR [menu_option04] like @optionname + '%'
      OR [menu_option05] like @optionname + '%'
      OR [menu_option06] like @optionname + '%'
      OR [menu_option07] like @optionname + '%'
      OR [menu_option08] like @optionname + '%'
      OR [menu_option09] like @optionname + '%'
      OR [menu_option10] like @optionname + '%'
      OR [menu_option11] like @optionname + '%'
      OR [menu_option12] like @optionname + '%'
      OR [menu_option13] like @optionname + '%'
      OR [menu_option14] like @optionname + '%'
      OR [menu_option15] like @optionname + '%'
      OR [menu_option16] like @optionname + '%'
      OR [menu_option17] like @optionname + '%'
      OR [menu_option18] like @optionname + '%'
      OR [menu_option19] like @optionname + '%'
      OR [menu_option20] like @optionname + '%'
      OR [menu_option21] like @optionname + '%'
      OR [menu_option22] like @optionname + '%'
      OR [menu_option23] like @optionname + '%'
      OR [menu_option24] like @optionname + '%'
      OR [menu_option25] like @optionname + '%'
      OR [menu_option26] like @optionname + '%'
      OR [menu_option27] like @optionname + '%'
      OR [menu_option28] like @optionname + '%'
      OR [menu_option29] like @optionname + '%'
      OR [menu_option30] like @optionname + '%'
      OR [menu_option31] like @optionname + '%'
      OR [menu_option32] like @optionname + '%'
      OR [menu_option33] like @optionname + '%'
      OR [menu_option34] like @optionname + '%')
  order by menu_name