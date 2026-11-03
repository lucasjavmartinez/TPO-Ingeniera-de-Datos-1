USE torneoEsportsBD1;
GO

-- 1. Se crea una vista para saber los jugadores con mayor cantidad de kills, deaths o assits (teniendo en cuenta todos los torneos)
CREATE VIEW view_estadisticasJugadoresActivos AS
SELECT
    J.nick as Nickname,
    P.nombre as Nombre,
    P.apellido as Apellido,
    E.nombre as Equipo_actual,
    SUM(AP.kills) as Total_Kills,
    SUM(AP.deaths) as Total_Deaths,
    SUM(AP.assists) as Total_Assists
FROM Persona P

INNER JOIN Jugador J ON P.id_persona = J.id_persona
INNER JOIN Integrante_Equipo IE ON J.id_persona = IE.id_jugador
INNER JOIN Equipo E ON IE.id_equipo = E.id_equipo
INNER JOIN Alineacion_Partido AP ON J.id_persona = AP.id_jugador

WHERE
    IE.fecha_egreso IS NULL
GROUP BY
    J.nick, P.nombre, P.apellido, E.nombre
HAVING
    SUM(AP.kills) > 0;
GO

-- 2. Se crea una vista para saber los jugadores con mayor cantidad de kills, deaths o assists pero teniendo en cuenta un determinado torneo

CREATE VIEW view_estadisticasJugadoresPorTorneo AS
SELECT
    T.nombre as Torneo,
    J.nick as Nickname,
    P.nombre as Nombre,
    P.apellido as Apellido,
    E.nombre as Equipo_Actual,
    SUM(AP.kills) as Total_Kills,
    SUM(AP.deaths) as Total_Deaths,
    SUM(AP.assists) as Total_Assists
FROM Persona P

INNER JOIN Jugador J ON P.id_persona = J.id_persona
INNER JOIN Integrante_Equipo IE ON P.id_persona = IE.id_jugador
INNER JOIN Equipo E ON IE.id_equipo = E.id_equipo
INNER JOIN Alineacion_Partido AP ON J.id_persona = AP.id_jugador
INNER JOIN Partido PA ON AP.id_partido = PA.id_partido
INNER JOIN Torneo T ON PA.id_torneo = T.id_torneo

WHERE
    IE.fecha_egreso IS NULL
GROUP BY
    T.nombre, J.nick, P.nombre, P.apellido, E.nombre
HAVING
    SUM(AP.kills) > 0;
GO