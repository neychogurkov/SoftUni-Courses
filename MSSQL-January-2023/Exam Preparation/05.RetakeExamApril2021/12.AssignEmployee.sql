USE [Service]

GO

CREATE PROC [usp_AssignEmployeeToReport](@EmployeeId INT, @ReportId INT)
AS
	DECLARE @employeeDepartmentId INT = (SELECT [DepartmentId] FROM [Employees] WHERE [Id] = @EmployeeId)

	DECLARE @categoryDepartmentId INT = (SELECT [DepartmentId] FROM [Categories] AS [c] JOIN [Reports] AS [r] ON [c].[Id] = [r].[CategoryId] WHERE r.[Id] = @ReportId)

	IF @employeeDepartmentId = @categoryDepartmentId
	UPDATE [Reports]
	SET [EmployeeId] = @EmployeeId
	WHERE [Id] = @ReportId
	ELSE
	THROW 50001, 'Employee doesn''t belong to the appropriate department!', 1

GO

EXEC usp_AssignEmployeeToReport 17, 2
EXEC usp_AssignEmployeeToReport 30, 1