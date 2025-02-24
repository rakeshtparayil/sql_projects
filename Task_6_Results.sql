-- CREATE TABLE Scientists (
--   SSN int,
--   Name Char(30) not null,
--   Primary Key (SSN)
-- );

-- CREATE TABLE Projects (
--   Code Char(4),
--   Name Char(50) not null,
--   Primary Key (Code)
-- );
	
-- CREATE TABLE AssignedTo (
--   Scientist int not null,
--   Project char(4) not null,
--   Hours int,
--   Primary Key (Scientist, Project)
-- );

-- INSERT INTO Scientists(SSN,Name) 
-- VALUES(123234877,'Michael Rogers'),
-- (152934485,'Anand Manikutty'),
-- (222364883, 'Carol Smith'),
-- (326587417,'Joe Stevens'),
-- (332154719,'Mary-Anne Foster'),	
-- (332569843,'George ODonnell'),
-- (546523478,'John Doe'),
-- (631231482,'David Smith'),
-- (654873219,'Zacary Efron'),
-- (745685214,'Eric Goldsmith'),
-- (845657245,'Elizabeth Doe'),
-- (845657246,'Kumar Swamy');

-- INSERT INTO Projects ( Code,Name)
-- VALUES ('AeH1','Winds: Studying Bernoullis Principle'),
-- ('AeH2','Aerodynamics and Bridge Design'),
-- ('AeH3','Aerodynamics and Gas Mileage'),
-- ('AeH4','Aerodynamics and Ice Hockey'),
-- ('AeH5','Aerodynamics of a Football'),
-- ('AeH6','Aerodynamics of Air Hockey'),
-- ('Ast1','A Matter of Time'),
-- ('Ast2','A Puzzling Parallax'),
-- ('Ast3','Build Your Own Telescope'),
-- ('Bte1','Juicy: Extracting Apple Juice with Pectinase'),
-- ('Bte2','A Magnetic Primer Designer'),
-- ('Bte3','Bacterial Transformation Efficiency'),
-- ('Che1','A Silver-Cleaning Battery'),
-- ('Che2','A Soluble Separation Solution');

-- INSERT INTO AssignedTo ( Scientist, Project, Hours)
-- VALUES (123234877,'AeH1', 156),
-- (152934485,'AeH3',189),
-- (222364883,'Ast3', 256),	   
-- (326587417,'Ast3', 789),
-- (332154719,'Bte1', 98),
-- (546523478,'Che1',89),
-- (631231482,'Ast3',112),
-- (654873219,'Che1', 299),
-- (745685214,'AeH3', 6546),
-- (845657245,'Ast1', 321),
-- (845657246,'Ast2', 9684),
-- (332569843,'AeH4', 321);

- 6.1 List all the scientists' names, their projects' names, 
SELECT Scientists.Name, Projects.Name, AssignedTo.Hours
FROM Scientists 
JOIN AssignedTo on Scientists.SSN  = AssignedTo.Scientist
JOIN Projects on AssignedTo.Project =Projects.Code;


    -- and the total hours worked on each project, 
SELECT Scientists.Name, Projects.Name,sum(AssignedTo.Hours) as Total_hours
FROM Scientists 
JOIN AssignedTo on Scientists.SSN  = AssignedTo.Scientist
JOIN Projects on AssignedTo.Project =Projects.Code
GROUP BY Scientists.Name, Projects.Name;


    -- in alphabetical order of project name, then scientist name.
SELECT Scientists.Name as Scientist_Name , Projects.Name as Project_Name,sum(AssignedTo.Hours) as Total_hours
FROM Scientists 
JOIN AssignedTo on Scientists.SSN  = AssignedTo.Scientist
JOIN Projects on AssignedTo.Project =Projects.Code
GROUP BY Scientists.Name, Projects.Name
ORDER BY Project_Name, Scientist_Name ;

-- 6.2 Now list the project names and total hours worked on each, from most to least total hours.
SELECT Projects.Name as Project_Name ,sum(AssignedTo.Hours) as Total_hours
FROM Projects 
JOIN AssignedTo ON Projects.Code  = AssignedTo.Project
GROUP BY Project_Name
ORDER BY Total_Hours DESC;

-- 6.3 Select the project names which do not have any scientists currently assigned to them.
SELECT Projects.Name AS Project_Name
FROM Projects
LEFT JOIN AssignedTo ON Projects.Code = AssignedTo.Project
WHERE AssignedTo.Project IS NULL;


