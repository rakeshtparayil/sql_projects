-- CREATE TABLE Employee (
--   EmployeeID INTEGER,
--   Name VARCHAR(255) NOT NULL,
--   Position VARCHAR(255) NOT NULL,
--   Salary REAL NOT NULL,
--   Remarks VARCHAR(255),
--   PRIMARY KEY (EmployeeID)
-- ); 

-- CREATE TABLE Planet (
--   PlanetID INTEGER,
--   Name VARCHAR(255) NOT NULL,
--   Coordinates REAL NOT NULL,
--   PRIMARY KEY (PlanetID)
-- ); 

-- CREATE TABLE Shipment (
--   ShipmentID INTEGER,
--   Date DATE,
--   Manager INTEGER NOT NULL,
--   Planet INTEGER NOT NULL,
--   PRIMARY KEY (ShipmentID)
-- );

-- CREATE TABLE Has_Clearance (
--   Employee INTEGER NOT NULL,
--   Planet INTEGER NOT NULL,
--   Level INTEGER NOT NULL,
--   PRIMARY KEY(Employee, Planet)
-- ); 

-- CREATE TABLE Client (
--   AccountNumber INTEGER,
--   Name VARCHAR(255) NOT NULL,
--   PRIMARY KEY (AccountNumber)
-- );
  
-- CREATE TABLE Package (
--   Shipment INTEGER NOT NULL,
--   PackageNumber INTEGER NOT NULL,
--   Contents VARCHAR(255) NOT NULL,
--   Weight REAL NOT NULL,
--   Sender INTEGER NOT NULL,
--   Recipient INTEGER NOT NULL,
--   PRIMARY KEY(Shipment, PackageNumber)
--   );


-- INSERT INTO Client VALUES(1, 'Zapp Brannigan');
-- INSERT INTO Client VALUES(2, "Al Gore's Head");
-- INSERT INTO Client VALUES(3, 'Barbados Slim');
-- INSERT INTO Client VALUES(4, 'Ogden Wernstrom');
-- INSERT INTO Client VALUES(5, 'Leo Wong');
-- INSERT INTO Client VALUES(6, 'Lrrr');
-- INSERT INTO Client VALUES(7, 'John Zoidberg');
-- INSERT INTO Client VALUES(8, 'John Zoidfarb');
-- INSERT INTO Client VALUES(9, 'Morbo');
-- INSERT INTO Client VALUES(10, 'Judge John Whitey');
-- INSERT INTO Client VALUES(11, 'Calculon');
-- INSERT INTO Employee VALUES(1, 'Phillip J. Fry', 'Delivery boy', 7500.0, 'Not to be confused with the Philip J. Fry from Hovering Squid World 97a');
-- INSERT INTO Employee VALUES(2, 'Turanga Leela', 'Captain', 10000.0, NULL);
-- INSERT INTO Employee VALUES(3, 'Bender Bending Rodriguez', 'Robot', 7500.0, NULL);
-- INSERT INTO Employee VALUES(4, 'Hubert J. Farnsworth', 'CEO', 20000.0, NULL);
-- INSERT INTO Employee VALUES(5, 'John A. Zoidberg', 'Physician', 25.0, NULL);
-- INSERT INTO Employee VALUES(6, 'Amy Wong', 'Intern', 5000.0, NULL);
-- INSERT INTO Employee VALUES(7, 'Hermes Conrad', 'Bureaucrat', 10000.0, NULL);
-- INSERT INTO Employee VALUES(8, 'Scruffy Scruffington', 'Janitor', 5000.0, NULL);
-- INSERT INTO Planet VALUES(1, 'Omicron Persei 8', 89475345.3545);
-- INSERT INTO Planet VALUES(2, 'Decapod X', 65498463216.3466);
-- INSERT INTO Planet VALUES(3, 'Mars', 32435021.65468);
-- INSERT INTO Planet VALUES(4, 'Omega III', 98432121.5464);
-- INSERT INTO Planet VALUES(5, 'Tarantulon VI', 849842198.354654);
-- INSERT INTO Planet VALUES(6, 'Cannibalon', 654321987.21654);
-- INSERT INTO Planet VALUES(7, 'DogDoo VII', 65498721354.688);
-- INSERT INTO Planet VALUES(8, 'Nintenduu 64', 6543219894.1654);
-- INSERT INTO Planet VALUES(9, 'Amazonia', 65432135979.6547);
-- INSERT INTO Has_Clearance VALUES(1, 1, 2);
-- INSERT INTO Has_Clearance VALUES(1, 2, 3);
-- INSERT INTO Has_Clearance VALUES(2, 3, 2);
-- INSERT INTO Has_Clearance VALUES(2, 4, 4);
-- INSERT INTO Has_Clearance VALUES(3, 5, 2);
-- INSERT INTO Has_Clearance VALUES(3, 6, 4);
-- INSERT INTO Has_Clearance VALUES(4, 7, 1);
-- INSERT INTO Shipment VALUES(1, '3004/05/11', 1, 2);
-- INSERT INTO Shipment VALUES(2, '3004/05/11', 1, 2);
-- INSERT INTO Shipment VALUES(3, NULL, 2, 3);
-- INSERT INTO Shipment VALUES(4, NULL, 2, 4);
-- INSERT INTO Shipment VALUES(5, NULL, 7, 5);
-- INSERT INTO Package VALUES(1, 1, 'Undeclared', 1.5, 1, 2);
-- INSERT INTO Package VALUES(2, 1, 'Undeclared', 10.0, 2, 3);
-- INSERT INTO Package VALUES(2, 2, 'A bucket of krill', 2.0, 8, 7);
-- INSERT INTO Package VALUES(3, 1, 'Undeclared', 15.0, 3, 4);
-- INSERT INTO Package VALUES(3, 2, 'Undeclared', 3.0, 5, 1);
-- INSERT INTO Package VALUES(3, 3, 'Undeclared', 7.0, 2, 3);
-- INSERT INTO Package VALUES(4, 1, 'Undeclared', 5.0, 4, 5);
-- INSERT INTO Package VALUES(4, 2, 'Undeclared', 27.0, 1, 2);
-- INSERT INTO Package VALUES(5, 1, 'Undeclared', 100.0, 5, 1);



-- 7.1 Who received a 1.5kg package?
SELECT c.Name AS Recipient_Name
FROM Package p
JOIN Client c ON p.Recipient = c.AccountNumber
WHERE p.Weight = 1.5;


    -- (The result is "Al Gore's Head").

-- 7.2 What is the total weight of all the packages that they sent?
SELECT sum(weight)
FROM Package;

-- Optional questions

-- 7.3 Retrieve the names of employees who have clearance level 4 or higher.
SELECT Employee.Name, Has_Clearance.Level
FROM Employee
JOIN Has_Clearance ON Employee.EmployeeID  = Has_Clearance.Employee
WHERE Level >=  4;


-- 7.4 Rank the employees based on their salary in descending order, showing their names and positions alongside their rank. (Try using a Window Function if you are up to the challenge!)

SELECT EmployeeID, Name, Position, Salary,  
 RANK() OVER (ORDER BY Salary DESC) AS SalaryRank 
FROM Employee;


-- 7.5 Create a CTE to calculate the total weight of packages sent to each planet, then join it with the Planet table to display the planet names and their corresponding total weights.
WITH PackageWeightPerPlanet AS (
    SELECT s.Planet, SUM(p.Weight) AS TotalWeight
    FROM Package p
    JOIN Shipment s ON p.Shipment = s.ShipmentID
    GROUP BY s.Planet
)
SELECT pl.Name AS PlanetName, pw.TotalWeight
FROM PackageWeightPerPlanet pw
JOIN Planet pl ON pw.Planet = pl.PlanetID;

-- 7.6 Retrieve the names of employees who have shipped packages to planets that no other employee has shipped to.
WITH UniquePlanets AS (
    SELECT s.Planet, s.Manager
    FROM Shipment s
    GROUP BY s.Planet, s.Manager
    HAVING COUNT(*) = 1  -- Only planets managed by one employee
)
SELECT e.Name AS EmployeeName
FROM UniquePlanets up
JOIN Employee e ON up.Manager = e.EmployeeID;

-- 7.7 Retrieve the names of planets along with the number of shipments made to each planet, but exclude planets where the total weight of packages sent is less than 20 units.
WITH PlanetShipments AS (
    SELECT s.Planet, 
           COUNT(s.ShipmentID) AS ShipmentCount,
           SUM(p.Weight) AS TotalWeight
    FROM Shipment s
    JOIN Package p ON s.ShipmentID = p.Shipment
    GROUP BY s.Planet
    HAVING SUM(p.Weight) >= 20  -- Exclude planets with < 20 units of weight
)
SELECT pl.Name AS PlanetName, ps.ShipmentCount
FROM PlanetShipments ps
JOIN Planet pl ON ps.Planet = pl.PlanetID;




