INSERT INTO ContDrugsImport
SELECT IGCode, '129983', FGCode, FGProductDescription, BKProductDescription, IGProductDescription, Size, Mass, UOM, g_lt, Base_g, FGBase_g, WOType, Precursor
from ContDrugsImport 
where IGCode = '100349'
AND FGCode = '025704'
