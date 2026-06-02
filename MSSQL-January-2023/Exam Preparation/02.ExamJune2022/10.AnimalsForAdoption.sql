USE [Zoo]

GO

SELECT [a].[Name],
	   YEAR([a].[BirthDate]) AS [BirthYear],
	   [at].[AnimalType]
FROM [Animals] AS [a]
JOIN [AnimalTypes] AS [at]
ON [a].[AnimalTypeId] = [at].[Id]
WHERE [at].[AnimalType] <> 'Birds'
AND [a].[OwnerId] IS NULL
AND DATEDIFF(YEAR, [a].[BirthDate], '01/01/2022') < 5
ORDER BY [a].[Name]