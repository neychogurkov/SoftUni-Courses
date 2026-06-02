USE [ColonialJourney]

GO

SELECT [Id],
	   CONCAT_WS(' ', [FirstName], [LastName]) AS [FullName]
FROM [Colonists]
WHERE [Id] IN (
			       SELECT [ColonistId] 
				   FROM [TravelCards] 
				   WHERE [JobDuringJourney] = 'Pilot'
			  )
ORDER BY [Id]