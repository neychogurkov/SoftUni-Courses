USE [Airport]

GO

SELECT [p].[FullName], 
	   COUNT(*) AS [CountOfAircraft],
	   SUM([fd].[TicketPrice]) AS [TotalPayed]
FROM [Passengers] AS [p]
JOIN [FlightDestinations] AS [fd]
ON [p].[Id] = [fd].[PassengerId]
GROUP BY [p].[FullName]
HAVING [p].[FullName] LIKE '_a%'
AND COUNT(*) > 1
ORDER BY [FullName]