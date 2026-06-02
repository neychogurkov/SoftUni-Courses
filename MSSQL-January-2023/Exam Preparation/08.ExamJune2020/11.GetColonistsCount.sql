USE [ColonialJourney]

GO

CREATE FUNCTION [udf_GetColonistsCount](@PlanetName VARCHAR(30)) 
RETURNS INT
AS
BEGIN
	RETURN (
				SELECT COUNT(*) AS [Count]
				FROM [Planets] AS [p]
				JOIN [Spaceports] AS [s]
				ON [p].Id = [s].[PlanetId]
				JOIN [Journeys] AS [j]
				ON [s].[Id] = [j].[DestinationSpaceportId]
				JOIN [TravelCards] AS [tc]
				ON [j].[Id] = [tc].[JourneyId]
				WHERE [p].[Name] = @PlanetName
		   )
END

GO

SELECT dbo.udf_GetColonistsCount('Otroyphus')