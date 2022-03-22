
-- 1.	Find Names of All Employees by First Name
USE SoftUni

SELECT FirstName, LastName FROM Employees
WHERE FirstName LIKE 'SA%';

-- 2.  Find Names of All employees by Last Name 

SELECT FirstName, LastName FROM Employees
WHERE LastName LIKE '%ei%';

-- 3.	Find First Names of All Employees

SELECT FirstName FROM Employees
	WHERE (DepartmentID = 3 OR DepartmentID = 10) AND YEAR(HireDate) BETWEEN 1995 AND 2005;

-- 4.	Find All Employees Except Engineers

SELECT FirstName,LastName FROM Employees
	WHERE JobTitle NOT LIKE '%engineer%';

--5. 	Find Towns with Name Length

SELECT Name FROM Towns
WHERE LEN(Name) BETWEEN 5 AND 6
ORDER BY Name;

-- 6.	 Find Towns Starting With
SELECT * FROM Towns
WHERE Name LIKE '[MKBE]%'
ORDER BY Name;

-- 7.	Find Towns Not Starting With

SELECT * FROM Towns
WHERE Name LIKE '[^RBD]%'
ORDER BY Name;

-- 8.	Create View Employees Hired After 2000 Year

CREATE VIEW  V_EmployeesHiredAfter2000 AS
	SELECT FirstName, LastName FROM Employees
		WHERE YEAR(HireDate) > 2000;

SELECT * FROM V_EmployeesHiredAfter2000;

-- 9.	Length of Last Name

SELECT FirstName,LastName FROM Employees
	WHERE LEN(LastName) = 5;

--10. Rank Employees by Salary
--11.	Find All Employees with Rank 2 *

SELECT * FROM (SELECT EmployeeID, FirstName,LastName,Salary, DENSE_RANK() OVER(PARTITION BY Salary ORDER BY EmployeeID ) AS [Rank]  FROM Employees
	WHERE (Salary BETWEEN 10000 AND 50000)) AS RankTable
		WHERE [Rank] = 2
			ORDER BY Salary DESC;

-- 12.	Countries Holding ‘A’ 3 or More Times

USE Geography

SELECT CountryName, IsoCode FROM Countries
WHERE CountryName LIKE '%a%a%a%'
ORDER BY IsoCode;

-- 13.	 Mix of Peak and River Names
USE Geography

SELECT PeakName, RiverName, LOWER (CONCAT(PeakName,SUBSTRING(RiverName,2,(LEN(RiverName)-1)))) AS Mix FROM Peaks, Rivers
WHERE RIGHT(PeakName,1) = LEFT(RiverName,1)
ORDER BY Mix

-- 14.	Games from 2011 and 2012 year

USE Diablo

SELECT TOP 50 [Name],FORMAT([Start], 'yyyy-MM-dd') AS Start FROM Games
WHERE(YEAR([Start]) BETWEEN 2011 AND 2012)
ORDER BY [Start]

-- 15.	 User Email Providers

SELECT Username, SUBSTRING(
	Email,
	(CHARINDEX('@',Email) + 1),
	(LEN(Email) - CHARINDEX('@',Email))) AS [Email Provider] 
	FROM Users
		ORDER BY [Email Provider], Username

-- 16.	 Get Users with IPAdress Like Pattern

SELECT Username,IpAddress FROM Users
	WHERE IpAddress LIKE '___.1_%._%.___'
		ORDER BY Username;

--17.  Show All Games with Duration and Part of the Day

SELECT [Name],
	CASE 
		WHEN DATEPART(HOUR,[Start]) BETWEEN 0 AND 11 THEN 'Morning'
		WHEN DATEPART(HOUR,[Start]) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS [Part of the Day],
		CASE
			WHEN Duration <= 3 THEN ' Extra Short'
			WHEN Duration >3 AND Duration <= 6 THEN 'Short'
			WHEN Duration > 6 THEN 'Long'
			ELSE 'Extra Long'
		END AS Duration
			FROM Games
				ORDER BY [Name],/*Games.*/Duration,[Part of the Day];

-- 18.	 Orders Table

USE Orders

SELECT ProductName,OrderDate,
	DATEADD(DAY,3,OrderDate) AS [Pay Due],
	DATEADD(MONTH,1,OrderDate) As [Deliver Due]
		FROM Orders;

-- 19.	 People Table
USE Demo

CREATE TABLE PeopleBirthday(
Id INT PRIMARY KEY,
[Name] VARCHAR(50),
BirthdayDate DATETIME2
);

SELECT *,
	DATEDIFF(YEAR,BirthdayDate,GETDATE()) AS [Age in Year], 
	DATEDIFF(MONTH,BirthdayDate,GETDATE()) AS [Age in Months],
	DATEDIFF(HOUR,BirthdayDate,GETDATE()) AS [Age in Hours],
	DATEDIFF(MINUTE,BirthdayDate,GETDATE()) AS [Age in Minutes] 
		FROM PeopleBirthday
