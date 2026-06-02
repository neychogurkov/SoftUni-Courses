USE [NationalTouristSitesOfBulgaria]

GO

CREATE FUNCTION udf_GetTouristsCountOnATouristSite (@Site VARCHAR(100))
RETURNS INT
AS
BEGIN
	RETURN (
				SELECT COUNT(*) 
				FROM [Sites] AS [s] 
				JOIN [SitesTourists] AS [st] 
				ON [s].[Id] = [st].[SiteId] 
				WHERE [s].[Name] = @Site
		   )
END