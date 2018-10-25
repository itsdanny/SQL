SELECT		h.completion_date as IGBKCompletionDate,
			h.works_order AS IGBKWorkOrder, 
			h.alpha_code AS IGBKAlphaCode, 
			h.warehouse AS IGBKwarehouse, 
			h.product_code AS IGBKProduct,
			h.quantity_required AS IGBKQtyRequired, 
			h.quantity_rejected AS IGBKIGBKQtyRejected, 
			h.quantity_finished AS IGBKQtyFinished, 
			d.quantity_issued AS IGQtyIssued,
			d.quantity_required AS IGQtyRequired, 
			d.component_code AS IGBKComponentCode, 
			d.component_unit AS IGBKComponetCode,
			h.finish_prod_unit as IGBKUnits,
			u.spare as IGBKSize,
			c.Mass,
			c.Base_g,
			c.FGBase_g
			INTO #Tmp
FROM		scheme.bmwohm h
LEFT JOIN	scheme.bmwodm d
ON			h.works_order = d.works_order
INNER JOIN	scheme.stunitdm u
ON			h.finish_prod_unit = u.unit_code
INNER JOIN	ContDrugsImport c
ON			c.IGCode = d.component_code
WHERE		h.warehouse = 'BK'
AND			h.completion_date BETWEEN '2014-01-01' AND '2014-12-31'
AND			c.FGCode = '087335'

SELECT		h.completion_date as BKFGCompletionDate,
			h.works_order AS BKFGWorkOrder, 
			h.alpha_code AS BKFGAlphaCode, 
			h.warehouse AS BKFGwarehouse, 
			h.product_code AS BKFGProduct,
			h.quantity_required AS FGQtyRequired, 
			h.quantity_rejected AS FGQtyRejected, 
			h.quantity_finished AS FGQtyFinished, 
			d.quantity_issued AS BKFGQtyIssued,
			d.quantity_required AS BKFGQtyRequired, 
			d.component_code AS BKFGComponentCode, 
			d.component_unit AS BKFGComponetCode, 
			h.finish_prod_unit as BKFGUnits,
			u.spare as BKFGSize
			INTO #Tmp2
FROM		scheme.bmwohm h
LEFT JOIN	scheme.bmwodm d
ON			h.works_order = d.works_order
INNER JOIN	scheme.stunitdm u
ON			h.finish_prod_unit = u.unit_code
INNER JOIN	#Tmp t
ON			t.IGBKAlphaCode = h.alpha_code
WHERE		h.warehouse = 'FG'
AND			h.completion_date BETWEEN '2014-01-01' AND '2014-12-31'
AND			d.stage = 'BULK'

SELECT			t.IGBKCompletionDate,  
				t.IGBKAlphaCode, 
				t.IGBKQtyRequired, 
				t.IGBKQtyRequired, 
				t.IGBKIGBKQtyRejected, 
				t.IGBKQtyFinished, 
				t.IGBKUnits,
				t2.FGQtyRequired, 
				t2.FGQtyRejected, 
				t2.FGQtyFinished, 
				t2.BKFGQtyIssued, 
				t2.BKFGQtyRequired,
				t2.BKFGSize,
				t2.BKFGUnits,
				t2.FGQtyFinished*t.Mass As LitresFilled,
				t2.FGQtyFinished*t.Base_g AS Base_g_Filled
FROM			#Tmp t 
LEFT	JOIN	#Tmp2 t2
ON				t.IGBKAlphaCode = t2.BKFGAlphaCode


DROP TABLE	#Tmp
DROP TABLE	#Tmp2
