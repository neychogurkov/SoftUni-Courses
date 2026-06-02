USE [NationalTouristSitesOfBulgaria]

GO

SELECT [l].[Province], 
	   [l].[Municipality], 
	   [l].[Name] AS [Location], 
	   COUNT(*) AS [CountOfSites]
FROM [Sites] AS [c]
JOIN [Locations] AS [l] 
ON [c].[LocationId] = [l].[Id]
WHERE [l].[Province] = 'Sofia'
GROUP BY [l].[Province], 
		 [l].[Municipality], 
		 [l].[Name]
ORDER BY [CountOfSites] DESC, 
		 [Location]