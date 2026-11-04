USE torneoEsportsBD1;
GO

--Consultas SQL

--1. Consultamos el jugador con mas cantidad de kills de un determinado equipo y los ordenamos de mayor a menor
SELECT  * FROM view_estadisticasJugadoresActivos
WHERE Equipo_actual = 'T1'
ORDER BY Total_Kills DESC;

-- esto tambien podria hacerse sin el filtro de equipo
SELECT * FROM view_estadisticasJugadoresActivos
ORDER BY Total_Kills DESC;


--2. Consultamos el mvp del torneo, esto se calcula de la sig manera: el jugador con mayor mvps acumulados en todos los partidos
--es quien ganará el premio mvp del torneo

SELECT TOP 1
    T.nombre AS Torneo,
    J.nick AS Nickname,
    CONCAT(P.nombre,' ', P.apellido) AS Nombre_completo,
    COUNT(Pa.id_partido) AS Cantidad_MVP
FROM Partido Pa
INNER JOIN Torneo T ON Pa.id_torneo = T.id_torneo
INNER JOIN Jugador J ON Pa.id_mvp_jugador = J.id_persona
INNER JOIN Persona P ON J.id_persona = P.id_persona
WHERE
    T.estado = 'Finalizado'
    AND Pa.id_mvp_jugador IS NOT NULL
GROUP BY
    T.nombre, J.nick, P.nombre, P.apellido
ORDER BY
    Cantidad_MVP DESC;
GO

-- 3. Hacemos uso de la funcion fn_calcularKDA el cual calcula el kda de un jugador
SELECT
    AP.id_partido AS Partido,
    J.nick as Nickname,
    P.nombre AS Nombre,
    P.apellido AS Apellido,
    kills,
    assists,
    deaths,
    dbo.fn_calcularKDA(kills, assists, deaths) AS KDAratio
FROM Alineacion_Partido AP
INNER JOIN Jugador J ON AP.id_jugador = J.id_persona
INNER JOIN Persona P ON J.id_persona = P.id_persona
WHERE J.nick = 'Faker';
GO


-- 4. Consultamos el MVP del torneo

SELECT
    nombre AS Torneo,
    fecha_inicio,
    dbo.fn_obtenerMVP(id_torneo) AS Jugador_MVP_Torneo
FROM Torneo
WHERE estado = 'Finalizado';


-- 5. rendimiento de equipo por partido
SELECT
    T.nombre AS Torneo,
    E.nombre AS Equipo,
    COUNT(DISTINCT Pa.id_partido) AS Partidos_Disputados,
    SUM(AP.kills) AS Total_Kills_Equipo,
    SUM(AP.assists) AS Total_Assists_Equipo,
    CAST(AVG(CAST(AP.kills AS DECIMAL(5,2))) AS DECIMAL(5,2)) AS Promedio_Kills_Por_Jugador
FROM Alineacion_Partido AP
INNER JOIN Partido Pa ON AP.id_partido = Pa.id_partido
INNER JOIN Torneo T ON Pa.id_torneo = T.id_torneo
INNER JOIN Equipo E ON AP.id_equipo = E.id_equipo
WHERE
    Pa.estado = 'Jugado'
GROUP BY
    T.nombre, E.nombre
HAVING
    SUM(AP.kills) > 25
    AND AVG(CAST(AP.kills AS DECIMAL(5,2))) >= 5.00
ORDER BY
    Total_Kills_Equipo DESC;
GO


--Consultas con subconsultas

/*1. Consultamos los jugadores inscriptos en el torneo que cuenten con alguna sancion
esto con la finalidad de que el organizador del evento pueda auditar y comprobar que
los equipos que van a disputar la siguiente partida no posea ninguna sancion vigente*/

SELECT
    T.nombre AS Torneo_activo,
    E.nombre AS Equipo_que_infringe,
    J.nick AS Jugador_con_sancion,
    CONCAT(P.nombre, ' ', P.apellido) AS Nombre_Jugador_Con_Sancion
FROM Torneo T
INNER JOIN Inscripcion I ON T.id_torneo = I.id_torneo
Inner Join Equipo E ON I.id_equipo = E.id_equipo
INNER JOIN Integrante_Equipo IE ON E.id_equipo = IE.id_equipo
INNER JOIN Jugador J ON IE.id_jugador = J.id_persona
INNER JOIN Persona P ON J.id_persona = P.id_persona
WHERE
    T.estado IN ('Inscripcion', 'En curso')
    AND IE.fecha_egreso IS NULL
    AND J.id_persona IN(
        --en esta subconsulta buscamos si el jugador tiene alguna sancion al momento
        SELECT id_jugador
        FROM Sancion
        WHERE CAST(GETDATE() AS DATE) BETWEEN fecha_inicio AND fecha_fin
    );
GO

/*2. Consultamos los equipos que llevan al menos 60 dias inactivos con la idea de borrarlos de la bd, 
esto para asegurarnos de que la base de datos no acumule equipos 
El equipo que tenga mas de 60 dias de participar de algun torneo es considerado equipo fantasma y deberia borrarse*/

SELECT
    E.nombre AS Equipo_inactivo,
    E.fecha_alta,
    CONCAT(P.nombre, ' ', P.apellido) AS Nombre_Manager,
    P.mail AS Mail_manager
FROM Equipo E
INNER JOIN Manager M ON E.id_manager = M.id_persona
INNER JOIN Persona P ON M.id_persona = P.id_persona
WHERE
    E.id_equipo NOT IN(
        SELECT DISTINCT id_equipo
        FROM Inscripcion
    )
    AND DATEDIFF(DAY, E.fecha_alta, GETDATE()) > 60;
GO

-- 3. Hacemos uso de la funcion fn_calcularWinrateEquipo pasandole como parametro el equipo mediante una subconsulta

SELECT dbo.fn_calcularWinrateEquipo(
    (SELECT id_equipo FROM Equipo WHERE nombre = 'G2 Esports')
) AS Winrate_Equipo;
GO

--pruebas de auditoria


-- 1. Prueba de Auditoria: modificamos espectadores y consultamos el historial JSON
UPDATE Partido SET cantidad_espectadores = 180000 WHERE id_partido = 1;
SELECT TOP 5 id_auditoria, tabla, operacion, usuario, fecha, datos_anteriores, datos_nuevos
FROM Auditoria
ORDER BY id_auditoria DESC;
GO

-- 2. Prueba de Error en SP (KDA negativo - Error 50023)
BEGIN TRY
    EXEC sp_verificarKDA @id_partido = 5, @id_jugador = 23, @kills = -5, @deaths = 2, @assists = 4, @id_equipo = 4;
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER() AS Codigo_Error, ERROR_MESSAGE() AS Mensaje_Error_Capturado;
END CATCH;
GO

-- 3. Prueba de Error en Trigger (Inscribir equipo en un torneo que ya esta 'En curso' - Error 50001)
BEGIN TRY
    INSERT INTO Inscripcion (id_torneo, id_equipo) VALUES (2, 5);
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER() AS Codigo_Error, ERROR_MESSAGE() AS Mensaje_Error_Capturado;
END CATCH;
GO

-- 4. Prueba de Error en SP (Cerrar partido sin ambos equipos definidos - Error 50028)
BEGIN TRY
    EXEC sp_registrarResultadoPartido @id_partido = 5, @puntaje_a = 16, @puntaje_b = 10, @id_mvp_jugador = 23;
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER() AS Codigo_Error, ERROR_MESSAGE() AS Mensaje_Error_Capturado;
END CATCH;
GO
