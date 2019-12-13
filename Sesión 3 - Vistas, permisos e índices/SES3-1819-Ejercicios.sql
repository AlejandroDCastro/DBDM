-- EJERCICIO 1
CREATE TABLE ataque_a_distancia (
    personaje_id         VARCHAR2(10) NOT NULL,
    distancia_hechizos   INT NOT NULL,
    distancia_destreza   INT NULL,
    CONSTRAINT pk_ataque_distancia PRIMARY KEY ( personaje_id ),
    CONSTRAINT fk_ataque_distancia FOREIGN KEY ( personaje_id )
        REFERENCES personajes,
    CONSTRAINT chk_distancia_hechizos CHECK ( distancia_hechizos IN (
        0,
        1
    ) )
);

CREATE TABLE ataque_cuerpo_a_cuerpo (
    personaje_id    VARCHAR2(10) NOT NULL,
    ataque_manos    INT NOT NULL,
    ataque_fuerza   INT NULL,
    CONSTRAINT pk_ataque_cuerpo_a_cuerpo PRIMARY KEY ( personaje_id ),
    CONSTRAINT fk_ataque_cuerpo_a_cuerpo FOREIGN KEY ( personaje_id )
        REFERENCES personajes,
    CONSTRAINT chk_ataque_fuerza CHECK ( ataque_manos IN (
        1,
        2
    ) )
);


-- EJERCICIO 2

INSERT INTO ataque_cuerpo_a_cuerpo (
    personaje_id,
    ataque_manos,
    ataque_fuerza
) VALUES (
    'PALO',
    1,
    70
);

INSERT INTO ataque_cuerpo_a_cuerpo (
    personaje_id,
    ataque_manos,
    ataque_fuerza
) VALUES (
    'PALA',
    1,
    60
);

INSERT INTO ataque_cuerpo_a_cuerpo (
    personaje_id,
    ataque_manos,
    ataque_fuerza
) VALUES (
    'BARBO',
    2,
    100
);

INSERT INTO ataque_cuerpo_a_cuerpo (
    personaje_id,
    ataque_manos,
    ataque_fuerza
) VALUES (
    'BARBA',
    2,
    90
);

INSERT INTO ataque_a_distancia (
    personaje_id,
    distancia_hechizos,
    distancia_destreza
) VALUES (
    'MAGO',
    1,
    200
);

INSERT INTO ataque_a_distancia (
    personaje_id,
    distancia_hechizos,
    distancia_destreza
) VALUES (
    'HECHICERA',
    1,
    300
);


-- EJERCICIO 3

CREATE OR REPLACE VIEW personajes_a_distancia AS
    SELECT
        p.*,
        a.distancia_hechizos,
        a.distancia_destreza
    FROM
        ataque_a_distancia   a,
        personajes           p
    WHERE
        a.personaje_id = p.personaje_id;

SELECT
    *
FROM
    personajes_a_distancia;


-- EJERCICIO 4

CREATE OR REPLACE VIEW personajes_femeninos AS
    SELECT
        *
    FROM
        personajes
    WHERE
        personaje_sexo = 'M';

INSERT INTO personajes_femeninos (
    personaje_id,
    personaje_nombre,
    personaje_tipo,
    personaje_sexo
) VALUES (
    'ARCO',
    'Arquero masculino',
    'ARQUERO',
    'H'
);

INSERT INTO personajes_femeninos (
    personaje_id,
    personaje_nombre,
    personaje_tipo,
    personaje_sexo
) VALUES (
    'ARCA',
    'Amazona',
    'ARQUERO',
    'M'
);

SELECT
    *
FROM
    personajes_femeninos; -- No se ven todas las filas insertadas

SELECT
    *
FROM
    personajes; -- Se ven todas las filas insertadas
-- Se podría evitar usando el modificador WITH CHECK OPTION


-- EJERCICIO 5

SELECT
    *
FROM
    dbdm_acv52.jugadores; -- No se ejecuta correctamente la sentencia


-- EJERCICIO 6

GRANT ALL ON jugadores TO invitado_dbdm_acv52;

SELECT
    *
FROM
    dbdm_acv52.jugadores; -- Se ejecuta correctamente la sentencia


-- EJERCICIO 7

REVOKE ALL ON jugadores FROM invitado_dbdm_acv52;

SELECT
    *
FROM
    dbdm_acv52.jugadores; -- No se ejecuta correctamente la sentencia


-- EJERCICIO 8

EXPLAIN PLAN SET STATEMENT_ID = 'SIN_INDICE'
    FOR
SELECT
    *
FROM
    jugadores
WHERE
    TO_CHAR(jugador_fecha_alta, 'yyyy') < '2018';

SELECT
    statement_id,
    operation,
    options,
    object_name,
    position
FROM
    plan_table;


-- EJERCICIO 9

CREATE INDEX indx_jugador_fecha_alta ON
    jugadores (
        jugador_fecha_alta
    );


-- EJERCICIO 10

EXPLAIN PLAN SET STATEMENT_ID = 'CON_INDICE'
    FOR
SELECT
    *
FROM
    jugadores
WHERE
    TO_CHAR(jugador_fecha_alta, 'yyyy') < '2018';

SELECT
    statement_id,
    operation,
    options,
    object_name,
    position
FROM
    plan_table;


-- EJERCICIO 11

-- En el primer caso haría una búsqueda secuencial por todas las filas, y en la segunda
-- utilizaría el índice que hemos creado.