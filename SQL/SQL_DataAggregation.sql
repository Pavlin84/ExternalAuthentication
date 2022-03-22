
--Problem 1.	Records’ Count

USE Gringotts

SELECT COUNT(*) AS [Count] FROM WizzardDeposits;

--Problem 2.	Longest Magic Wand

SELECT MAX(MagicWandSize) AS [LongestMagicWand] FROM WizzardDeposits;

--Problem 3.	Longest Magic Wand per Deposit Groups

SELECT DepositGroup, MAX(MagicWandSize) AS [LongestMagicWand] FROM WizzardDeposits
GROUP BY DepositGroup;

--Problem 4.	* Smallest Deposit Group per Magic Wand Size

SELECT TOP(2) DepositGroup FROM WizzardDeposits
GROUP BY DepositGroup
ORDER BY AVG(MagicWandSize);

--Problem 5.	Deposits Sum

SELECT DepositGroup, SUM(DepositAmount) AS [TotalSum] FROM WizzardDeposits
	GROUP BY DepositGroup;

--Problem 6.	Deposits Sum for Ollivander Family

SELECT DepositGroup,SUM(DepositAmount) AS [TotalSum] FROM WizzardDeposits
	WHERE MagicWandCreator = 'Ollivander family'
		GROUP BY DepositGroup
		--HAVING SUM(DepositAmount) < 150000
		--ORDER BY TotalSum DESC;

--Problem 7.	Deposits Filter

SELECT DepositGroup,SUM(DepositAmount) AS [TotalSum] FROM WizzardDeposits
	WHERE MagicWandCreator = 'Ollivander family'
		GROUP BY DepositGroup
		HAVING SUM(DepositAmount) < 150000
		ORDER BY TotalSum DESC;

--Problem 8.	 Deposit Charge

SELECT DepositGroup,MagicWandCreator, MIN(DepositCharge) AS [MinDepositCharge] FROM WizzardDeposits
	GROUP BY DepositGroup, MagicWandCreator	
	ORDER BY MagicWandCreator, DepositGroup;
	
--Problem 9.	Age Groups
SELECT AgeGroup , COUNT(*) AS [WizardCount] FROM
	(SELECT 
		CASE
			WHEN Age <= 10 THEN '[0-10]'
			WHEN Age BETWEEN 11 AND 20 THEN '[11-20]' 
			WHEN Age BETWEEN 21 AND 30 THEN '[21-30]' 
			WHEN Age BETWEEN 31 AND 40 THEN '[31-40]' 
			WHEN Age BETWEEN 41 AND 50 THEN '[41-50]' 
			WHEN Age BETWEEN 51 AND 60 THEN '[51-60]' 
			ELSE '[61+]'
		END AS [AgeGroup], *
	FROM WizzardDeposits) AS [AgeGroupTable]
	GROUP BY AgeGroup;

--Problem 10.	First Letter

SELECT LEFT (FirstName,1) AS [FirstLetter] FROM WizzardDeposits
	WHERE DepositGroup = 'Troll Chest'
	GROUP BY LEFT (FirstName,1);

-- Problem 11.	Average Interest 

SELECT DepositGroup, IsDepositExpired, AVG(DepositInterest) FROM WizzardDeposits
	WHERE DepositStartDate > '1985-01-01'
	GROUP BY DepositGroup, IsDepositExpired
ORDER BY DepositGroup DESC, IsDepositExpired;

--Problem 12.	* Rich Wizard, Poor Wizard

SElECT SUM(FirstAmount - SecondAmount) FROM
		(SELECT fw.Id, fw.DepositAmount AS [FirstAmount], sw.DepositAmount AS [SecondAmount] FROM WizzardDeposits AS fw
			JOIN WizzardDeposits AS sw ON fw.Id+1 = sw.Id) AS [IntermidiatQuery]

--Problem 13.	Departments Total Salaries
USE SoftUni

SELECT DepartmentID, SUM(Salary) AS [TotalSalary] FROM Employees	
	GROUP BY DepartmentID

--Problem 14.	Employees Minimum Salaries

SELECT DepartmentID, MIN(Salary) AS [MinimumSalary] FROM Employees	
	WHERE DepartmentID IN(2,5,7) AND HireDate > '2000-01-01'
	GROUP BY DepartmentID

--Problem 15.	Employees Average Salaries

SELECT * INTO EmploueWithBigSalary FROM Employees
	WHERE Salary > 30000;

DELETE FROM EmploueWithBigSalary
	WHERE ManagerID = 42;

UPDATE EmploueWithBigSalary
	SET Salary += 5000
	WHERE DepartmentID = 1;

--SELECT * FROM Employees
--	WHERE DepartmentID = 1;

SELECT DepartmentID, AVG(Salary) AS [AverageSalary] FROM EmploueWithBigSalary	
	GROUP BY DepartmentID;

--Problem 16.	Employees Maximum Salaries

SELECT DepartmentID, MAX(Salary) AS [MaxSalary] FROM Employees	
	GROUP BY DepartmentID
	HAVING MAX(Salary) < 30000 OR MAX(Salary)> 70000;

--Problem 17.	Employees Count Salaries

SELECT COUNT(*) FROM Employees
	WHERE ManagerID IS NULL;

--Problem 18.	*3rd Highest Salary
SELECT DepartmentID, Salary FROM
		(SELECT DepartmentID, Salary,
				DENSE_RANK()
					OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS [Ranking]
				FROM Employees) AS [RankingQuery]
				WHERE Ranking = 3
				GROUP BY DepartmentID, Salary
--Problem 19. **Salary Challenge

CREATE VIEW V_AverageSalary AS
	SElECT DepartmentID,AVG(Salary) AS [AverageSalary] FROM Employees
		GROUP BY DepartmentID
GO

--SELECT TOP(10) FirstName, LastName, e.DepartmentID FROM Employees AS e
--	JOIN V_AverageSalary AS avs ON e.DepartmentID = avs.DepartmentID
--		WHERE E.Salary > avs.AverageSalary
--		ORDER BY DepartmentID;

SELECT TOP(10) FirstName, LastName, e.DepartmentID FROM Employees AS e
	JOIN
	(SElECT DepartmentID,AVG(Salary) AS [AverageSalary] FROM Employees
		GROUP BY DepartmentID) AS avs 
	ON e.DepartmentID = avs.DepartmentID
		WHERE E.Salary > avs.AverageSalary
		ORDER BY DepartmentID;