SELECT	*
FROM		BatchInformation

DELETE 
FROM		BatchProcessOrders WHERE		LastUsedDateTime < '2018-01-01'

DELETE 
FROM		BatchInformationComments WHERE		Id NOT IN (SELECT	BatchId
			FROM		BatchProcessOrders)

DELETE 
FROM		BatchInformation WHERE		Id NOT IN (SELECT	BatchId
			FROM		BatchProcessOrders)

DECLARE @HeaderResults TABLE(Id INT IDENTITY(1,1), BatchNumber VARCHAR(6), LastUsedDate DATETIME)
INSERT		INTO @HeaderResults
SELECT		 s.BatchNumber, MAX(s.LastUsedDate)
FROM		Insight.[dbo].[SageBatchData] s
LEFT JOIN 	SAPMasterMaterialLookup m
ON			s.product = m.[Mat# Identificationnumber] collate Latin1_General_CI_AS
GROUP BY	s.BatchNumber
ORDER BY	BatchNumber

DECLARE @Results TABLE(Id INT IDENTITY(1,1), MaterialCode varchar(10), Description VARCHAR(50), BatchNumber VARCHAR(6), LastUsedDate DATETIME, MaterialType VARCHAR(10))
INSERT		INTO @Results
SELECT		ISNULL(m.Material, s.product) AS MaterialCode,
			ISNULL(m.[Material Description], 
			LTRIM(RTRIM(s.long_description))) AS [Description], 
			s.BatchNumber, s.LastUsedDate ,
			m.MTyp
FROM		Insight.[dbo].[SageBatchData] s
LEFT JOIN 	SAPMasterMaterialLookup m
ON			s.product = m.[Mat# Identificationnumber] collate Latin1_General_CI_AS
ORDER BY	BatchNumber

--BEGIN  TRAN

DECLARE @Row INT = 1, @Rows INT 
DECLARE @MaterialCode VARCHAR(20) 
DECLARE @Description VARCHAR(50)
DECLARE @BatchNumber VARCHAR(20)
DECLARE @MaterialType VARCHAR(10)
DECLARE @LastUsedDate DATETIME
DECLARE @BatchId INT 
DECLARE @AssortmentNumber INT

SET @Rows = (SELECT COUNT(1) FROM @HeaderResults)

	WHILE @Row <= @Rows
	BEGIN

		SELECT	@BatchNumber = BatchNumber,					
				@LastUsedDate = LastUsedDate					
		FROM	@HeaderResults
		WHERE	id = @Row
				
		SELECT	@AssortmentNumber = dbo.[fn_GetNextAssortNumber]()
	
		INSERT INTO BatchInformation (BatchNumber, CreatedDateTime, ConfirmedDateTime, ConfirmedBy, ValidatedDateTime, ValidatedBy, PaperworkRaisedDateTime, PaperWorkRaisedBy, PaperworkSentDateTime, PaperworkSentBy,AssortmentNumber)		
		VALUES (@BatchNumber, @LastUsedDate, @LastUsedDate, 'SAGE',@LastUsedDate,'SAGE',@LastUsedDate,'SAGE', @LastUsedDate,'SAGE',@AssortmentNumber)
		SELECT	@BatchId = @@IDENTITY

		---VALUES (@BatchId, @MaterialCode, @Description, @MaterialType, NULL, 1, @LastUsedDate, @LastUsedDate, CASE @MaterialType WHEN 'ZFER' THEN '1' ELSE '2' END, 'SAGE', @BatchNumber)
		INSERT INTO BatchProcessOrders(BatchId, MaterialCode, MaterialDescription, MaterialType, ProcessOrderNumber, ScenarioId, LastUsedDateTime, ValidatedDateTime, PositionNumber, [User], BatchNo, AssortmentNumber)
		SELECT		@BatchId, MaterialCode, Description, MaterialType, null, 1, @LastUsedDate, @LastUsedDate, CASE MaterialType WHEN 'ZFER' THEN '1' ELSE '2' END, 'SAGE', BatchNumber,@AssortmentNumber
		FROM		@Results
		WHERE		BatchNumber = @BatchNumber

	SET @Row = @Row + 1
	END



--ROLLBACK

RETURN 

SELECT		 *
FROM		BatchInformation
WHERE		ValidatedBy = 'SAGE'

SELECT		 *
FROM		BatchProcessOrders
WHERE		[User] = 'SAGE'





DELETE
FROM		BatchProcessOrders
WHERE		[User] = 'SAGE'
DELETE
FROM		BatchInformation
WHERE		ValidatedBy = 'SAGE'