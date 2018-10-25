/*
--3
SELECT
		   LTRIM(RTRIM(m.product)) AS [Material],
		   m.description AS [Materual Short Text],
		   LTRIM(RTRIM(q.lot_number)) AS [Batch Number],
		   sum(q.quantity) AS [Quantity],
		   LTRIM(RTRIM(q.bin_number)) AS [Distination Storage Bin],
		   LTRIM(RTRIM(qa.lot_number2)) AS [Storage Unit Number],
		   m.drawing_number

--INTO #ETL1
FROM       syslive.scheme.stockm m WITH(NOLOCK)
INNER JOIN syslive.scheme.stquem q WITH(NOLOCK) 
ON		   m.warehouse = q.warehouse 
AND		   m.product = q.product
INNER JOIN syslive.scheme.stqueam qa WITH(NOLOCK) 
ON		   q.warehouse = qa.warehouse 
AND		   q.product = qa.product
AND		   q.sequence_number = qa.sequence_number
WHERE	   q.quantity > 0 
AND        m.warehouse = 'IG' 
AND			ISNUMERIC(LTRIM(RTRIM(q.bin_number))) = 1
AND		   LEN(LTRIM(RTRIM(q.lot_number))) < 9
GROUP BY   m.product, m.description, q.lot_number, q.bin_number, qa.lot_number2, m.drawing_number
ORDER BY   q.lot_number
use syslive
GO
*/
DECLARE @Updates TABLE(Id INT IDENTITY(1,1), Material VARCHAR(20), [Materual Short Text] VARCHAR(20), lot_number VARCHAR(10), orig_lot_number VARCHAR(10), batch_number VARCHAR(10), Quantity INT, [Distination Storage Bin] VARCHAR(20), 
		LotNumber2 VARCHAR(20), sequence_number VARCHAR(10), Fail bit)
INSERT INTO @Updates
--SELECT	*
--FROM	SAPMigration.dbo.LotUpdates
--WHERE		Material != '23515402'

SELECT		  LTRIM(RTRIM(m.product)) AS [Material],
		   m.description AS [Materual Short Text],
		   LTRIM(RTRIM(q.lot_number)) AS lot,
		   LTRIM(RTRIM(q.lot_number)),
		   LTRIM(RTRIM(q.batch_number)),
		   sum(q.quantity) AS [Quantity],
		   LTRIM(RTRIM(q.bin_number)) AS [Distination Storage Bin],
		   LTRIM(RTRIM(qa.lot_number2)) AS [Storage Unit Number],
			'',
			0
			--q.sequence_number
FROM       syslive.scheme.stockm m WITH(NOLOCK)
INNER JOIN syslive.scheme.stquem q WITH(NOLOCK) 
ON		   m.warehouse = q.warehouse 
AND		   m.product = q.product
INNER JOIN syslive.scheme.stqueam qa WITH(NOLOCK) 
ON		   q.warehouse = qa.warehouse 
AND		   q.product = qa.product
AND		   q.sequence_number = qa.sequence_number
WHERE	   q.quantity > 0 
AND        m.warehouse = 'IG' 
AND			ISNUMERIC(LTRIM(RTRIM(q.bin_number))) = 1
AND		   LEN(LTRIM(RTRIM(q.lot_number))) < 9
GROUP BY   m.product, m.description, q.lot_number, q.bin_number, qa.lot_number2,  LTRIM(RTRIM(q.batch_number))
ORDER BY	1

--select * from @Updates
--RETURN

DECLARE @Row INT = 1, @Rows INT
SET @Rows = (SELECT COUNT(1) FROM @Updates)
DECLARE @CurMat VARCHAR(20) = 'c' 
DECLARE @NextMat VARCHAR(20) = 'n'
DECLARE @CurLot VARCHAR(20) = 'c' 
DECLARE @CurLot2 VARCHAR(20) = 'c' 
DECLARE @NextLot VARCHAR(20) = 'n'
DECLARE @CurBatch VARCHAR(20) = 'c' 
DECLARE @NextBatch VARCHAR(20) = 'n'
DECLARE @AppendLotNo INT = 0
DECLARE @BinNo VARCHAR(20) = ''
DECLARE @PalletNumber VARCHAR(20) = ''
DECLARE @Seq VARCHAR(10) = ''
DECLARE @qem INT = 0, @his INT = 0, @recp INT = 0
--BEGIN TRAN
WHILE @Row <= @Rows
BEGIN
	SELECT		@NextMat = Material,
				@NextLot = lot_number,
				@NextBatch = batch_number,
				@Seq = sequence_number,
				@CurLot2 = LotNumber2,
				@BinNo = [Distination Storage Bin],
				@qem = 0,
				@his = 0,
				@recp = 0
	FROM		@Updates
	WHERE		Id = @Row
	
	SET @CurMat = @NextMat
	SET @CurLot = @NextLot
	SET @CurBatch = @NextBatch	
	SET @AppendLotNo  = @AppendLotNo + 1

	IF	@CurMat <> @NextMat OR	@AppendLotNo = 100
	BEGIN
		SET @AppendLotNo = 1
	END
				
	PRINT 'Mat: '+ @CurMat    
	PRINT 'Lot: '+ @CurLot
	PRINT 'Bat: '+ @CurBatch
	PRINT 'Bin: '+ @BinNo
	/*	
	SELECT	CASE lot_number2 WHEN '' THEN '' ELSE lot_number2 +'A'+REPLACE(STR(CAST(@AppendLotNo AS VARCHAR(2)), 2), SPACE(1), '0') END NewLotNo, lot_number2 Original, s1.*
	FROM	syslive.scheme.stqueam s1 WITH(NOLOCK)	
	INNER JOIN 	syslive.scheme.stquem s WITH(NOLOCK)	
	ON		s1.product = s.product
	AND		s1.warehouse = s.warehouse
	AND		s1.sequence_number = s.sequence_number
	WHERE	LTRIM(RTRIM(s.product)) =  @CurMat
	AND		LTRIM(RTRIM(s.batch_number)) = @CurBatch
	AND		LTRIM(RTRIM(s.lot_number)) = @CurLot
	AND		LTRIM(RTRIM(s1.lot_number2)) = @CurLot2
	AND		quantity > 0
	
	
	SELECT	LTRIM(RTRIM(lot_number))+'A'+REPLACE(STR(CAST(@AppendLotNo AS VARCHAR(2)), 2), SPACE(1), '0') NewLotNo, lot_number Original, *
	FROM	syslive.scheme.stquem s WITH(NOLOCK)	
	WHERE	LTRIM(RTRIM(s.product)) =  @CurMat
	AND		LTRIM(RTRIM(s.batch_number)) = @CurBatch
	AND		LTRIM(RTRIM(s.lot_number)) = @CurLot
	AND		LTRIM(RTRIM(bin_number)) = @BinNo
	AND		s.quantity > 0
				
	SELECT	LTRIM(RTRIM(lot_number))+'A'+REPLACE(STR(CAST(@AppendLotNo AS VARCHAR(2)), 2), SPACE(1), '0') NewLotNo,	lot_number Original, *
	FROM	syslive.scheme.stkhstm h WITH(NOLOCK)
	WHERE	LTRIM(RTRIM(h.product)) = @CurMat
	AND		LTRIM(RTRIM(h.lot_number)) = @CurLot
	AND		LTRIM(RTRIM(h.batch_number)) = @NextBatch
	AND		LTRIM(RTRIM(to_bin_number)) = @BinNo

	SELECT	 h.movement_reference AS QNumber
	FROM	syslive.scheme.stkhstm as h with (nolock)
	WHERE  LTRIM(RTRIM(h.lot_number)) = @CurLot
	AND		h.transaction_type = 'RECP'
	*/
	/*
	PRINT 'stquem'	
	UPDATE 	s
	SET		lot_number = LTRIM(RTRIM(lot_number))+'A'+REPLACE(STR(CAST(@AppendLotNo AS VARCHAR(2)), 2), SPACE(1), '0')
	FROM	syslive.scheme.stquem s
	WHERE	LTRIM(RTRIM(s.product)) =  @CurMat
	AND		LTRIM(RTRIM(s.batch_number)) = @CurBatch
	AND		LTRIM(RTRIM(s.lot_number)) = @CurLot
	AND		LTRIM(RTRIM(s.sequence_number)) = @Seq
	AND		LTRIM(RTRIM(bin_number)) = @BinNo
	AND		s.quantity > 0
		
	PRINT 'stqueam'
	UPDATE 	s
	SET 	lot_number2	= CASE lot_number2 WHEN '' THEN '' ELSE LTRIM(RTRIM(lot_number2)) +'A'+REPLACE(STR(CAST(@AppendLotNo AS VARCHAR(2)), 2), SPACE(1), '0') END
	FROM	syslive.scheme.stqueam s
	WHERE	LTRIM(RTRIM(s.product)) =  @CurMat
	AND		LTRIM(RTRIM(s.lot_number2)) = @CurLot2
	AND		LTRIM(RTRIM(s.sequence_number)) = @Seq
	
	PRINT 'stkhstm'
	UPDATE 	h
	SET		lot_number =  LTRIM(RTRIM(lot_number))+'A'+REPLACE(STR(CAST(@AppendLotNo AS VARCHAR(2)), 2), SPACE(1), '0')
	FROM	syslive.scheme.stkhstm h
	WHERE	LTRIM(RTRIM(h.product)) = @CurMat
	AND		LTRIM(RTRIM(h.lot_number)) = @CurLot
	AND		LTRIM(RTRIM(h.batch_number)) = @NextBatch
	AND		LTRIM(RTRIM(to_bin_number)) = @BinNo
	*/
	--BEGIN TRAN 

	SET @PalletNumber = CASE @CurLot2 WHEN '' THEN '' ELSE LTRIM(RTRIM(@CurLot2)) +'A'+REPLACE(STR(CAST(@AppendLotNo AS VARCHAR(2)), 2), SPACE(1), '0') END
	IF	LEN(@PalletNumber) > 9
	BEGIN
		SET @PalletNumber = LEFT (@PalletNumber, 9)
	END

	PRINT 'stqueam'
	UPDATE 		s1
	SET 		lot_number2	= @PalletNumber
	FROM		syslive.scheme.stqueam s1
	INNER JOIN 	syslive.scheme.stquem s
	ON			s1.product = s.product
	AND			s1.warehouse = s.warehouse
	AND			s1.sequence_number = s.sequence_number
	WHERE		LTRIM(RTRIM(s.product)) =  @CurMat
	AND			LTRIM(RTRIM(s.batch_number)) = @CurBatch
	AND			LTRIM(RTRIM(s.lot_number)) = @CurLot
	AND			LTRIM(RTRIM(s1.lot_number2)) = @CurLot2
	AND			quantity > 0
 	
	SET @PalletNumber = CASE @CurLot WHEN '' THEN '' ELSE LTRIM(RTRIM(@CurLot)) +'A'+REPLACE(STR(CAST(@AppendLotNo AS VARCHAR(2)), 2), SPACE(1), '0') END
	IF	LEN(@PalletNumber) > 9
	BEGIN
		SET @PalletNumber = LEFT (@PalletNumber, 9)
	END
	
	IF	LEN(@PalletNumber) < 9
	BEGIN
		SET @PalletNumber =  REPLACE(LEFT(@PalletNumber + space(9), 9), ' ','X')
	END

	PRINT 'stquem'	
	UPDATE 	s
	SET		lot_number =  @PalletNumber
	FROM	syslive.scheme.stquem s
	WHERE	LTRIM(RTRIM(s.product)) =  @CurMat
	AND		LTRIM(RTRIM(s.batch_number)) = @CurBatch
	AND		LTRIM(RTRIM(s.lot_number)) = @CurLot
	AND		LTRIM(RTRIM(bin_number)) = @BinNo
	AND		s.quantity > 0


	IF	@@ROWCOUNT > 0
	BEGIN
		SET @qem = 1
	END				
	PRINT 'stkhstm stock'
	UPDATE 	h
	SET		lot_number =  @PalletNumber
	FROM	syslive.scheme.stkhstm h 
	WHERE	LTRIM(RTRIM(h.product)) = @CurMat
	AND		LTRIM(RTRIM(h.lot_number)) = @CurLot
	AND		LTRIM(RTRIM(h.batch_number)) = @CurBatch
	AND		LTRIM(RTRIM(to_bin_number)) = @BinNo
	
	IF	@@ROWCOUNT > 0
	BEGIN
		SET @his = 1
	END				
	PRINT 'stkhstm RECP'
	UPDATE 	h
	SET		lot_number = @PalletNumber
	FROM	syslive.scheme.stkhstm as h 
	WHERE	LTRIM(RTRIM(h.lot_number)) = @CurLot
	AND		h.transaction_type = 'RECP'

	IF	@@ROWCOUNT > 0
	BEGIN
		SET @recp = 1
	END				
	IF	@qem+@his+@recp < 3
	BEGIN
		UPDATE 	@Updates SET Fail = 1 WHERE Id = @Row
		--ROLLBACK		
	END
	--ELSE 
	--BEGIN
	--	COMMIT
	--END
		
SET @Row = @Row + 1
END

SELECT	*
FROM		@Updates
WHERE		Fail = 1

SELECT		m.product AS [Material],
			m.description AS [Materual Short Text],
			q.lot_number AS [Lot Number],		   
			q.lot_number,		   
			q.batch_number,
			SUM(q.quantity) AS [Quantity],
			q.bin_number AS [Distination Storage Bin],			
			qa.lot_number2 AS [Lot Number2]			
FROM		syslive.scheme.stockm m WITH(NOLOCK)
INNER JOIN	syslive.scheme.stquem q WITH(NOLOCK) 
ON			m.warehouse = q.warehouse 
AND			m.product = q.product
INNER JOIN	syslive.scheme.stqueam qa WITH(NOLOCK) 
ON			q.warehouse = qa.warehouse 
AND			q.product = qa.product
AND			q.sequence_number = qa.sequence_number
WHERE		q.quantity > 0 
AND			m.warehouse = 'IG' 
AND			ISNUMERIC(q.bin_number) = 1
AND			batch_number IN ('VW64B', 'Q32809', 'Q28270', 'Q28270', 'Q24290', 'WA23B', 'Q32093', 'Q32093', 'Q27249', 'A23266', 'Q40482', 'Q40482', 'AW54B')
AND			q.bin_number IN ('14019', '11216', '11303', '11303', '30356', '30356', '10019', '53402', '10109', '10221', '41513', '42508', '41614')
GROUP BY	q.bin_number, m.product, m.description,q.bin_number,q.lot_number,qa.lot_number2, q.batch_number
ORDER BY	1

--ROLLBACK

