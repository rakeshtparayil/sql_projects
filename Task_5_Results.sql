-- CREATE TABLE Pieces (
--  Code INTEGER NOT NULL,
--  Name TEXT NOT NULL,
--  PRIMARY KEY (Code)
--  );
-- CREATE TABLE Providers (
--  Code VARCHAR(40) NOT NULL,  
--  Name TEXT NOT NULL,
-- PRIMARY KEY (Code) 
--  );
-- CREATE TABLE Provides (
--  Piece INTEGER, 
--  Provider VARCHAR(40), 
--  Price INTEGER NOT NULL,
--  PRIMARY KEY(Piece, Provider) 
--  );
 

-- INSERT INTO Providers(Code, Name) VALUES('HAL','Clarke Enterprises');
-- INSERT INTO Providers(Code, Name) VALUES('RBT','Susan Calvin Corp.');
-- INSERT INTO Providers(Code, Name) VALUES('TNBC','Skellington Supplies');

-- INSERT INTO Pieces(Code, Name) VALUES(1,'Sprocket');
-- INSERT INTO Pieces(Code, Name) VALUES(2,'Screw');
-- INSERT INTO Pieces(Code, Name) VALUES(3,'Nut');
-- INSERT INTO Pieces(Code, Name) VALUES(4,'Bolt');

-- INSERT INTO Provides(Piece, Provider, Price) VALUES(1,'HAL',10);
-- INSERT INTO Provides(Piece, Provider, Price) VALUES(1,'RBT',15);
-- INSERT INTO Provides(Piece, Provider, Price) VALUES(2,'HAL',20);
-- INSERT INTO Provides(Piece, Provider, Price) VALUES(2,'RBT',15);
-- INSERT INTO Provides(Piece, Provider, Price) VALUES(2,'TNBC',14);
-- INSERT INTO Provides(Piece, Provider, Price) VALUES(3,'RBT',50);
-- INSERT INTO Provides(Piece, Provider, Price) VALUES(3,'TNBC',45);
-- INSERT INTO Provides(Piece, Provider, Price) VALUES(4,'HAL',5);
-- INSERT INTO Provides(Piece, Provider, Price) VALUES(4,'RBT',7);



CREATE VIEW Full_Provider_Info AS
SELECT 
    Pieces.Code AS Piece_Code, 
    Pieces.Name AS Piece_Name, 
    Providers.Code AS Provider_Code, 
    Providers.Name AS Provider_Name, 
    Provides.Price
FROM Provides
JOIN Pieces ON Provides.Piece = Pieces.Code
JOIN Providers ON Provides.Provider = Providers.Code;

Select * From Full_Provider_Info;

-- 5.1 Select the name of all the pieces. 
SELECT Name FROM Pieces;

-- 5.2  Select all the providers' data. 
SELECT * FROM Providers;

-- 5.3 Obtain the average price of each piece (show only the piece code and the average price).
SELECT Piece_Name, Avg(Price) from Full_Provider_Info
GROUP BY Piece_Code;

-- 5.4  Obtain the names of all providers who supply piece 1.
SELECT Provider_Name from Full_Provider_Info
WHERE Piece_Code = 1;

-- 5.5 Select the name of pieces provided by the provider with code "HAL".
SELECT Piece_Name from Full_Provider_Info 
WHERE Provider_Code = 'HAL';

-- 5.6 Add an entry to the database to indicate that "Skellington Supplies" (code "TNBC") will provide sprockets (code "1") for 15 cents each.
INSERT INTO Provides (Piece, Provider, Price)
VALUES (1, 'TNBC', 0.15);


-- 5.7 For each piece, find the most expensive offering of that piece and include the piece name, provider name, and price 
SELECT 
    Piece_Name, 
    Provider_Name, 
    MAX(Price) AS Max_Price
FROM Full_Provider_Info
GROUP BY Piece_Name, Provider_Name
HAVING Price = (
    SELECT MAX(Price)
    FROM Full_Provider_Info AS FPI
    WHERE FPI.Piece_Name = Full_Provider_Info.Piece_Name
);

--(OPTIONAL: As there could be more than one provider who supply the same piece at the most expensive price, 
-- show all providers who supply at the most expensive price).
-- 5.8 Increase all prices by one cent.
-- 5.9 Update the database to reflect that "Susan Calvin Corp." (code "RBT") will not supply bolts (code 4).
-- 5.10 Update the database to reflect that "Susan Calvin Corp." (code "RBT") will not supply any pieces (the provider should still remain in the database).

