USE [Diablo]

GO

--1
SELECT SUBSTRING([Email], CHARINDEX('@', [Email]) + 1, LEN([Email])) AS [Email Provider],
	   COUNT(*) AS [Number Of Users]
FROM [Users]
GROUP BY SUBSTRING([Email], CHARINDEX('@', [Email]) + 1, LEN([Email]))
ORDER BY [Number Of Users] DESC,
		 [Email Provider]

--2
SELECT [g].[Name] AS [Game],
	   [gt].[Name] AS [Game Type],
	   [u].[Username],
	   [ug].[Level],
	   [ug].[Cash],
	   [c].[Name] AS [Character]
FROM [Games] AS [g]
JOIN [GameTypes] AS [gt]
ON [g].[GameTypeId] = [gt].[Id]
JOIN [UsersGames] AS [ug]
ON [g].[Id] = [ug].[GameId]
JOIN [Users] AS [u]
ON [ug].[UserId] = [u].[Id]
JOIN [Characters] AS [c]
ON [ug].[CharacterId] = [c].[Id]
ORDER BY [ug].[Level] DESC,
		 [u].[Username],
		 [g].[Name]

--3
SELECT [u].[Username],
	   [g].[Name] AS [Game],
	   COUNT(*) AS [Items Count],
	   SUM([i].[Price]) AS [Items Price]
FROM [UsersGames] AS [ug]
JOIN [Users] AS [u]
ON [ug].[UserId] = [u].[Id]
JOIN [Games] AS [g]
ON [ug].[GameId] = [g].[Id]
JOIN [UserGameItems] AS [ugi]
ON [ug].[Id] = [ugi].[UserGameId]
JOIN [Items] AS [i]
ON [ugi].[ItemId] = [i].[Id]
GROUP BY [u].[Id], [u].[Username], [g].[Id], [g].[Name]
HAVING COUNT(*) >= 10
ORDER BY [Items Count] DESC,
	     [Items Price] DESC,
		 [u].[Username]

--4
SELECT [u].[Username],
	   [g].[Name] AS [Game],
	   MAX([c].[Name]) AS [Character],
       SUM([is].[Strength]) + MAX([cs].[Strength]) + MAX([gts].[Strength]) AS [Strength],
	   SUM([is].[Defence]) + MAX([cs].[Defence]) + MAX([gts].[Defence]) AS [Defence],
	   SUM([is].[Speed]) + MAX([cs].[Speed]) + MAX([gts].[Speed]) AS [Speed],
	   SUM([is].[Mind]) + MAX([cs].[Mind]) + MAX([gts].[Mind]) AS [Mind],
	   SUM([is].[Luck]) + MAX([cs].[Luck]) + MAX([gts].[Luck]) AS [Luck]
FROM [UsersGames] AS [ug]
JOIN [Users] AS [u]
ON [ug].[UserId] = [u].[Id]
JOIN [Games] AS [g]
ON [ug].[GameId] = [g].[Id]
JOIN [GameTypes] AS [gt]
ON [g].[GameTypeId] = [gt].[Id]
JOIN [Statistics] AS [gts]
ON [gt].[BonusStatsId] = [gts].[Id]
JOIN [Characters] AS [c]
ON [ug].[CharacterId] = [c].[Id]
JOIN [Statistics] as [cs]
ON [c].[StatisticId] = [cs].[Id]
JOIN [UserGameItems] AS [ugi]
ON [ug].[Id] = [ugi].[UserGameId]
JOIN [Items] AS [i]
ON [ugi].[ItemId] = [i].[Id]
JOIN [Statistics] AS [is]
ON [i].[StatisticId] = [is].[Id]
GROUP BY [u].[Username],
		 [g].[Name]
ORDER BY [Strength] DESC,
		 [Defence] DESC,
		 [Speed] DESC,
		 [Mind] DESC,
		 [Luck] DESC

--5
DECLARE @averageMind DECIMAL(10, 2) = (
									   	   SELECT 
										   AVG([Mind]) 
										   FROM [Statistics]
									  )
DECLARE @averageLuck DECIMAL(10, 2) = (
									   	   SELECT 
										   AVG([Luck]) 
										   FROM [Statistics]
									  )
DECLARE @averageSpeed DECIMAL(10, 2) = (
									   	   SELECT 
										   AVG([Speed]) 
										   FROM [Statistics]
									   )

SELECT [i].[Name],
	   [i].[Price],
	   [i].[MinLevel],
	   [s].[Strength],
	   [s].[Defence],
	   [s].[Speed],
	   [s].[Luck],
	   [s].[Mind]
FROM [Items] AS [i]
JOIN [Statistics] AS [s]
ON [i].StatisticId = [s].[Id]
WHERE [s].[Mind] > @averageMind
AND [s].[Luck] > @averageLuck
AND [s].[Speed] > @averageSpeed
ORDER BY [i].[Name]

--6
SELECT [i].[Name] AS [Item],
	   [i].[Price],
	   [i].[MinLevel],
	   [gt].[Name] AS [Forbidden Game Type]
FROM [Items] AS [i]
LEFT JOIN [GameTypeForbiddenItems] AS [gtfi]
ON [i].[Id] = [gtfi].[ItemId]
LEFT JOIN [GameTypes] AS [gt]
ON [gtfi].[GameTypeId] = [gt].[Id]
ORDER BY [gt].[Name] DESC,
	     [i].[Name]

--7
INSERT INTO [UserGameItems]
SELECT [Id],
	   (SELECT [Id] 
		FROM [UsersGames]
		WHERE [UserId] = (
						      SELECT [Id] 
							  FROM [Users] 
							  WHERE [Username] = 'Alex'
						 )
		AND [GameId] = (
							SELECT [Id] 
							FROM [Games]
							WHERE [Name] = 'Edinburgh')
					   )
FROM [Items]
WHERE [Name] IN ('Blackguard', 
				 'Bottomless Potion of Amplification', 
				 'Eye of Etlich (Diablo III)', 
				 'Gem of Efficacious Toxin', 
				 'Golden Gorget of Leoric',
				 'Hellfire Amulet')

UPDATE [UsersGames]
SET [Cash] -= (
			       SELECT SUM([Price]) 
				   FROM [Items]
				   WHERE [Name] IN ('Blackguard', 
									'Bottomless Potion of Amplification', 
									'Eye of Etlich (Diablo III)', 
									'Gem of Efficacious Toxin', 
									'Golden Gorget of Leoric',
									'Hellfire Amulet'))
WHERE [UserId] = (
				      SELECT [Id] 
					  FROM [Users] 
					  WHERE [Username] = 'Alex'
				 )

SELECT [u].[Username],
	   [g].[Name],
	   [ug].[Cash],
	   [i].[Name] AS [Item Name]
FROM [UsersGames] AS [ug]
JOIN [Users] AS [u]
ON [ug].[UserId] = [u].[Id]
JOIN [Games] AS [g]
ON [ug].[GameId] = [g].[Id]
JOIN [UserGameItems] AS [ugi]
ON [ug].[Id] = [ugi].[UserGameId]
JOIN [Items] AS [i]
ON [ugi].[ItemId] = [i].[Id]
WHERE [g].[Name] = 'Edinburgh'
ORDER BY [Item Name]

--8
USE [Geography]

GO

SELECT [p].[PeakName],
	   [m].[MountainRange] AS [Mountain],
	   [p].[Elevation]
FROM [Peaks] AS [p]
JOIN [Mountains] AS [m]
ON [p].[MountainId] = [m].[Id]
ORDER BY [p].[Elevation] DESC,
		 [p].[PeakName]

--9
SELECT [p].[PeakName],
	   [m].[MountainRange] AS [Mountain],
	   [c].[CountryName],
	   [co].[ContinentName]
FROM [Peaks] AS [p]
JOIN [Mountains] AS [m]
ON [p].[MountainId] = [m].[Id]
JOIN [MountainsCountries] AS [mc]
ON [m].[Id] = [mc].[MountainId]
JOIN [Countries] AS [c]
ON [mc].[CountryCode] = [c].[CountryCode]
JOIN [Continents] AS [co]
ON [c].[ContinentCode] = [co].[ContinentCode]
ORDER BY [p].[PeakName],
		 [c].[CountryName]

--10
SELECT [c].[CountryName],
	   [co].[ContinentName],
	   COUNT([r].[Id]) AS [RiversCount],
	   ISNULL(SUM([r].[Length]), 0) AS [TotalLength]
FROM [Countries] AS [c]
JOIN [Continents] AS [co]
ON [c].[ContinentCode] = [co].[ContinentCode]
LEFT JOIN [CountriesRivers] AS [cr]
ON [c].[CountryCode] = [cr].[CountryCode]
LEFT JOIN [Rivers] AS [r]
ON [cr].[RiverId] = [r].[Id]
GROUP BY [c].[CountryName], 
		 [co].[ContinentName]
ORDER BY [RiversCount] DESC,
		 [TotalLength] DESC,
		 [c].[CountryName]

--11
SELECT [cu].[CurrencyCode], 
	   [cu].[Description] AS [Currency],
	   COUNT([co].[CountryCode]) AS [NumberOfCountries]
FROM [Currencies] AS [cu]
LEFT JOIN [Countries] AS [co]
ON [cu].[CurrencyCode] = [co].[CurrencyCode]
GROUP BY [cu].[CurrencyCode], 
		 [cu].[Description]
ORDER BY [NumberOfCountries] DESC,
		 [Currency]

--12
SELECT [ci].[ContinentName],
	   SUM([cr].[AreaInSqKm]) AS [CountriesArea],
	   SUM(CAST([cr].[Population] AS BIGINT)) AS [CountriesPopulation]
FROM [Continents] AS [ci]
JOIN [Countries] AS [cr]
ON [ci].[ContinentCode] = [cr].[ContinentCode]
GROUP BY [ci].[ContinentCode],
		 [ci].[ContinentName]
ORDER BY [CountriesPopulation] DESC

--13
CREATE TABLE [Monasteries]
(
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50),
	[CountryCode] CHAR(2) NOT NULL FOREIGN KEY REFERENCES [Countries]([CountryCode])
)

INSERT INTO Monasteries(Name, CountryCode) VALUES
('Rila Monastery “St. Ivan of Rila”', 'BG'), 
('Bachkovo Monastery “Virgin Mary”', 'BG'),
('Troyan Monastery “Holy Mother''s Assumption”', 'BG'),
('Kopan Monastery', 'NP'),
('Thrangu Tashi Yangtse Monastery', 'NP'),
('Shechen Tennyi Dargyeling Monastery', 'NP'),
('Benchen Monastery', 'NP'),
('Southern Shaolin Monastery', 'CN'),
('Dabei Monastery', 'CN'),
('Wa Sau Toi', 'CN'),
('Lhunshigyia Monastery', 'CN'),
('Rakya Monastery', 'CN'),
('Monasteries of Meteora', 'GR'),
('The Holy Monastery of Stavronikita', 'GR'),
('Taung Kalat Monastery', 'MM'),
('Pa-Auk Forest Monastery', 'MM'),
('Taktsang Palphug Monastery', 'BT'),
('Sümela Monastery', 'TR')

ALTER TABLE [Countries]
ADD [IsDeleted] BIT

UPDATE [Countries]
SET [IsDeleted] = 0

UPDATE [Countries]
SET [IsDeleted] = 1
WHERE [CountryCode] IN (	
							SELECT [c].[CountryCode]
							FROM [Countries] AS [c]
							JOIN [CountriesRivers] AS [cr]
							ON [c].[CountryCode] = [cr].[CountryCode]
							GROUP BY [c].[CountryCode]
							HAVING COUNT([cr].[RiverId]) > 3
					   )

SELECT [m].[Name] AS [Monastery],
	   [c].[CountryName] AS [Country]
FROM [Monasteries] AS [m]
JOIN [Countries] AS [c]
ON [m].[CountryCode] = [c].[CountryCode]
WHERE [c].[IsDeleted] = 0
ORDER BY [m].[Name]

--14
UPDATE [Countries]
SET [CountryName] = 'Burma'
WHERE [CountryName] = 'Myanmar'

INSERT INTO [Monasteries]
VALUES
('Hanga Abbey', (SELECT [CountryCode] FROM [Countries] WHERE [CountryName] = 'Tanzania')),
('Myin-Tin-Daik', (SELECT [CountryCode] FROM [Countries] WHERE [CountryName] = 'Myanmar'))

SELECT [ci].[ContinentName], 
	   [cr].[CountryName],
	   COUNT([m].[Id]) AS [MonasteriesCount]
FROM [Monasteries] AS [m]
RIGHT JOIN [Countries] AS [cr]
ON [m].[CountryCode] = [cr].[CountryCode]
JOIN [Continents] AS [ci]
ON [cr].[ContinentCode] = [ci].[ContinentCode]
WHERE [cr].[IsDeleted] = 0
GROUP BY [cr].[CountryCode],
		 [ci].[ContinentName], 
		 [cr].[CountryName]
ORDER BY [MonasteriesCount] DESC,
		 [cr].[CountryName]