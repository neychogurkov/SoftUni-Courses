USE [Service]

GO

SELECT [u].[Username],
	   [c].[Name] AS [CategoryName]
FROM [Users] AS [u]
JOIN [Reports] AS [r]
ON [u].[Id] = [r].[UserId]
JOIN [Categories] AS [c]
ON [r].[CategoryId] = [c].[Id]
WHERE FORMAT([u].[BirthDate], 'dd-MM') = FORMAT([r].[OpenDate], 'dd-MM')
ORDER BY [u].[Username],
		 [CategoryName]