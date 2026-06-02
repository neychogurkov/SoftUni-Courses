USE [Boardgames]

GO

SELECT [Name],
	   [Rating]
FROM [Boardgames]
ORDER BY [YearPublished],
		 [Name] DESC