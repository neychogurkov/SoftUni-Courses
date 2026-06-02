USE [Service]

GO

SELECT [Description],
	   FORMAT([OpenDate], 'dd-MM-yyyy')
FROM [Reports]
WHERE [EmployeeId] IS NULL
ORDER BY [OpenDate],
		 [Description]