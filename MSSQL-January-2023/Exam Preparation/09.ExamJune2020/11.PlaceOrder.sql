USE [WMS]

GO

CREATE OR ALTER PROC [usp_PlaceOrder] @jobId INT, @serialNumber VARCHAR(50), @quantity INT
AS
BEGIN 
	IF (SELECT [Status] FROM [Jobs] WHERE [JobId] = @jobId) = 'Finished'
		THROW 50011, 'This job is not active!', 1
	ELSE IF @quantity <= 0
		THROW 50012, 'Part quantity must be more than zero!', 1
	ELSE IF @jobId NOT IN (Select [JobId] FROM [Jobs])
		THROW 50013, 'Job not found!', 1
	ELSE IF @serialNumber NOT IN (SELECT [SerialNumber] FROM [Parts])
		THROW 50014, 'Part not found!', 1
END

GO

DECLARE @err_msg AS NVARCHAR(MAX);
BEGIN TRY
  EXEC usp_PlaceOrder 1, 'ZeroQuantity', 0
END TRY

BEGIN CATCH
  SET @err_msg = ERROR_MESSAGE();
  SELECT @err_msg
END CATCH
