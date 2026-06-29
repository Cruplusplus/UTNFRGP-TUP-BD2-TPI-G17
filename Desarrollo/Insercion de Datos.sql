USE GimnasioDB;
GO

--Roles del staff
INSERT INTO Roles (NombreRol) VALUES 
('Profesor'),
('Personal Trainer'),
('Recepcionista'),
('Personal de Limpieza');
GO

--Membresias
INSERT INTO Membresias (Nombre, Precio, DuracionDias) VALUES 
('Pase Libre Mensual', 30000.00, 30),
('Pase 3 Veces por Semana', 25000.00, 30),
('Pase Libre Anual', 200000.00, 365);
GO

--Personas test
INSERT INTO Personas (Nombre, Apellido, Email, Telefono, FechaNacimiento, Activo) VALUES 
('Juan', 'Cruz', 'juan@email.com', '1122334455', '1990-05-15', 1),
('Lautaro', 'Silva', 'silva@email.com', '1155667788', '1988-09-20', 1),
('Carlos', 'Rodriguez', 'carlos.rod@email.com', NULL, '1995-03-10', 1),
('Ana', 'Martínez', 'ana.martinez@email.com', '1199887766', '1992-12-01', 1),
('Lucas', 'Lopez', 'lucas.lopez@email.com', '1144332211', '2000-01-25', 1);
GO

--Clasificar socios
INSERT INTO Socios (IDPersona, FechaRegistro)
SELECT IDPersona, '2026-06-17' FROM Personas WHERE Email IN ('juan@email.com', 'silva@email.com', 'lucas.lopez@email.com');
GO

--Clasificar empleados
INSERT INTO Empleados (IDPersona, IDRol, FechaContratacion)
SELECT p.IDPersona, r.IDRol, '2025-06-25' 
FROM Personas p, Roles r 
WHERE p.Email = 'carlos.rod@email.com' AND r.NombreRol = 'Profesor de Planta';

INSERT INTO Empleados (IDPersona, IDRol, FechaContratacion)
SELECT p.IDPersona, r.IDRol, '2025-08-15' 
FROM Personas p, Roles r 
WHERE p.Email = 'ana.martinez@email.com' AND r.NombreRol = 'Recepcionista';
GO

--Insert clases del gym
INSERT INTO Clases (Nombre, IDProfesor, Horario, CupoMaximo, CupoDisponible)
SELECT 'Crossfit Inicial', IDEmpleado, '2026-07-01 19:00:00', 20, 20
FROM Empleados e JOIN Personas p ON e.IDPersona = p.IDPersona WHERE p.Email = 'carlos.rod@email.com';

INSERT INTO Clases (Nombre, IDProfesor, Horario, CupoMaximo, CupoDisponible)
SELECT 'Spinning Avanzado', IDEmpleado, '2026-07-02 08:00:00', 15, 15
FROM Empleados e JOIN Personas p ON e.IDPersona = p.IDPersona WHERE p.Email = 'carlos.rod@email.com';
GO

--Asignar Membresías a los Socios
INSERT INTO SocioMembresias (IDSocio, IDMembresia, FechaInicio, FechaVencimiento, Activa)
SELECT s.IDSocio, m.IDMembresia, '2026-06-01', '2026-07-01', 1
FROM Socios s JOIN Personas p ON s.IDPersona = p.IDPersona CROSS JOIN Membresias m
WHERE p.Email = 'juan@email.com' AND m.Nombre = 'Pase Libre Mensual';

INSERT INTO SocioMembresias (IDSocio, IDMembresia, FechaInicio, FechaVencimiento, Activa)
SELECT s.IDSocio, m.IDMembresia, '2026-06-15', '2026-07-15', 1
FROM Socios s JOIN Personas p ON s.IDPersona = p.IDPersona CROSS JOIN Membresias m
WHERE p.Email = 'silva@email.com' AND m.Nombre = 'Pase 3 Veces por Semana';
GO

-- Registrar Pagos
INSERT INTO Pagos (IDSocioMembresia, Monto, FechaPago)
SELECT IDSocioMembresia, 25000.00, '2026-06-01 10:30:00' FROM SocioMembresias WHERE IDSocio = 1;
GO