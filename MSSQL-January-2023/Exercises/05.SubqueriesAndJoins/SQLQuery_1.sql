USE [SoftUni]
--1
SELECT TOP(5)
    [e].[EmployeeID], 
	[e].[JobTitle],	
	[a].[AddressID], 
	[a].[AddressText]
FROM [Employees] AS [e] 
JOIN [Addresses] AS [a] ON [e].[AddressID] = [a].[AddressID]
ORDER BY [a].[AddressId]

--2
SELECT TOP(50)
    [e].[FirstName], 
	[e].[LastName], 
	[t].[Name] AS [Town], 
	[AddressText]
FROM [Employees] AS [e] 
JOIN [Addresses] AS [a] ON [e].[AddressID] = [a].[AddressID] 
JOIN [Towns] AS [t] ON [a].[TownID] = [t].[TownID]
ORDER BY [e].[FirstName], [e].[LastName]

--3
SELECT 
	[e].[EmployeeID], 
	[e].[FirstName], 
	[e].[LastName], 
	[d].[Name] AS [DepartmentName]
FROM [Employees] AS [e] 
JOIN [Departments] AS [d] ON [e].[DepartmentID] = [d].[DepartmentID]
WHERE [d].[Name] = 'Sales'
ORDER BY [e].[EmployeeID]

--4
SELECT TOP(5)
	[e].[EmployeeID],
	[e].[FirstName],
	[e].[Salary],
	[d].[Name] AS [DepartmentName]
FROM [Employees] AS [e]
JOIN [Departments] AS [d] ON [e].[DepartmentID] = [d].[DepartmentID]
WHERE [e].[Salary] > 15000
ORDER BY [d].[DepartmentID]

--5
SELECT TOP(3) 
	[e].[EmployeeID],
	[e].[FirstName]
FROM [Employees] AS [e]
LEFT JOIN [EmployeesProjects] AS [ep] ON [e].[EmployeeID] = [ep].[EmployeeID]
WHERE [ep].[ProjectID] IS NULL

--6
SELECT
	[e].[FirstName],
	[e].[LastName],
	[e].[HireDate],
	[d].[Name] AS [DeptName]
FROM [Employees] AS [e]
JOIN [Departments] AS [d] ON [e].[DepartmentID] = [d].[DepartmentID]
WHERE [e].[HireDate] > '1999-01-01' AND [d].[Name] IN ('Sales', 'Finance')
ORDER BY [e].[HireDate]

--7
SELECT TOP(5)
	[e].[EmployeeID],
	[e].[FirstName],
	[p].[Name] AS [ProjectName]
FROM [Employees] AS [e]
JOIN [EmployeesProjects] AS [ep] ON [e].[EmployeeID] = [ep].[EmployeeID]
JOIN [Projects] AS [p] ON [ep].[ProjectID] = [p].[ProjectID]
WHERE [p].[StartDate] > '2002-08-13' AND [p].[EndDate] IS NULL
ORDER BY [e].[EmployeeID]

--8
SELECT 
	[e].[EmployeeID],
	[e].[FirstName],
	CASE
	WHEN YEAR([p].[StartDate]) >= 2005 THEN NULL
	ELSE [p].[Name]
    END AS [ProjectName]
FROM [Employees] AS [e]
JOIN [EmployeesProjects] AS [ep] ON [e].[EmployeeID] = [ep].[EmployeeID]
JOIN [Projects] AS [p] ON [ep].[ProjectID] = [p].[ProjectID]
WHERE [e].[EmployeeID] = 24

--9
SELECT 
	[e].[EmployeeID],
	[e].[FirstName],
	[e].[ManagerID],
	[m].[FirstName] AS [ManagerName]
FROM [Employees] AS [e] 
JOIN [Employees] AS [m] ON [e].ManagerID = [m].[EmployeeID]
WHERE [m].[EmployeeID] IN (3, 7)
ORDER BY [e].[EmployeeID]

--10
SELECT TOP(50)
	[e].[EmployeeID],
	CONCAT([e].[FirstName], ' ', [e].[LastName]) AS [EmployeeName],
	CONCAT([m].[FirstName], ' ', [m].[LastName]) AS [ManagerName],
	[d].[Name] AS [DepartmentName]
FROM [Employees] AS [e]
JOIN [Employees] AS [m] ON [e].[ManagerID] = [m].[EmployeeID]
JOIN [Departments] AS [d] ON [e].[DepartmentID] = [d].[DepartmentID]
ORDER BY [e].[EmployeeID]

--11
SELECT 
	MIN([AverageSalary]) AS [MinAverageSalary]
FROM 
(
	SELECT AVG(Salary) AS [AverageSalary]
	FROM [Employees]
	GROUP BY [DepartmentID]
) AS [MinAverageSalary]
--12
USE [Geography]

SELECT 
	[c].[CountryCode],
	[m].[MountainRange],
	[p].[PeakName],
	[p].[Elevation]
FROM [Countries] AS [c]
JOIN [MountainsCountries] AS [mc] ON [c].[CountryCode] = [mc].[CountryCode]
JOIN Mountains AS [m] ON [mc].[MountainId] = [m].[Id]
JOIN Peaks AS [p] ON [m].[Id] = [p].[MountainId]
WHERE [c].[CountryName] = 'Bulgaria' AND [p].[Elevation] > 2835
ORDER BY [p].[Elevation] DESC

--13
SELECT 
	[CountryCode],
	COUNT(MountainId)
FROM [MountainsCountries]
WHERE [CountryCode] IN (
							SELECT 
								[CountryCode] 
							FROM [Countries] 
							WHERE [CountryName] IN ('United States', 'Russia', 'Bulgaria'))
GROUP BY [CountryCode] 

--14
SELECT TOP(5)
	[c].[CountryName],
	[r].[RiverName]
FROM [Countries] AS [c]
JOIN [Continents] AS [co] ON [c].[ContinentCode] = [co].[ContinentCode]
LEFT JOIN [CountriesRivers] AS [cr] ON [c].[CountryCode] = [cr].[CountryCode]
LEFT JOIN [Rivers] AS [r] ON [cr].[RiverId] = [r].[Id]
WHERE [co].[ContinentName] = 'Africa'
ORDER BY [c].[CountryName]

--15
SELECT 
	[ContinentCode], 
	[CurrencyCode], 
	[CurrencyUsage] 
FROM (
			SELECT *, DENSE_RANK() OVER (PARTITION BY [ContinentCode] ORDER BY [CurrencyUsage] DESC) AS [CurrencyRank] 
			FROM (
			SELECT [ContinentCode], [CurrencyCode], COUNT(*) AS [CurrencyUsage]
			FROM [Countries]
			GROUP BY [ContinentCode], [CurrencyCode]
			HAVING COUNT(*) > 1
				 ) AS [CurrencyUsageSubquery]
	 ) AS [CurrencyRankingSubquery]
WHERE [CurrencyRank] = 1

--16
SELECT 
	COUNT(*) AS [Count]
FROM [Countries] AS [c]
LEFT JOIN [MountainsCountries] AS [mc] ON [c].[CountryCode] = [mc].[CountryCode]
LEFT JOIN [Mountains] AS [m] ON [mc].[MountainId] = [m].[Id]
WHERE [m].[Id] IS NULL

--17
SELECT TOP(5)
	[c].[CountryName],
	MAX([p].[Elevation]) AS [HighestPeakElevation],
	MAX([r].[Length]) AS LongestRiverLength
FROM [Countries] AS [c]
LEFT JOIN [MountainsCountries] AS [mc] ON [c].[CountryCode] = [mc].[CountryCode]
LEFT JOIN [Mountains] AS [m] ON [mc].[MountainId] = [m].[Id]
LEFT JOIN [Peaks] AS [p] ON [m].[Id] = [p].[MountainId]
LEFT JOIN [CountriesRivers] AS [cr] ON [c].[CountryCode] = [cr].[CountryCode]
LEFT JOIN [Rivers] AS [r] ON [cr].[RiverId] = [r].[Id]
GROUP BY [c].[CountryName]
ORDER BY [HighestPeakElevation] DESC, [LongestRiverLength] DESC, [c].[CountryName]

--18
SELECT TOP(5)
		[Country],
		ISNULL([PeakName], '(no highest peak)') AS [Highest Peak Name],
		ISNULL([Elevation], 0) AS [Highest Peak Elevation],
		ISNULL([MountainRange], '(no mountain)') AS [Mountain]
FROM (
		SELECT 
			[c].[CountryName] AS [Country],
			[p].[PeakName],
			[p].[Elevation],
			[m].[MountainRange],
			DENSE_RANK() OVER (PARTITION BY [c].[CountryName] ORDER BY [p].[Elevation] DESC) AS [PeakRank]
		FROM [Countries] AS [c]
		LEFT JOIN [MountainsCountries] AS [mc] ON [c].[CountryCode] = [mc].[CountryCode]
		LEFT JOIN [Mountains] AS [m] ON [mc].[MountainId] = [m].[Id]
		LEFT JOIN [Peaks] AS [p] ON [m].[Id] = [p].[MountainId]
	) AS [PeakRankingSubquery]
WHERE [PeakRank] = 1
ORDER BY [Country], [Highest Peak Name]