
CREATE DATABASE TableRelation;

-- 1.	One-To-One Relationship



CREATE TABLE Passports(
	[PassportID] INT PRIMARY KEY,
	[PassportNumber] VARCHAR(8) NOT NULL
);

CREATE TABLE Persons(
	PersonId INT PRIMARY KEY NOT NULL,
	FirstName NVARCHAR(50) NOT NULL,
	Salary DECIMAL(7,2) NOT NULL,
	PassportID  INT NOT NULL FOREIGN KEY
		REFERENCES Passports(PassportID) UNIQUE
	);

INSERT Passports(PassportID,PassportNumber)
	VALUES
		(101,'N34FG21B'),
		(102,'K65LO4R7'),
		(103,'ZE657QP2');

INSERT Persons(PersonId,FirstName,Salary,PassportID)
	VALUES
		(4,'Roberto',43300,101),
		(2, 'Tom',56100,103),
		(3,'Yana',60200,101);


--SELECT * FROM Persons;
--SELECT * FROM Passports;

/*ALTER TABLE Passports 
	ADD CONSTRAINT PK_PassportId PRIMARY KEY (PassportId);

ALTER TABLE Persons 
	ADD CONSTRAINT PK_PersonId PRIMARY KEY(PersonId)

ALTER TABLE Persons
	ADD CONSTRAINT FK_PersontPassports FOREIGN KEY (PassportId)
		REFERENCES Passports(PassportId);*/

 -- 2.	One-To-Many Relationship

 CREATE TABLE Manufacturers(
 ManufacturerID INT PRIMARY KEY IDENTITY,
 [Name] NVARCHAR(50) NOT NULL,
 EstablishedOn DATE
 );
 	
CREATE TABLE Models(
ModelID INT PRIMARY KEY IDENTITY(100,1),
[Name] NVARCHAR(50) NOT NULL,
ManufacturerID INT FOREIGN KEY REFERENCES Manufacturers(ManufacturerID)
);

INSERT INTO Manufacturers([Name],EstablishedOn)
	VALUES
		('BMW','1916-03-07'),
		('Tesla','2003-01-01'),
		('Lada','1966-06-01');

INSERT INTO Models([Name],[ManufacturerID])
	VALUES
		('X1',1),
		('i6',1),
		('Model S',2),
		('Model X',2),
		('Model 3',2),
		('Nova',3)



SELECT * FROM Models

-- 3.	Many-To-Many Relationship 

CREATE TABLE Students(
StudentID INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(50) NOT NULL
);

CREATE TABLE Exams (
ExamID INT PRIMARY KEY IDENTITY(101,1),
[Name] NVARCHAR(50) NOT NULL 
);

CREATE TABLE StudentsExams(
StudentID INT FOREIGN KEY REFERENCES Students(StudentID),
ExamID INT FOREIGN KEY REFERENCES Exams(ExamID)
PRIMARY KEY(StudentID,ExamID)
);

INSERT INTO Students([Name])
	VALUES
		('Mila'),
		('Toni'),
		('Ron');

INSERT INTO Exams([Name])
	VALUES
		('SpringMVC'),
		('Neo4j'),
		('Oracle 11g');

INSERT INTO StudentsExams(StudentID,[ExamID])
	VALUES
		(1,101),
		(1,102),
		(2,101),
		(3,103),
		(2,102),
		(2,103);
	
--  4.	Self-Referencing 

CREATE TABLE Teachers(
TeacherID INT PRIMARY KEY IDENTITY(101,1),
[Name] NVARCHAR(50) NOT NULL,
ManagerID INT FOREIGN KEY REFERENCES Teachers(TeacherID)
);

INSERT INTO Teachers([Name],ManagerID)
	VALUES
		('John',NULL),
		('Maya',106),
		('Silvia',106),
		('Ted',105),
		('Mark',101),
		('Greta',101)



SELECT * FROM Teachers

--Problem 5.	Online Store Database

CREATE TABLE ItemTypes(
ItemTypeID INT PRIMARY KEY,
[Name] VARCHAR(50)
);

CREATE TABLE Items(
ItemID INT PRIMARY KEY,
[Name] VARCHAR(50),
ItemTypeID INT FOREIGN KEY REFERENCES Itemtypes(ItemTypeID)
);

CREATE TABLE Cities(
CityID INT PRIMARY KEY,
[Name] VARCHAR(50)
);

CREATE TABLE Customers(
CustomerID INT PRIMARY KEY,
[Name] VARCHAR(50),
Birthday DATE,
CityID INT FOREIGN KEY REFERENCES Cities(CityID)
);

CREATE TABLE Orders(
OrderID INT PRIMARY KEY,
CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID)
);

CREATE TABLE OrderItems(
OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
ItemID INT FOREIGN KEY REFERENCES Items(ItemID),
PRIMARY KEY(OrderID,ItemID)
);


--6	University Database

CREATE TABLE Subjects(
SubjectID INT PRIMARY KEY,
SubjectName VARCHAR(50)
);

CREATE TABLE Majors(
MajorID INT PRIMARY KEY,
[Name] VARCHAR(50) NOT NULL
);

	--DROP TABLE StudentsExams
	--DROP TABLE Agenda

CREATE TABLE Students(
StudentID INT PRIMARY KEY,
StudentNumber VARCHAR(8) UNIQUE NOT NULL,
StudentName VARCHAR(50) NOT NULL,
MajorID INT FOREIGN KEY REFERENCES Majors(MajorID)
);

CREATE TABLE Payments(
PaymentID INT PRIMARY KEY,
PaymentDate DATE,
PaymentAmount DECIMAL(7,2) NOT NULL,
StudentID INT FOREIGN KEY REFERENCES Students(StudentID)
);

CREATE TABLE Agenda(
StudentID INT FOREIGN KEY REFERENCES Students(StudentID),
SubjectID INT FOREIGN KEY REFERENCES  Subjects(SubjectID),
PRIMARY KEY(StudentID,SubjectID)
);

-- 9.	*Peaks in Rila
-- MountainRange	PeakName	Elevation

USE  [Geography] 

SELECT MountainRange,PeakName,Elevation FROM Mountains
	JOIN  Peaks ON 
		 Mountains.Id = Peaks.MountainId
		WHERE MountainRange = 'Rila'
			ORDER BY Elevation DESC
	  

	
