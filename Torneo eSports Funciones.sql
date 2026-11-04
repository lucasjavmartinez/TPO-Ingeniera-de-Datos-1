USE torneoEsportsBD1;
GO

-- 1. Esta funcion busca calcular el kda de los jugadores para medir su desempeño en la partida

CREATE OR ALTER FUNCTION fn_calcularKDA(
    @kills INT,
    @assists INT,
    @deaths INT
)
RETURNS DECIMAL(5,2)
AS
BEGIN
    DECLARE @ratioKDA DECIMAL(5,2);
    IF @deaths = 0
        SET @deaths = 1;
    SET @ratioKDA = CAST((@kills + @assists) AS DECIMAL(5,2)) / @deaths;
    RETURN @ratioKDA;
END;
GO

-- 2. Esta funcion busca calcular el winrate de un determinado equipo
CREATE OR ALTER FUNCTION fn_calcularWinrateEquipo(
    @id_equipo INT
)
RETURNS DECIMAL(5,2)
AS
BEGIN
    DECLARE @partidos_jugados INT;
    DECLARE @partidos_ganados INT;
    DECLARE @winrate DECIMAL(5,2);

    SELECT @partidos_jugados = COUNT(*)
    FROM Partido
    WHERE estado = 'Jugado'
        AND(id_equipo_a = @id_equipo OR id_equipo_b = @id_equipo);
    
    IF @partidos_jugados = 0
        RETURN 0.00;
    SELECT @partidos_ganados = COUNT(*)
    FROM Partido
    WHERE estado = 'Jugado'
        AND(
            (id_equipo_a = @id_equipo AND puntaje_a > puntaje_b)
            OR
            (id_equipo_b = @id_equipo AND puntaje_b > puntaje_a)
        );
    SET @winrate = CAST(@partidos_ganados AS DECIMAL (5,2)) / @partidos_jugados * 100;

    RETURN @winrate;
END;
GO

-- 3. Esta funcion nos devuelve al mvp del torneo

CREATE OR ALTER FUNCTION fn_obtenerMVP(
    @id_torneo INT
)
RETURNS VARCHAR(50)
AS
BEGIN
    DECLARE @nicknameMVP VARCHAR(50);

    SELECT TOP 1 @nicknameMVP = J.nick
    FROM Partido PA
    INNER JOIN Jugador J ON PA.id_mvp_jugador = J.id_persona
    WHERE PA.id_torneo = @id_torneo
    AND PA.estado = 'Jugado'
    AND PA.id_mvp_jugador IS NOT NULL
    GROUP BY J.nick
    ORDER BY COUNT(PA.id_partido) DESC;

    RETURN @nicknameMVP;
END;
GO