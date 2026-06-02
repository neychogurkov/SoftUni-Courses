CREATE DATABASE [Boardgames]

GO

USE [Boardgames]

GO

CREATE TABLE [Categories]
(
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE [Addresses]
(
	[Id] INT PRIMARY KEY IDENTITY,
	[StreetName] NVARCHAR(100) NOT NULL,
	[StreetNumber] INT NOT NULL,
	[Town] VARCHAR(30) NOT NULL,
	[Country] VARCHAR(50) NOT NULL,
	[ZIP] INT NOT NULL
)

CREATE TABLE [Publishers]
(
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(30) UNIQUE NOT NULL,
	[AddressId] INT NOT NULL FOREIGN KEY REFERENCES [Addresses]([Id]),
	[Website] NVARCHAR(40),
	[Phone] NVARCHAR(20)
)

CREATE TABLE [PlayersRanges]
(
	[Id] INT PRIMARY KEY IDENTITY,
	[PlayersMin] INT NOT NULL,
	[PlayersMax] INT NOT NULL
)

CREATE TABLE [Boardgames]
(
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(30) NOT NULL,
	[YearPublished] INT NOT NULL,
	[Rating] DECIMAL(10, 2) NOT NULL,
	[CategoryId] INT NOT NULL REFERENCES [Categories]([Id]),
	[PublisherId] INT NOT NULL REFERENCES [Publishers]([Id]),
	[PlayersRangeId] INT NOT NULL REFERENCES [PlayersRanges]([Id]),
)

CREATE TABLE [Creators]
(
	[Id] INT PRIMARY KEY IDENTITY,
	[FirstName] NVARCHAR(30) NOT NULL,
	[LastName] NVARCHAR(30) NOT NULL,
	[Email] NVARCHAR(30) NOT NULL,
)

CREATE TABLE [CreatorsBoardgames]
(
	[CreatorId] INT NOT NULL REFERENCES [Creators]([Id]),
	[BoardgameId] INT NOT NULL REFERENCES [Boardgames]([Id]),
	PRIMARY KEY([CreatorId], [BoardgameId])
)