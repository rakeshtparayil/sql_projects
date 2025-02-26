SELECT Physican.Name as Physican_name
Physican.Position as phy.position
JOIN Trained_In ON Physican.EmployeeID  = Trained_In.Physican
FROM Physican;