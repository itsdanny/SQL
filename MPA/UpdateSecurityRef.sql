/*update scheme.bmwohm set security_reference = 'AM' WHERE security_reference = '1'-- AND (due_date >= '2016-03-14' OR status IN ('A','I'))
update scheme.bmwohm set security_reference = 'PM' WHERE security_reference = '2'
update scheme.bmwohm set security_reference = 'NS' WHERE security_reference = '3'


select * from scheme.bmwohm WHERE security_reference = '1' AND (due_date >= '2016-03-14' OR status IN ('A','I'))
select * from scheme.bmwohm WHERE security_reference = '1' AND (due_date >= '2016-03-14' OR status IN ('A','I'))
select * from scheme.bmwohm WHERE security_reference = '1' AND (due_date >= '2016-03-14' OR status IN ('A','I'))

update scheme.bmwohm set security_reference = 1 WHERE security_reference = 'AM' AND (due_date >= '2016-03-14' OR status IN ('A','I'))
update scheme.bmwohm set security_reference = 2 WHERE security_reference = 'PM' AND (due_date >= '2016-03-14' OR status IN ('A','I'))
update scheme.bmwohm set security_reference = 3 WHERE security_reference = 'NS' AND (due_date >= '2016-03-14' OR status IN ('A','I'))
*/
--select * from scheme.bmwohm WHERE security_reference = '1' AND (due_date >= '2016-03-14' OR status IN ('A','I'))
--	SELECT * FROM WOAM
DECLARE @Tmp Table(Id INT IDENTITY(1,1), order_date DATETIME, works_order VARCHAR(7), security_reference VARCHAR(2), machine_name VARCHAR(30), GoingToSlot INT)

INSERT INTO @Tmp
SELECT		DISTINCT b.order_date, b.works_order, security_reference, w.machine_group, 0
FROM		scheme.bmwohm b 
INNER JOIN	scheme.wswopm w 
ON			b.works_order = w.works_order
WHERE		security_reference IN ('AM','PM','NS','1','2','3','4') 
AND			(due_date >= '2016-03-14' OR b.status IN ('A','I'))
--AND			w.machine_name = '4000L MANUFACTURING PAN'
--AND			b.works_order in ('NA27','NA28')
ORDER BY	w.machine_group, b.order_date, b.security_reference

select * from @Tmp
DECLARE @Row INT = 1, @Rows INT = (SELECT COUNT(1) FROM @Tmp)
DECLARE @CurWorkCentre VARCHAR(30) = '', @CurOrderDate DATETIME = '2000-01-01 00:00:00', @CurWorkOrder VARCHAR(6) = '', @CurSlot VARCHAR(2)
DECLARE @NextWorkCentre VARCHAR(30), @NextOrderDate DATETIME, @NextWorkOrder VARCHAR(6), @NextSlot VARCHAR(2)
DECLARE	@Slot INT = 1
WHILE @Row <= @Rows
BEGIN
	
	SELECT 	@NextWorkCentre = machine_name,
			@NextOrderDate = order_date,
			@NextSlot = security_reference,
			@CurWorkOrder = works_order			
	FROM	@Tmp 
	WHERE	Id = @Row
	
	IF  @CurWorkCentre <> @NextWorkCentre or  @CurOrderDate <> @NextOrderDate 
	BEGIN
		SELECT @CurWorkCentre = @NextWorkCentre, @Slot = 1, @CurOrderDate = @NextOrderDate
	END	
	
	--IF @CurOrderDate <> @NextOrderDate 
	--BEGIN
	--	SELECT @CurOrderDate = @NextOrderDate, @Slot = 1 
	--END
	
	-- IF SLOTS ARE THE SAME, INCREMENT IT
	--IF @CurSlot = @NextSlot
	--BEGIN
	--	SELECT @CurSlot = @NextSlot, @Slot = @Slot + 1
	--	UPDATE	scheme.bmwohm 
	--	SET		security_reference = @Slot
	--	WHERE	works_order = @CurWorkOrder
	--END
	--ELSE
	--BEGIN	
	--	UPDATE	scheme.bmwohm 
	--	SET		security_reference = @Slot
	--	WHERE	works_order = @CurWorkOrder

	--	SELECT @Slot = @Slot + 1
	--END
	UPDATE	scheme.bmwohm 
	SET		security_reference = @Slot
	WHERE	works_order = @CurWorkOrder

	SELECT @Slot = @Slot + 1

SET @Row = @Row + 1
END

SELECT		DISTINCT b.order_date, b.works_order, CAST(security_reference AS INT) AS security_reference, w.machine_name
FROM		scheme.bmwohm b 
INNER JOIN	scheme.wswopm w 
ON			b.works_order = w.works_order
WHERE		security_reference IN ('1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16') 
AND			(due_date >= '2016-03-14' OR b.status IN ('A','I'))
ORDER BY	w.machine_name, b.order_date, CAST(security_reference AS INT)

/*
-- FIX IT
SELECT		*
FROM		scheme.bmwohm h
INNER JOIN	WOAM t
ON			h.works_order = t.works_order
AND			h.security_reference <> t.security_reference
*/
/*
UPDATE		h
SET			h.security_reference = t.security_reference
FROM		scheme.bmwohm h
INNER JOIN	WOAM t
ON			h.works_order = t.works_order
AND			h.security_reference <> t.security_reference
*/


--SELECT order_date, works_order, security_reference FROM	scheme.bmwohm h where h.works_order in ('NA27','NA28')


--SELECT		DISTINCT b.order_date, b.works_order, security_reference, w.machine_name
--FROM		scheme.bmwohm b 
--INNER JOIN	scheme.wswopm w
--ON			b.works_order = w.works_order
--WHERE		(due_date >= '2016-03-14' OR b.status IN ('A','I'))
----AND			w.machine_name = '4000L MANUFACTURING PAN'
--AND			b.works_order in ('NA27','NA28')
--ORDER BY	w.machine_name, b.order_date

