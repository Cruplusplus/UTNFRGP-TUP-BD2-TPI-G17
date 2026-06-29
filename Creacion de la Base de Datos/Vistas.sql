USE GimnasioDB;
GO

--Estado de Cuenta de Socios y Membresias Activas
CREATE VIEW vw_SociosMembresiasActivas AS
SELECT 
    s.IDSocio,
    p.Nombre + ' ' + p.Apellido AS Socio,
    p.Email,
    m.Nombre AS PlanContratado,
    sm.FechaInicio,
    sm.FechaVencimiento,
    DATEDIFF(day, GETDATE(), sm.FechaVencimiento) AS DiasRestantes
FROM SocioMembresias sm
INNER JOIN Socios s ON sm.IDSocio = s.IDSocio
INNER JOIN Personas p ON s.IDPersona = p.IDPersona
INNER JOIN Membresias m ON sm.IDMembresia = m.IDMembresia
WHERE sm.Activa = 1;
GO

--Reporte de Ocupacion de Clases
CREATE VIEW vw_OcupacionClases AS
SELECT 
    c.IDClase,
    c.Nombre AS Clase,
    c.Horario,
    prof_p.Nombre + ' ' + prof_p.Apellido AS Profesor,
    c.CupoMaximo,
    c.CupoDisponible,
    (c.CupoMaximo - c.CupoDisponible) AS AlumnosInscritos,
    CONVERT(DECIMAL(5,2), ((c.CupoMaximo - c.CupoDisponible) * 100.0 / c.CupoMaximo)) AS PorcentajeOcupacion
FROM Clases c
INNER JOIN Empleados e ON c.IDProfesor = e.IDEmpleado
INNER JOIN Personas prof_p ON e.IDPersona = prof_p.IDPersona;
GO

--Control de Recaudacion Mensual
CREATE VIEW vw_RecaudacionMensual AS
SELECT 
    YEAR(pa.FechaPago) AS Anio,
    MONTH(pa.FechaPago) AS Mes,
    COUNT(pa.IDPago) AS CantidadTransacciones,
    SUM(pa.Monto) AS TotalRecaudado,
    AVG(pa.Monto) AS TicketPromedio
FROM Pagos pa
GROUP BY YEAR(pa.FechaPago), MONTH(pa.FechaPago);
GO