USE [Boardgames]

GO

CREATE PROC usp_SearchByCategory(@category VARCHAR(50))
AS
BEGIN
	SELECT [b].[Name],
		   [b].[YearPublished],
		   [b].[Rating],
		   [c].[Name] AS [CategoryName],
		   [p].[Name] AS [PublisherName],
		   CONCAT([pr].[PlayersMin], ' people') AS [PlayersMin],
		   CONCAT([pr].[PlayersMax], ' people') AS [PlayersMax]
	FROM [Boardgames] AS [b]
	JOIN [Categories] AS [c]
	ON [b].[CategoryId] = [c].[Id]
	JOIN [PlayersRanges] AS [pr]
	ON [b].[PlayersRangeId] = [pr].[Id]
	JOIN [Publishers] AS [p]
	ON [b].[PublisherId] = [p].[Id]
	WHERE [c].[Name] = @category
	ORDER BY [PublisherName],
			 [b].[YearPublished] DESC
END

GO

EXEC usp_SearchByCategory 'Wargames'