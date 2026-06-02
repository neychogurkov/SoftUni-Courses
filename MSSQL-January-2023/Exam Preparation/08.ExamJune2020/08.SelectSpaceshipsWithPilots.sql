USE [ColonialJourney]

GO

SELECT [s].[Name],
	   [s].[Manufacturer]
FROM [Spaceships] AS [s]
JOIN [Journeys] AS [j]
ON [s].[Id] = [j].[SpaceshipId]
JOIN [TravelCards] AS [tc]
ON [j].[Id] = [tc].[JourneyId]
JOIN [Colonists] AS [c]
ON [tc].[ColonistId] = [c].[Id]
WHERE [tc].[JobDuringJourney] = 'Pilot'
AND DATEDIFF(YEAR, [c].[BirthDate], '2019-01-01') < 30
ORDER BY [s].[Name]