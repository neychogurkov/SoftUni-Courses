CREATE DATABASE [WMS]

GO

USE [WMS]

GO

CREATE TABLE [Clients]
(
	[ClientId] INT PRIMARY KEY IDENTITY,
	[FirstName] VARCHAR(50) NOT NULL,
	[LastName] VARCHAR(50) NOT NULL,
	[Phone] CHAR(12) NOT NULL
)

CREATE TABLE [Mechanics]
(
	[MechanicId] INT PRIMARY KEY IDENTITY,
	[FirstName] VARCHAR(50) NOT NULL,
	[LastName] VARCHAR(50) NOT NULL,
	[Address] VARCHAR(255) NOT NULL
)

CREATE TABLE [Models]
(
	[ModelId] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) UNIQUE NOT NULL
)

CREATE TABLE [Jobs]
(
	[JobId] INT PRIMARY KEY IDENTITY,
	[ModelId] INT NOT NULL FOREIGN KEY REFERENCES [Models]([ModelId]),
	[Status] VARCHAR(11) NOT NULL DEFAULT 'Pending' CHECK([Status] IN ('Pending', 'In Progress', 'Finished')),
	[ClientId] INT NOT NULL FOREIGN KEY REFERENCES [Clients]([ClientId]),
	[MechanicId] INT FOREIGN KEY REFERENCES [Mechanics]([MechanicId]),
	[IssueDate] DATE NOT NULL,
	[FinishDate] DATE
)

CREATE TABLE [Orders]
(
	[OrderId] INT PRIMARY KEY IDENTITY,
	[JobId] INT NOT NULL FOREIGN KEY REFERENCES [Jobs]([JobId]),
	[IssueDate] DATE,
	[Delivered] BIT NOT NULL DEFAULT 0
)

CREATE TABLE [Vendors]
(
	[VendorId] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) UNIQUE NOT NULL
)

CREATE TABLE [Parts]
(
	[PartId] INT PRIMARY KEY IDENTITY,
	[SerialNumber] VARCHAR(50) UNIQUE NOT NULL,
	[Description] VARCHAR(255),
	[Price] DECIMAL(6, 2) CHECK([Price] > 0) NOT NULL,
	[VendorId] INT NOT NULL FOREIGN KEY REFERENCES [Vendors]([VendorId]),
	[StockQty] INT NOT NULL DEFAULT 0 CHECK([StockQty] >= 0)
)

CREATE TABLE [OrderParts]
(
	[OrderId] INT FOREIGN KEY REFERENCES [Orders]([OrderId]),
	[PartId] INT FOREIGN KEY REFERENCES [Parts]([PartId]),
	PRIMARY KEY([OrderId], [PartId]),
	[Quantity] INT DEFAULT 1 CHECK([Quantity] > 0)
)

CREATE TABLE [PartsNeeded]
(
	[JobId] INT FOREIGN KEY REFERENCES [Jobs]([JobId]),
	[PartId] INT FOREIGN KEY REFERENCES [Parts]([PartId]),
	PRIMARY KEY([JobId], [PartId]),
	[Quantity] INT DEFAULT 1 CHECK([Quantity] > 0)
)