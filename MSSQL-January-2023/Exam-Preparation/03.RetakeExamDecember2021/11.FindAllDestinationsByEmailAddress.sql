USE [Airport]

GO

CREATE FUNCTION [udf_FlightDestinationsByEmail](@email VARCHAR(50))
RETURNS INT
AS
BEGIN 
	RETURN (
				SELECT COUNT(*) 
				FROM [FlightDestinations] 
				WHERE [PassengerId] = (
											SELECT [Id] 
											FROM [Passengers] 
											WHERE [Email] = @email
									  )
		   )
END

GO

SELECT dbo.udf_FlightDestinationsByEmail ('PierretteDunmuir@gmail.com')
SELECT dbo.udf_FlightDestinationsByEmail('Montacute@gmail.com')
SELECT dbo.udf_FlightDestinationsByEmail('MerisShale@gmail.com')