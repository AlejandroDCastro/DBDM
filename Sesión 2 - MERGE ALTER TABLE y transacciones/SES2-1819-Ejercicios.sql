
-- EJERCICIO 1

MERGE INTO jugadores j USING jugadores_nuevos jn ON ( j.jugador_id = jn.jugador_id )
WHEN MATCHED THEN UPDATE SET jugador_nombre = jugador_nombre || '(*)',
                             jugador_fecha_alta = jn.jugador_fecha_alta,
                             jugador_activo = jn.jugador_activo DELETE
WHERE
    ( jugador_activo = 0
      AND jn.jugador_activo = 0 )
WHEN NOT MATCHED THEN INSERT (
    jugador_id,
    jugador_nombre,
    jugador_fecha_alta ) VALUES (
    jn.jugador_id,
    jn.jugador_nombre,
    SYSDATE );


-- EJERCICIO 2

CREATE TABLE registro_entradas (
    jugador_id            VARCHAR2(50) NULL,
    registro_sk           INT
        GENERATED ALWAYS AS IDENTITY,
    registro_fecha_hora   DATE NOT NULL,
    registro_valido       INT DEFAULT 1 NOT NULL,
    CONSTRAINT chk_registro_valido CHECK ( registro_valido IN (
        0,
        1
    ) ),
    CONSTRAINT pk_registro_entradas PRIMARY KEY ( registro_sk )
);


-- EJERCICIO 3

INSERT INTO registro_entradas (
    jugador_id,
    registro_fecha_hora,
    registro_valido
) VALUES (
    'acastrovalero@gmail.com',
    SYSDATE,
    1
);

INSERT INTO registro_entradas (
    jugador_id,
    registro_fecha_hora,
    registro_valido
) VALUES (
    'alexchica@gmail.com',
    SYSDATE,
    1
);

INSERT INTO registro_entradas (
    jugador_id,
    registro_fecha_hora,
    registro_valido
) VALUES (
    'gabrielmartinez@gmail.com',
    SYSDATE,
    1
);

INSERT INTO registro_entradas (
    jugador_id,
    registro_fecha_hora,
    registro_valido
) VALUES (
    'acastrovalero@gmail.com',
    SYSDATE,
    1
);

INSERT INTO registro_entradas (
    jugador_id,
    registro_fecha_hora,
    registro_valido
) VALUES (
    'acastrovalero@gmail.com',
    SYSDATE,
    0
);

SELECT
    *
FROM
    registro_entradas;


-- EJERCICIO 4

-- La sentencia ALTER TABLE te permite modificar la estructura de una tabla
-- mientras que la sentencia UPDATE te permite modificar las filas la misma.


-- EJERCICIO 5

ALTER TABLE partidas ADD partida_puntuacion_2 INT NULL;


-- EJERCICIO 6

DELETE FROM registro_entradas;

ALTER TABLE registro_entradas ADD (
    CONSTRAINT fk_jugador_id FOREIGN KEY ( jugador_id )
        REFERENCES jugadores
);

ALTER TABLE registro_entradas MODIFY
    registro_fecha_hora DEFAULT SYSDATE;


-- EJERCICIO 7

INSERT INTO registro_entradas (
    jugador_id,
    registro_fecha_hora,
    registro_valido
) VALUES (
    'Jugador1@dbdm.es',
    SYSDATE,
    1
);

SELECT
    *
FROM
    registro_entradas; -- Aparece la nueva fila

ROLLBACK;

SELECT
    *
FROM
    registro_entradas; -- La fila ha desaparecido. Tabla vacía


-- EJERCICIO 8

GRANT SELECT ON registro_entradas TO dbdm_gma26;

INSERT INTO registro_entradas (
    jugador_id,
    registro_fecha_hora,
    registro_valido
) VALUES (
    'Jugador1@dbdm.es',
    SYSDATE,
    1
);

SELECT
    *
FROM
    registro_entradas; -- Aparece la fila insertada

COMMIT; -- Al compañero no le aparece hasta que no se ejecuta el commit

REVOKE ALL ON registro_entradas FROM dbdm_gma26; -- Ahora le quitamos los permisos