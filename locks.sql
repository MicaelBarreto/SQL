DROP DATABASE IF EXISTS exercicio;

CREATE DATABASE exercicio;

USE exercicio;

CREATE TABLE Banco (
		Saldo FLOAT,
        Conta INTEGER NOT NULL,
        
        PRIMARY KEY(Conta)
);

INSERT INTO Banco VALUES (1200, 10);
INSERT INTO Banco VALUES (1300, 20);
INSERT INTO Banco VALUES (1400, 30);

BEGIN TRANSACTION T1;
SET autocommit = 0;
LOCK TABLES Banco WRITE;
UPDATE Banco
SET Saldo = ((SELECT Saldo FROM Banco WHERE Conta = 10) - 100)
WHERE Conta = 10;
UPDATE Banco
SET Saldo = ((SELECT Saldo FROM Banco WHERE Conta = 20) + 100)
WHERE Conta = 20;
COMMIT TRANSACTION T1;

BEGIN TRANSACTION T2;
SET autocommit = 0;
LOCK TABLES Banco WRITE;
UPDATE Banco
SET Saldo = ((SELECT Saldo FROM Banco WHERE Conta = 20) - 200)
WHERE Conta = 20;
UPDATE Banco
SET Saldo = ((SELECT Saldo FROM Banco WHERE Conta = 20) - 110)
WHERE Conta = 20;
UPDATE Banco
SET Saldo = ((SELECT Saldo FROM Banco WHERE Conta = 30) + 200)
WHERE Conta = 30;
COMMIT TRANSACTION T2;

BEGIN TRANSACTION T3;
SET autocommit = 0;
LOCK TABLES Banco WRITE;
UPDATE Banco
SET Saldo = ((SELECT Saldo FROM Banco WHERE Conta = 30) - 200)
WHERE Conta = 30;
UPDATE Banco
SET Saldo = ((SELECT Saldo FROM BanCO WHERE Conta = 10) + 200)
WHERE Conta = 10;
COMMIT TRANSACTION T3;

