-- CREATE TABLE Warehouses (
--    Code INTEGER NOT NULL,
--    Location VARCHAR(255) NOT NULL ,
--    Capacity INTEGER NOT NULL,
--    PRIMARY KEY (Code)
--  );
-- CREATE TABLE Boxes (
--     Code CHAR(4) NOT NULL,
--     Contents VARCHAR(255) NOT NULL ,
--     Value REAL NOT NULL ,
--     Warehouse INTEGER NOT NULL,
--     PRIMARY KEY (Code)
--  );
 
--  INSERT INTO Warehouses(Code,Location,Capacity) VALUES(1,'Chicago',3);
--  INSERT INTO Warehouses(Code,Location,Capacity) VALUES(2,'Chicago',4);
--  INSERT INTO Warehouses(Code,Location,Capacity) VALUES(3,'New York',7);
--  INSERT INTO Warehouses(Code,Location,Capacity) VALUES(4,'Los Angeles',2);
--  INSERT INTO Warehouses(Code,Location,Capacity) VALUES(5,'San Francisco',8);
 
--  INSERT INTO Boxes(Code,Contents,Value,Warehouse) VALUES('0MN7','Rocks',180,3);
--  INSERT INTO Boxes(Code,Contents,Value,Warehouse) VALUES('4H8P','Rocks',250,1);
--  INSERT INTO Boxes(Code,Contents,Value,Warehouse) VALUES('4RT3','Scissors',190,4);
--  INSERT INTO Boxes(Code,Contents,Value,Warehouse) VALUES('7G3H','Rocks',200,1);
--  INSERT INTO Boxes(Code,Contents,Value,Warehouse) VALUES('8JN6','Papers',75,1);
--  INSERT INTO Boxes(Code,Contents,Value,Warehouse) VALUES('8Y6U','Papers',50,3);
--  INSERT INTO Boxes(Code,Contents,Value,Warehouse) VALUES('9J6F','Papers',175,2);
--  INSERT INTO Boxes(Code,Contents,Value,Warehouse) VALUES('LL08','Rocks',140,4);
--  INSERT INTO Boxes(Code,Contents,Value,Warehouse) VALUES('P0H6','Scissors',125,1);
--  INSERT INTO Boxes(Code,Contents,Value,Warehouse) VALUES('P2T6','Scissors',150,2);
--  INSERT INTO Boxes(Code,Contents,Value,Warehouse) VALUES('TU55','Papers',90,5);


--3.1 Select all warehouses.
SELECT * from Warehouses;

--3.2 Select all boxes with a value larger than $150.
SELECT * FROM Boxes WHERE Value > 150;

--3.3 Select all distinct contents in all the boxes.
SELECT DISTINCT Contents FROM Boxes;

--3.4 Select the average value of all the boxes.
SELECT AVG(Value)FROM Boxes;

--3.5 Select the warehouse code and the average value of the boxes in each warehouse.
SELECT Warehouse, AVG(Value)
from Boxes
GROUP BY Warehouse;

--3.6 Same as previous exercise, but select only those warehouses where the average value of the boxes is greater than 150.
SELECT Warehouse, AVG(Value)
from Boxes
GROUP BY Warehouse
HAVING AVG(Value) > 150;


--3.7 Select the code of each box, along with the name of the city the box is located in.
SELECT Boxes.Code, Warehouses.Location
FROM Boxes
INNER JOIN Warehouses ON Boxes.Warehouse = Warehouses.Code;

--3.8 Select the warehouse codes, along with the number of boxes in each warehouse. 
SELECT Warehouses.Code, COUNT(Boxes.Code) AS BoxCount
FROM Warehouses
INNER JOIN Boxes ON Boxes.Warehouse = Warehouses.Code
GROUP BY Warehouses.Code;


--3.9 Select the codes of all warehouses that are saturated (a warehouse is saturated if the number of boxes in it is larger than the warehouse's capacity).
SELECT Boxes.Warehouse, Warehouses.Capacity, COUNT(Boxes.Code) AS number_of_boxes
FROM Warehouses 
JOIN Boxes
ON Warehouses.Code=Boxes.Warehouse
GROUP BY Boxes.Warehouse, Warehouses.Capacity
HAVING Warehouses.Capacity < COUNT(Boxes.Code)
ORDER BY Boxes.Warehouse;

--3.10 Select the codes of all the boxes located in Chicago.
SELECT Boxes.Code
FROM Boxes
JOIN Warehouses ON Warehouses.Code=Boxes.Warehouse
WHERE Warehouses.Location = 'Chicago';


--3.11 Create a new warehouse in New York with a capacity for 3 boxes.
INSERT INTO Warehouses
VALUES (6,'New York',3);

--3.12 Create a new box, with code "H5RT", containing "Papers" with a value of $200, and located in warehouse 2.
INSERT INTO Boxes
VALUES ('H5RT','Papers',200,2);

--3.13 Reduce the value of all boxes by 15%.
UPDATE Boxes
SET VALUE = Value * 0.85;

--3.14 Delete all records of boxes from saturated warehouses.
DELETE FROM Boxes
WHERE Warehouse IN 
(SELECT Boxes.Warehouse
FROM Warehouses 
JOIN Boxes
ON Warehouses.Code=Boxes.Warehouse
GROUP BY Boxes.Warehouse, Warehouses.Capacity
HAVING Warehouses.Capacity < COUNT(Boxes.Code)
ORDER BY Boxes.Warehouse
);

--3.15 Remove all boxes with a value lower than $100.
DELETE FROM Boxes
WHERE Value < 100;

--3.16 Add Index for column "Warehouse" in table "boxes"
CREATE INDEX INDEX_WAREHOUSE 
ON Boxes (Warehouse)

    -- !!!NOTE!!!: index should NOT be used on small tables in practice
--3.17 Print all the existing indexes
--3.18 Remove (drop) the index you just created
DROP INDEX INDEX_WAREHOUSE;

