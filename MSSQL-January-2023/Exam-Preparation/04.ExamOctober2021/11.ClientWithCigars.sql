USE [CigarShop]

GO

CREATE FUNCTION [udf_ClientWithCigars](@name NVARCHAR(30))
RETURNS INT
AS
BEGIN 
	RETURN (
				SELECT COUNT(*) 
				FROM [Clients] AS [cl] 
				JOIN [ClientsCigars] AS [cc] 
				ON [cl].[Id] = [cc].[ClientId]
				WHERE [cl].[FirstName] = @name
		   )
END

GO

SELECT dbo.udf_ClientWithCigars('Betty')