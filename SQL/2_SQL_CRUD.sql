
USE SoftUni

--  2.	Find All Information About Departments

SELECT * FROM Departments;

--  3.	Find all Department Names

SELECT [Name] FROM Departments;

-- 4.  Find Salary of Each Employee

SELECT Firstname, LastName, Salary FROM Employees

-- 5.  Find Full Name of Each Employee

SELECT FirstName, MiddleName, LastName FROM Employees   

-- 6.  Find Email Address of Each Employee

SELECT FirstName + '.' + LastName + '@SoftUni.bg' AS [Full Email Address] FROM Employees 

-- 7.	Find All Different Employee’s Salaries 

SELECT Salary FROM Employees
GROUP BY Salary

SELECT DISTINCT Salary FROM Employees

-- 8. Find all Information About Employees

SELECT * FROM Employees
WHERE JobTitle = 'Sales Representative';

SELECT * FROM Employees
WHERE (Salary >= 20000 AND Salary <= 30000)

-- 10.	 Find Names of All Employees

SELECT FirstName + ' ' + MiddleName + ' ' + LastName AS FullName FROM Employees
WHERE Salary = 25000 OR Salary = 14000 OR Salary = 12500 OR Salary = 23600

--11.	 Find All Employees Without Manager

SELECT FirstName, LastName FROM Employees
WHERE ManagerID IS NULL;

-- 12.	 Find All Employees with Salary More Than 50000

SELECT FirstName, LastName, Salary FROM Employees
WHERE Salary > 50000
ORDER BY Salary DESC;

--13.	 Find 5 Best Paid Employees.

SELECT TOP(5) FirstName, LastName FROM Employees
ORDER BY Salary DESC;

-- 14.	Find All Employees Except Marketing
--SELECT * FROM Departments

SELECT FirstName, LastName FROM Employees
WHERE DepartmentID != 4;

	/* 15.	Sort Employees Table
	•	First by salary in decreasing order
	•	Then by first name alphabetically
	•	Then by last name descending
	•	Then by middle name alphabetically
	*/

	SELECT * FROM Employees
	ORDER BY Salary DESC, FirstName, LastName DESC, MiddleName;

-- 16.	Create View Employees with Salaries

	CREATE VIEW [V_EmployeesSalaries ] AS
	SELECT FirstName, LastName, Salary FROM Employees;

	--SELECT * FROM v_EmployeesSalary

--17.	Create View Employees with Job Titles
USE SoftUni
		GO
	CREATE VIEW V_EmployeeNameJobTitle AS
		SELECT CONCAT(FirstName,' ',MiddleName,' ',LastName) AS[Full Name],JobTitle FROM Employees

	
	--DROP VIEW V_EmployeeNameJobTitle;
	 
	 GO
	SELECT * FROM V_EmployeeNameJobTitle

--18.	 Distinct Job Titles

SELECT DISTINCT JobTitle FROM  Employees

 --19.	Find First 10 Started Projects

 SELECT TOP(10) [ProjectID],[Name],[Description],StartDate,EndDate FROM Projects
	ORDER BY StartDate,[Name]

 --20. Last 7 Hired Employees

 SELECT TOP(7) FirstName,LastName,HireDate FROM Employees
	ORDER BY HireDate DESC

	/*21.	Increase Salaries
	Write a SQL query to increase salaries of all employees that are in the Engineering, Tool Design,
	Marketing or Information Services department by 12%. 
	Then select Salaries column from the Employees table. After that exercise restore your database to revert those changes.
	*/

 UPDATE Employees
	SET Salary *= 1.12
		WHERE DepartmentID IN(1,2,4,11)

	SELECT Salary FROM Employees 

SELECT * FROM Employees
WHERE DepartmentID IN(1,2,4,11)
 
 USE DIABLO

 --25.	 All Diablo Characters

 SELECT [Name] FROM Characters
 ORDER BY [Name]