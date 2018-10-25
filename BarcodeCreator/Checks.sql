SELECT [warehouse], [product], [page_number], [text10] FROM [scheme].[sttechm] WITH (NOLOCK) WHERE [page_number] = '026' AND [text10] = '25045501'
SELECT [warehouse], [product], [drawing_number] FROM [scheme].[stockm] WITH (NOLOCK) WHERE [drawing_number] = '25045501'
SELECT [bar_code], [prod_code] AS product, [warehouse_code] AS warehouse FROM [scheme].[dcbarcmapm] WITH (NOLOCK) WHERE [bar_code] = '25045501'


SELECT [warehouse], [product], [page_number], [text10] FROM [scheme].[sttechm] WITH (NOLOCK) WHERE [page_number] = '026' AND [product] = '25045501'
SELECT [warehouse], [product], [drawing_number] FROM [scheme].[stockm] WITH (NOLOCK) WHERE [product] = '25045501'
SELECT [bar_code], [prod_code] AS product, [warehouse_code] AS warehouse FROM [scheme].[dcbarcmapm] WITH (NOLOCK) WHERE [prod_code] = '25045501'

