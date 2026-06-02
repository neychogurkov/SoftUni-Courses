USE [SoftUni]

--1
CREATE PROC [usp_GetEmployeesSalaryAbove35000]
AS
	SELECT 
		[FirstName], 
		[LastName]
	FROM [Employees]
	WHERE [Salary] > 35000

GO

EXEC [usp_GetEmployeesSalaryAbove35000]

--2
CREATE PROC [usp_GetEmployeesSalaryAboveNumber] @number DECIMAL(18, 4)
AS
	SELECT 
		[FirstName], 
		[LastName]
	FROM [Employees]
	WHERE [Salary] >= @number

GO

EXEC [usp_GetEmployeesSalaryAboveNumber] 48100  

--3
CREATE PROC [usp_GetTownsStartingWith] @string VARCHAR(50)
AS
	SELECT [Name] 
	FROM [Towns]
	WHERE [Name] LIKE CONCAT(@string, '%')

GO

EXEC [usp_GetTownsStartingWith] 'b'

--4
CREATE PROC [usp_GetEmployeesFromTown] @townName VARCHAR(50)
AS
	SELECT 
		[e].[FirstName], 
		[e].[LastName]
	FROM [Employees] AS [e]
	JOIN [Addresses] AS [a] ON [e].[AddressID] = [a].[AddressID]
	JOIN [Towns] AS [t] ON [a].[TownID] = [t].[TownID]
	WHERE [t].[Name] = @townName

GO

EXEC [usp_GetEmployeesFromTown] 'Sofia'

--5
CREATE FUNCTION [ufn_GetSalaryLevel] (@salary DECIMAL(18,4))
RETURNS VARCHAR(10)
AS
BEGIN
	DECLARE @salaryLevel VARCHAR(10) = 'Average'
	IF @salary < 30000
		SET @salaryLevel = 'Low'
	ELSE IF @salary > 50000
		SET @salaryLevel = 'High'
	RETURN @salaryLevel
END

GO

SELECT [Salary], [dbo].[ufn_GetSalaryLevel]([Salary]) AS [Salary Level]
FROM [Employees]

--6
CREATE PROC [usp_EmployeesBySalaryLevel] @salaryLevel VARCHAR(10)
AS
	SELECT 
		[FirstName],
		[LastName]
	FROM [Employees]
	WHERE [dbo].[ufn_GetSalaryLevel]([Salary]) = @salaryLevel 

GO

EXEC [usp_EmployeesBySalaryLevel] 'High'

--7
CREATE FUNCTION [ufn_IsWordComprised](@setOfLetters VARCHAR(100), @word VARCHAR(100))
RETURNS BIT
AS
BEGIN
	DECLARE @result BIT
	IF @word LIKE REPLICATE(CONCAT('[', @setOfLetters, ']'), LEN(@word))
		SET @result = 1
	ELSE
		SET @result = 0
	RETURN @result
END

GO

SELECT 'oistmiahf', 'Sofia', [dbo].[ufn_IsWordComprised]('oistmiahf', 'Sofia')

--8
CREATE PROC [usp_DeleteEmployeesFromDepartment] @departmentId INT
AS
	ALTER TABLE [Departments] ALTER COLUMN [ManagerID] INT NULL
	ALTER TABLE [Employees] ALTER COLUMN [ManagerID] INT NULL

	DELETE 
	FROM [EmployeesProjects]
	WHERE [EmployeeID] IN (
							  SELECT [EmployeeID] 
							  FROM [Employees] 
							  WHERE [DepartmentID] = @departmentId)
	
	UPDATE [Employees] 
	SET [ManagerID] = NULL 
	WHERE [ManagerID] IN (
							  SELECT [EmployeeID] 
							  FROM [Employees] 
							  WHERE [DepartmentID] = @departmentId
						 )

	UPDATE [Departments] 
	SET [ManagerID] = NULL 
	WHERE [ManagerID] IN (
							  SELECT [EmployeeID] 
							  FROM [Employees] 
							  WHERE [DepartmentID] = @departmentId
						 )

	DELETE 
	FROM [Employees] 
	WHERE [DepartmentID] = @departmentId

	DELETE 
	FROM [Departments] 
	WHERE [DepartmentID] = @departmentId

	SELECT COUNT(*) 
	FROM [Departments] 
	WHERE [DepartmentID] = @departmentId

GO

EXEC [usp_DeleteEmployeesFromDepartment] 1

--9
GO

USE [Bank]

GO

CREATE PROC [usp_GetHoldersFullName]
AS
	SELECT 
		CONCAT([FirstName], ' ', [LastName]) AS [Full Name]
	FROM [AccountHolders]

GO

EXEC [usp_GetHoldersFullName]

--10
GO
CREATE PROC [usp_GetHoldersWithBalanceHigherThan] @balance MONEY
AS	
SELECT 
	[FirstName], 
	[LastName] 
FROM [AccountHolders] 
WHERE [Id] IN 
(
	SELECT [ah].[Id] FROM [AccountHolders] AS [ah]
	JOIN [Accounts] AS [a] ON [ah].[Id] = [a].[AccountHolderId]
	GROUP BY [ah].[Id]
	HAVING SUM([a].[Balance]) > @balance
)
ORDER BY [FirstName], [LastName]

GO

EXEC [usp_GetHoldersWithBalanceHigherThan] 200000

--11
CREATE FUNCTION [ufn_CalculateFutureValue] (@sum DECIMAL(18, 4), @yearlyInterestRate FLOAT, @numberOfYears INT)
RETURNS DECIMAL(18, 4)
AS
BEGIN
	RETURN ROUND(@sum * POWER(1 + @yearlyInterestRate, @numberOfYears), 4)
END

GO

SELECT [dbo].[ufn_CalculateFutureValue](1000, 0.1, 5)

--12
CREATE PROC [usp_CalculateFutureValueForAccount] @accountId INT, @interestRate FLOAT
AS
	SELECT 
		[a].[Id] AS [Account Id],
		[ah].[FirstName] AS [First Name],
		[ah].[LastName] AS [Last Name],
		[a].[Balance] AS [Current Balance],
		[dbo].[ufn_CalculateFutureValue]([a].[Balance], @interestRate, 5) AS [Balance in 5 years]
	FROM [AccountHolders] AS [ah]
	JOIN [Accounts] AS [a] ON [ah].[Id] = [a].[AccountHolderId]
	WHERE [a].[Id] = @accountId

GO

EXEC [usp_CalculateFutureValueForAccount] 1, 0.1

--13
USE [Diablo]

CREATE FUNCTION [ufn_CashInUsersGames](@gameName VARCHAR(50))
RETURNS TABLE
AS
RETURN
(
	SELECT SUM(Cash) AS [SumCash] 
	FROM (
			SELECT 
				[g].[Name], 
				[Cash], 
				ROW_NUMBER() OVER (ORDER BY [ug].[Cash] DESC) AS [Rank]
			FROM [Games] AS [g]
			JOIN [UsersGames] AS [ug] ON [g].[Id] = [ug].[GameId]
			WHERE [g].[Name] = @gameName
		 ) AS [RowNumber]
	WHERE RANK % 2 = 1
)

GO

SELECT * FROM [dbo].[ufn_CashInUsersGames]('Love in a mist')