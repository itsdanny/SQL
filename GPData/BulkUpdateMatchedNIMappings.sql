update import 
set import.BNFCode = NI.BNFCode
from ImportDataNI import inner join 
BNFNIMappings NI on import.BNFCode = '-' and 
Upper(Ltrim(RtriM(import.VTM_NM))) = Upper(Ltrim(RtriM(NI.VTM_NM))) and Upper(Ltrim(RtriM(import.VPM_NM))) = Upper(Ltrim(RtriM(NI.VPM_NM))) and Upper(Ltrim(RtriM(import.AMP_NM))) = Upper(Ltrim(RtriM(NI.AMP_NM)))
