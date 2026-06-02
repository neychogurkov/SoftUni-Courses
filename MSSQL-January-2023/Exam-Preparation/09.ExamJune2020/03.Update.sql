USE [WMS]

GO

DECLARE @mechanicId INT = (SELECT [MechanicId] FROM [Mechanics] WHERE [FirstName] = 'Ryan' AND [LastName] = 'Harnos')

UPDATE [Jobs]
SET [MechanicId] = @mechanicId
WHERE [Status] = 'Pending'

UPDATE [Jobs]
SET [Status] = 'In Progress'
WHERE [Status] = 'Pending'