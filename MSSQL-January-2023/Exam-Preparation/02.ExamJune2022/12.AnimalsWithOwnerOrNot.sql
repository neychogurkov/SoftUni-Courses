USE [Zoo]

GO

CREATE PROC [usp_AnimalsWithOwnersOrNot](@AnimalName VARCHAR(30))
AS
	SELECT [a].[Name],
		   ISNULL([o].[Name], 'For adoption')
	FROM [Owners] AS [o]
	RIGHT JOIN [Animals] AS [a] ON [o].[Id] = [a].[OwnerId]
	WHERE [a].[Name] = @AnimalName

GO

EXEC usp_AnimalsWithOwnersOrNot 'Pumpkinseed Sunfish'
EXEC usp_AnimalsWithOwnersOrNot 'Hippo'
EXEC usp_AnimalsWithOwnersOrNot 'Brown bear'