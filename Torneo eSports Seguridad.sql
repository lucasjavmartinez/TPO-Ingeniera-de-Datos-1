USE torneoEsportsBD1;
GO

-- se crean los roles que se usaran en el sistema
CREATE ROLE rol_administrador;
CREATE ROLE rol_organizador;
CREATE ROLE rol_arbitro;
CREATE ROLE rol_publico_jugador;
GO


--se da permisos de administrador al rol administrador, este tiene acceso total (lectura, escritura, modificacion de todo)
--este es el unico que podria modificar los partidos jugados
GRANT CONTROL ON DATABASE::torneoEsportsBD1 TO rol_administrador;
GO

--le damos permisos al rol organizador, este podra gestionar el torneo, inscripciones, arbitros y liquidar premios
GRANT SELECT, INSERT, UPDATE ON Torneo TO rol_organizador;
GRANT SELECT, INSERT, UPDATE, DELETE ON Inscripcion TO rol_organizador;
GRANT SELECT, INSERT, UPDATE ON Partido TO rol_organizador;
GRANT SELECT ON Equipo TO rol_organizador;
GRANT SELECT ON Jugador TO rol_organizador;
GRANT SELECT ON Persona TO rol_organizador;
GRANT SELECT, INSERT, UPDATE ON Pago_Premio TO rol_organizador;

--le permitimos la ejecucion de Stored Procedures gerenciales
GRANT EXECUTE ON sp_insertPersonal TO rol_organizador;
GRANT EXECUTE ON sp_bajaPersona TO rol_organizador;
GRANT EXECUTE ON sp_liquidarPremiosTorneo TO rol_organizador;
GO

--le damos permisos al rol arbitro, este podra gestionar la carga de alineaciones, kda, sanciones y actualizar resultados de partidos
GRANT SELECT, UPDATE ON Partido TO rol_arbitro;
GRANT SELECT, INSERT, UPDATE ON Alineacion_Partido TO rol_arbitro;
GRANT SELECT, INSERT, UPDATE ON Sancion TO rol_arbitro;
GRANT SELECT ON Jugador TO rol_arbitro;
GRANT SELECT ON Equipo TO rol_arbitro;

--le permitimos la ejecucion de Stored Procedures relacionados a los partidos
GRANT EXECUTE ON sp_verificarKDA TO rol_arbitro;
GRANT EXECUTE ON sp_registrarResultadoPartido TO rol_arbitro;
GO

--le damos los permisos al rol jugador, este podra hacer consultas de vistas publicas y carteleras
GRANT SELECT ON view_estadisticasJugadoresActivos TO rol_publico_jugador;
GRANT SELECT ON view_estadisticasJugadoresPorTorneo TO rol_publico_jugador;
GRANT SELECT ON Torneo TO rol_publico_jugador;
GRANT SELECT ON Equipo TO rol_publico_jugador;
GRANT SELECT ON Partido TO rol_publico_jugador;

--aca protegemos la data sensible para que los roles como los jugadores no puedan acceder a ella
DENY SELECT, INSERT, UPDATE, DELETE ON Persona TO rol_publico_jugador;
DENY SELECT ON Sancion TO rol_publico_jugador;
DENY SELECT ON Pago_Premio TO rol_publico_jugador;
GO

GRANT SELECT ON Auditoria TO rol_organizador;
DENY SELECT, INSERT, UPDATE, DELETE ON Auditoria TO rol_publico_jugador;
DENY SELECT, INSERT, UPDATE, DELETE ON Auditoria TO rol_arbitro;


GRANT EXECUTE ON sp_insertarJugador TO rol_organizador;
GRANT EXECUTE ON dbo.fn_calcularKDA TO rol_publico_jugador, rol_arbitro, rol_organizador;
GRANT EXECUTE ON dbo.fn_calcularWinrateEquipo TO rol_publico_jugador, rol_arbitro, rol_organizador;
GRANT EXECUTE ON dbo.fn_obtenerMVP TO rol_publico_jugador, rol_arbitro, rol_organizador;
GO

-- Creamos usuarios en la base de datos y asignamos roles
CREATE USER usr_admin WITHOUT LOGIN;
CREATE USER usr_organizador WITHOUT LOGIN;
CREATE USER usr_arbitro WITHOUT LOGIN;
CREATE USER usr_jugador_publico WITHOUT LOGIN;
GO

ALTER ROLE rol_administrador ADD MEMBER usr_admin;
ALTER ROLE rol_organizador ADD MEMBER usr_organizador;
ALTER ROLE rol_arbitro ADD MEMBER usr_arbitro;
ALTER ROLE rol_publico_jugador ADD MEMBER usr_jugador_publico;
GO
