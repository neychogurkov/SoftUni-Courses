CREATE DATABASE [TableRelationsExercise]

GO

USE [TableRelationsExercise]

GO

--1
CREATE TABLE [Passports]
(
    [PassportID] INT PRIMARY KEY IDENTITY(101, 1),
    [PassportNumber] CHAR(8) NOT NULL
)

CREATE TABLE [Persons]
(
    [PersonID] INT PRIMARY KEY IDENTITY,
    [FirstName] VARCHAR(50) NOT NULL,
    [Salary] DECIMAL(10, 2),
    [PassportID] INT NOT NULL UNIQUE FOREIGN KEY REFERENCES [Passports]([PassportID])
)

INSERT INTO [Passports]
VALUES
    ('N34FG21B'),
    ('K65LO4R7'),
    ('ZE657QP2')

INSERT INTO [Persons]
VALUES
    ('Roberto', '43300', 102),
    ('Tom', '56100', 103),
    ('Yana', '60200', 101)

--2
CREATE TABLE [Manufacturers]
(
    [ManufacturerID] INT PRIMARY KEY IDENTITY,
    [Name] VARCHAR(50) NOT NULL,
    [EstablishedOn] DATETIME2 NOT NULL
)

CREATE TABLE [Models]
(
    [ModelID] INT PRIMARY KEY IDENTITY(101, 1),
    [Name] VARCHAR(50) NOT NULL,
    [ManufacturerID] INT NOT NULL FOREIGN KEY REFERENCES [Manufacturers]([ManufacturerID])
)

INSERT INTO [Manufacturers]
VALUES
    ('BMW', '1916-03-07'),
    ('Tesla', '2003-01-01'),
    ('Lada', '1966-05-01')

INSERT INTO [Models]
VALUES
    ('X1', 1),
    ('i6', 1),
    ('Model S', 2),
    ('Model X', 2),
    ('Model 3', 2),
    ('Nova', 3)

--3
CREATE TABLE [Students]
(
    [StudentID] INT PRIMARY KEY IDENTITY,
    [Name] VARCHAR(50) NOT NULL
)

CREATE TABLE [Exams]
(
    [ExamID] INT PRIMARY KEY IDENTITY (101, 1),
    [Name] VARCHAR(50) NOT NULL
)

CREATE TABLE [StudentsExams]
(
    [StudentID] INT NOT NULL FOREIGN KEY REFERENCES [Students]([StudentID]),
    [ExamID] INT NOT NULL FOREIGN KEY REFERENCES [Exams]([ExamID]),
    PRIMARY KEY([StudentID], [ExamID])
)

INSERT INTO [Students]
VALUES
    ('Mila'),
    ('Toni'),
    ('Ron')

INSERT INTO [Exams]
VALUES
    ('SpringMVC'),
    ('Neo4j'),
    ('Oracle 11g')

INSERT INTO [StudentsExams]
VALUES
    (1, 101),
    (1, 102),
    (2, 101),
    (3, 103),
    (2, 102),
    (2, 103)

--4
CREATE TABLE [Teachers]
(
    [TeacherID] INT PRIMARY KEY IDENTITY(101, 1),
    [Name] VARCHAR(50) NOT NULL,
    [ManagerID] INT FOREIGN KEY REFERENCES [Teachers]([TeacherID])
)

INSERT INTO [Teachers]
VALUES
    ('John', NULL),
    ('Maya', 106),
    ('Silvia', 106),
    ('Ted', 105),
    ('Mark', 101),
    ('Greta', 101)

--5
CREATE DATABASE [OnlineStore]

GO

USE [OnlineStore]

GO

CREATE TABLE [Cities]
(
    [CityID] INT PRIMARY KEY IDENTITY,
    [Name] VARCHAR(50) NOT NULL
)
CREATE TABLE [Customers]
(
    [CustomerID] INT PRIMARY KEY IDENTITY,
    [Name] VARCHAR(50) NOT NULL,
    [Birthday] DATETIME2,
    [CityID] INT NOT NULL FOREIGN KEY REFERENCES [Cities]([CityID])
)

CREATE TABLE [Orders]
(
    [OrderID] INT PRIMARY KEY IDENTITY,
    [CustomerID] INT NOT NULL FOREIGN KEY REFERENCES [Customers]([CustomerID])
)

CREATE TABLE [ItemTypes]
(
    [ItemTypeID] INT PRIMARY KEY IDENTITY,
    [Name] VARCHAR(50) NOT NULL
)

CREATE TABLE [Items]
(
    [ItemID] INT PRIMARY KEY IDENTITY,
    [Name] VARCHAR(50) NOT NULL,
    [ItemTypeID] INT NOT NULL FOREIGN KEY REFERENCES [ItemTypes]([ItemTypeID])
)

CREATE TABLE [OrderItems]
(
    [OrderID] INT NOT NULL FOREIGN KEY REFERENCES [Orders]([OrderID]),
    [ItemID] INT NOT NULL FOREIGN KEY REFERENCES [Items]([ItemID]),
    PRIMARY KEY ([OrderID], [ItemID])
)

--6
CREATE DATABASE [University]

GO

USE [University]

GO

CREATE TABLE [Majors]
(
    [MajorID] INT PRIMARY KEY IDENTITY,
    [Name] VARCHAR(50) NOT NULL
)

CREATE TABLE [Students]
(
    [StudentID] INT PRIMARY KEY IDENTITY,
    [StudentNumber] VARCHAR(20) NOT NULL,
    [StudentName] VARCHAR(50) NOT NULL,
    [MajorID] INT NOT NULL FOREIGN KEY REFERENCES [Majors]([MajorID])
)

CREATE TABLE [Payments]
(
    [PaymentID] INT PRIMARY KEY IDENTITY,
    [PaymentDate] DATETIME2 NOT NULL,
    [PaymentAmount] DECIMAL(10, 2) NOT NULL,
    [StudentID] INT NOT NULL FOREIGN KEY REFERENCES [Students]([StudentID])
)

CREATE TABLE [Subjects]
(
    [SubjectID] INT PRIMARY KEY IDENTITY,
    [SubjectName] VARCHAR(50) NOT NULL
)

CREATE TABLE [Agenda]
(
    [StudentID] INT NOT NULL FOREIGN KEY REFERENCES [Students]([StudentID]),
    [SubjectID] INT NOT NULL FOREIGN KEY REFERENCES [Subjects]([SubjectID]),
    PRIMARY KEY ([StudentID], [SubjectID])
)

--9
USE [Geography]

SELECT [MountainRange], [PeakName], [Elevation]
FROM [Peaks] AS [p]
    JOIN [Mountains] AS [m]
    ON [p].[MountainId] = [m].[Id]
WHERE [m].[MountainRange] = 'Rila'
ORDER BY [Elevation] DESC