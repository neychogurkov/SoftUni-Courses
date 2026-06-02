USE [Boardgames]

GO

CREATE FUNCTION udf_CreatorWithBoardgames(@name NVARCHAR(30))
RETURNS INT
AS
BEGIN
	RETURN (
				SELECT COUNT(*)
				FROM [CreatorsBoardgames]
				WHERE [CreatorId] = (
										 SELECT [Id] 
										 FROM [Creators] 
										 WHERE [FirstName] = @name
									)
		   )
END

GO

SELECT dbo.udf_CreatorWithBoardgames('Bruno')