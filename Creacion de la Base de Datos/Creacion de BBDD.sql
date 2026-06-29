CREATE DATABASE GimnasioDB
GO

USE GimnasioDB;
GO

CREATE TABLE Personas (
    IDPersona BIGINT IDENTITY(1,1) NOT NULL,
    Nombre VARCHAR(50) NOT NULL,
    Apellido VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    Telefono VARCHAR(100) NULL,
    FechaNacimiento DATE NOT NULL,
    Activo BIT NOT NULL,
    
    CONSTRAINT PK_Personas PRIMARY KEY (IDPersona),
    CONSTRAINT UQ_Personas_Email UNIQUE (Email)
);
GO

CREATE TABLE Roles (
    IDRol INT IDENTITY(1,1) NOT NULL,
    NombreRol VARCHAR(100) NOT NULL,
    
    CONSTRAINT PK_Roles PRIMARY KEY (IDRol)
);
GO

CREATE TABLE Membresias (
    IDMembresia INT IDENTITY(1,1) NOT NULL,
    Nombre VARCHAR(100) NOT NULL,
    Precio MONEY NOT NULL,
    DuracionDias INTEGER NOT NULL,
    
    CONSTRAINT PK_Membresias PRIMARY KEY (IDMembresia)
);
GO

CREATE TABLE Socios (
    IDSocio BIGINT IDENTITY(1,1) NOT NULL,
    IDPersona BIGINT NOT NULL,
    FechaRegistro DATE NOT NULL,
    
    CONSTRAINT PK_Socios PRIMARY KEY (IDSocio),
    CONSTRAINT FK_Socios_Personas FOREIGN KEY (IDPersona) REFERENCES Personas(IDPersona)
);
GO

CREATE TABLE Empleados (
    IDEmpleado BIGINT IDENTITY(1,1) NOT NULL,
    IDPersona BIGINT NOT NULL,
    IDRol INT NOT NULL,
    FechaContratacion DATE NOT NULL,
    
    CONSTRAINT PK_Empleados PRIMARY KEY (IDEmpleado),
    CONSTRAINT FK_Empleados_Personas FOREIGN KEY (IDPersona) REFERENCES Personas(IDPersona),
    CONSTRAINT FK_Empleados_Roles FOREIGN KEY (IDRol) REFERENCES Roles(IDRol)
);
GO

CREATE TABLE Clases (
    IDClase BIGINT IDENTITY(1,1) NOT NULL,
    Nombre VARCHAR(100) NOT NULL,
    IDProfesor BIGINT NOT NULL,
    Horario DATETIME NOT NULL,
    CupoMaximo INTEGER NOT NULL,
    CupoDisponible INTEGER NOT NULL,
    
    CONSTRAINT PK_Clases PRIMARY KEY (IDClase),
    CONSTRAINT FK_Clases_Empleados FOREIGN KEY (IDProfesor) REFERENCES Empleados(IDEmpleado)
);
GO

CREATE TABLE SocioMembresias (
    IDSocioMembresia BIGINT IDENTITY(1,1) NOT NULL,
    IDSocio BIGINT NOT NULL,
    IDMembresia INT NOT NULL,
    FechaInicio DATE NOT NULL,
    FechaVencimiento DATE NOT NULL,
    Activa BIT NOT NULL,
    
    CONSTRAINT PK_SocioMembresias PRIMARY KEY (IDSocioMembresia),
    CONSTRAINT FK_SocioMembresias_Socios FOREIGN KEY (IDSocio) REFERENCES Socios(IDSocio),
    CONSTRAINT FK_SocioMembresias_Membresias FOREIGN KEY (IDMembresia) REFERENCES Membresias(IDMembresia),
    CONSTRAINT UQ_SocioMembresia_Activa UNIQUE (IDSocio, IDMembresia, FechaInicio)
);
GO

CREATE TABLE Pagos (
    IDPago BIGINT IDENTITY(1,1) NOT NULL,
    IDSocioMembresia BIGINT NOT NULL,
    Monto MONEY NOT NULL,
    FechaPago DATETIME NOT NULL,
    
    CONSTRAINT PK_Pagos PRIMARY KEY (IDPago),
    CONSTRAINT FK_Pagos_SocioMembresias FOREIGN KEY (IDSocioMembresia) REFERENCES SocioMembresias(IDSocioMembresia)
);
GO

CREATE TABLE InscripcionesClase (
    IDInscripcion BIGINT IDENTITY(1,1) NOT NULL,
    IDSocio BIGINT NOT NULL,
    IDClase BIGINT NOT NULL,
    FechaInscripcion DATE NOT NULL,
    
    CONSTRAINT PK_InscripcionesClase PRIMARY KEY (IDInscripcion),
    CONSTRAINT FK_InscripcionesClase_Socios FOREIGN KEY (IDSocio) REFERENCES Socios(IDSocio),
    CONSTRAINT FK_InscripcionesClase_Clases FOREIGN KEY (IDClase) REFERENCES Clases(IDClase)
);
GO

CREATE TABLE HistorialAsistencias (
    IDAsistencia BIGINT IDENTITY(1,1) NOT NULL,
    IDSocio BIGINT NOT NULL,
    IDClase BIGINT NOT NULL,
    FechaAsistencia DATE NOT NULL,
    Presente BIT NOT NULL,
    
    CONSTRAINT PK_HistorialAsistencias PRIMARY KEY (IDAsistencia),
    CONSTRAINT FK_HistorialAsistencias_Socios FOREIGN KEY (IDSocio) REFERENCES Socios(IDSocio),
    CONSTRAINT FK_HistorialAsistencias_Clases FOREIGN KEY (IDClase) REFERENCES Clases(IDClase)
);
GO