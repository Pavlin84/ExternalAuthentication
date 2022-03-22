
--Problem 14. Create Table Logs

USE Bank

CREATE TABLE Logs(
LogId INT PRIMARY KEY IDENTITY,
AccountId INT FOREIGN KEY REFERENCES Accounts(Id) NOT NULL,
OldSum MONEY,
NewSum MONEY
);

CREATE TRIGGER tr_AccountChanges ON Accounts FOR UPDATE
	AS
	INSERT INTO Logs(AccountId, OldSum, NewSum)
	SELECT i.Id, d.Balance, i.Balance 
	FROM inserted AS i
	JOIN deleted AS d ON i.Id = d.Id
	GO


SELECT * FROM Logs
SELECT * FROM Accounts

UPDATE Accounts
SET Balance = 2000
WHERE Id% 2 = 0

-- Problem 15. Create Table Emails

CREATE TABLE NotificationEmails(
Id INT PRIMARY KEY IDENTITY,
Recipient INT NOT NULL,
[Subject] VARCHAR(60), 
Body VARCHAR(80) );

CREATE TRIGGER tr_NotificationEmails ON Logs FOR INSERT
	AS
	INSERT INTO NotificationEmails(Recipient, [Subject], Body)
	SELECT AccountId, CONCAT('Balance change for account: ',AccountId), CONCAT('On ', FORMAT(GETDATE(),'MMM dd yyyy HH:mm tt'), ' your balance was changed from ', OldSum, ' to ', NewSum)
		FROM Logs
	GO
SELECT * FROM NotificationEmails;

--Problem 16. Deposit Money

CREATE PROCEDURE usp_DepositMoney (@AccountId INT, @MoneyAmount MONEY)
AS
BEGIN TRANSACTION
DECLARE @curentAcountId INT = (SELECT Id FROM Accounts WHERE Id = @AccountId)

IF @MoneyAmount < 0
	BEGIN
		ROLLBACK
		RAISERROR ('Invalid amount', 16,1);
		RETURN
	END
IF @curentAcountId IS NULL
	BEGIN
		ROLLBACK
		RAISERROR ('Account not exist', 16,1)
		RETURN
	END
	UPDATE Accounts
	SET Balance += @MoneyAmount
	WHERE ID = @AccountId
COMMIT

GO

SELECT * FROM Accounts
EXEC usp_DepositMoney 3,200

--Problem 17. Withdraw Money

CREATE PROCEDURE  usp_WithdrawMoney (@AccountId INT, @MoneyAmount MONEY) 
AS
BEGIN TRANSACTION
DECLARE @currentAcount INT = (SELECT Id FROM Accounts WHERE Id = @AccountId)
DECLARE @accountBalance MONEY = (SELECT Balance FROM Accounts WHERE Id = @AccountId)
IF @currentAcount IS NULL
	BEGIN
		ROLLBACK
		RAISERROR('Account not exist', 16,1)
		RETURN
	END
ELSE IF @MoneyAmount < 0
	BEGIN
		ROLLBACK
		RAISERROR('Invalid amount',16,1)
	END
ELSE IF @MoneyAmount > @accountBalance
	BEGIN
	  ROLLBACK
	  RAISERROR('Not Enought money', 16, 1)
	  RETURN
	END
UPDATE Accounts
SET Balance -= @MoneyAmount
	WHERE ID = @AccountId
COMMIT

--Problem 18. Money Transfer

CREATE PROCEDURE usp_TransferMoney(@SenderId INT, @ReceiverId INT, @Amount MONEY) 
	AS
	BEGIN TRANSACTION
	EXECUTE usp_WithdrawMoney @SenderId, @Amount;
	EXECUTE usp_DepositMoney @ReceiverId, @Amount;
	COMMIT

SELECT * FROM Accounts
EXECUTE usp_TransferMoney 1, 2, 700


-----

CREATE PROCEDURE usp_DepositMoneytTwo (@AccountId INT, @MoneyAmount MONEY)
AS
BEGIN TRANSACTION
		DECLARE @CurentAcount INT = (SELECT Id FROM Accounts WHERE (Id = @AccountId))
	IF @CurentAcount IS NULL
		BEGIN
		ROLLBACK
		RAISERROR('Acount not exist', 16, 1)
		RETURN
		END
	IF @MoneyAmount <= 0
		BEGIN
		ROLLBACK
		RAISERROR('Invalid Amount', 16, 1)
		END
	UPDATE Accounts
	SET Balance += @MoneyAmount
	WHERE Id =  @AccountId
COMMIT
GO

CREATE PROCEDURE usp_WithdrawMoneTWO (@AcountId INT, @MoneyAmound MONEY)
AS
BEGIN TRANSACTION
	DECLARE @CurentAcound INT =(SELECT Id FROM Accounts WHERE (Id = @AcountId))
	DECLARE @CurentBalance INT =(SELECT Balance FROM Accounts WHERE (Id = @AcountId)) 
		IF @CurentAcound IS NULL
		BEGIN
		ROLLBACK
		RAISERROR('Acount not exist', 16, 1)
		RETURN
		END
	IF @MoneyAmound <= 0
		BEGIN
		ROLLBACK
		RAISERROR('Invalid Amount', 16, 1)
		RETURN
		END
	IF @CurentBalance < @MoneyAmound
		BEGIN
		ROLLBACK
		RAISERROR('Have not enough money',16, 1)
		RETURN
		END
	UPDATE Accounts
	SET Balance -= @MoneyAmound
	WHERE (Id = @AcountId)
COMMIT

CREATE PROCEDURE usp_TransferMoneyTwo(@Sender INT, @Reciver INT, @Amount MONEY)
	AS
	BEGIN TRANSACTION
	EXECUTE usp_WithdrawMoneTWO @Sender, @Amount
	EXECUTE usp_DepositMoneytTwo @Reciver, @Amount
	COMMIT

SELECT * FROM Accounts

EXECUTE usp_TransferMoneyTwo 4,332, -2000