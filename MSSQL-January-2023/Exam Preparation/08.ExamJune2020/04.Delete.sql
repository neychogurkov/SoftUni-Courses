USE [ColonialJourney]

GO

DELETE 
FROM [TravelCards]
WHERE [JourneyId] <= 3

DELETE 
FROM [Journeys]
WHERE [Id] <= 3