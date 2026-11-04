-- Inserts de datos, se usaron datos de equipos, jugadores y demas que juegan lol

USE torneoEsportsBD1;
GO

INSERT INTO Juego (nombre, descripcion) 
VALUES ('League of Legends', 'MOBA 5v5 competitivo desarrollado por Riot Games');
GO

--organizador
EXEC sp_insertPersonal '11111111', 'John', 'Needham', 'jneedham@riotgames.com', '1980-05-10', 'Organizador';
GO

-- managers
EXEC sp_insertPersonal '22222222', 'Jeong-gyun', 'Kim', 'kkoma@t1.gg', '1985-12-23', 'Manager';
EXEC sp_insertPersonal '33333333', 'Dong-bin', 'Go', 'score@geng.gg', '1992-07-08', 'Manager';
EXEC sp_insertPersonal '44444444', 'Romain', 'Bigeard', 'romain@g2esports.com', '1989-11-30', 'Manager';
EXEC sp_insertPersonal '55555550', 'Patrik', 'Sattermon', 'carn@fnatic.com', '1985-04-12', 'Manager';
EXEC sp_insertPersonal '55555555', 'Steve', 'Arhancet', 'steve@teamliquid.com', '1981-04-15', 'Manager';
GO

--arbitro
EXEC sp_insertPersonal '99999999', 'Marc', 'Merrill', 'marc@riotgames.com', '1980-08-22', 'Arbitro';
GO

--jugadores t1
EXEC sp_insertarJugador '66666661', 'Woo-je', 'Choi', 'zeus@t1.gg', '2004-01-31', 'Zeus';
EXEC sp_insertarJugador '66666662', 'Hyeon-joon', 'Moon', 'oner@t1.gg', '2002-12-24', 'Oner';
EXEC sp_insertarJugador '66666663', 'Sang-hyeok', 'Lee', 'faker@t1.gg', '1996-05-07', 'Faker';
EXEC sp_insertarJugador '66666664', 'Min-hyeong', 'Lee', 'gumayusi@t1.gg', '2002-02-06', 'Gumayusi';
EXEC sp_insertarJugador '66666665', 'Min-seok', 'Ryu', 'keria@t1.gg', '2002-10-14', 'Keria';

--jugadores geng
EXEC sp_insertarJugador '77777771', 'Hyeon-joon', 'Choi', 'doran@geng.gg', '2000-07-22', 'Doran';
EXEC sp_insertarJugador '77777772', 'Wang-ho', 'Han', 'peanut@geng.gg', '1998-02-03', 'Peanut';
EXEC sp_insertarJugador '77777773', 'Ji-hoon', 'Jeong', 'chovy@geng.gg', '2001-03-03', 'Chovy';
EXEC sp_insertarJugador '77777774', 'Su-hwan', 'Kim', 'peyz@geng.gg', '2005-12-05', 'Peyz';
EXEC sp_insertarJugador '77777775', 'Hwan-joong', 'Yoo', 'delight@geng.gg', '2002-09-12', 'Delight';

--jugadores g2
EXEC sp_insertarJugador '88888881', 'Sergen', 'Celik', 'brokenblade@g2.com', '2000-01-19', 'BrokenBlade';
EXEC sp_insertarJugador '88888882', 'Martin', 'Sundelin', 'yike@g2.com', '2000-11-11', 'Yike';
EXEC sp_insertarJugador '88888883', 'Rasmus', 'Winther', 'caps@g2.com', '1999-11-17', 'Caps';
EXEC sp_insertarJugador '88888884', 'Steven', 'Liv', 'hanssama@g2.com', '1999-09-02', 'Hans Sama';
EXEC sp_insertarJugador '88888885', 'Mihael', 'Mehle', 'mikyx@g2.com', '1998-11-02', 'Mikyx';

--jugadores fnatic
EXEC sp_insertarJugador '98888881', 'Oscar', 'Munoz', 'oscarinin@fnatic.com', '2003-05-15', 'Oscarinin';
EXEC sp_insertarJugador '98888882', 'Ivan', 'Martin', 'razork@fnatic.com', '2000-10-07', 'Razork';
EXEC sp_insertarJugador '98888883', 'Marek', 'Brazda', 'humanoid@fnatic.com', '2000-03-14', 'Humanoid';
EXEC sp_insertarJugador '98888884', 'Oh', 'Taek', 'noah@fnatic.com', '2001-10-04', 'Noah';
EXEC sp_insertarJugador '98888885', 'Yoon', 'Se-jun', 'jun@fnatic.com', '2000-08-20', 'Jun';
GO

-- agregamos mas personas para que cumpla con el requisito de sistema de tener al menos 8 equipos anotados en 1 torneo

EXEC sp_insertPersonal '55555561', 'Bai', 'Jiahao', 'tabe@blg.cn', '1991-01-18', 'Manager';
EXEC sp_insertPersonal '55555562', 'Yoon', 'Seong-young', 'homme@jdg.cn', '1985-03-02', 'Manager';
EXEC sp_insertPersonal '55555563', 'Thomas', 'Siikken', 'thinkcard@nrg.gg', '1993-06-12', 'Manager';
EXEC sp_insertPersonal '55555564', 'Alfonso', 'Aguirre', 'mithy@cloud9.gg', '1994-11-07', 'Manager';

-- jugadores

EXEC sp_insertarJugador '10000001', 'Ze-Bin', 'Chen', 'bin@blg.cn', '2002-09-28', 'Bin';
EXEC sp_insertarJugador '10000002', 'Peng', 'Xun', 'xun@blg.cn', '2002-02-05', 'Xun';
EXEC sp_insertarJugador '10000003', 'Jia-Hao', 'Zeng', 'yagao@blg.cn', '1998-10-19', 'Yagao';
EXEC sp_insertarJugador '10000004', 'Zhao', 'Jia-Hao', 'elk@blg.cn', '2001-09-29', 'Elk';
EXEC sp_insertarJugador '10000005', 'Luo', 'Wen-Jun', 'on@blg.cn', '2003-05-11', 'ON';

EXEC sp_insertarJugador '20000001', 'Bai', 'Jia-Hao', '369@jdg.cn', '2001-07-12', '369';
EXEC sp_insertarJugador '20000002', 'Seo', 'Jin-hyeok', 'kanavi@jdg.cn', '2000-11-02', 'Kanavi';
EXEC sp_insertarJugador '20000003', 'Zhuo', 'Ding', 'knight@jdg.cn', '2000-05-22', 'knight';
EXEC sp_insertarJugador '20000004', 'Park', 'Jae-hyuk', 'ruler@jdg.cn', '1998-12-29', 'Ruler';
EXEC sp_insertarJugador '20000005', 'Lou', 'Yun-Feng', 'missing@jdg.cn', '2001-05-26', 'MISSING';

EXEC sp_insertarJugador '30000001', 'Niship', 'Doshi', 'dhokla@nrg.gg', '1997-08-15', 'Dhokla';
EXEC sp_insertarJugador '30000002', 'Juan', 'Arturo', 'contractz@nrg.gg', '1999-08-26', 'Contractz';
EXEC sp_insertarJugador '30000003', 'Cristian', 'Palafox', 'palafox@nrg.gg', '1999-07-02', 'Palafox';
EXEC sp_insertarJugador '30000004', 'Victor', 'Huang', 'fbi@nrg.gg', '1999-02-17', 'FBI';
EXEC sp_insertarJugador '30000005', 'Lee', 'Dong-geun', 'ignar@nrg.gg', '1996-11-14', 'IgNar';

EXEC sp_insertarJugador '40000001', 'Ibrahim', 'Allami', 'fudge@cloud9.gg', '2002-04-30', 'Fudge';
EXEC sp_insertarJugador '40000002', 'Robert', 'Huang', 'blaber@cloud9.gg', '2000-01-04', 'Blaber';
EXEC sp_insertarJugador '40000003', 'Jang', 'Ha-gwon', 'emenes@cloud9.gg', '2002-01-22', 'EMENES';
EXEC sp_insertarJugador '40000004', 'Kim', 'Min-cheol', 'berserker@cloud9.gg', '2003-05-25', 'Berserker';
EXEC sp_insertarJugador '40000005', 'Jesper', 'Svenningsen', 'zven@cloud9.gg', '1997-06-24', 'Zven';
GO


INSERT INTO Equipo (id_manager, nombre, fecha_alta) VALUES 
(2, 'T1', CAST(GETDATE() AS DATE)),
(3, 'Gen.G', CAST(GETDATE() AS DATE)),
(4, 'G2 Esports', CAST(GETDATE() AS DATE)),
(5, 'Fnatic', CAST(GETDATE() AS DATE)),
(6, 'Team Liquid', DATEADD(DAY, -75, GETDATE())), -- este es un equipo fantasma para hacer una consulta
(28, 'Bilibili Gaming', CAST(GETDATE() AS DATE)),
(29, 'JD Gaming', CAST(GETDATE() AS DATE)),
(30, 'NRG', CAST(GETDATE() AS DATE)),
(31, 'Cloud9', CAST(GETDATE() AS DATE)); 
GO

INSERT INTO Integrante_Equipo (id_equipo, id_jugador) VALUES 
(1, 8), (1, 9), (1, 10), (1, 11), (1, 12),--t1
(2, 13), (2, 14), (2, 15), (2, 16), (2, 17),--genG
(3, 18), (3, 19), (3, 20), (3, 21), (3, 22),--g2 esports
(4, 23), (4, 24), (4, 25), (4, 26), (4, 27),--fnatic
(6, 32), (6, 33), (6, 34), (6, 35), (6, 36),--bilibili gaming
(7, 37), (7, 38), (7, 39), (7, 40), (7, 41),--jd gaming
(8, 42), (8, 43), (8, 44), (8, 45), (8, 46),--nrg
(9, 47), (9, 48), (9, 49), (9, 50), (9, 51);--cloud9
GO

INSERT INTO Torneo (id_juego, id_organizador, nombre, fecha_inicio, cantidad_equipos, premio_base, estado) 
VALUES 
--se anotan los 3 en curso pero luego se ira modificando
(1, 1, 'Worlds 2023 - Main Event', '2023-10-10', 8, 2000000.00, 'Inscripcion'),
(1, 1, 'MSI 2024 - Bracket Stage', '2024-05-01', 8, 500000.00, 'Inscripcion'),
(1, 1, 'Esports World Cup 2024', '2024-07-01', 8, 250000.00, 'Inscripcion');
GO

INSERT INTO Inscripcion (id_torneo, id_equipo, estado) VALUES 
-- hay 8 equipos en el id torneo 1 y 2, y solo 3 en el id torneo 3 (esto hace que figure en inscripcion)
(1, 1, 'Activo'), (1, 2, 'Activo'), (1, 3, 'Activo'), (1, 4, 'Activo'),
(1, 6, 'Activo'), (1, 7, 'Activo'), (1, 8, 'Activo'), (1, 9, 'Activo'),
(2, 1, 'Activo'), (2, 2, 'Activo'), (2, 3, 'Activo'), (2, 4, 'Activo'),
(2, 6, 'Activo'), (2, 7, 'Activo'), (2, 8, 'Activo'), (2, 9, 'Activo'),
(3, 2, 'Activo'), (3, 3, 'Activo'), (3, 4, 'Activo');
GO

--cambiamos el estado a 'en curso' porque cumple con el cupo de minimo 8 inscriptos
UPDATE Torneo SET estado = 'En curso' WHERE id_torneo IN (1, 2);
GO

INSERT INTO Partido (id_torneo, nro_fase, nro_llave, id_arbitro, id_equipo_a, id_equipo_b, fecha_hora, estado)
VALUES 
(1, 1, 1, 7, 1, 2, '2023-10-15 15:00:00', 'Pendiente'), -- ID 1: T1 vs Gen.G (Torneo 1)
(1, 1, 2, 7, 3, 4, '2023-10-16 15:00:00', 'Pendiente'), -- ID 2: G2 vs Fnatic (Torneo 1)
(1, 2, 1, 7, NULL, NULL, '2023-10-20 18:00:00', 'Pendiente'), -- ID 3: Gran Final Torneo 1
(2, 1, 1, 7, 1, 2, '2024-05-05 16:00:00', 'Pendiente'), -- ID 4: T1 vs Gen.G (MSI - Torneo 2)
(2, 1, 2, 7, 4, NULL, NULL, 'Pendiente'), -- ID 5: Fnatic vs TBD (MSI - Torneo 2)
--agregamos un partido del torneo 2 que aun no se juega para probar la consulta 1
(2, 2, 1, 7, NULL, NULL, '2024-05-12 18:00:00', 'Pendiente'); -- ID 6: Gran Final Torneo 2 (MSI)
GO

-- Arbol/llaves del Torneo 1 y del Torneo 2
UPDATE Partido SET id_partido_siguiente = 3, lado_siguiente = 'A' WHERE id_partido = 1;
UPDATE Partido SET id_partido_siguiente = 3, lado_siguiente = 'B' WHERE id_partido = 2;

UPDATE Partido SET id_partido_siguiente = 6, lado_siguiente = 'A' WHERE id_partido = 4;
UPDATE Partido SET id_partido_siguiente = 6, lado_siguiente = 'B' WHERE id_partido = 5;
GO

-- Carga de estadisticas (Alineacion_Partido) y cierre de Semifinales del Torneo 1 usando nuestros SPs
-- Partido 1 (T1 vs Gen.G)
EXEC sp_verificarKDA 1, 8, 2, 4, 10, 1;
EXEC sp_verificarKDA 1, 9, 5, 3, 15, 1;
EXEC sp_verificarKDA 1, 10, 12, 1, 8, 1;
EXEC sp_verificarKDA 1, 11, 10, 2, 6, 1;
EXEC sp_verificarKDA 1, 12, 1, 2, 22, 1;
EXEC sp_verificarKDA 1, 13, 2, 6, 4, 2;
EXEC sp_verificarKDA 1, 14, 3, 5, 8, 2;
EXEC sp_verificarKDA 1, 15, 9, 3, 5, 2;
EXEC sp_verificarKDA 1, 16, 4, 7, 3, 2;
EXEC sp_verificarKDA 1, 17, 0, 9, 12, 2;

-- Cerramos Partido 1: Gana T1 (16-12), MVP Faker (10). T1 avanza automaticamente al lado 'A' del Partido 3.
EXEC sp_registrarResultadoPartido @id_partido = 1, @puntaje_a = 16, @puntaje_b = 12, @id_mvp_jugador = 10, @cantidad_espectadores = 150000;

-- Partido 2 (G2 vs Fnatic)
EXEC sp_verificarKDA 2, 18, 6, 2, 5, 3;
EXEC sp_verificarKDA 2, 19, 4, 3, 10, 3;
EXEC sp_verificarKDA 2, 20, 15, 1, 6, 3;
EXEC sp_verificarKDA 2, 21, 8, 2, 7, 3;
EXEC sp_verificarKDA 2, 22, 1, 2, 18, 3;
EXEC sp_verificarKDA 2, 23, 2, 8, 3, 4;
EXEC sp_verificarKDA 2, 24, 3, 6, 5, 4;
EXEC sp_verificarKDA 2, 25, 4, 5, 4, 4;
EXEC sp_verificarKDA 2, 26, 1, 9, 2, 4;
EXEC sp_verificarKDA 2, 27, 0, 6, 8, 4;

-- Cerramos Partido 2: Gana G2 (16-10), MVP Caps (20). G2 avanza automaticamente al lado 'B' del Partido 3.
EXEC sp_registrarResultadoPartido @id_partido = 2, @puntaje_a = 16, @puntaje_b = 10, @id_mvp_jugador = 20, @cantidad_espectadores = 120000;
GO

-- Carga de estadisticas y cierre de la Gran Final del Torneo 1 (Partido 3: T1 vs G2 Esports)
EXEC sp_verificarKDA 3, 8, 4, 3, 8, 1;
EXEC sp_verificarKDA 3, 9, 6, 4, 12, 1;
EXEC sp_verificarKDA 3, 10, 14, 2, 9, 1;
EXEC sp_verificarKDA 3, 11, 8, 3, 7, 1;
EXEC sp_verificarKDA 3, 12, 2, 1, 18, 1;
EXEC sp_verificarKDA 3, 18, 3, 7, 5, 3;
EXEC sp_verificarKDA 3, 19, 4, 6, 7, 3;
EXEC sp_verificarKDA 3, 20, 10, 4, 4, 3;
EXEC sp_verificarKDA 3, 21, 5, 8, 6, 3;
EXEC sp_verificarKDA 3, 22, 1, 9, 15, 3;

-- Cerramos la Gran Final (Partido 3): Gana T1 (16-14), MVP Faker (10).
-- Como no tiene partido siguiente, el SP pasa automaticamente el Torneo 1 a 'Finalizado'.
EXEC sp_registrarResultadoPartido @id_partido = 3, @puntaje_a = 16, @puntaje_b = 14, @id_mvp_jugador = 10, @cantidad_espectadores = 420000;
GO

-- Carga de estadisticas y cierre del Partido 4 (Torneo 2 - MSI 2024: T1 vs Gen.G)
EXEC sp_verificarKDA 4, 8, 1, 6, 4, 1;
EXEC sp_verificarKDA 4, 9, 3, 5, 2, 1;
EXEC sp_verificarKDA 4, 10, 5, 4, 3, 1;
EXEC sp_verificarKDA 4, 11, 4, 3, 1, 1;
EXEC sp_verificarKDA 4, 12, 1, 4, 8, 1;
EXEC sp_verificarKDA 4, 13, 5, 2, 7, 2;
EXEC sp_verificarKDA 4, 14, 4, 1, 12, 2;
EXEC sp_verificarKDA 4, 15, 11, 2, 6, 2;
EXEC sp_verificarKDA 4, 16, 7, 1, 5, 2;
EXEC sp_verificarKDA 4, 17, 0, 2, 16, 2;

EXEC sp_registrarResultadoPartido @id_partido = 4, @puntaje_a = 14, @puntaje_b = 16, @id_mvp_jugador = 15, @cantidad_espectadores = 210000;
GO

-- Sanciones:
-- Sancion vigente hoy a Peanut (id_jugador = 14) para probar la Subconsulta 1 de auditoria
INSERT INTO Sancion (id_jugador, motivo, fecha_inicio, fecha_fin)
VALUES (14, 'Comportamiento antideportivo en stage', DATEADD(DAY, -5, GETDATE()), DATEADD(DAY, 10, GETDATE()));

-- Sancion historica a Mikyx (id_jugador = 22) posterior al partido pero dentro del periodo del Torneo 1
-- para demostrar el descuento del 25% que aplica el CURSOR al liquidar premios
INSERT INTO Sancion (id_jugador, motivo, fecha_inicio, fecha_fin)
VALUES (22, 'Retraso reiterado en el check-in de la final', '2023-10-21', '2023-10-25');
GO

-- Ejecutamos el CURSOR para liquidar los premios del Torneo 1 ('Worlds 2023 - Main Event')
EXEC sp_liquidarPremiosTorneo @id_torneo = 1;
GO