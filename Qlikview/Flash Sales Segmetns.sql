SELECT	*
FROM		Brand
WHERE		BrandName IN ('Acriflex','Allens','Anodesyn','Benenox','Care','Cerumol','Cetraben OTC','Combogesic','Covonia','Eucryl','Flexitol OTC','H/h other','Hedrin','Jcb','KYJelly OTC','Lactoflora','Ladival','Lloydcrm','Metanium','Movelat OTC','Mycota','Natures Aid','Ownlabel','Radian b','Samaritan','Setlers','Strive','Transvasin','Virasorb','Vit/min/fd','Zoflora')
ORDER BY	2

RETURN

SELECT	*
FROM		Flash

UPDATE 	Flash SET CompanySegmentName ='OTC'
WHERE		Brand IN ('Acriflex','Allens','Anodesyn','Benenox','Care','Cerumol','Cetraben OTC','Combogesic','Covonia','Eucryl','Flexitol OTC','H/h other','Hedrin','Jcb','KYJelly OTC','Lactoflora','Ladival','Lloydcrm','Metanium','Movelat OTC','Mycota','Natures Aid','Ownlabel','Radian b','Samaritan','Setlers','Strive','Transvasin','Virasorb','Vit/min/fd','Zoflora')

-- Rx
UPDATE 	Flash SET CompanySegmentName ='Rx'
WHERE		Brand IN ('Algesal','Altoderm','Cetraben Rx','Eczmol','Flexitol Rx','Galcodine','Galenphol','Galfer','Galpseud','Hirudoid','KYJelly Rx','Movelat Rx','Zero')

-- GENERICS
UPDATE 	Flash SET CompanySegmentName ='Generics'
WHERE		Brand IN ('Acitretin','Adipine','Benzylpenicillin','Buprenorphine','Chlorpromazine','Codeine Phosphate','Diagemet','Dimethyl Sulfoxide','Doxazosin','Eldisine/Vindesine','Ethambutol','Felotens','Fenofibrate','Fluconazole','Iodine','Lorazepam','Loremetazepam','Magnesium Hydroxide','Memantine','Meprobamate','Methadone','Naproxen','Oxazepam','Paraffin','Phenobarbital','Pyrazinamide','Rimso','Salicylic Acid','Soap Spirit','Tabphyn/Tamsulosine','Tensipine/Nifedipin','Trihexyphenidyl','Viazem','Voractiv','Xismox/ISMN','Zinc & CO','Generics Budget Adjustment')

-- INTERNIS
UPDATE 	Flash SET CompanySegmentName ='Internis'
WHERE		Brand IN ('Accrete','Binosto','Fultium Rx','Fultium OTC')

