USE [Service]

GO

SELECT [Description],
	   [c].[Name] AS [CategoryName]
FROM [Reports] AS [r]
JOIN [Categories] AS [c]
ON [r].[CategoryId] = [c].[Id]
ORDER BY [Description],
		 [CategoryName]