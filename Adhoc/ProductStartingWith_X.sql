/* SSMSBoost
Event: DocumentClosing
Event date: 2015-03-11 14:06:05
*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
CREATE FUNCTION fn__ReturnCheckDigitLine
(	
	-- Add the parameters for the function here
	@CheckDigit INT
)

RETURNS  @Results		Table(							
							  CheckDigit1 CHAR(1),
							  CheckDigit2 CHAR(1),
							  CheckDigit3 CHAR(1),
							  CheckDigit4 CHAR(1),
							  CheckDigit5 CHAR(1),
							  CheckDigit6 CHAR(1),
							  CheckDigit7 CHAR(1),
							  CheckDigit8 CHAR(1),
							  CheckDigit9 CHAR(1),
							  CheckDigit10 CHAR(1)) 
AS
BEGIN

	DECLARE @CheckDigits Table(
							  CheckDigit1 CHAR(1),
							  CheckDigit2 CHAR(1),
							  CheckDigit3 CHAR(1),
							  CheckDigit4 CHAR(1),
							  CheckDigit5 CHAR(1),
							  CheckDigit6 CHAR(1),
							  CheckDigit7 CHAR(1),
							  CheckDigit8 CHAR(1),
							  CheckDigit9 CHAR(1),
							  CheckDigit10 CHAR(1))

	IF @CheckDigit = 0
	BEGIN
		INSERT INTO @CheckDigits SELECT '0','9','7','5','3','1','X','8','6','4'
	END
	ELSE IF @CheckDigit = 1
	BEGIN
		INSERT INTO @CheckDigits SELECT '1','X','9','6','4','2','0','9','7','5'
	END
	ELSE IF @CheckDigit = 2
	BEGIN
		INSERT INTO @CheckDigits SELECT '2','0','9','7','5','3','1','X','8','6'
	END
	ELSE IF @CheckDigit = 3
	BEGIN
		INSERT INTO @CheckDigits SELECT '3','1','X','8','6','4','2','0','9','7'
	END
	ELSE IF @CheckDigit = 4
	BEGIN
		INSERT INTO @CheckDigits SELECT '4','2','0','9','7','5','3','1','X','8'
	END
	ELSE IF @CheckDigit = 5
	BEGIN
		INSERT INTO @CheckDigits SELECT '5','3','1','X','8','6','4','2','0','9'
	END
	ELSE IF @CheckDigit = 6
	BEGIN
		INSERT INTO @CheckDigits SELECT '6','4','2','0','9','7','5','3','1','X'
	END
	ELSE IF @CheckDigit = 7
	BEGIN
		INSERT INTO @CheckDigits SELECT '7','5','3','1','X','8','6','4','2','0'
	END	
	ELSE IF @CheckDigit = 8
	BEGIN
		INSERT INTO @CheckDigits SELECT '8','6','4','2','0','9','7','5','3','1'
	END
	ELSE IF @CheckDigit = 9
	BEGIN
		INSERT INTO @CheckDigits SELECT  '9','7','5','3','1','X','8','6','4','2'
	END
	ELSE IF @CheckDigit = 10
	BEGIN
		INSERT INTO @CheckDigits SELECT  'X','8','6','4','2','0','9','7','5','3'
	END
		
			
	INSERT INTO @Results
	SELECT * FROM @CheckDigits
	
  RETURN
 END
GO


--SELECT * from dbo.fn__ReturnCheckDigitLine(1)
--SELECT * from dbo.fn__ReturnCheckDigitLine(2)
--SELECT * from dbo.fn__ReturnCheckDigitLine(3)
--SELECT * from dbo.fn__ReturnCheckDigitLine(4)
--SELECT * from dbo.fn__ReturnCheckDigitLine(5)
--SELECT * from dbo.fn__ReturnCheckDigitLine(6)
--SELECT * from dbo.fn__ReturnCheckDigitLine(7)
--SELECT * from dbo.fn__ReturnCheckDigitLine(8)
--SELECT * from dbo.fn__ReturnCheckDigitLine(9)
--SELECT * from dbo.fn__ReturnCheckDigitLine(10)

go

DECLARE @CheckDigits Table( Id INT IDENTITY(1,1), 
							StartCheckDigit INT,
							EndCheckDigit INT,
							Sheet INT)

DECLARE @ProductCodes Table(Id INT IDENTITY(1,1), 
							Product0 VARCHAR(8),
							Product1 VARCHAR(8),
							Product2 VARCHAR(8), 
							Product3 VARCHAR(8), 
							Product4 VARCHAR(8), 
							Product5 VARCHAR(8),
							Product6 VARCHAR(8), 
							Product7 VARCHAR(8), 
							Product8 VARCHAR(8),
							Product9 VARCHAR(8),							   
							Sheet INT)

DECLARE @Results Table(CheckDigit1 CHAR(1),
						CheckDigit2 CHAR(1),
						CheckDigit3 CHAR(1),
						CheckDigit4 CHAR(1),
						CheckDigit5 CHAR(1),
						CheckDigit6 CHAR(1),
						CheckDigit7 CHAR(1),
						CheckDigit8 CHAR(1),
						CheckDigit9 CHAR(1),
						CheckDigitX CHAR(1))

INSERT INTO @CheckDigits VALUES (0,5,1)
INSERT INTO @CheckDigits VALUES (2,7,2)
INSERT INTO @CheckDigits VALUES (6,0,3)
INSERT INTO @CheckDigits VALUES (8,2,4)
INSERT INTO @CheckDigits VALUES (1,6,5)
INSERT INTO @CheckDigits VALUES (3,8,6)
INSERT INTO @CheckDigits VALUES (7,1,7)
INSERT INTO @CheckDigits VALUES (9,3,8)
INSERT INTO @CheckDigits VALUES (2,7,9)
INSERT INTO @CheckDigits VALUES (4,9,10)
INSERT INTO @CheckDigits VALUES (8,2,11)
INSERT INTO @CheckDigits VALUES (10,4,12)
INSERT INTO @CheckDigits VALUES (3,8,13)
INSERT INTO @CheckDigits VALUES (5,10,14)
INSERT INTO @CheckDigits VALUES (9,3,15)
INSERT INTO @CheckDigits VALUES (0,5,16)
INSERT INTO @CheckDigits VALUES (4,9,17)
INSERT INTO @CheckDigits VALUES (6,0,18)
INSERT INTO @CheckDigits VALUES (10,4,19)
INSERT INTO @CheckDigits VALUES (1,6,20)

DECLARE @Sheet INT = 0
DECLARE @Row INT = 0
DECLARE @Col INT = 0
DECLARE @LastRowVal INT = 0
DECLARE @CalcNextRow BIT = 0
DECLARE @CHAR INT
DECLARE @LeftPart VARCHAR(4) = '00000'
DECLARE	@StartDigit VARCHAR(1) = '7'
DECLARE @LastTableRow INT 
PRINT 'START'
  WHILE @Row < 9999
	BEGIN
	
	IF @Row % 500 = 0
	BEGIN		
		PRINT 'NEW SHEET'
		SET @Sheet = @Sheet + 1
		SET @CalcNextRow = 0
	END	

	-- CALC THE CD
	IF @CalcNextRow = 1
	BEGIN		
		 SET @LastTableRow = (SELECT COUNT(0) FROM @ProductCodes)		 
		 IF (@LastTableRow % 10 <> 0) 
		 BEGIN
			 IF (@LastRowVal + 8 > 10) 
			BEGIN
				SET @LastRowVal = @LastRowVal - 3
			END
			ELSE
			BEGIN					
				SET @LastRowVal = @LastRowVal + 8			
			END
		 END
		ELSE 
		BEGIN
			PRINT 'Adding 1 to LastRowVal: ' + CAST(@LastRowVal AS VARCHAR(5)) + '. To give: ' + CAST(@LastRowVal+1 AS VARCHAR(5)) 
			SET @LastRowVal = @LastRowVal + 1					
			IF  @LastRowVal > 10
			BEGIN
				SET @LastRowVal = 0				
			END
		END	 
	END
	ELSE
	BEGIN
		SET @LastRowVal = (SELECT StartCheckDigit FROM @CheckDigits WHERE Sheet = @Sheet)		
		SET @CalcNextRow = 1
	END

	PRINT 'ADDING DATA FOR:- Cur Sheet: ' + CAST(@Sheet AS VARCHAR(5)) + '. LastRowVal: ' + CAST(@LastRowVal AS VARCHAR(5)) + '. Last Table Row: ' + CAST(@LastTableRow AS VARCHAR(5))

	DELETE FROM @Results WHERE 1 = 1
	INSERT INTO @Results SELECT * FROM dbo.fn__ReturnCheckDigitLine(@LastRowVal)
	
	INSERT INTO @ProductCodes(Product0, Product1, Product2, Product3, Product4, Product5, Product6, Product7, Product8, Product9, Sheet)
	VALUES ('7'+RIGHT(@LeftPart+CAST(@Row AS VARCHAR(4)),4) + ''+(SELECT CheckDigit1 FROM @Results),
			'7'+RIGHT(@LeftPart+CAST(@Row AS VARCHAR(4)),4) + ''+(SELECT CheckDigit2 FROM @Results),
			'7'+RIGHT(@LeftPart+CAST(@Row AS VARCHAR(4)),4) + ''+(SELECT CheckDigit3 FROM @Results),
			'7'+RIGHT(@LeftPart+CAST(@Row AS VARCHAR(4)),4) + ''+(SELECT CheckDigit4 FROM @Results),
			'7'+RIGHT(@LeftPart+CAST(@Row AS VARCHAR(4)),4) + ''+(SELECT CheckDigit5 FROM @Results),
			'7'+RIGHT(@LeftPart+CAST(@Row AS VARCHAR(4)),4) + ''+(SELECT CheckDigit6 FROM @Results),
			'7'+RIGHT(@LeftPart+CAST(@Row AS VARCHAR(4)),4) + ''+(SELECT CheckDigit7 FROM @Results),
			'7'+RIGHT(@LeftPart+CAST(@Row AS VARCHAR(4)),4) + ''+(SELECT CheckDigit8 FROM @Results),
			'7'+RIGHT(@LeftPart+CAST(@Row AS VARCHAR(4)),4) + ''+(SELECT CheckDigit9 FROM @Results),
			'7'+RIGHT(@LeftPart+CAST(@Row AS VARCHAR(4)),4) + ''+(SELECT CheckDigitX FROM @Results),
			@Sheet)		
	SET @Row = @Row + 10
  END

DROP FUNCTION fn__ReturnCheckDigitLine

SELECT * FROM @ProductCodes
