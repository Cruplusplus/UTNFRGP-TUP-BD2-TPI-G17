USE GimnasioDB;
GO

--Automatizacion de Reserva de Cupo en Clases
CREATE TRIGGER trg_Inscripcion_ActualizarCupo
ON InscripcionesClase
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    IF EXISTS (
        SELECT 1 
        FROM Clases c
        INNER JOIN inserted i ON c.IDClase = i.IDClase
        WHERE c.CupoDisponible <= 0
    )
    BEGIN
        RAISERROR('No se puede completar la inscripcion. Cupo agotado en la clase seleccionada.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
    
    UPDATE Clases
    SET CupoDisponible = CupoDisponible - 1
    FROM Clases c
    INNER JOIN inserted i ON c.IDClase = i.IDClase;
END;
GO

--Devolucion Automatica de Cupo por Cancelacion
CREATE TRIGGER trg_Cancelacion_ActualizarCupo
ON InscripcionesClase
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE Clases
    SET CupoDisponible = CupoDisponible + 1
    FROM Clases c
    INNER JOIN deleted d ON c.IDClase = d.IDClase;
END;
GO