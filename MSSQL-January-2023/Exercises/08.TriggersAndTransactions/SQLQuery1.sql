USE [Bank]

GO

--1
CREATE TABLE [Logs]
(
	[LogId] INT PRIMARY KEY IDENTITY,
	[AccountId] INT,
	[OldSum] MONEY,
	[NewSum] MONEY
)

GO

CREATE TRIGGER [tr_AddToLogsOnBalanceChange]
ON [Accounts] 
FOR UPDATE
AS
	INSERT INTO [Logs]
	SELECT [i].[Id],
		   [d].[Balance],
		   [i].[Balance]
	FROM [inserted] AS [i]
	JOIN [deleted] AS [d]
	ON [i].[Id] = [d].[Id]

--2
CREATE TABLE [NotificationEmails]
(
	[Id] INT PRIMARY KEY IDENTITY,
	[Recipient] INT,
	[Subject] VARCHAR(100),
	[Body] VARCHAR(100)
)

GO

CREATE TRIGGER [tr_AddToEmailsOnLogCreation]
ON [Logs]
FOR INSERT
AS
	INSERT INTO [NotificationEmails]
	SELECT [AccountId],
		   CONCAT('Balance change for account: ', [AccountId]),
		   CONCAT('On ', GETDATE(), ' your balance was changed from ', [OldSum], ' to ', [NewSum], '.')
	FROM [inserted]

--3
CREATE PROC [usp_DepositMoney] @AccountId INT, @MoneyAmount MONEY
AS
	UPDATE [Accounts]
	SET [Balance] += @MoneyAmount
	WHERE [Id] = @AccountId

GO

EXEC [usp_DepositMoney] 1, 10

--4
CREATE PROC [usp_WithdrawMoney] @AccountId INT, @MoneyAmount MONEY
AS
	UPDATE [Accounts]
	SET [Balance] -= @MoneyAmount
	WHERE [Id] = @AccountId

GO

EXEC [usp_WithdrawMoney] 5, 25

--5
CREATE PROC [usp_TransferMoney] @SenderId INT, @ReceiverId INT, @Amount MONEY
AS
	BEGIN TRANSACTION
	EXEC [usp_DepositMoney] @ReceiverId, @Amount
	EXEC [usp_WithdrawMoney] @SenderId, @Amount

	IF @Amount < 0
	ROLLBACK
	ELSE 
	COMMIT

GO

EXEC [usp_TransferMoney] 5, 1, 5000

--6
USE [Diablo]

GO



--7
DECLARE @userId INT = (
					       SELECT [Id] 
						   FROM [Users] 
						   WHERE [Username] = 'Stamat'
					  )
DECLARE @gameId INT = (
					       SELECT [Id] 
						   FROM [Games] 
						   WHERE [Name] = 'Safflower'
					  )

DECLARE @userGameId INT = (
						       SELECT [Id]
							   FROM [UsersGames] 
							   WHERE [UserId] = @userId 
							   AND [GameId] = @gameId
						  )

DECLARE @userCash MONEY = (SELECT Cash FROM [UsersGames] WHERE [Id] = @userGameId)
DECLARE @itemsPrice MONEY = (SELECT SUM(Price) FROM [Items] WHERE MinLevel BETWEEN 11 AND 12)

IF @userCash >= @itemsPrice
BEGIN
BEGIN TRANSACTION
	UPDATE [UsersGames]
	SET [Cash] -= @itemsPrice
	WHERE [Id] = @userGameId

INSERT INTO [UserGameItems]
SELECT [Id], 
	   @userGameId
FROM [Items]
WHERE MinLevel IN (11, 12)
COMMIT
END

SET @userCash = (SELECT Cash FROM [UsersGames] WHERE [Id] = @userGameId)
SET @itemsPrice = (SELECT SUM(Price) FROM [Items] WHERE MinLevel BETWEEN 19 AND 21)

IF @userCash >= @itemsPrice
BEGIN
BEGIN TRANSACTION
	UPDATE [UsersGames]
	SET [Cash] -= @itemsPrice
	WHERE [Id] = @userGameId

INSERT INTO [UserGameItems]
SELECT [Id], 
	   @userGameId
FROM [Items]
WHERE MinLevel BETWEEN 19 AND 21
COMMIT
END

SELECT [i].[Name] AS [Item Name]
FROM [Items] AS [i]
JOIN [UserGameItems] AS [ugi]
ON [i].[Id] = [ugi].[ItemId]
JOIN [UsersGames] AS [ug]
ON [ugi].[UserGameId] = [ug].[Id]
WHERE [ugi].[UserGameId] = @userGameId
ORDER BY [Item Name]

--8
USE [SoftUni]

GO

CREATE PROC [usp_AssignProject] @emloyeeId INT, @projectID INT
AS
	BEGIN TRANSACTION
	IF (SELECT COUNT(*) FROM [EmployeesProjects] WHERE [EmployeeID] = @emloyeeId) >= 3
	BEGIN
	RAISERROR('The employee has too many projects!', 16, 1)
	ROLLBACK
	END

	INSERT INTO [EmployeesProjects]
	VALUES
	(@emloyeeId, @projectID)
	COMMIT

GO

EXEC [usp_AssignProject] 1, 5

SELECT * FROM [EmployeesProjects]

--9
CREATE TABLE [Deleted_Employees]
(
	[EmployeeId] INT PRIMARY KEY,
	[FirstName] VARCHAR(50) NOT NULL,
	[LastName] VARCHAR(50) NOT NULL,
	[MiddleName] VARCHAR(50) NOT NULL,
	[JobTitle] VARCHAR(50) NOT NULL,
	[DepartmentId] INT NOT NULL,
	[Salary] MONEY NOT NULL
)

CREATE TRIGGER [tr_AddToDeletedEmployeesOnDelete]
ON [Employees]
FOR DELETE
AS
	INSERT INTO [Deleted_Employees]
	SELECT [EmployeeId],
		   [FirstName],
		   [LastName],
		   [MiddleName],
		   [JobTitle],
		   [DepartmentId],
		   [Salary]
	FROM [deleted]