USE [Airport]

GO

UPDATE [Aircraft]
SET [Condition] = 'A'
WHERE [Condition] IN ('B', 'C')
AND ([FlightHours] IS NULL OR [FlightHours] <= 100)
AND [Year] >= 2013