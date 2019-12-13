-- EJERCICIO 1
DROP TABLE salarios;

DROP TABLE lo_conduce;

DROP TABLE conductores;

DROP TABLE autobuses;

DROP TABLE plazas_parking;

CREATE TABLE plazas_parking (
    clave VARCHAR2(256) NOT NULL,
    CONSTRAINT pk_plazas_parking PRIMARY KEY ( clave )
);

CREATE TABLE autobuses (
    nombre   VARCHAR2(100) NOT NULL,
    marca    VARCHAR2(100),
    clave    VARCHAR2(256) NOT NULL UNIQUE,
    CONSTRAINT pk_autobuses PRIMARY KEY ( nombre ),
    CONSTRAINT fk_clave FOREIGN KEY ( clave )
        REFERENCES plazas_parking ( clave )
);

CREATE TABLE conductores (
    dni               CHAR(9) NOT NULL,
    nombre            VARCHAR2(100) NOT NULL,
    años_antiguedad   INT,
    CONSTRAINT pk_conductores PRIMARY KEY ( dni )
);

CREATE TABLE lo_conduce (
    conductor   CHAR(9) NOT NULL,
    fecha       DATE NOT NULL,
    CONSTRAINT pk_lo_conduce PRIMARY KEY ( conductor ),
    CONSTRAINT fk_conductor FOREIGN KEY ( conductor )
        REFERENCES conductores ( dni )
);

CREATE TABLE salarios (
    codigo                 VARCHAR(10) NOT NULL,
    nombre                 VARCHAR(100),
    fecha_alta             DATE,
    salario_fijo           DECIMAL(6, 2),
    salario_complementos   DECIMAL(6, 2),
    CONSTRAINT pk_salarios PRIMARY KEY ( codigo )
);


-- EJERCICIO 2

ALTER TABLE conductores MODIFY
    nombre NULL;

ALTER TABLE lo_conduce ADD nombre_autobus VARCHAR(100)
    CONSTRAINT fk_nombre
        REFERENCES autobuses;

ALTER TABLE lo_conduce DROP CONSTRAINT pk_lo_conduce;
ALTER TABLE lo_conduce ADD (
    CONSTRAINT pk_lo_conduce PRIMARY KEY ( conductor,
                                           nombre_autobus )
);

ALTER TABLE salarios ADD conductor CHAR(9)
    CONSTRAINT fk_conductor
        REFERENCES conductores;


-- EJERCICIO 3

INSERT INTO plazas_parking VALUES ( 'PLAZA 1' );

INSERT INTO plazas_parking VALUES ( 'PLAZA 2' );

INSERT INTO plazas_parking VALUES ( 'PLAZA 3' );

INSERT INTO plazas_parking VALUES ( 'PLAZA 4' );

INSERT INTO plazas_parking VALUES ( 'PLAZA 5' );

INSERT INTO autobuses VALUES (
    'Autobús 1',
    'Mercedes',
    'PLAZA 1'
);

INSERT INTO autobuses VALUES (
    'Autobús 2',
    'Irízar',
    'PLAZA 2'
);

INSERT INTO autobuses VALUES (
    'Autobús 3',
    'Renault',
    'PLAZA 3'
);

INSERT INTO autobuses VALUES (
    'Autobús 4',
    'Irízar',
    'PLAZA 4'
);

INSERT INTO conductores VALUES (
    '11111111A',
    'Juan García',
    5
);

INSERT INTO conductores VALUES (
    '22222222B',
    'Pedro Pérez',
    1
);

INSERT INTO conductores VALUES (
    '33333333C',
    'Diego Sánchez',
    10
);

INSERT INTO conductores VALUES (
    '44444444D',
    'Raúl Martínez',
    25
);

INSERT INTO lo_conduce VALUES (
    '11111111A',
    '01-01-2018',
    'Autobús 1'
);

INSERT INTO lo_conduce VALUES (
    '11111111A',
    '02-01-2018',
    'Autobús 2'
);

INSERT INTO lo_conduce VALUES (
    '22222222B',
    '01-01-2018',
    'Autobús 2'
);

INSERT INTO lo_conduce VALUES (
    '33333333C',
    '02-02-2018',
    'Autobús 3'
);

INSERT INTO salarios VALUES (
    'S01',
    'Salario Base',
    '01/01/2013',
    1200.50,
    500.00,
    '11111111A'
);

INSERT INTO salarios VALUES (
    'S02',
    'Antigüedad',
    '01/04/2016',
    200.30,
    20.25,
    '11111111A'
);

INSERT INTO salarios VALUES (
    'S03',
    'Desplazamiento',
    '01/01/2016',
    50.50,
    0,
    '11111111A'
);

INSERT INTO salarios VALUES (
    'S04',
    'Incentivos',
    '01/10/2015',
    60.25,
    30.50,
    '11111111A'
);


-- EJERCICIO 4

CREATE TABLE conduciendo (
    cod_autobus   VARCHAR2(100) NOT NULL,
    notas         VARCHAR2(150),
    supervisor    VARCHAR2(100),
    pasajeros     INT,
    CONSTRAINT pk_conduciendo PRIMARY KEY ( cod_autobus )
);


-- EJERCICIO 5

DROP TABLE autobuses; -- No te lo permite porque la tabla LO_CONDUCE tiene una CAj a esta tabla

DROP TABLE conduciendo; -- Te lo permite porque no hay ninguna tabla que la referencie


-- EJERCICIO 6

DELETE FROM salarios
WHERE
    nombre LIKE '%Base%';


-- EJERCICIO 7

UPDATE autobuses
SET
    marca = 'Irízar'
WHERE
    nombre = 'Autobús 3';


-- EJERCICIO 8

-- ALTER permite modificar objetos previamente creados en la base de datos como tablas,
-- funciones o procedimientos almacenados. UPDATE por otra parte permite actualizar la
-- información de las filas dentro de una tabla en particular basado en condiciones que se definen en la misma instrucción. 


-- EJERCICIO 9

CREATE TABLE ejercicio9 (
    col1   VARCHAR2(10) DEFAULT 'defecto',
    col2   VARCHAR(10),
    col3   VARCHAR(10) DEFAULT 'defecto' NOT NULL,
    col4   VARCHAR(10) NOT NULL
);

INSERT INTO ejercicio9 VALUES (
    NULL,
    'valor1',
    'valor1',
    'valor1'
); -- Se inserta con valor null en col1

INSERT INTO ejercicio9 VALUES (
    'valor2',
    NULL,
    'valor2',
    'valor2'
); -- Se inserta con valor null en col2

INSERT INTO ejercicio9 VALUES (
    'valor3',
    'valor3',
    NULL,
    'valor3'
); -- No se inserta porque col3 no admite nulos

INSERT INTO ejercicio9 VALUES (
    'valor4',
    'valor4',
    'valor4',
    NULL
); -- No se inserta porque col4 no admite nulos

INSERT INTO ejercicio9 (
    col2,
    col3,
    col4
) VALUES (
    'valor5',
    'valor5',
    'valor5'
); -- Se inserta con el valor por defecto en col1

INSERT INTO ejercicio9 (
    col1,
    col3,
    col4
) VALUES (
    'valor6',
    'valor6',
    'valor6'
); -- Se inserta con el valor null en col2

INSERT INTO ejercicio9 (
    col1,
    col2,
    col4
) VALUES (
    'valor7',
    'valor7',
    'valor7'
); -- Se inserta con el valor por defecto en col3

INSERT INTO ejercicio9 (
    col1,
    col2,
    col3
) VALUES (
    'valor8',
    'valor8',
    'valor8'
); -- No se inserta en col4 porque no admite null

INSERT INTO ejercicio9 VALUES ( DEFAULT,
'valor9',
'valor9',
'valor9' ); -- Se inserta con el valor por defecto en col1

INSERT INTO ejercicio9 VALUES (
    'valor10', DEFAULT,
    'valor10',
    'valor10'
); -- Se inserta con el valor null en col2 ya que es el valor por defecto

INSERT INTO ejercicio9 VALUES (
    'valor11',
    'valor11', DEFAULT,
    'valor11'
); -- Se inserta con el valor por defecto en col3

INSERT INTO ejercicio9 VALUES (
    'valor12',
    'valor12',
    'valor12', DEFAULT
); -- No se inserta en col4 porque no tiene valor por defecto y no permite nulos


-- EJERCICIO 10

DROP TABLE ejercicio9;


-- EJERCICIO 11

