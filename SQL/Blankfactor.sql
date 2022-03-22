CREATE DATABASE BlankFactorEnterTest

USE BlankFactorEnterTest

create table Kids (
Id  Int Identity (1,1) primary key
,[First Name] varchar(100)
,[Last Name]  varchar(100)
,[Birth Date]  datetime
)

create table Toys (
Id  Int Identity (1,1)
,[Kid Id]  Int FOREIGN KEY REFERENCES Kids(Id)
,[Name] varchar(100)
,[Colour]  varchar(100)
)

delete from Kids
delete from Toys

INSERT INTO Kids ([First Name],[Last Name],[Birth Date])
Values
('Sam','Small',DATEADD(Month,- floor(rand() * 120),GetDate()))
,('Annie',null,'20180527')
,('Dave','Drei','20140325')
,('Ivan','Ivanov','20150517')
,('Brenda','Simon','20160315')
,('Samantha','Fox','20190715')
,('Diana','Ros','20160918')
,('Michael','Buble','20190410')
,('Bilbo','Baggins','20200125')
,('Rox','Mirers','20130411')
,('Frodo','Baggins','20150313')
,('Riana','Wober','20161115')
,('Marta',null,'20121230')

INSERT INTO Toys ([Kid Id],[Name],[Colour])
Values
('1','car','blue')
,('1','ball','red')
,('1','doll','blue')
,('2','truck','green')
,('2','car','red')
,('2','ball','green')
,('2','doll','blue')
,('3','car','green')
,('4','doll','red')
,('4','ball','blue')
,('5','ball','green')
,('6','truck','blue')
,('6','truck','red')
,('7','car','green')
,('2','car','green')
,('1','ball','blue')
,('1','car','red')
,('8','ball',null)



/*
Select full name (in one cell), Birth Date of all kids 3 years old and above
expected column list: Full Name( ex. "Sam Small"), Birth Date (ex. "2021-08-18" )
*/
SELECT CONCAT([First Name], ' ', [Last Name]) AS  [Full Name], FORMAT([Birth Date], 'yyyy-MM-dd') AS [Birth Date] FROM Kids
	WHERE (DATEDIFF(year, [Birth Date], GETDATE()) >= 3)

/*
Select all kids who have more than 2 blue toys
expected column list: Full Name( ex. "Sam Small"), Number of Blue Toys
*/
SELECT CONCAT([First Name], ' ', [Last Name]) AS  [Full Name], COUNT(*) AS [Number of Blue]  FROM  Kids
	JOIN [Toys] ON Toys.[Kid Id] = Kids.Id
	WHERE(Toys.Colour = 'blue')
	GROUP BY Kids.[First Name], Kids.[Last Name]
HAVING COUNT(*) >2

/*
Select all kids under 5 years of age who have more than 1 toy
expected column list: Full Name( ex. "Sam Small"), Birth Date  (ex. "2021-08-18" ), Number of Toys
*/
 SELECT CONCAT([First Name], ' ', [Last Name]) AS  [Full Name], FORMAT([Birth Date], 'yyyy-MM-dd') AS [Birth Date], COUNT(*) AS [Number of Toys]  FROM Kids
	JOIN [Toys] ON Toys.[Kid Id] = Kids.Id
	WHERE (DATEDIFF(year, [Birth Date], GETDATE()) < 5)
	GROUP BY Kids.[First Name], Kids.[Last Name], Kids.[Birth Date]
HAVING COUNT(*) > 1

/*
Select all kids with no toys at all
expected column list: Full Name( ex. "Sam Small")
*/
SELECT CONCAT([First Name], ' ', [Last Name]) AS  [Full Name] FROM [Kids]
	LEFT JOIN [Toys] ON Toys.[Kid Id] = Kids.Id
	WHERE Toys.Id IS NULL

/*
Select all kids having birthday in April
expected column list: Full Name( ex. "Sam Small"), Birth Date  (ex. "2021-08-18" )
*/
SELECT CONCAT([First Name], ' ', [Last Name]) AS  [Full Name], FORMAT([Birth Date], 'yyyy-mm-dd') AS [Birth Date] FROM Kids
	WHERE MONTH(Kids.[Birth Date]) = 4

/*
Select all the kids with the highest number of toys (if more than one show all of them)
expected column list: Kid id, Full Name( ex. "Sam Small"), Number of toys
*/

SELECT	[Kid id], [Full Name], [Number of toys]
	FROM 
		(SELECT 
			Kids.Id AS [Kid id],
			CONCAT([First Name], ' ', [Last Name]) AS  [Full Name], 
			COUNT(Toys.Id) AS [Number of toys],
			DENSE_RANK() OVER(ORDER BY COUNT(Toys.Id) DESC) AS [Ranking]
		FROM Kids
	JOIN [Toys] ON Toys.[Kid Id] = Kids.Id
	GROUP BY Kids.Id, Kids.[First Name], Kids.[Last Name]) AS [kidsgroup]
WHERE Ranking = 1


/*
Select all kids ordered by toy count if two kids has same number of toys their names should be in one cell separated by comma
we need just an idea how this could be achieved (don't spent much time on this will be discussed)
*/
SELECT STRING_AGG([Full Name], ', ') AS [Names], [Toys Count] FROM
(SELECT CONCAT([First Name], ' ', [Last Name]) AS  [Full Name], COUNT(*) AS [Toys Count] FROM Toys AS t
	JOIN Kids AS k ON t.[Kid Id] = K.Id
	GROUP BY k.[First Name],k.[Last Name]) AS [ToysCounted]
	GROUP BY [Toys Count]
ORDER BY [Toys Count] DESC