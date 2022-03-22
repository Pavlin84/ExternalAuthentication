

--Problem 1. Employees with Salary Above 35000
USE SoftUni;

CREATE OR ALTER PROC usp_GetEmployeesSalaryAbove35000 
AS
BEGIN
SELECT FirstName, LastName FROM Employees
	WHERE Salary > 35000;
END
GO

EXEC usp_GetEmployeesSalaryAbove35000;

--Problem 2. Employees with Salary Above Number

CREATE PROC usp_GetEmployeesSalaryAboveNumber (@number DECIMAL(18,4))
AS 
SELECT FirstName, LastName FROM Employees
	WHERE Salary >= @number;
GO


EXECUTE usp_GetEmployeesSalaryAboveNumber 48100;

--Problem 3. Town Names Starting With

CREATE PROCEDURE usp_GetTownsStartingWith(@startName varchar(20))
AS
	SELECT t.Name FROM Towns AS t
			WHERE LEFT(t.Name, LEN(@startName)) = @startName;
			

EXEC usp_GetTownsStartingWith 'b';

--Problem 4. Employees from Town

CREATE PROCEDURE usp_GetEmployeesFromTown (@townName VARCHAR(50))
AS
	SELECT FirstName, LastName FROM Employees AS e
		JOIN Addresses AS a ON e.AddressID = a.AddressID
		JOIN Towns AS t ON a.TownID = t.TownID
		WHERE t.Name = @townName;

GO

EXECUTE usp_GetEmployeesFromTown'Sofia';

--Problem 5. Salary Level Function

CREATE FUNCTION ufn_GetSalaryLevel(@salary DECIMAL(18,4)) 
RETURNS VARCHAR(10)
AS
	BEGIN
		DECLARE @salaryScale VARCHAR(10)

	  IF (@salary IS NULL) 
		SET @salaryScale = NULL
	  ELSE IF (@salary < 30000)   
		SET @salaryScale='Low'
	  ELSE IF (@salary <= 50000 ) 
		SET @salaryScale = 'Average'
	  ELSE
		SET @salaryScale = 'High'
	  RETURN @salaryScale
	END


SELECT FirstName,Salary, dbo.ufn_GetSalaryLevel(Salary) AS SalaryLevel FROM Employees

--Problem 6. Employees by Salary Level

CREATE PROCEDURE usp_DeleteEmployeesFromDepartment (@departmentId INT)
	AS
	DELETE EmployeesProjects
		WHERE EmployeeID IN (SELECT EmployeeID FROM Employees WHERE DepartmentID = @departmentId);

	UPDATE Employees
	SET ManagerID = NULL
		WHERE ManagerID IN (SELECT EmployeeID FROM Employees WHERE DepartmentID = @departmentId);

	ALTER TABLE Departments
		ALTER COLUMN ManagerID INT;

	UPDATE Departments
		SET ManagerID = NULL
		WHERE ManagerID IN (SELECT EmployeeID FROM Employees WHERE DepartmentID = @departmentId);

	DELETE Employees
		WHERE EmployeeID IN (SELECT EmployeeID FROM Employees WHERE DepartmentID = @departmentId);

	DELETE Departments
		WHERE DepartmentID = @departmentId;

	SELECT COUNT(*) FROM Employees 
		WHERE DepartmentID = @departmentId

--Problem 9. Find Full Name
USE Bank

CREATE PROCEDURE usp_GetHoldersFullName 
	AS 
	SELECT (FirstName +' '+ LastName) AS FullName FROM [AccountHolders]