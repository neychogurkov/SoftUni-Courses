USE [Service]

GO

SELECT ISNULL([e].[FirstName] + ' ' + [e].[LastName], 'None') AS [Employee],
	   ISNULL([d].[Name], 'None') AS [Department],
	   [c].[Name] AS [Category],
	   [r].[Description],	
	   FORMAT([r].[OpenDate], 'dd.MM.yyyy') AS [OpenDate],
	   [s].[Label] AS [Status],
	   [u].[Name] AS [User]
FROM [Reports] AS [r]
LEFT JOIN [Users] AS [u] 
ON [r].[UserId] = [u].[Id]
LEFT JOIN [Status] AS [s]
ON [r].[StatusId] = [s].[Id]
LEFT JOIN [Categories] AS [c]
ON [r].[CategoryId] = [c].[Id]
LEFT JOIN [Employees] AS [e]
ON [r].[EmployeeId] = [e].[Id]
LEFT JOIN [Departments] AS [d]
ON [e].[DepartmentId] = [d].[Id]
ORDER BY [e].[FirstName] DESC,
	     [e].[LastName] DESC,
		 [Department],
		 [Category],
		 [Description],
		 [OpenDate],
		 [Status],
		 [User]