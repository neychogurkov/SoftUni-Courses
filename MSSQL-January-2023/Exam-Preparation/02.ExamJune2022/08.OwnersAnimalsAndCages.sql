USE [Zoo]

GO

SELECT CONCAT([o].[Name], '-', [a].[Name]) AS [OwnersAnimals],
	   [o].[PhoneNumber],
	   [ac].[CageId]
FROM [Owners] AS [o]
JOIN [Animals] AS [a]
ON [o].[Id] = [a].[OwnerId]
JOIN [AnimalsCages] AS [ac]
ON [a].[Id] = [ac].[AnimalId]
JOIN [AnimalTypes] AS [at]
ON [a].[AnimalTypeId] = [at].[Id]
WHERE [at].[AnimalType] = 'Mammals'
ORDER BY [o].[Name],
		 [a].[Name] DESC