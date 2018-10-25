USE StadaFactBook
IF OBJECT_ID('tempdb..#BKForecast') IS NOT NULL
BEGIN
DROP TABLE #BKForecast
END
IF OBJECT_ID('tempdb..#BKProducts') IS NOT NULL
BEGIN
DROP TABLE #BKProducts
END

-- DO THE BUDGET CALS - BREAK BUDGET FG DOWN INTO BKS...
DELETE FROM Budgets WHERE Warehouse ='BK'

CREATE TABLE #BKProducts (Groups VARCHAR(50), Product VARCHAR(10), Quantity INT DEFAULT (0), Period DATETIME, KGs FLOAT DEFAULT (0), lvlOneBK VARCHAR(10),lvlTwoBK VARCHAR(10),lvlThreeBK VARCHAR(10),lvlFourBK VARCHAR(10))
INSERT INTO #BKProducts (Product,  Quantity, Period) 
(SELECT Product, Quantity*u.spare, BudgetPeriod FROM Budgets p INNER JOIN syslive.scheme.stockm b ON p.Product = b.product INNER JOIN syslive.scheme.stunitdm u ON b.unit_code = u.unit_code WHERE b.product IN ('001015','001023','001066','001090','001147','001155','001171','001201','001376','001406','001430','001473','001546','001570','001724','001910','002003','002089','002119','002224','002240','002259','002291','002461','002518','002577','002607','002674','002682','002771','002828','002909','003018','003085','003247','003301','003352','003409','003425','003492','003700','004103','004227','004332','004901','004928','004944','004979','005029','005053','005061','005169','005533','005576','005932','006009','006122','006149','006246','006734','007692','007862','008079','008087','008192','008303','008338','008575','008702','008729','008958','008966','008982','009040','010200','010502','014001','014036','014087','014117','014176','014273','014753','014796','014826','016268','016306','016314','016330','016357','016365','016373','016411','016438','016446','016462','016470','016497','016519','016527','016608','016659','016748','016756','016764','016896','016977','016985','017205','017345','017353','017442','018406','019119','019143','019151','019178','019380','019690','020974','024198','024228','024341','024384','024481','025089','025704','026565','026743','026980','030708','030716','040029','040037','040053','040061','040088','040096','040126','040142','040150','040169','040177','040185','040193','040223','040231','040258','040266','040274','040282','044024','044032','044091','044105','044172','044180','044199','044202','044261','044288','044296','044318','044326','044342','044350','044369','044377','044415','044423','044458','044466','044482','044490','044504','054011','055018','055026','055034','056022','057002','057010','057118','057207','057215','058009','058017','059005','059013','061158','061182','061514','061522','064610','065323','065331','065358','067202','067237','067296','067318','067326','067571','067598','067636','067660','067725','067741','067768','067822','069000','069019','069027','069035','069078','070467','070602','070610','070629','074306','074314','074322','074330','074357','074365','074373','074381','074438','087335','087483','087491','087505','087521','087556','087572','087580','087661','087742','087750','088420','088501','088528','089001','089028','089222','089230','089265','089303','089478','089486','089508','089737','089990','126569','126577','126968','127212','127220','127255','127263','127271','127298','127328','128391','128537','128545','128553','128707','128715','128820','128952','128960','128979','129010','129177','129207','00202X','00233X','00622X','06131X'))

CREATE TABLE #BKForecast(Product VARCHAR(10), Descript VARCHAR(50),Quantity INT default (0), Period DATETIME, KGs FLOAT DEFAULT (0))

INSERT INTO #BKForecast(Product, KGs, Period)
SELECT		b.component_code, 
			--Quantity,
			ROUND(CASE component_unit WHEN 'g' THEN p.Quantity*(b.usage_quantity/1000) ELSE p.Quantity*b.usage_quantity END, 0),			
			p.Period
FROM		syslive.scheme.bmassdm b
INNER JOIN	#BKProducts p
ON			p.Product = b.product_code
WHERE		b.component_whouse = 'BK' 

UPDATE		p
SET			p.lvlTwoBK = b.component_code
FROM		syslive.scheme.bmassdm b
INNER JOIN	#BKProducts p
ON			p.lvlOneBK = b.product_code
WHERE		b.component_whouse = 'BK' 
AND			p.lvlOneBK IS NOT NULL

INSERT INTO #BKForecast(Product, KGs, Period)
SELECT		b.component_code, 
			ROUND(CASE component_unit WHEN 'g' THEN p.Quantity*(b.usage_quantity/1000) ELSE p.Quantity*b.usage_quantity END, 0),			
			p.Period
FROM		syslive.scheme.bmassdm b
INNER JOIN	#BKProducts p
ON			p.lvlOneBK = b.product_code
WHERE		b.component_whouse = 'BK' 

UPDATE		p
SET			p.lvlThreeBK = b.component_code
FROM		syslive.scheme.bmassdm b
INNER JOIN	#BKProducts p
ON			p.lvlTwoBK = b.product_code
WHERE		b.component_whouse = 'BK' 
AND			p.lvlTwoBK IS NOT NULL

INSERT INTO Budgets(Product, Warehouse, Quantity, BudgetPeriod)
SELECT	Product, 'BK', SUM(KGs), Period	FROM #BKForecast
GROUP BY	Product,Period
GO
--------------------------------------------------------------------------------------------------------------------------------------------------------
-- *****************************************************************NOW DO THE ACTUAL*****************************************************************--
-------------------------------------------------------------------------------------------------------------------------------------------------------- 
IF OBJECT_ID('tempdb..#BKActualProducts') IS NOT NULL
BEGIN
DROP TABLE #BKActualProducts
END
IF OBJECT_ID('tempdb..#BKActual') IS NOT NULL
BEGIN
DROP TABLE #BKActual
END

CREATE TABLE #BKActualProducts (Groups VARCHAR(50), OperationName VARCHAR(20), Product VARCHAR(10), Quantity INT default (0), Period DateTime, KGs FLOAT default (0), lvlOneBK VARCHAR(10),lvlTwoBK VARCHAR(10),lvlThreeBK VARCHAR(10))
INSERT INTO #BKActualProducts(Period, Product, Quantity, Groups)	
SELECT		DATEADD(MONTH, DATEDIFF(MONTH, 0, completion_date), 0),
			wo.product_code,		
			wo.quantity_finished,	
			StadaFactBKGroups.Groups			
FROM        syslive.scheme.bmwohm wo WITH(NOLOCK) 
INNER JOIN  syslive.scheme.wsroutdm d WITH(NOLOCK)	
ON			(wo.warehouse + wo.product_code = d.code) 
INNER JOIN	syslive.dbo.StadaFactBKGroups 
ON			LEFT(d.resource_code, 4) = LEFT(StadaFactBKGroups.Line, 4)	
WHERE		(d.operation_name IN ('Manufacture', 'Transfer', 'Clean Up', 'Set Up'))
AND			wo.completion_date BETWEEN StadaFactBook.dbo.fn_StartOfYear() AND StadaFactBook.dbo.fn_EndOfLastMonth()
GROUP BY	Groups, wo.product_code, wo.quantity_finished, DATEADD(MONTH, DATEDIFF(MONTH, 0, completion_date), 0)


UPDATE		p
SET			p.KGs = ROUND(CASE component_unit WHEN 'g' THEN p.Quantity*(b.usage_quantity/1000) ELSE p.Quantity*b.usage_quantity END, 0)
FROM		syslive.scheme.bmassdm b
INNER JOIN	#BKActualProducts p
ON			p.Product = b.product_code
where		b.component_whouse = 'BK'


INSERT INTO #BKActualProducts(lvlTwoBK, KGs, Period, Groups)
SELECT		b.component_code, 
			SUM(ROUND(CASE component_unit WHEN 'g' THEN p.Quantity*(b.usage_quantity/1000) ELSE p.Quantity*b.usage_quantity END, 0)),			
			p.Period,
			p.Groups
FROM		syslive.scheme.bmassdm b
INNER JOIN	#BKActualProducts p
ON			p.Product = b.product_code
GROUP BY	b.component_code,p.Period, p.Groups


INSERT INTO #BKActualProducts(lvlThreeBK, KGs, Period, Groups)
SELECT		b.component_code, 			
			SUM(ROUND(CASE component_unit WHEN 'g' THEN p.Quantity*(b.usage_quantity/1000) ELSE p.Quantity*b.usage_quantity END, 0)),			
			p.Period,
			p.Groups
FROM		syslive.scheme.bmassdm b
INNER JOIN	#BKActualProducts p
ON			p.lvlTwoBK = b.product_code
GROUP BY	b.component_code,p.Period, 
			p.Quantity,b.usage_quantity,
p.Groups


SELECT		Groups, SUM(b.Quantity) AS KGBudget, SUM(r.KGs) as KGFinished, Period
FROM		#BKActualProducts r
INNER JOIN	StadaFactBook.dbo.Budgets b
ON			r.Product = b.Product
WHERE		b.Warehouse = 'BK'
AND			b.BudgetPeriod = r.Period
GROUP BY	Groups, Period
ORDER BY	Groups

