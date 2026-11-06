USE torneoEsportsBD1;
GO

-- 1. Se crea una vista para saber los jugadores con mayor cantidad de kills, deaths o assits (teniendo en cuenta todos los torneos)
CREATE OR ALTER VIEW view_estadisticasJugadoresActivos AS
SELECT
    J.nick AS Nickname,
    P.nombre AS Nombre,
    P.apellido AS Apellido,
    E.nombre AS Equipo_actual,
    SUM(AP.kills) AS Total_Kills,
    SUM(AP.deaths) AS Total_Deaths,
    SUM(AP.assists) AS Total_Assists
FROM Persona P
INNER JOIN Jugador J ON P.id_persona = J.id_persona
INNER JOIN Integrante_Equipo IE ON J.id_persona = IE.id_jugador
INNER JOIN Equipo E ON IE.id_equipo = E.id_equipo
INNER JOIN Alineacion_Partido AP ON J.id_persona = AP.id_jugador
INNER JOIN Partido PA ON AP.id_partido = PA.id_partido
WHERE
    IE.fecha_egreso IS NULL
    AND P.activo = 1
    AND PA.estado = 'Jugado'
GROUP BY
    J.nick, P.nombre, P.apellido, E.nombre
HAVING
    SUM(AP.kills) > 0;
GO

-- 2. Se crea una vista para saber los jugadores con mayor cantidad de kills, deaths o assists pero teniendo en cuenta un determinado torneo

CREATE OR ALTER VIEW view_estadisticasJugadoresPorTorneo AS
SELECT
    T.nombre AS Torneo,
    J.nick AS Nickname,
    P.nombre AS Nombre,
    P.apellido AS Apellido,
    E.nombre AS Equipo_Torneo,
    SUM(AP.kills) AS Total_Kills,
    SUM(AP.deaths) AS Total_Deaths,
    SUM(AP.assists) AS Total_Assists
FROM Persona P
INNER JOIN Jugador J ON P.id_persona = J.id_persona
INNER JOIN Alineacion_Partido AP ON J.id_persona = AP.id_jugador
INNER JOIN Equipo E ON AP.id_equipo = E.id_equipo
INNER JOIN Partido PA ON AP.id_partido = PA.id_partido
INNER JOIN Torneo T ON PA.id_torneo = T.id_torneo
WHERE
    PA.estado = 'Jugado'
GROUP BY
    T.nombre, J.nick, P.nombre, P.apellido, E.nombre
HAVING
    SUM(AP.kills) > 0;
GO