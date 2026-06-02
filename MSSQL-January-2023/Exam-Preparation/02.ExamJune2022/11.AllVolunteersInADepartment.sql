USE [Zoo]

GO

CREATE FUNCTION [udf_GetVolunteersCountFromADepartment](@VolunteersDepartment VARCHAR(30))
RETURNS INT
AS
BEGIN
	RETURN (	
				SELECT COUNT(*) 
				FROM [Volunteers] 
				WHERE [DepartmentId] = (
											SELECT [Id] 
											FROM [VolunteersDepartments] 
											WHERE [DepartmentName] = @VolunteersDepartment
									   )
		   )
END

GO

SELECT dbo.udf_GetVolunteersCountFromADepartment ('Education program assistant')
SELECT dbo.udf_GetVolunteersCountFromADepartment ('Guest engagement')
SELECT dbo.udf_GetVolunteersCountFromADepartment ('Zoo events')