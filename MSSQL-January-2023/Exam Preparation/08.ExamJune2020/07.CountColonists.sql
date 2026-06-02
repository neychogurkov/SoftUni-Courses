USE [ColonialJourney]

GO

SELECT COUNT(*) AS [Count]
FROM [Colonists] AS [c]
JOIN [TravelCards] AS [tc]
ON [c].[Id] = [tc].[ColonistId]
JOIN [Journeys] AS [j]
ON [tc].[JourneyId] = [j].[Id]
WHERE [j].[Purpose] = 'Technical'