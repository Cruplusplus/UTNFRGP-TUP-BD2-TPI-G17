USE GimnasioDB;
GO

--Historial de Asistencias Parametrizado por Socio y Fechas
CREATE PROCEDURE sp_ReporteAsistenciasSocio
    @IDSocio BIGINT,
    @FechaDesde DATE,
    @FechaHasta DATE
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        ha.FechaAsistencia,
        c.Nombre AS Clase,
        c.Horario AS HorarioClase,
        CASE WHEN ha.Presente = 1 THEN 'PRESENTE' ELSE 'AUSENTE' END AS EstadoAsistencia
    FROM HistorialAsistencias ha
    INNER JOIN Clases c ON ha.IDClase = c.IDClase
    WHERE ha.IDSocio = @IDSocio 
      AND ha.FechaAsistencia BETWEEN @FechaDesde AND @FechaHasta
    ORDER BY ha.FechaAsistencia DESC;
END;
GO

--Registro Seguro de Pago de Cuotas con Transacciones
CREATE PROCEDURE sp_RegistrarPagoMembresia
    @IDSocioMembresia BIGINT,
    @Monto MONEY,
    @FechaPago DATETIME
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        IF NOT EXISTS (SELECT 1 FROM SocioMembresias WHERE IDSocioMembresia = @IDSocioMembresia)
        BEGIN
            RAISERROR('El ID de contrato Socio-Membresía no existe.', 16, 1);
        END
        
        INSERT INTO Pagos (IDSocioMembresia, Monto, FechaPago)
        VALUES (@IDSocioMembresia, @Monto, @FechaPago);
        
        UPDATE SocioMembresias 
        SET Activa = 1 
        WHERE IDSocioMembresia = @IDSocioMembresia;
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH --amamos a catch
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
            
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO