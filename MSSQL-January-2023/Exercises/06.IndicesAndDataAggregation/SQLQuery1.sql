USE [Gringotts]

--1
SELECT 
	COUNT(*) AS [Count]
FROM [WizzardDeposits]

--2
SELECT 
	MAX([MagicWandSize]) AS [LongestMagicWand] 
FROM [WizzardDeposits]

--3
SELECT 
	[DepositGroup], 
	MAX([MagicWandSize]) AS [LongestMagicWand] 
FROM [WizzardDeposits] 
GROUP BY [DepositGroup]

--4
SELECT TOP(2) 
	[DepositGroup] 
FROM [WizzardDeposits] 
GROUP BY [DepositGroup] 
ORDER BY AVG([MagicWandSize])

--5
SELECT 
	[DepositGroup], 
	SUM([DepositAmount]) AS [TotalSum] 
FROM [WizzardDeposits] 
GROUP BY [DepositGroup]

--6
SELECT 
	[DepositGroup], 
	SUM([DepositAmount]) AS [TotalSum] 
FROM [WizzardDeposits] 
WHERE [MagicWandCreator] = 'Ollivander family' 
GROUP BY [DepositGroup]

--7
SELECT 
	[DepositGroup], 
	SUM([DepositAmount]) AS [TotalSum] 
FROM [WizzardDeposits] 
WHERE [MagicWandCreator] = 'Ollivander family'
GROUP BY [DepositGroup]
HAVING SUM([DepositAmount]) < 150000
ORDER BY SUM([DepositAmount]) DESC

--8
SELECT 
	[DepositGroup], 
	[MagicWandCreator], 
	MIN([DepositCharge]) AS [MinDepositCharge]
FROM [WizzardDeposits] 
GROUP BY [DepositGroup], [MagicWandCreator] 
ORDER BY [MagicWandCreator], [DepositGroup]

--9
SELECT 
	[AgeGroup],
	COUNT(*) AS [WizardCount]
FROM (
		SELECT
			CASE
			WHEN [Age] BETWEEN 0 AND 10 THEN '[0-10]'
			WHEN [Age] BETWEEN 11 AND 20 THEN '[11-20]'
			WHEN [Age] BETWEEN 21 AND 30 THEN '[21-30]'
			WHEN [Age] BETWEEN 31 AND 40 THEN '[31-40]'
			WHEN [Age] BETWEEN 41 AND 50 THEN '[41-50]'
			WHEN [Age] BETWEEN 51 AND 60 THEN '[51-60]'
			ELSE '[61+]'
			END AS [AgeGroup]
		FROM [WizzardDeposits]
	 ) AS [AgeGroupSubquery]
GROUP BY [AgeGroup]

SELECT '0-10' AS [a], SUM([Count])
FROM
(
SELECT [Age], COUNT(*) AS [Count] FROM [WizzardDeposits]
GROUP BY [Age]
) AS [a]
WHERE [Age] BETWEEN 11 AND 20

--10
SELECT 
	DISTINCT LEFT([FirstName], 1) AS [FirstLetter] 
FROM [WizzardDeposits] 
WHERE [DepositGroup] = 'Troll Chest'
ORDER BY [FirstLetter]

--11
SELECT 
	[DepositGroup], 
	[IsDepositExpired], 
	AVG([DepositInterest]) 
FROM [WizzardDeposits] 
WHERE [DepositStartDate] > '1985-01-01' 
GROUP BY [DepositGroup], [IsDepositExpired] 
ORDER BY [DepositGroup] DESC, [IsDepositExpired]

--12
SELECT 
	SUM([wd1].[DepositAmount] - [wd2].[DepositAmount]) AS [SumDifference]
FROM [WizzardDeposits] AS [wd1]
JOIN [WizzardDeposits] AS [wd2] ON [wd1].[Id] + 1 = [wd2].[Id]

--13
USE [SoftUni]

SELECT 
	[DepartmentID], 
	SUM([Salary]) 
FROM [Employees] 
GROUP BY [DepartmentID] 
ORDER BY [DepartmentID]

--14
SELECT 
	[DepartmentID], 
	MIN(Salary) 
FROM [Employees] 
WHERE [DepartmentID] IN (2, 5, 7) AND [HireDate] > '2000-01-01' 
GROUP BY [DepartmentID]

--15
SELECT *
INTO [NewEmployees]
FROM [Employees]
WHERE [Salary] > 30000

DELETE FROM [NewEmployees] WHERE [ManagerID] = 42

UPDATE [NewEmployees] SET [Salary] += 5000 WHERE [DepartmentID] = 1

SELECT 
	[DepartmentID], 
	AVG([Salary]) AS [AverageSalary]
FROM [NewEmployees]
GROUP BY [DepartmentID]
--16
SELECT 
	[DepartmentID], 
	[MaxSalary] 
FROM (
		SELECT 
			[DepartmentID], 
			MAX([Salary]) AS [MaxSalary] 
		FROM [Employees]  
		GROUP BY [DepartmentID]) AS [MaxSalaries] 
WHERE [MaxSalary] NOT BETWEEN 30000 AND 70000

--17
SELECT COUNT([Salary]) FROM [Employees] WHERE [ManagerID] IS NULL

--18
SELECT DISTINCT 
	[DepartmentID],
	[Salary] AS [ThirdHighestSalary] 
FROM (
		SELECT 
			[DepartmentID], 
			[Salary], 
			DENSE_RANK() OVER (PARTITION BY [DepartmentID] ORDER BY [Salary] DESC) AS [SalaryRank] 
		FROM [Employees]
     ) AS [ThirdHighestSalaries]
WHERE [SalaryRank] = 3

--19
SELECT TOP(10) 
	[e].[FirstName], 
	[e].[LastName], 
	[e].[DepartmentID] 
FROM [Employees] AS [e]
WHERE [e].[Salary] > (SELECT AVG(Salary) FROM [Employees] WHERE [DepartmentID] = [e].[DepartmentID])
ORDER BY [e].[DepartmentID]