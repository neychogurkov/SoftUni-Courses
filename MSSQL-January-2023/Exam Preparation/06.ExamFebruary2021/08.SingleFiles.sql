USE [Bitbucket]

GO

SELECT [Id], 
	   [Name], 
	   CONCAT([Size], 'KB') AS [Size]
FROM [Files]
WHERE [Id] NOT IN (
				       SELECT [p].[Id]
				       FROM [Files] AS [f]
				       JOIN [Files] AS [p] ON [f].[ParentId] = [p].[Id]
				  )
ORDER BY [Id],
		 [Name],
		 [Size] DESC