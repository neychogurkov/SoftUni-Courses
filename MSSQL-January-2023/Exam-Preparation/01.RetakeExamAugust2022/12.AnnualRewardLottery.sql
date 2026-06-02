USE [NationalTouristSitesOfBulgaria]

GO

CREATE PROC usp_AnnualRewardLottery @TouristName VARCHAR(50)
AS
	DECLARE @SitesCount INT = (
									SELECT COUNT(*) 
									FROM [Tourists] AS [t] 
									JOIN [SitesTourists] AS [st] 
									ON [t].[Id] = [st].[TouristId] 
									WHERE [t].[Name] = @TouristName
							  )
	DECLARE @Reward VARCHAR(20)
	
	IF @SitesCount >= 100
		SET @Reward = 'Gold badge'
	ELSE IF @SitesCount >= 50
		SET @Reward = 'Silver badge'
	ELSE IF @SitesCount >= 25
		SET @Reward = 'Bronze badge'
		
	UPDATE [Tourists] 
	SET [Reward] = @Reward 
	WHERE [Name] = @TouristName

	SELECT [Name], 
		   [Reward] 
	FROM [Tourists] 
	WHERE [Name] = @TouristName