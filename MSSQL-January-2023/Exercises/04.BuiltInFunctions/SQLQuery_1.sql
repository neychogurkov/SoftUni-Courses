USE [SoftUni]

--1
SELECT [FirstName], [LastName]
FROM [Employees]
WHERE [FirstName] LIKE 'Sa%'

--2
SELECT [FirstName], [LastName]
FROM [Employees]
WHERE [LastName] LIKE '%ei%'

--3
SELECT [FirstName]
FROM [Employees]
WHERE [DepartmentID] IN (3,10) AND YEAR([HireDate]) BETWEEN 1995 AND 2005

--4
SELECT [FirstName], [LastName]
FROM [Employees]
WHERE [JobTitle] NOT LIKE '%engineer%'

--5
SELECT [Name]
FROM [Towns]
WHERE LEN([Name]) IN (5,6)
ORDER BY [Name]

--6
SELECT *
FROM [Towns]
WHERE [Name] LIKE '[MKBE]%'
ORDER BY [Name]

--7
SELECT *
FROM [Towns]
WHERE [Name] LIKE '[^RBD]%'
ORDER BY [Name]

--8
GO

CREATE VIEW [V_EmployeesHiredAfter2000]
AS
    SELECT [FirstName], [LastName]
    FROM [Employees]
    WHERE YEAR([HireDate]) > 2000

GO

SELECT *
FROM [V_EmployeesHiredAfter2000]

--9
SELECT [FirstName], [LastName]
FROM [Employees]
WHERE LEN([LastName]) = 5

--10
SELECT [EmployeeID],
    [FirstName],
    [LastName],
    [Salary],
    DENSE_RANK() OVER (PARTITION BY [Salary] ORDER BY [EmployeeID]) 
       AS [Rank]
FROM [Employees]
WHERE [Salary] BETWEEN 10000 AND 50000
ORDER BY Salary DESC

--11
SELECT *
FROM (
     SELECT [EmployeeID],
            [FirstName],
            [LastName],
            [Salary],
            DENSE_RANK() OVER (PARTITION BY [Salary] ORDER BY [EmployeeID]) 
            AS [Rank]
    FROM [Employees]
    WHERE [Salary] BETWEEN 10000 AND 50000
    ) AS [RankingSubquery]
WHERE [Rank] = 2
ORDER BY [Salary] DESC

--12
USE [Geography]

SELECT [CountryName], [IsoCode]
FROM [Countries]
WHERE [CountryName]  LIKE '%A%A%A%'
ORDER BY IsoCode

--13
SELECT [PeakName], [RiverName], LOWER(CONCAT([PeakName], RIGHT([RiverName], LEN([RiverName]) - 1)))
FROM [Peaks], [Rivers]
WHERE RIGHT([PeakName], 1) = LEFT([RiverName], 1)
ORDER BY [PeakName], [RiverName]

--14
USE [Diablo]
SELECT TOP (50)
    [Name], FORMAT([Start], 'yyyy-MM-dd') AS [Start]
FROM [Games]
WHERE YEAR([Start]) IN (2011, 2012)
ORDER BY [Start], [Name]

--15
SELECT [Username], SUBSTRING([Email], CHARINDEX('@', [Email]) + 1, LEN([Email]) - CHARINDEX('@', [Email]))  AS [Email Provider]
FROM [Users]
ORDER BY [Email Provider], [Username]

--16
SELECT [Username], [IpAddress]
FROM [Users]
WHERE [IpAddress] LIKE '___.1%.%.___'
ORDER BY [Username]

--17
SELECT [Name],
    CASE 
WHEN DATEPART(HOUR, [Start]) >= 0 AND DATEPART(HOUR, [Start])  < 12 THEN 'Morning'
WHEN DATEPART(HOUR, [Start])  >= 12 AND DATEPART(HOUR, [Start])  < 18 THEN 'Afternoon'
WHEN DATEPART(HOUR, [Start])  >= 18 AND DATEPART(HOUR, [Start])  < 24 THEN 'Evening'
END AS [Part of the Day],
    CASE 
WHEN [Duration] <= 3 THEN 'Extra Short'
WHEN [Duration] >= 3 AND [Duration] <= 6 THEN 'Short'
WHEN [Duration] > 6 THEN 'Long'
ELSE 'Extra Long'
END AS [Duration]
FROM [Games]
ORDER BY [Name], [Duration]

--18
USE [Orders]
SELECT [ProductName], [OrderDate], DATEADD(DAY, 3, [OrderDate]) AS [Pay Due], DATEADD(MONTH, 1, [OrderDate]) AS [Deliver Due]
FROM [Orders]

--19
CREATE DATABASE [BuiltInFunctionsExercise]

GO

USE [BuiltInFunctionsExercise]

GO

CREATE TABLE [People]
(
    [Id] INT PRIMARY KEY IDENTITY,
    [Name] VARCHAR(50) NOT NULL,
    [Birthdate] DATETIME2 NOT NULL
)

INSERT INTO [People]
VALUES
    ('Victor', '2000-12-07'),
    ('Steven', '1992-09-10'),
    ('Stephen', '1910-09-19'),
    ('John', '2010-01-06')

SELECT [Name],
    DATEDIFF(MONTH, [Birthdate], GETDATE())/12 AS [Age in Years],
    DATEDIFF(MONTH, [Birthdate], GETDATE()) AS [Age in Months],
    DATEDIFF(DAY, [Birthdate], GETDATE()) AS [Age in Days],
    DATEDIFF(MINUTE, [Birthdate], GETDATE()) AS [Age in Minutes]
FROM [People]