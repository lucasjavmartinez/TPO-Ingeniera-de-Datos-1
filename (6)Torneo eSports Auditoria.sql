USE torneoEsportsBD1;
GO

IF OBJECT_ID('dbo.Auditoria', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Auditoria (
        id_auditoria      INT IDENTITY(1,1) CONSTRAINT PK_Auditoria PRIMARY KEY,
        tabla             VARCHAR(50)  NOT NULL,
        operacion         VARCHAR(10)  NOT NULL,
        usuario           VARCHAR(128) NOT NULL CONSTRAINT DF_Auditoria_usuario DEFAULT (SUSER_SNAME()),
        fecha             DATETIME2    NOT NULL CONSTRAINT DF_Auditoria_fecha   DEFAULT (SYSDATETIME()),
        datos_anteriores  NVARCHAR(MAX) NULL,
        datos_nuevos      NVARCHAR(MAX) NULL,
        CONSTRAINT CK_Auditoria_operacion CHECK (operacion IN ('INSERT','UPDATE','DELETE'))
    );
END
GO
 
-- Trigger de auditoria sobre Partido
CREATE OR ALTER TRIGGER trg_Auditoria_Partido
ON Partido
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
 
    INSERT INTO Auditoria (tabla, operacion, datos_anteriores, datos_nuevos)
    SELECT 'Partido',
           CASE WHEN EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted) THEN 'UPDATE'
                WHEN EXISTS (SELECT 1 FROM inserted) THEN 'INSERT'
                ELSE 'DELETE' END,
           (SELECT * FROM deleted  FOR JSON PATH),
           (SELECT * FROM inserted FOR JSON PATH);
END
GO
 
-- Trigger de auditoria sobre Inscripcion
CREATE OR ALTER TRIGGER trg_Auditoria_Inscripcion
ON Inscripcion
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
 
    INSERT INTO Auditoria (tabla, operacion, datos_anteriores, datos_nuevos)
    SELECT 'Inscripcion',
           CASE WHEN EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted) THEN 'UPDATE'
                WHEN EXISTS (SELECT 1 FROM inserted) THEN 'INSERT'
                ELSE 'DELETE' END,
           (SELECT * FROM deleted  FOR JSON PATH),
           (SELECT * FROM inserted FOR JSON PATH);
END
GO
 
-- Trigger de auditoria sobre Pago_Premio
CREATE OR ALTER TRIGGER trg_Auditoria_PagoPremio
ON Pago_Premio
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
 
    INSERT INTO Auditoria (tabla, operacion, datos_anteriores, datos_nuevos)
    SELECT 'Pago_Premio',
           CASE WHEN EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted) THEN 'UPDATE'
                WHEN EXISTS (SELECT 1 FROM inserted) THEN 'INSERT'
                ELSE 'DELETE' END,
           (SELECT * FROM deleted  FOR JSON PATH),
           (SELECT * FROM inserted FOR JSON PATH);
END
GO
 
/* PRUEBA PARA MODIFICAR ALGO Y VER COMO QUEDA EN EL REGISTRO */
UPDATE Partido SET cantidad_espectadores = 1000 WHERE id_partido = 1;
SELECT TOP 5 id_auditoria, tabla, operacion, usuario, fecha, datos_anteriores, datos_nuevos
FROM Auditoria
ORDER BY id_auditoria DESC;
GO