
-- EJERCICIO 1

DROP TABLE jugadores;

DROP TABLE partidas;

CREATE TABLE jugadores (
    jugador_id           VARCHAR2(50) NOT NULL,
    jugador_nombre       VARCHAR2(50) NOT NULL,
    jugador_fecha_alta   DATE NOT NULL,
    jugador_activo       INT DEFAULT 1 NOT NULL,
    CONSTRAINT pk_jugadores PRIMARY KEY ( jugador_id ),
    CONSTRAINT chk_activo CHECK ( jugador_activo IN (
        0,
        1
    ) )
);

CREATE TABLE partidas (
    partida_jugador_id     VARCHAR2(50) NOT NULL,
    partida_personaje_id   VARCHAR2(10) NOT NULL,
    partida_duracion       INT DEFAULT 0 NOT NULL,
    partida_fecha_inicio   DATE DEFAULT SYSDATE NOT NULL,
    partida_fecha_fin      DATE NULL,
    CONSTRAINT pk_partidas PRIMARY KEY ( partida_jugador_id,
                                         partida_personaje_id,
                                         partida_fecha_inicio ),
    CONSTRAINT fk_partida_jugador FOREIGN KEY ( partida_jugador_id )
        REFERENCES jugadores,
    CONSTRAINT fk_partida_personaje FOREIGN KEY ( partida_personaje_id )
        REFERENCES personajes
);

-- No se podrá crear primero la tabla partidas debido a que no hay una tabla jugadores
-- a la que haga referencia la columna partida_jugador_id


-- EJERCICIO 2

DROP TABLE partidas;

CREATE TABLE partidas (
    partida_jugador_id     VARCHAR2(50) NOT NULL,
    partida_personaje_id   VARCHAR2(10) NOT NULL,
    partida_duracion       INT DEFAULT 0 NOT NULL,
    partida_fecha_inicio   DATE DEFAULT SYSDATE NOT NULL,
    partida_fecha_fin      DATE NULL,
    partida_puntuacion     INT NULL,
    CONSTRAINT pk_partidas PRIMARY KEY ( partida_jugador_id,
                                         partida_personaje_id,
                                         partida_fecha_inicio ),
    CONSTRAINT fk_jugador_id FOREIGN KEY ( partida_jugador_id )
        REFERENCES jugadores,
    CONSTRAINT fk_personaje_id FOREIGN KEY ( partida_personaje_id )
        REFERENCES personajes
);


-- EJERCICIO 3

INSERT INTO jugadores VALUES (
    'Jugador1@dbdm.es',
    'Jugador 1',
    TO_DATE('01-01-2016', 'dd-mm-yyyy'),
    1
);

INSERT INTO jugadores VALUES (
    'Jugadora2@dbdm.es',
    'Jugadora 2',
    TO_DATE('01-01-2017', 'dd-mm-yyyy'),
    1
);

INSERT INTO jugadores VALUES (
    'Jugadora3@dbdm.es',
    'Jugadora 3',
    TO_DATE('01-01-2017', 'dd-mm-yyyy'),
    1
);

INSERT INTO jugadores VALUES (
    'Jugador4@dbdm.es',
    'Jugador 4',
    TO_DATE('01-01-2018', 'dd-mm-yyyy'),
    0
);

INSERT INTO partidas VALUES (
    'Jugador1@dbdm.es',
    'MAGO',
    140,
    TO_DATE('02-02-2016 18:00:00', 'DD-MM-YYYY HH24:MI:SS'),
    TO_DATE('03-02-2016 20:05:00', 'DD-MM-YYYY HH24:MI:SS'),
    520
);

INSERT INTO partidas VALUES (
    'Jugador1@dbdm.es',
    'PALA',
    180,
    TO_DATE('05-02-2017 21:00:05', 'DD-MM-YYYY HH24:MI:SS'),
    TO_DATE('06-02-2017 23:15:12', 'DD-MM-YYYY HH24:MI:SS'),
    620
);

INSERT INTO partidas VALUES (
    'Jugadora2@dbdm.es',
    'BARBA',
    30,
    TO_DATE('02-02-2016 10:15:00', 'DD-MM-YYYY HH24:MI:SS'),
    TO_DATE('02-02-2016 16:12:25', 'DD-MM-YYYY HH24:MI:SS'),
    600
);

INSERT INTO partidas VALUES (
    'Jugadora2@dbdm.es',
    'BARBO',
    40,
    TO_DATE('11-07-2018 23:30:00', 'DD-MM-YYYY HH24:MI:SS'),
    TO_DATE('12-07-2018 01:12:23', 'DD-MM-YYYY HH24:MI:SS'),
    400
);

INSERT INTO partidas VALUES (
    'Jugadora2@dbdm.es',
    'PALO',
    10,
    TO_DATE('02-01-2019 00:00:00', 'DD-MM-YYYY HH24:MI:SS'),
    TO_DATE('02-01-2019 04:12:12', 'DD-MM-YYYY HH24:MI:SS'),
    300
);

INSERT INTO partidas VALUES (
    'Jugadora3@dbdm.es',
    'PALA',
    150,
    TO_DATE('28-01-2019 17:00:00', 'DD-MM-YYYY HH24:MI:SS'),
    NULL,
    NULL
);

INSERT INTO partidas VALUES (
    'Jugadora2@dbdm.es',
    'BARBA',
    25,
    TO_DATE('28-01-2019 19:00:00', 'DD-MM-YYYY HH24:MI:SS'),
    NULL,
    NULL
);


-- EJERCICIO 4 

UPDATE personajes
SET
    personaje_sexo = 'M'
WHERE
    personaje_id = 'HECHICERA';


-- EJERCICIO 5

SELECT
    *
FROM
    jugadores
WHERE
    TO_CHAR(jugador_fecha_alta, 'yyyy') = '2018';


-- EJERCICIO 6

SELECT
    jugador_id,
    jugador_nombre,
    SUM(partida_duracion) / 60 AS duracion
FROM
    jugadores
    JOIN partidas ON ( partida_jugador_id = jugador_id )
WHERE
    TO_CHAR(partida_fecha_inicio, 'dd/mm/yyyy') > '01/01/2019'
GROUP BY
    jugador_id,
    jugador_nombre
HAVING
    ( SUM(partida_duracion) / 60 ) > 6
ORDER BY
    SUM(partida_duracion) DESC;


-- EJERCICIO 7

SELECT
    personaje_id,
    personaje_nombre,
    COUNT(DISTINCT partida_jugador_id) njugadores
FROM
    personajes left
    JOIN partidas ON ( personaje_id = partida_personaje_id )
GROUP BY
    personaje_id,
    personaje_nombre
ORDER BY
    3 DESC;


-- EJERCICIO 8

SELECT
    jugador_id,
    jugador_nombre,
    MAX(partida_puntuacion),
    MIN(partida_puntuacion),
    AVG(partida_puntuacion)
FROM
    jugadores   j,
    partidas    p
WHERE
    j.jugador_id = p.partida_jugador_id
    AND j.jugador_activo = 1
    AND p.partida_fecha_fin IS NOT NULL
GROUP BY
    jugador_id,
    jugador_nombre;


-- EJERCICIO 9

SELECT
    TO_CHAR(partida_fecha_inicio, 'Day') AS dia,
    personaje_nombre,
    COUNT(*) AS veces_utilizado
FROM
    personajes
    INNER JOIN partidas ON personaje_id = partida_personaje_id
WHERE
    partida_fecha_fin IS NOT NULL
    AND partida_puntuacion IS NOT NULL
    AND partida_puntuacion <> 0
GROUP BY
    TO_CHAR(partida_fecha_inicio, 'Day'),
    TO_CHAR(partida_fecha_inicio, 'D'),
    personaje_id,
    personaje_nombre
ORDER BY
    TO_CHAR(partida_fecha_inicio, 'D') ASC;


-- EJERCICIO 10

DELETE FROM partidas
WHERE
    TO_DATE('01/01/2018', 'dd/mm/yyyy') > partida_fecha_inicio;