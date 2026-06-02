USE [Bakery]

GO

CREATE TRIGGER [tr_DeleteRelationsOnDelete]
ON [Products]
INSTEAD OF DELETE
AS
BEGIN
	DECLARE @productId INT = (SELECT [Id] FROM [deleted])
	DELETE 
	FROM [Feedbacks]
	WHERE [ProductId] = @productId

	DELETE 
	FROM [ProductsIngredients]
	WHERE [ProductId] = @productId

	DELETE FROM [Products] WHERE Id = @productId
END

GO

DELETE FROM Products WHERE Id = 7