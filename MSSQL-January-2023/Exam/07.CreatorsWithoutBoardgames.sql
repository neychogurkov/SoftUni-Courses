USE [Boardgames]

GO

SELECT [Id],
	   CONCAT_WS(' ', [FirstName], [LastName]) AS [CreatorName],
	   [Email]
FROM [Creators]
WHERE [Id] NOT IN (
				       SELECT [CreatorId] 
					   FROM [CreatorsBoardgames]
				  )
ORDER BY [CreatorName]