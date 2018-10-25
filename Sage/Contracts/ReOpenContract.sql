use syslive
DECLARE	@Contract VARCHAR(10) = 'C000598'
SELECT       complete, *
FROM         scheme.poschddcm
WHERE        (num = @Contract)

SELECT       complete, *
FROM         scheme.poschdcm
WHERE        (num = @Contract)

update	scheme.poschddcm
SET		complete = 'N'
WHERE   (num = @Contract)

UPDATE  scheme.poschdcm
SET		complete = 'N'
WHERE   (num = @Contract)
