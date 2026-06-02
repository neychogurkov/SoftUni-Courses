USE [CigarShop]

GO

SELECT CONCAT([cl].[FirstName], ' ', [cl].[LastName]) AS [FullName],
	   [a].[Country],
	   [a].[ZIP],
	   CONCAT('$', MAX([ci].[PriceForSingleCigar])) AS [CigarPrice]
FROM [Clients] AS [cl]
JOIN [Addresses] AS [a]
ON [cl].[AddressId] = [a].[Id]
JOIN [ClientsCigars] AS [cc]
ON [cl].[Id] = [cc].[ClientId]
JOIN [Cigars] AS [ci]
ON [cc].[CigarId] = [ci].[Id]
GROUP BY [cl].[FirstName], [cl].[LastName], [a].[Country], [a].[ZIP]
HAVING [a].[ZIP] LIKE REPLICATE('[0-9]', LEN([a].[ZIP]))
ORDER BY [FullName]