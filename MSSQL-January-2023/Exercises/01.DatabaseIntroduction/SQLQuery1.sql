--1
CREATE DATABASE [Minions]

USE [Minions]

--2
CREATE TABLE [Minions]
(
    Id INT NOT NULL,
    Name VARCHAR(50),
    Age INT,
    CONSTRAINT PK_Minions
PRIMARY KEY (Id)
)

CREATE TABLE [Towns]
(
    Id INT NOT NULL,
    Name VARCHAR(50),
    CONSTRAINT PK_Towns
PRIMARY KEY (Id)
)

--3
ALTER TABLE [Minions]
ADD TownId INT NOT NULL

ALTER TABLE [Minions]
ADD CONSTRAINT FK_Minions_Towns
FOREIGN KEY(TownId)
REFERENCES Towns(Id)

--4
INSERT INTO [Towns]
    (Id, Name)
VALUES
    (1, 'Sofia'),
    (2, 'Plovdiv'),
    (3, 'Varna')

INSERT INTO [Minions]
    (Id, Name, Age, TownId)
VALUES
    (1, 'Kevin', 22, 1),
    (2, 'Bob', 15, 3),
    (3, 'Steward', NULL, 2)

--5
TRUNCATE TABLE Minions

--6
DROP TABLE [Minions]
DROP TABLE [Towns]

--7
CREATE TABLE [People]
(
    Id INT IDENTITY PRIMARY KEY,
    Name NVARCHAR(200),
    Picture VARBINARY(MAX),
    Height DECIMAL(10,2),
    Weight DECIMAL(10,2),
    Gender CHAR(1) NOT NULL,
    Birthdate DATE NOT NULL,
    Biography NVARCHAR(MAX)
)

INSERT INTO [People]
    (Name, Picture, Height, Weight, Gender, Birthdate, Biography)
VALUES
    ('George', NULL, 1.82, 85, 'm', '20001020', 'Nice person.'),
    ('Peter', NULL, 1.95, 90, 'm', '20040109', 'Good person.'),
    ('Maria', NULL, 1.65, 54, 'f', '20021115', 'Great person.'),
    ('John', NULL, 1.82, 80, 'm', '19980527', 'Smiley person.'),
    ('Jane', NULL, 1.73, 58, 'f', '19950915', 'Polite person.')

--8
CREATE TABLE [Users]
(
    Id BIGINT IDENTITY PRIMARY KEY,
    Username VARCHAR(30) NOT NULL,
    Password VARCHAR(26) NOT NULL,
    ProfilePicture VARBINARY(MAX),
    LastLoginTime DATETIME2,
    IsDeleted BIT
)

INSERT INTO [Users]
    (Username, Password, LastLoginTime, IsDeleted)
VALUES
    ('Ivan25', 'Vanko', '2023-01-05T15:23:05', 0),
    ('George', 'Gosho1234', '2020-12-15T23:10:27', 1),
    ('JohnSmith', 'john152', '2021-06-11T08:35:30', 0),
    ('Jasmine', 'jas2939', '2018-02-22T10:42:39', 1),
    ('Maria', 'mar982', '2022-12-25T16:14:52', 0)

--9
ALTER TABLE [Users]
DROP CONSTRAINT PK__Users__3214EC07956E813F
ALTER TABLE [Users]
ADD CONSTRAINT PK_IdUsername PRIMARY KEY(Id, Username)

--10
ALTER TABLE [Users]
ADD CONSTRAINT CHK_PasswordLength 
CHECK(LEN(Password)>=5)

--11
ALTER TABLE [Users]
ADD CONSTRAINT DF_LastLoginTime
DEFAULT GETDATE() FOR LastLoginTime

--12
ALTER TABLE [Users]
DROP CONSTRAINT PK_IdUsername

ALTER TABLE [Users]
ADD CONSTRAINT PK_Users
PRIMARY KEY(Id)

ALTER TABLE [Users]
ADD UNIQUE (Username)

ALTER TABLE [Users]
ADD CONSTRAINT CHK_UsernameLength
CHECK(LEN(Username)>=3)

--13
CREATE TABLE Directors
(
    Id INT IDENTITY PRIMARY KEY,
    DirectorName VARCHAR(50) NOT NULL,
    Notes VARCHAR(200)
)

CREATE TABLE Genres
(
    Id INT IDENTITY PRIMARY KEY,
    GenreName VARCHAR(50) NOT NULL,
    Notes VARCHAR(200)
)

CREATE TABLE Categories
(
    Id INT IDENTITY PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL,
    Notes VARCHAR(200)
)

CREATE TABLE Movies
(
    Id INT IDENTITY PRIMARY KEY,
    Title VARCHAR(50) NOT NULL,
    DirectorId INT NOT NULL,
    CopyrightYear INT,
    Length VARCHAR(50),
    GenreId INT NOT NULL,
    CategoryID INT NOT NULL,
    Rating DECIMAL(10,2),
    Notes VARCHAR(200)
)

INSERT INTO [Directors]
VALUES
    ('John', 'John''s Notes'),
    ('Michael', 'Michael''s Notes'),
    ('George', 'George''s Notes'),
    ('Peter', 'Peter''s Notes'),
    ('Sam', 'Sam''s Notes')

INSERT INTO [Genres]
VALUES
    ('Sci-fi', 'Sci-fi Notes'),
    ('Action', 'Action Notes'),
    ('Horror', 'Horror Notes'),
    ('Comedy', 'Comedy Notes'),
    ('Thriller', 'Thriller Notes')

INSERT INTO [Categories]
VALUES
    ('Category1', 'Category1 Notes'),
    ('Category2', 'Category2 Notes'),
    ('Category3', 'Category3 Notes'),
    ('Category4', 'Category4 Notes'),
    ('Category5', 'Category5 Notes')

INSERT INTO [Movies]
VALUES
    ('Interstellar', 2, 2014, '3 hours', 1, 3, 9.58, 'Nice movie'),
    ('Home alone 1', 3, 1990, '2 hours', 4, 5, 9.20, 'Legendary movie'),
    ('Die hard 3', 5, 1995, '2:30 hours', 2, 1, 8.78, 'Great movie'),
    ('Spider-man 3', 4, 2007, '2:20 hours', 5, 2, 9.07, 'Amazing movie'),
    ('It', 1, 2017, '2 hours', 3, 4, 9.12, 'Scary movie')

--14
CREATE DATABASE CarRental
GO

USE CarRental

CREATE TABLE Categories
(
    Id INT IDENTITY PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL,
    DailyRate DECIMAL(10,2),
    WeeklyRate DECIMAL(10,2),
    MonthlyRate DECIMAL(10,2),
    WeekendRate DECIMAL(10,2)
)

CREATE TABLE Cars
(
    Id INT IDENTITY PRIMARY KEY,
    PlateNumber VARCHAR(20) NOT NULL,
    Manufacturer VARCHAR(50) NOT NULL,
    Model VARCHAR(50) NOT NULL,
    CarYear INT,
    CategoryId INT NOT NULL,
    Doors INT,
    Picture VARBINARY(MAX),
    Condition VARCHAR(100),
    Available BIT
)

CREATE TABLE Employees
(
    Id INT IDENTITY PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Title VARCHAR(50) NOT NULL,
    Notes VARCHAR(200)
)

CREATE TABLE Customers
(
    Id INT IDENTITY PRIMARY KEY,
    DriverLicenceNumber VARCHAR(50) NOT NULL,
    FullName VARCHAR(100) NOT NULL,
    Address VARCHAR(100),
    City VARCHAR(50),
    ZIPCode VARCHAR(10),
    Notes VARCHAR(200)
)

CREATE TABLE RentalOrders
(
    Id INT IDENTITY PRIMARY KEY,
    EmployeeId INT NOT NULL,
    CustomerId INT NOT NULL,
    CarId INT NOT NULL,
    TankLevel DECIMAL(10,2),
    KilometrageStart DECIMAL(10,2),
    KilometrageEnd DECIMAL(10,2),
    TotalKilometrage DECIMAL(10,2),
    StartDate DATETIME2,
    EndDate DATETIME2,
    TotalDays INT,
    RateApplied DECIMAL(10,2),
    TaxRate DECIMAL(10,2),
    OrderStatus VARCHAR(50),
    Notes VARCHAR(200)
)

INSERT INTO Categories
VALUES
    ('A', 12.00, 90.25, 270.00, 20.50),
    ('B', 15.00, 130.15, 375.50, 30.00),
    ('C', 20.00, 190.75, 545.00, 50.00)

INSERT INTO Cars
    (PlateNumber, Manufacturer, Model, CarYear, CategoryId, Doors, Condition, Available)
VALUES
    ('CB 2552 AC', 'Mercedes-Benz', 'AMG GT 63 S', 2022, 2, 4, 'Perfect', 1),
    ('CB 1234 CA', 'BMW', '1250 GS Adventure', 2019, 1, 0, 'Good', 1),
    ('CB 9999 BA', 'Toyota', 'RAV4', 2022, 2, 4, 'Great', 0)

INSERT INTO Employees
    (FirstName, LastName, Title)
VALUES
    ('George', 'Ivanov', 'CEO'),
    ('Ivan', 'Dimitrov', 'Manager'),
    ('Peter', 'Todorov', 'Driver')

INSERT INTO Customers
    (DriverLicenceNumber, FullName, Address, City, ZIPCode)
VALUES
    ('14625321', 'Dimitar Dimitrov', 'Sofia', 'Sofia', '1113'),
    ('32542534', 'Martin Ivanov', 'Sofia', 'Sofia', '1138'),
    ('26354789', 'George Georgiev', 'Sofia', 'Sofia', '1142')

INSERT INTO RentalOrders
    (EmployeeId, CustomerId, CarId, TankLevel, KilometrageStart, KilometrageEnd, TotalKilometrage, StartDate, EndDate, TotalDays, RateApplied, TaxRate, OrderStatus)
VALUES
    (2, 1, 1, 80, 12500, 13000, 500, '2022-08-19', '2022-08-21', 3, 2.50, 25.00, 'Pending'),
    (3, 3, 3, 100, 38000, 40000, 2000, '2022-05-25', '2022-05-30', 6, 4.25, 30.00, 'Completed'),
    (1, 2, 2, 25, 25200, 25900, 700, '2020-06-01', '2020-06-05', 5, 3.00, 20.00, 'Completed')

--15
CREATE DATABASE Hotel
GO

USE Hotel 
GO

CREATE TABLE Employees
(
    Id INT IDENTITY PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Title VARCHAR(50) NOT NULL,
    Notes VARCHAR(MAX)
)

CREATE TABLE Customers
(
    AccountNumber INT IDENTITY PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    PhoneNumber VARCHAR(20) NOT NULL,
    EmergencyName VARCHAR(50),
    EmergencyNumber VARCHAR(20),
    Notes VARCHAR(MAX)
)

CREATE TABLE RoomStatus
(
    RoomStatus VARCHAR(50) PRIMARY KEY,
    Notes VARCHAR(MAX),
)

CREATE TABLE RoomTypes
(
    RoomType VARCHAR(50) PRIMARY KEY,
    Notes VARCHAR(MAX),
)

CREATE TABLE BedTypes
(
    BedType VARCHAR(50) PRIMARY KEY,
    Notes VARCHAR(MAX),
)

CREATE TABLE Rooms
(
    RoomNumber INT IDENTITY PRIMARY KEY,
    RoomType VARCHAR(50) NOT NULL FOREIGN KEY REFERENCES RoomTypes(RoomType),
    BedType VARCHAR(50) NOT NULL FOREIGN KEY REFERENCES BedTypes(BedType),
    Rate DECIMAL(10,2),
    RoomStatus VARCHAR(50) NOT NULL FOREIGN KEY REFERENCES RoomStatus(RoomStatus),
    Notes VARCHAR(MAX)
)

CREATE TABLE Payments
(
    Id INT IDENTITY PRIMARY KEY,
    EmployeeId INT NOT NULL FOREIGN KEY REFERENCES Employees(Id),
    PaymentDate DATETIME2,
    AccountNumber INT NOT NULL FOREIGN KEY REFERENCES Customers(AccountNumber),
    FirstDateOccupied DATETIME2,
    LastDateOccupied DATETIME2,
    TotalDays INT,
    AmountCharged DECIMAL(10,2),
    TaxRate DECIMAL(10,2),
    TaxAmount DECIMAL(10,2),
    PaymentTotal DECIMAL(10,2),
    Notes VARCHAR(MAX)
)

CREATE TABLE Occupancies
(
    Id INT IDENTITY PRIMARY KEY,
    EmployeeId INT NOT NULL FOREIGN KEY REFERENCES Employees(Id),
    DateOccupied DATETIME2,
    AccountNumber INT NOT NULL FOREIGN KEY REFERENCES Customers(AccountNumber),
    RoomNumber INT NOT NULL FOREIGN KEY REFERENCES Rooms(RoomNumber),
    RateApplied DECIMAL(10,2),
    PhoneCharge DECIMAL(10,2),
    Notes VARCHAR(MAX)
)

INSERT INTO Employees
    (FirstName, LastName, Title)
VALUES
    ('John', 'Taylor', 'Manager'),
    ('Mike', 'Johnson', 'Receptionist'),
    ('Phil', 'Terry', 'Cleaner')

INSERT INTO Customers
    (FirstName,LastName,PhoneNumber)
VALUES
    ('Luke', 'Hamilton', '+44462149534'),
    ('Lewis', 'Brown', '+44981247123'),
    ('Thomas', 'Aaron', '+44283812943')

INSERT INTO RoomStatus
    (RoomStatus)
VALUES
    ('Occupied'),
    ('Available'),
    ('On-change')

INSERT INTO RoomTypes
    (RoomType)
VALUES
    ('Single'),
    ('Double'),
    ('Triple')

INSERT INTO BedTypes
    (BedType)
VALUES
    ('Double'),
    ('Queen'),
    ('King')

INSERT INTO Rooms
    (RoomType, BedType, Rate, RoomStatus)
VALUES
    ('Single', 'Double', 8.4, 'Occupied'),
    ('Double', 'King', 9.5, 'On-change'),
    ('Triple', 'Queen', 9.9, 'Available')

INSERT INTO Payments
    (EmployeeId, PaymentDate, AccountNumber, FirstDateOccupied, LastDateOccupied, TotalDays, AmountCharged, TaxRate, TaxAmount, PaymentTotal)
VALUES
    (2, '20220615', 3, '20220615', '20220622', 7, 1250, 20, 250, 1500),
    (2, '20220710', 2, '20220701', '20220710', 10, 2000, 20, 400, 2400),
    (2, '20220822', 1, '20220822', '20220830', 8, 1500, 20, 300, 1800)

INSERT INTO Occupancies
    (EmployeeId, DateOccupied, AccountNumber, RoomNumber, RateApplied, PhoneCharge)
VALUES
    (3, '2022-06-30', 1, 1, 4.5, 20),
    (3, '2022-07-15', 2, 3, 5, 15),
    (3, '2022-09-01', 3, 2, 6, 10)

--16
CREATE DATABASE SoftUni

GO

USE SoftUni

CREATE TABLE Towns
(
    Id INT IDENTITY,
    Name VARCHAR(50) NOT NULL,
    CONSTRAINT PK_Towns
PRIMARY KEY(Id)
)

CREATE TABLE Addresses
(
    Id INT IDENTITY,
    AddressText VARCHAR(100),
    TownId INT NOT NULL,
    CONSTRAINT PK_Addresses
PRIMARY KEY (Id),
    CONSTRAINT FK_Addresses_Towns
FOREIGN KEY(TownId)
REFERENCES Towns(Id)
)

CREATE TABLE Departments
(
    Id INT IDENTITY,
    Name VARCHAR(50) NOT NULL,
    CONSTRAINT PK_Departments
PRIMARY KEY (Id)
)

CREATE TABLE Employees
(
    Id INT IDENTITY,
    FirstName VARCHAR(50) NOT NULL,
    MiddleName VARCHAR(50),
    LastName VARCHAR(50) NOT NULL,
    JobTitle VARCHAR(50) NOT NULL,
    DepartmentId INT NOT NULL,
    HireDate DATETIME2,
    Salary DECIMAL(10,2),
    AddressId INT,
    CONSTRAINT PK_Employees
PRIMARY KEY(Id),
    CONSTRAINT FK_Employees_Departments
FOREIGN KEY (DepartmentId)
REFERENCES Departments(Id)
)

--18
INSERT INTO Towns
VALUES
    ('Sofia'),
    ('Plovdiv'),
    ('Varna'),
    ('Burgas')

INSERT INTO Departments
VALUES
    ('Engineering'),
    ('Sales'),
    ('Marketing'),
    ('Software Development'),
    ('Quality Assurance')
SELECT *
FROM Departments

INSERT INTO Employees
    (FirstName, MiddleName, LastName, JobTitle, DepartmentId, HireDate, Salary)
VALUES
    ('Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 4, '2013-02-01', 3500.00),
    ('Petar', 'Petrov', 'Petrov', 'Senior Engineer', 1, '2004-03-02', 4000.00),
    ('Maria', 'Petrova', 'Ivanova', 'Intern', 5, '2016-08-28', 525.25),
    ('Georgi', 'Terziev', 'Ivanov', 'CEO', 2, '2007-12-09', 3000.00),
    ('Peter', 'Pan', 'Pan', 'Intern', 3, '2016-08-28', 599.88)

--19
SELECT *
FROM Towns
SELECT *
FROM Departments
SELECT *
FROM Employees

--20
SELECT *
FROM Towns
ORDER BY Name
SELECT *
FROM Departments
ORDER BY Name
SELECT *
FROM Employees
ORDER BY Salary DESC

--21
SELECT Name
FROM Towns
ORDER BY Name
SELECT Name
FROM Departments
ORDER BY Name
SELECT FirstName, LastName, JobTitle, Salary
FROM Employees
ORDER BY Salary DESC

--22
UPDATE Employees SET Salary = 1.1 * Salary
SELECT Salary
FROM Employees

--23
UPDATE Payments SET TaxRate = 0.97 * TaxRate
SELECT TaxRate
FROM Payments

--24
TRUNCATE TABLE Occupancies