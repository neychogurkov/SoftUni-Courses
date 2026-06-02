USE [WMS]

GO

CREATE FUNCTION [udf_GetCost](@jobId INT)
RETURNS DECIMAL(10, 2)
AS
BEGIN 
	RETURN ISNULL((SELECT SUM([p].[Price] * [op].[Quantity])
	FROM [Orders] AS [o]
	JOIN [OrderParts] AS [op]
	ON [o].[OrderId] = [op].[OrderId]
	JOIN [Parts] AS [p]
	ON [op].[PartId] = [p].[PartId]
	WHERE [o].[JobId] = @jobId
	GROUP BY [o].[JobId]), 0)
END

GO

SELECT dbo.udf_GetCost(1)
SELECT dbo.udf_GetCost(3)
