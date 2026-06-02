USE [NationalTouristSitesOfBulgaria]

GO

SELECT [c].[Name] AS [Site],
	   [l].[Name] AS [Location], 
	   [l].[Municipality],
	   [l].[Province],
	   [c].[Establishment]
FROM [Sites] AS [c]
JOIN [Locations] AS [l] 
ON [c].[LocationId] = [l].[Id]
WHERE [l].[Name] LIKE '[^BMD]%' AND [c].[Establishment] LIKE '%BC'
ORDER BY [Site]