USE [Airport]

GO

CREATE PROC [usp_SearchByAirportName] @airportName VARCHAR(70)
AS
	SELECT [ap].[AirportName],
		   [p].[FullName],
		   CASE
		   WHEN [fd].[TicketPrice] <= 400 THEN 'Low'
		   WHEN [fd].TicketPrice BETWEEN 401 AND 1500 THEN 'Medium'
		   ELSE 'High'
		   END AS [LevelOfTickerPrice],
		   [ac].[Manufacturer],
		   [ac].[Condition],
		   [at].[TypeName]
	FROM [Airports] AS [ap]
	JOIN [FlightDestinations] AS [fd]
	ON [ap].[Id] = [fd].[AirportId]
	JOIN [Passengers] AS [p]
	ON [fd].[PassengerId] = [p].[Id]
	JOIN [Aircraft] AS [ac]
	ON [fd].[AircraftId] = [ac].[Id]
	JOIN [AircraftTypes] AS [at]
	ON [ac].TypeId = [at].[Id]
	WHERE [AirportName] = @airportName
	ORDER BY [ac].[Manufacturer],
			 [p].[FullName]

GO

EXEC usp_SearchByAirportName 'Sir Seretse Khama International Airport'