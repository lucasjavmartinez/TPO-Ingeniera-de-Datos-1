USE torneoEsportsBD1;
GO

--Procedimiento 1: sirve para insertar ya sea Organizador, Manager o Arbitro los cuales comparten atributos al ser Persona

CREATE OR ALTER PROCEDURE sp_insertPersonal
    @dni VARCHAR(10),
    @nombre VARCHAR(60),
    @apellido VARCHAR(60),
    @mail VARCHAR(100),
    @fecha_nacimiento DATE,
    @rol VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY --iniciamos el manejo de errores
        BEGIN TRAN;
        INSERT INTO Persona(dni, nombre, apellido, mail, fecha_nacimiento)
        VALUES (@dni, @nombre, @apellido, @mail, @fecha_nacimiento);

        DECLARE @NuevoIdPersona INT = SCOPE_IDENTITY();

        IF @rol = 'Organizador'
            INSERT INTO Organizador(id_persona) VALUES(@NuevoIdPersona);
        ELSE IF @rol = 'Manager'
            INSERT INTO Manager(id_persona) VALUES(@NuevoIdPersona);
        ELSE IF @rol = 'Arbitro'
            INSERT INTO Arbitro(id_persona) VALUES(@NuevoIdPersona);
        ELSE
        BEGIN
            THROW 50017, 'El rol es invalido, debe de ser Organizador, Manager o Arbitro', 1;
        END

        COMMIT TRAN; --si todo esta bien se guarda en la bd
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 --esto es del motor de base de datos
            ROLLBACK TRAN; --si falló se hace rollback de la transaccion
        DECLARE @Error NVARCHAR(4000) = 'Fallo al registrar personal: ' + ERROR_MESSAGE();
        THROW 50018, @Error, 1;
    END CATCH
END;
GO

-- Procedimiento 2: sirve para insertar unicamente jugadores ya que este a diferencia del resto tiene el atributo nick

CREATE OR ALTER PROCEDURE sp_insertarJugador
    @dni VARCHAR(10),
    @nombre VARCHAR(60),
    @apellido VARCHAR(60),
    @mail VARCHAR(100),
    @fecha_nacimiento DATE,
    @nick VARCHAR(30)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
        INSERT INTO Persona(dni, nombre, apellido, mail, fecha_nacimiento)
        VALUES (@dni, @nombre, @apellido, @mail, @fecha_nacimiento);

        DECLARE @NuevoIdPersona INT = SCOPE_IDENTITY();

        INSERT INTO Jugador(id_persona, nick)
        VALUES (@NuevoIdPersona, @nick);

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRAN;
        DECLARE @Error NVARCHAR(4000) = 'Fallo al registrar el jugador: ' + ERROR_MESSAGE();
        THROW 50019, @Error, 1;
    END CATCH
END;
GO

-- Sp 3: sirve para cambiar el estado de la persona a la cual se da de baja

CREATE OR ALTER PROCEDURE sp_bajaPersona
    @id_persona INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
        --comprobamos si el id existe en la base de datos, si no existe tira error
        IF NOT EXISTS (SELECT 1 FROM Persona WHERE id_persona = @id_persona)
        BEGIN
            THROW 50020, 'La persona no existe en el sistema', 1;
        END

        UPDATE Persona
        SET activo = 0
        WHERE id_persona = @id_persona;
        UPDATE Integrante_Equipo
        SET fecha_egreso = CAST(GETDATE() AS DATE)
            WHERE id_jugador = @id_persona
            AND fecha_egreso IS NULL;
        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
         ROLLBACK TRAN;
        DECLARE @Error NVARCHAR(4000) = 'Fallo al dar de baja a la persona: ' + ERROR_MESSAGE();
        THROW 50021, @Error, 1;
    END CATCH
END;
GO


--procedimiento 4: se crea para verificar que los atributos kda tengan sentido

CREATE OR ALTER PROCEDURE sp_verificarKDA
    @id_partido INT,
    @id_jugador INT,
    @kills INT,
    @deaths INT,
    @assists INT,
    @id_equipo INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
        --aca verificamos si no se superan las 30 muertes
        IF @deaths > 30
        BEGIN
            THROW 50022, 'No es posible tener mas de 30 muertes por partido', 1;
        END
        --aca verificamos si los atributos del kda no son negativos
        IF @kills < 0 OR @deaths < 0 OR @assists < 0
        BEGIN
            THROW 50023, 'No es posible tener datos de KDA negativos', 1;
        END
        --si todo esta ok:
        INSERT INTO Alineacion_Partido(id_partido, id_jugador, kills, deaths, assists, id_equipo)
        VALUES(@id_partido, @id_jugador, @kills, @deaths, @assists, @id_equipo);
        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRAN;
        DECLARE @Error NVARCHAR(4000) = 'Fallo al momento de cargar los datos del kda: '+ ERROR_MESSAGE();
        THROW 50024, @Error, 1;
    END CATCH
END;
GO


-- Procedimiento 5: Registra el resultado de un partido, elimina al perdedor y avanza al ganador a la siguiente ronda (o finaliza el torneo si es la final).

CREATE OR ALTER PROCEDURE sp_registrarResultadoPartido
    @id_partido INT,
    @puntaje_a INT,
    @puntaje_b INT,
    @id_mvp_jugador INT,
    @cantidad_espectadores INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Variables para almacenar los datos actuales del partido y calcular ganador/perdedor
    DECLARE @id_torneo INT;
    DECLARE @estado_torneo VARCHAR(15);
    DECLARE @estado_partido VARCHAR(10);
    DECLARE @id_equipo_a INT;
    DECLARE @id_equipo_b INT;
    DECLARE @id_partido_siguiente INT;
    DECLARE @lado_siguiente CHAR(1);
    DECLARE @id_ganador INT;
    DECLARE @id_perdedor INT;

    BEGIN TRY
        BEGIN TRAN;

        -- 1. Buscamos los datos del partido y el estado de su torneo
        SELECT 
            @id_torneo = P.id_torneo,
            @estado_torneo = T.estado,
            @estado_partido = P.estado,
            @id_equipo_a = P.id_equipo_a,
            @id_equipo_b = P.id_equipo_b,
            @id_partido_siguiente = P.id_partido_siguiente,
            @lado_siguiente = P.lado_siguiente
        FROM Partido P
        INNER JOIN Torneo T ON P.id_torneo = T.id_torneo
        WHERE P.id_partido = @id_partido;

        -- Validamos que el partido exista
        IF @id_torneo IS NULL
        BEGIN
            THROW 50025, 'El partido indicado no existe en el sistema.', 1;
        END

        -- Validamos que el torneo este 'En curso'
        IF @estado_torneo <> 'En curso'
        BEGIN
            THROW 50026, 'Solo se pueden registrar resultados de partidos pertenecientes a un torneo En curso.', 1;
        END

        -- Validamos que el partido este 'Pendiente' y tenga ambos equipos definidos
        IF @estado_partido <> 'Pendiente'
        BEGIN
            THROW 50027, 'El partido no se encuentra en estado Pendiente (ya fue jugado o cancelado).', 1;
        END

        IF @id_equipo_a IS NULL OR @id_equipo_b IS NULL
        BEGIN
            THROW 50028, 'No se puede cerrar el partido porque aun falta definir al menos uno de los equipos del cruce.', 1;
        END

        -- Validamos la regla de negocio del puntaje antes del CHECK constraint (16 para ganar, 0 a 15 el perdedor)
        IF NOT (
            (@puntaje_a = 16 AND @puntaje_b BETWEEN 0 AND 15) OR 
            (@puntaje_b = 16 AND @puntaje_a BETWEEN 0 AND 15)
        )
        BEGIN
            THROW 50029, 'Puntaje invalido: el ganador debe tener 16 puntos y el perdedor entre 0 y 15.', 1;
        END

        -- Determinamos quien gano y quien perdio segun el puntaje
        IF @puntaje_a > @puntaje_b
        BEGIN
            SET @id_ganador = @id_equipo_a;
            SET @id_perdedor = @id_equipo_b;
        END
        ELSE
        BEGIN
            SET @id_ganador = @id_equipo_b;
            SET @id_perdedor = @id_equipo_a;
        END

        -- Actualizamos el partido a 'Jugado'
        -- aca se ejecutaria el trigger trg_Partido_Validar, este verifica que ya esten cargados los 5 jugadores por equipo en Alineacion_Partido y el MVP.
        UPDATE Partido
        SET puntaje_a = @puntaje_a,
            puntaje_b = @puntaje_b,
            id_mvp_jugador = @id_mvp_jugador,
            cantidad_espectadores = @cantidad_espectadores,
            fecha_hora = ISNULL(fecha_hora, SYSDATETIME()),
            estado = 'Jugado'
        WHERE id_partido = @id_partido;

        -- Actualizamos el estado del equipo perdedor a 'Eliminado' en la tabla Inscripcion
        UPDATE Inscripcion
        SET estado = 'Eliminado'
        WHERE id_torneo = @id_torneo 
          AND id_equipo = @id_perdedor;

        -- Logica de avance de ronda o cierre de torneo
        IF @id_partido_siguiente IS NOT NULL
        BEGIN
            -- Si hay partido siguiente, colocamos al ganador en el lado correspondiente ('A' o 'B')
            IF @lado_siguiente = 'A'
            BEGIN
                UPDATE Partido
                SET id_equipo_a = @id_ganador
                WHERE id_partido = @id_partido_siguiente;
            END
            ELSE IF @lado_siguiente = 'B'
            BEGIN
                UPDATE Partido
                SET id_equipo_b = @id_ganador
                WHERE id_partido = @id_partido_siguiente;
            END
        END
        ELSE
        BEGIN
            --aca comprobamos que no exista un partido en estado pendiente
            IF NOT EXISTS(SELECT 1 FROM Partido WHERE id_torneo = @id_torneo AND estado = 'Pendiente' AND id_partido <> @id_partido)
            BEGIN
                UPDATE Torneo
                SET estado = 'Finalizado',
                    fecha_fin = CAST(GETDATE()AS DATE)
                WHERE id_torneo = @id_torneo;
            
            UPDATE Inscripcion
            SET estado = 'Eliminado'
            WHERE id_torneo = @id_torneo
                AND id_equipo <> @id_ganador
                AND estado = 'Activo';
            END
        END
        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRAN;
        DECLARE @Error NVARCHAR(4000) = 'Fallo al registrar el resultado del partido: ' + ERROR_MESSAGE();
        THROW 50030, @Error, 1;
    END CATCH
END;
GO

-- Procedimiento 6 (con Cursor): Liquida y registra los pagos de premios de un torneo finalizado evaluando la situacion individual y disciplinaria de cada jugador finalista.

CREATE OR ALTER PROCEDURE sp_liquidarPremiosTorneo
    @id_torneo INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Variables del torneo y del partido final
    DECLARE @estado_torneo VARCHAR(15);
    DECLARE @premio_base DECIMAL(12,2);
    DECLARE @fecha_inicio_torneo DATE;
    DECLARE @fecha_fin_torneo DATE;
    DECLARE @id_partido_final INT;
    DECLARE @id_equipo_campeon INT;
    DECLARE @id_equipo_subcampeon INT;

    -- Variables para el calculo de montos
    DECLARE @monto_base_campeon DECIMAL(12,2);
    DECLARE @monto_base_subcampeon DECIMAL(12,2);
    DECLARE @monto_mvp DECIMAL(12,2);
    DECLARE @nick_mvp VARCHAR(50);
    DECLARE @id_jugador_mvp INT;

    -- Variables que usara el CURSOR fila por fila
    DECLARE @cur_id_jugador INT;
    DECLARE @cur_id_equipo INT;
    DECLARE @tipo_premio VARCHAR(12);
    DECLARE @monto_final_jugador DECIMAL(12,2);

    BEGIN TRY
        BEGIN TRAN;

        -- Verificamos que el torneo exista y obtenemos sus datos
        SELECT 
            @estado_torneo = estado,
            @premio_base = premio_base,
            @fecha_inicio_torneo = fecha_inicio,
            @fecha_fin_torneo = ISNULL(fecha_fin, CAST(GETDATE() AS DATE))
        FROM Torneo
        WHERE id_torneo = @id_torneo;

        IF @estado_torneo IS NULL
        BEGIN
            THROW 50031, 'El torneo indicado no existe.', 1;
        END

        -- Validamos que el torneo este Finalizado (coherente con trg_PagoPremio_Validar)
        IF @estado_torneo <> 'Finalizado'
        BEGIN
            THROW 50032, 'Solo se pueden liquidar premios de un torneo que se encuentre Finalizado.', 1;
        END

        -- Validamos que los premios de este torneo no se hayan pagado antes
        IF EXISTS (SELECT 1 FROM Pago_Premio WHERE id_torneo = @id_torneo)
        BEGIN
            THROW 50033, 'Los premios para este torneo ya fueron liquidados anteriormente.', 1;
        END

        -- Obtenemos el partido correspondiente a la Gran Final (la fase mas alta jugada en el torneo) y determinamos que equipo salio campeon y cual subcampeon
        SELECT TOP 1
            @id_partido_final = id_partido,
            @id_equipo_campeon = CASE WHEN puntaje_a > puntaje_b THEN id_equipo_a ELSE id_equipo_b END,
            @id_equipo_subcampeon = CASE WHEN puntaje_a > puntaje_b THEN id_equipo_b ELSE id_equipo_a END
        FROM Partido
        WHERE id_torneo = @id_torneo
          AND estado = 'Jugado'
        ORDER BY nro_fase DESC;

        IF @id_partido_final IS NULL
        BEGIN
            THROW 50034, 'No se encontro un partido final jugado para poder liquidar los premios.', 1;
        END

        -- Calculamos los montos base individuales:
        -- 60% del premio_base para los 5 jugadores del campeon (12% c/u)
        -- 30% del premio_base para los 5 jugadores del subcampeon (6% c/u)
        -- 10% del premio_base para el MVP del torneo
        SET @monto_base_campeon = (@premio_base * 0.60) / 5.0;
        SET @monto_base_subcampeon = (@premio_base * 0.30) / 5.0;
        SET @monto_mvp = @premio_base * 0.10;

        -- Declaramos el CURSOR para recorrer a los 10 jugadores que disputaron la final
        DECLARE cur_jugadores_final CURSOR LOCAL FAST_FORWARD FOR
            SELECT id_jugador, id_equipo
            FROM Alineacion_Partido
            WHERE id_partido = @id_partido_final;

        OPEN cur_jugadores_final;
        FETCH NEXT FROM cur_jugadores_final INTO @cur_id_jugador, @cur_id_equipo;

        -- Iteramos sobre cada jugador de la final
        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Definimos si le corresponde el premio de 1er puesto o 2do puesto
            IF @cur_id_equipo = @id_equipo_campeon
            BEGIN
                SET @tipo_premio = '1er puesto';
                SET @monto_final_jugador = @monto_base_campeon;
            END
            ELSE
            BEGIN
                SET @tipo_premio = '2do puesto';
                SET @monto_final_jugador = @monto_base_subcampeon;
            END

            -- Evaluamos si este jugador tuvo sanciones vigentes durante las fechas del torneo, si registra sancion se le descuenta un 25% del premio por conducta antideportiva.
            IF EXISTS (
                SELECT 1 
                FROM Sancion 
                WHERE id_jugador = @cur_id_jugador
                  AND fecha_inicio <= @fecha_fin_torneo
                  AND fecha_fin >= @fecha_inicio_torneo
            )
            BEGIN
                SET @monto_final_jugador = @monto_final_jugador * 0.75;
            END

            -- Insertamos el pago individual del jugador en Pago_Premio
            INSERT INTO Pago_Premio (id_torneo, id_jugador, tipo, monto)
            VALUES (@id_torneo, @cur_id_jugador, @tipo_premio, @monto_final_jugador);

            -- Pasamos al siguiente jugador del cursor
            FETCH NEXT FROM cur_jugadores_final INTO @cur_id_jugador, @cur_id_equipo;
        END

        -- Cerramos y liberamos la memoria del cursor
        CLOSE cur_jugadores_final;
        DEALLOCATE cur_jugadores_final;

        -- Liquidamos el premio adicional al MVP del torneo reutilizando la funcion fn_obtenerMVP
        SET @nick_mvp = dbo.fn_obtenerMVP(@id_torneo);

        IF @nick_mvp IS NOT NULL
        BEGIN
            SELECT @id_jugador_mvp = id_persona 
            FROM Jugador 
            WHERE nick = @nick_mvp;

            INSERT INTO Pago_Premio (id_torneo, id_jugador, tipo, monto)
            VALUES (@id_torneo, @id_jugador_mvp, 'MVP', @monto_mvp);
        END

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        -- Si el cursor quedo abierto por algun error a mitad del bucle, lo cerramos y liberamos
        IF CURSOR_STATUS('local', 'cur_jugadores_final') >= 0
        BEGIN
            CLOSE cur_jugadores_final;
            DEALLOCATE cur_jugadores_final;
        END

        IF @@TRANCOUNT > 0
            ROLLBACK TRAN;

        DECLARE @Error NVARCHAR(4000) = 'Fallo al liquidar los premios del torneo: ' + ERROR_MESSAGE();
        THROW 50035, @Error, 1;
    END CATCH
END;
GO
