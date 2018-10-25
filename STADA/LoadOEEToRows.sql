--January, February, March, April, May, June, July, August, September, October, November, December
DROP TABLE BottlesOEE
SELECT Line, SageRef, Shifts, Speed, 'January' AS OEEMonth, January AS OEEValue INTO BottlesOEE FROM BottlesOEEImport 
UNION
SELECT Line, SageRef, Shifts, Speed, 'February' AS OEEMonth, February AS OEEValue FROM BottlesOEEImport 
UNION
SELECT Line, SageRef, Shifts, Speed, 'March' AS OEEMonth, March AS OEEValue FROM BottlesOEEImport 
UNION
SELECT Line, SageRef, Shifts, Speed, 'April' AS OEEMonth, April AS OEEValue FROM BottlesOEEImport 
UNION
SELECT Line, SageRef, Shifts, Speed, 'May' AS OEEMonth, May AS OEEValue FROM BottlesOEEImport 
UNION
SELECT Line, SageRef, Shifts, Speed, 'June' AS OEEMonth, June AS OEEValue FROM BottlesOEEImport 
UNION
SELECT Line, SageRef, Shifts, Speed, 'July' AS OEEMonth, July AS OEEValue FROM BottlesOEEImport 
UNION
SELECT Line, SageRef, Shifts, Speed, 'August' AS OEEMonth, August AS OEEValue FROM BottlesOEEImport 
UNION
SELECT Line, SageRef, Shifts, Speed, 'September' AS OEEMonth, September AS OEEValue FROM BottlesOEEImport 
UNION
SELECT Line, SageRef, Shifts, Speed, 'October' AS OEEMonth, October AS OEEValue FROM BottlesOEEImport 
UNION
SELECT Line, SageRef, Shifts, Speed, 'November' AS OEEMonth, November AS OEEValue FROM BottlesOEEImport 
UNION
SELECT Line, SageRef, Shifts, Speed, 'December' AS OEEMonth, December AS OEEValue FROM BottlesOEEImport 

SELECT * FROM BottlesTEEPImport
DROP TABLE BottlesTEEP
SELECT Line, SageRef, Speed, 'January' AS TEEPMonth, January AS TEEPValue INTO BottlesTEEP FROM BottlesTEEPImport 
UNION
SELECT Line, SageRef, Speed, 'February' AS TEEPMonth, February AS TEEPValue FROM BottlesTEEPImport 
UNION
SELECT Line, SageRef, Speed, 'March' AS TEEPMonth, March AS TEEPValue FROM BottlesTEEPImport 
UNION
SELECT Line, SageRef, Speed, 'April' AS TEEPMonth, April AS TEEPValue FROM BottlesTEEPImport 
UNION
SELECT Line, SageRef, Speed, 'May' AS TEEPMonth, May AS TEEPValue FROM BottlesTEEPImport 
UNION
SELECT Line, SageRef, Speed, 'June' AS TEEPMonth, June AS TEEPValue FROM BottlesTEEPImport 
UNION
SELECT Line, SageRef, Speed, 'July' AS TEEPMonth, July AS TEEPValue FROM BottlesTEEPImport 
UNION
SELECT Line, SageRef, Speed, 'August' AS TEEPMonth, August AS TEEPValue FROM BottlesTEEPImport 
UNION
SELECT Line, SageRef, Speed, 'September' AS TEEPMonth, September AS TEEPValue FROM BottlesTEEPImport 
UNION
SELECT Line, SageRef, Speed, 'October' AS TEEPMonth, October AS TEEPValue FROM BottlesTEEPImport 
UNION
SELECT Line, SageRef, Speed, 'November' AS TEEPMonth, November AS TEEPValue FROM BottlesTEEPImport 
UNION
SELECT Line, SageRef, Speed, 'December' AS TEEPMonth, December AS TEEPValue FROM BottlesTEEPImport 

