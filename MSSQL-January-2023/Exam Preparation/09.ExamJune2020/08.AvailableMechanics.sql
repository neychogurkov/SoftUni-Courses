USE [WMS]

GO

SELECT CONCAT_WS(' ', [m].[FirstName], [m].[LastName]) AS [Available]
FROM [Mechanics] AS [m]
LEFT JOIN [Jobs] AS [j]
ON [m].[MechanicId] = [j].[MechanicId]
WHERE [m].[MechanicId] NOT IN (
							       SELECT DISTINCT [m].[MechanicId]
							       FROM [Mechanics] AS [m]
							       LEFT JOIN [Jobs] AS [j]
							       ON [m].[MechanicId] = [j].[MechanicId]
							       WHERE [j].[Status] IN ('Pending', 'In Progress')
							  )
GROUP BY [m].[MechanicId], 
		 [m].[FirstName], 
		 [m].[LastName]
ORDER BY [m].[MechanicId]