USE	syslive

DROP TABLE #Results 
CREATE TABLE #Results (CompletionDate DateTime, quantity_finished int, Product varchar(12), Operation varchar(12), Groups varchar(15), batches int, ProdDesc varchar(50))

INSERT INTO #Results(CompletionDate, quantity_finished, batches, Product, Operation, Groups)
SELECT		DATEADD(MONTH, DATEDIFF(MONTH, 0, completion_date), 0), SUM(quantity_finished), count(distinct wo.works_order) as batches, wo.product_code, d.operation_name, g.Groups
FROM        scheme.bmwohm wo WITH(NOLOCK) 
INNER JOIN	scheme.stockm m 
ON			wo.product_code = m.product
AND			wo.warehouse = m.warehouse
LEFT JOIN   scheme.wsroutdm d WITH(NOLOCK)	
ON			(wo.warehouse + wo.product_code = d.code) 
INNER JOIN	StadaFactFGGroups g
ON			LEFT(d.resource_code, 4) = LEFT(g.Line, 4)
WHERE		wo.completion_date BETWEEN StadaFactBook.dbo.fn_StartOfYear() AND StadaFactBook.dbo.fn_EndOfLastMonth()
AND			(UPPER(d.operation_name) = UPPER('FILLING'))
AND			wo.product_code in ('001015','001023','001066','001090','001147','001155','001171','001201','001376','001406','001430','001473','001546','001570','001724','001910','002003','002089','002119','002224','002240','002259','002291','002461','002518','002577','002607','002674','002682','002771','002828','002909','003018','003085','003247','003301','003352','003409','003425','003492','003700','004103','004227','004332','004901','004928','004944','004979','005029','005053','005061','005169','005533','005576','005932','006009','006122','006149','006246','006734','007692','007862','008079','008087','008192','008303','008338','008575','008702','008729','008958','008966','008982','009040','010200','010502','014001','014036','014087','014117','014176','014273','014753','014796','014826','016268','016306','016314','016330','016357','016365','016373','016411','016438','016446','016462','016470','016497','016519','016527','016608','016659','016748','016756','016764','016896','016977','016985','017205','017345','017353','017442','018406','019119','019143','019151','019178','019380','019690','020974','024198','024228','024341','024384','024481','025089','025704','026565','026743','026980','030708','030716','040029','040037','040053','040061','040088','040096','040126','040142','040150','040169','040177','040185','040193','040223','040231','040258','040266','040274','040282','044024','044032','044091','044105','044172','044180','044199','044202','044261','044288','044296','044318','044326','044342','044350','044369','044377','044415','044423','044458','044466','044482','044490','044504','054011','055018','055026','055034','056022','057002','057010','057118','057207','057215','058009','058017','059005','059013','061158','061182','061514','061522','064610','065323','065331','065358','067202','067237','067296','067318','067326','067571','067598','067636','067660','067725','067741','067768','067822','069000','069019','069027','069035','069078','070467','070602','070610','070629','074306','074314','074322','074330','074357','074365','074373','074381','074438','087335','087483','087491','087505','087521','087556','087572','087580','087661','087742','087750','088420','088501','088528','089001','089028','089222','089230','089265','089303','089478','089486','089508','089737','089990','126569','126577','126968','127212','127220','127255','127263','127271','127298','127328','128391','128537','128545','128553','128707','128715','128820','128952','128960','128979','129010','129177','129207','00202X','00233X','00622X','06131X')
GROUP BY	code, DATEADD(MONTH, DATEDIFF(MONTH, 0, completion_date), 0), wo.product_code, d.operation_name, g.Groups

select CompletionDate, Groups, sum(quantity_finished) as ActualPacks  from #Results group by CompletionDate, Groups
order by Groups
SELECT * FROM StadaFactBook.dbo.Budgets b

SELECT		b.*, m.long_description 
FROM		StadaFactBook.dbo.Budgets b
INNER JOIN	scheme.stockm m 
ON			b.Product = m.product
AND			b.Warehouse = m.warehouse
AND			m.warehouse ='FG'
ORDER BY	BudgetPeriod, b.Product, m.long_description

SELECT		Groups,  SUM(Quantity) As BudgetQuantity, SUM(quantity_finished) as QuantityFinished, BudgetPeriod
FROM		#Results r
INNER JOIN	StadaFactBook.dbo.Budgets b
ON			r.Product = b.Product
WHERE		b.BudgetPeriod = r.CompletionDate
group by	Groups,BudgetPeriod
order by	Groups

select		r.*, s.long_description	 
FROM		#Results r
INNER JOIN	scheme.stockm s
ON			r.Product = s.product
and			s.warehouse = 'FG'
where	product = '040274' 
/*

select	*  fROM        scheme.bmwohm wo WITH(NOLOCK) where product_code = '001023' where 
SELECT * FROM [syslive].[dbo].[StadaFactFGGroups]

*/
