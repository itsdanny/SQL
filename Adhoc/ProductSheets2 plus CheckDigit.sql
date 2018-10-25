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

/*
SELECT * from dbo.fn__ReturnCheckDigitLine(1)
SELECT * from dbo.fn__ReturnCheckDigitLine(2)
SELECT * from dbo.fn__ReturnCheckDigitLine(3)
SELECT * from dbo.fn__ReturnCheckDigitLine(4)
SELECT * from dbo.fn__ReturnCheckDigitLine(5)
SELECT * from dbo.fn__ReturnCheckDigitLine(6)
SELECT * from dbo.fn__ReturnCheckDigitLine(7)
SELECT * from dbo.fn__ReturnCheckDigitLine(8)
SELECT * from dbo.fn__ReturnCheckDigitLine(9)
SELECT * from dbo.fn__ReturnCheckDigitLine(10)

go
*/
-- SAME STUFF, DIFFERENT SHEETS/RANGES
DECLARE @CheckDigits Table( Id INT IDENTITY(1,1), 
							ProductPrefix VARCHAR(2),
							StartCheckDigit INT,-- START OF THE SHEET
							EndCheckDigit INT,
							Sheet INT)

DECLARE @ProductCodes Table(Id INT IDENTITY(1,1), 
							Product0 VARCHAR(10),
							Product1 VARCHAR(10),
							Product2 VARCHAR(10), 
							Product3 VARCHAR(10), 
							Product4 VARCHAR(10), 
							Product5 VARCHAR(10),
							Product6 VARCHAR(10), 
							Product7 VARCHAR(10), 
							Product8 VARCHAR(10),
							Product9 VARCHAR(10),							   
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

INSERT INTO @CheckDigits VALUES (12,5,10,1)
INSERT INTO @CheckDigits VALUES (12,7,1,2)
INSERT INTO @CheckDigits VALUES (13,0,0,3)
INSERT INTO @CheckDigits VALUES (13,2,2,4)
INSERT INTO @CheckDigits VALUES (14,6,6,5)
INSERT INTO @CheckDigits VALUES (14,8,8,6)
INSERT INTO @CheckDigits VALUES (15,1,1,7)
INSERT INTO @CheckDigits VALUES (15,3,3,8)
INSERT INTO @CheckDigits VALUES (16,7,7,9)
INSERT INTO @CheckDigits VALUES (16,9,9,10)
INSERT INTO @CheckDigits VALUES (17,2,2,11)
INSERT INTO @CheckDigits VALUES (17,4,4,12)
INSERT INTO @CheckDigits VALUES (18,8,8,13)
INSERT INTO @CheckDigits VALUES (18,10,10,14)
INSERT INTO @CheckDigits VALUES (19,3,3,15)
INSERT INTO @CheckDigits VALUES (19,5,5,16)
INSERT INTO @CheckDigits VALUES (20,8,9,17)
INSERT INTO @CheckDigits VALUES (20,10,0,18)
INSERT INTO @CheckDigits VALUES (21,3,4,19)
INSERT INTO @CheckDigits VALUES (21,5,6,20)
INSERT INTO @CheckDigits VALUES (22,9,3,21)
INSERT INTO @CheckDigits VALUES (22,0,1,22)
INSERT INTO @CheckDigits VALUES (23,4,1,23)
INSERT INTO @CheckDigits VALUES (23,6,1,24)
INSERT INTO @CheckDigits VALUES (24,10,1,25)
INSERT INTO @CheckDigits VALUES (24,1,1,26)
INSERT INTO @CheckDigits VALUES (25,5,1,27)
INSERT INTO @CheckDigits VALUES (25,7,1,28)
INSERT INTO @CheckDigits VALUES (26,0,1,29)
INSERT INTO @CheckDigits VALUES (26,2,1,30)
INSERT INTO @CheckDigits VALUES (27,6,1,31)
INSERT INTO @CheckDigits VALUES (27,8,1,32)
INSERT INTO @CheckDigits VALUES (28,1,1,33)
INSERT INTO @CheckDigits VALUES (28,3,1,34)
INSERT INTO @CheckDigits VALUES (29,7,1,35)
INSERT INTO @CheckDigits VALUES (29,9,3,36)

DECLARE @Sheets INT = (SELECT COUNT(1) FROM @CheckDigits)
DECLARE @Sheet INT = 0
DECLARE @Row INT = 0
DECLARE @Col INT = 0
DECLARE @LastRowVal INT = 0
DECLARE @CalcNextRow BIT = 0
DECLARE @LeftPart VARCHAR(4) = '0000'
DECLARE @LastTableRow INT 
DECLARE @ProductPrefix VARCHAR(2)  

PRINT 'START'
  WHILE @Sheet <= @Sheets
	BEGIN
	-- reset this on 1000th value
	IF @Row % 1000 = 0
	BEGIN		
		SET @Row = 0
	END	
	
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
		SELECT @LastRowVal = StartCheckDigit, @ProductPrefix = ProductPrefix FROM @CheckDigits WHERE Sheet = @Sheet
		SET @CalcNextRow = 1
	END

	IF @Sheet < = @Sheets
	BEGIN
	PRINT 'ADDING DATA FOR:- Prefix: ' + CAST(@ProductPrefix  AS VARCHAR(2)) + '. Cur Sheet: ' + CAST(@Sheet AS VARCHAR(5)) + '. LastRowVal: ' + CAST(@LastRowVal AS VARCHAR(5)) + '. Last Table Row: ' + CAST(@LastTableRow AS VARCHAR(5))
	
	DELETE FROM @Results WHERE 1 = 1
	INSERT INTO @Results SELECT * FROM dbo.fn__ReturnCheckDigitLine(@LastRowVal)	

	INSERT INTO @ProductCodes(Product0, Product1, Product2, Product3, Product4, Product5, Product6, Product7, Product8, Product9, Sheet)
	VALUES (@ProductPrefix + RIGHT(@LeftPart+CAST(@Row AS VARCHAR(3)),3) + '-' + (SELECT CheckDigit1 FROM @Results),
			@ProductPrefix + RIGHT(@LeftPart+CAST(@Row+1 AS VARCHAR(3)),3) + '-'+(SELECT CheckDigit2 FROM @Results),
			@ProductPrefix + RIGHT(@LeftPart+CAST(@Row+2 AS VARCHAR(3)),3) + '-'+(SELECT CheckDigit3 FROM @Results),
			@ProductPrefix + RIGHT(@LeftPart+CAST(@Row+3 AS VARCHAR(3)),3) + '-'+(SELECT CheckDigit4 FROM @Results),
			@ProductPrefix + RIGHT(@LeftPart+CAST(@Row+4 AS VARCHAR(3)),3) + '-'+(SELECT CheckDigit5 FROM @Results),
			@ProductPrefix + RIGHT(@LeftPart+CAST(@Row+5 AS VARCHAR(3)),3) + '-'+(SELECT CheckDigit6 FROM @Results),
			@ProductPrefix + RIGHT(@LeftPart+CAST(@Row+6 AS VARCHAR(3)),3) + '-'+(SELECT CheckDigit7 FROM @Results),
			@ProductPrefix + RIGHT(@LeftPart+CAST(@Row+7 AS VARCHAR(3)),3) + '-'+(SELECT CheckDigit8 FROM @Results),
			@ProductPrefix + RIGHT(@LeftPart+CAST(@Row+8 AS VARCHAR(3)),3) + '-'+(SELECT CheckDigit9 FROM @Results),
			@ProductPrefix + RIGHT(@LeftPart+CAST(@Row+9 AS VARCHAR(3)),3) + '-'+(SELECT CheckDigitX FROM @Results),
			@Sheet)		
	SET @Row = @Row + 10
	END
  END

SELECT * FROM @ProductCodes
drop FUNCTION fn__ReturnCheckDigitLine