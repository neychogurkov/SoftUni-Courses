USE [Boardgames]

GO

SELECT CONCAT_WS(' ', [FirstName], [LastName]) AS [FullName],
	   [c].[Email],
	   MAX([b].[Rating]) AS [Rating]
FROM [Creators] AS [c]
JOIN [CreatorsBoardgames] AS [cb]
ON [c].[Id] = [cb].[CreatorId]
JOIN [Boardgames] AS [b]
ON [cb].[BoardgameId] = [b].[Id]
GROUP BY [c].[Id], 
		 [c].[FirstName], 
		 [c].[LastName],
		 [c].[Email]
HAVING [c].[Email] LIKE '%.com'
ORDER BY [FullName]