--Exercises: Joins, Subqueries, CTE and Indices

--1.	Employee Address

USE SoftUni

SELECT	TOP(5) EmployeeID, JobTitle, Employees.AddressID, AddressText  FROM Employees	
	JOIN Addresses ON Employees.AddressID = Addresses.AddressID
ORDER BY Addresses.AddressID;

--2.	Addresses with Towns

SELECT TOP(50) FirstName, LastName, Towns.Name, AddressText FROM Employees
	JOIN Addresses ON Employees.AddressID = Addresses.AddressID
		JOIN Towns ON Towns.TownID = Addresses.TownID
	ORDER BY FirstName,LastName;

--3.	Sales Employee

SELECT EmployeeID, FirstName, LastName, Departments.Name FROM Employees
	JOIN Departments ON Departments.DepartmentID = Employees.DepartmentID
		WHERE Departments.Name = 'Sales'
	ORDER BY EmployeeID;

-- 4.	Employee Departments

SELECT TOP(5) EmployeeID, FirstName, Salary, Departments.Name FROM Employees
	JOIN Departments ON Departments.DepartmentID = Employees.DepartmentID
		WHERE Salary > 15000
	ORDER BY Employees.DepartmentID;

--5.	Employees Without Project

--SELECT Employees.EmployeeID, FirstName FROM EmployeesProjects 
--	JOIN Employees ON Employees.EmployeeID = EmployeesProjects.EmployeeID
--		JOIN Projects ON Projects.ProjectID = EmployeesProjects.ProjectID
--		WHERE COUNT = 0

SELECT TOP(3) Employees.EmployeeID, FirstName FROM  Employees	
	LEFT JOIN EmployeesProjects ON EmployeesProjects.EmployeeID = Employees.EmployeeID
		WHERE ProjectID IS NULL
	ORDER BY EmployeeID;
	
--6.	Employees Hired After

SELECT FirstName, LastName, HireDate, Departments.Name FROM Employees
	JOIN Departments ON Departments.DepartmentID = Employees.DepartmentID
		WHERE HireDate > '1999-01-01' AND Departments.Name IN('Sales','Finance')
	ORDER BY HireDate;

--7.	Employees with Project

	SELECT TOP(5) Employees.EmployeeID, FirstName, Projects.Name FROM EmployeesProjects 
		JOIN Employees ON Employees.EmployeeID = EmployeesProjects.EmployeeID
		JOIN Projects ON Projects.ProjectID = EmployeesProjects.ProjectID
			WHERE StartDate > '2002-08-13' AND EndDate IS NULL
		ORDER BY EmployeeID;

--8.	Employee 24

SELECT Employees.EmployeeID, FirstName, 
	CASE
		WHEN  YEAR(StartDate) >= 2005 THEN NULL 
		ELSE Projects.Name
	END AS ProjectName
	FROM EmployeesProjects 
		JOIN Employees ON Employees.EmployeeID = EmployeesProjects.EmployeeID
		JOIN Projects ON Projects.ProjectID = EmployeesProjects.ProjectID
	WHERE Employees.EmployeeID = 24;

--9.	Employee Manager

SELECT e.EmployeeID, e.FirstName, m.EmployeeID, m.FirstName FROM Employees AS e
	JOIN Employees AS m ON e.ManagerID = m.EmployeeID 
		WHERE m.EmployeeID IN(3,7)
	ORDER BY E.EmployeeID;
			
--10. Employee Summary

SELECT	TOP(50) e.EmployeeID, (e.FirstName +' '+ e.LastName) AS EmployeeName,
	(m.FirstName +' '+ m.LastName) AS ManagerName, 
	Departments.Name 
FROM Employees AS e
	JOIN Employees AS m ON e.ManagerID = m.EmployeeID 
	JOIN Departments ON Departments.DepartmentID = e.DepartmentID
ORDER BY e.EmployeeID;

--11. Min Average Salary

SELECT TOP(1) (SELECT AVG(Salary) FROM Employees 
	WHERE Employees.DepartmentID = Departments.DepartmentID) AS MinAverageSalary 
FROM Departments
ORDER BY MinAverageSalary;

--12. Highest Peaks in Bulgaria
USE [Geography];

SELECT c.CountryCode, MountainRange, PeakName, Elevation FROM Countries AS c
	JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode 
	JOIN Mountains AS M ON mc.MountainId = M.Id 
	JOIN Peaks AS p on m.Id = p.MountainId
		WHERE CountryName = 'Bulgaria' /*AND Elevation > 2835*/
	ORDER BY Elevation DESC

--13. Count Mountain Ranges

SELECT c.CountryCode,(SELECT COUNT(MountainId) FROM MountainsCountries AS mc
	WHERE mc.CountryCode = c.CountryCode) AS MountainRanges
FROM  Countries AS c
	WHERE C.CountryCode IN('BG','RU','US');

--14. Countries with Rivers
	
SELECT TOP(5) CountryName, RiverName FROM Countries AS c
	LEFT JOIN CountriesRivers AS cr ON c.CountryCode = cr.CountryCode
	LEFT JOIN Rivers AS r ON cr.RiverId = r.Id
		WHERE C.ContinentCode = 'AF'
	ORDER BY CountryName;

--15.  Continents and Currencies

SELECT ContinentCode, CurrencyCode, CurrencyUsageCount AS CurrencyUsage FROM
	(SELECT ContinentCode,	CurrencyCode, CurrencyUsageCount,
	DENSE_RANK() 
		OVER (PARTITION BY ContinentCode ORDER BY CurrencyUsageCount DESC) AS [Ranking]
		FROM (SELECT ContinentCode, CurrencyCode, COUNT(CurrencyCode) AS [CurrencyUsageCount]
		FROM Countries
		GROUP BY ContinentCode, CurrencyCode) AS [AllCurrencyUsage]
			WHERE CurrencyUsageCount > 1) AS [CurrencyRank]
			WHERE Ranking = 1
		ORDER BY ContinentCode;




--16.	Countries without any Mountains

SELECT COUNT(*) FROM Countries c
	LEFT JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
	WHERE mc.CountryCode IS NULL

-- 17.	Highest Peak and Longest River by Country

SELECT TOP(5) CountryName, Elevation, [Length] FROM
	(SELECT CountryName, p.Elevation, p.PeakName, r.Length,
		DENSE_RANK() OVER
			(PARTITION BY CountryName ORDER BY p.Elevation DESC, r.Length DESC) AS Ranking
		FROM Countries AS c
			JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
			JOIN Mountains AS m ON mc.MountainId = M.Id
			JOIN Peaks AS p ON mc.MountainId = p.MountainId
			JOIN CountriesRivers AS cr ON c.CountryCode = cr.CountryCode
			JOIN Rivers AS r ON cr.RiverId = r.Id) AS TableWithRanking
		WHERE Ranking = 1
		ORDER BY Elevation DESC, [Length] DESC,CountryName

-- 18.	* Highest Peak Name and Elevation by country


	
	SELECT TOP(5) CountryName,  
	CASE
		WHEN PeakName IS NULL THEN '(no highest peak)'
		ELSE PeakName 
	END AS [Highest Peak Name],
		CASE 
			WHEN Elevation IS NULL THEN 0
			ELSE Elevation
		END AS [Highest Peak Elevation],
			CASE
				WHEN MountainRange IS NULL THEN '(no mountain)'
				ELSE MountainRange
			END
				FROM 
					(SELECT CountryName, PeakName, Elevation, MountainRange,
						DENSE_RANK() OVER
							(PARTITION BY CountryName ORDER BY Elevation DESC) AS Ranking
						FROM Countries AS c
								LEFT JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
								LEFT JOIN Mountains AS m ON mc.MountainId = M.Id
								LEFT JOIN Peaks AS p ON mc.MountainId = p.MountainId) AS QueriForRanking
							WHERE Ranking = 1
							ORDER BY CountryName, [Highest Peak Name]
-- 	
