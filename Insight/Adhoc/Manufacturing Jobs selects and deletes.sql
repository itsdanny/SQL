-- Delete a ManuFacturing Job/Campaign
DECLARE @Jobs TABLE (WON VARCHAR(30))
DECLARE @JobIds TABLE (id VARCHAR(30))
DECLARE @JobLogIds TABLE (id VARCHAR(30))

DECLARE @ManuJobId INT
--'GN28A','GK80A','GK86A'
INSERT @Jobs SELECT 'GY92A'


INSERT INTO @JobIds
SELECT id FROM ManufacturingJob WHERE WorkOrderNumber IN (SELECT * FROM @Jobs)

INSERT INTO @JobLogIds
SELECT id FROM dbo.ManufacturingJobLog WHERE ManufacturingJobId in (SELECT * FROM @JobIds)

SELECT * FROM dbo.ManufactureCampaignJob WHERE ManufactureJobLogId IN (SELECT * FROM @JobLogIds)

SELECT		mjl.* , ms.Name
FROM		ManufacturingJobLog mjl 
INNER JOIN	ManufacturingStage ms
ON			mjl.ManufacturingStageId = ms.Id
WHERE	ManufacturingJobId in (SELECT * FROM @JobIds)
order by mjl.StartDateTime desc

SELECT * FROM ManufacturingJob WHERE WorkOrderNumber IN (SELECT * FROM @Jobs)
/*

DELETE FROM dbo.ManufactureCampaignJob WHERE ManufactureJobLogId IN (SELECT * FROM @JobLogIds)
DELETE FROM dbo.ManufacturingJobLog WHERE	ManufacturingJobId in (SELECT * FROM @JobIds)
DELETE FROM ManufacturingJob WHERE WorkOrderNumber IN (SELECT * FROM @Jobs)

*/