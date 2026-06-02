USE [ColonialJourney]

GO

SELECT [JobDuringJourney],
	   [FullName],
	   [JobRank]
FROM (
	      SELECT [tc].[JobDuringJourney],
	      CONCAT_WS(' ', [FirstName], [LastName]) AS [FullName],
	      DENSE_RANK() OVER (PARTITION BY [JobDuringJourney] ORDER BY [BirthDate]) AS [JobRank]
		  FROM [Colonists] AS [c]
		  JOIN [TravelCards] AS [tc]
		  ON [c].[Id] = [tc].[ColonistId]
	 ) AS [RankingSubquery]
WHERE [JobRank] = 2