-- Si quieres limpiar la base de datos antes de probar los ejercicios
-- ejecuta las cinco sentencias que siguen


DROP TABLE LO_CONDUCE;
DROP TABLE AUTOBUSES;
DROP TABLE SALARIOS;   
DROP TABLE CONDUCTORES;
DROP TABLE PLAZAS_PARKING;

-- Ejercicio 1


CREATE TABLE PLAZAS_PARKING (clave VARCHAR2(256) CONSTRAINT PK_clave PRIMARY KEY);
CREATE TABLE AUTOBUSES (nombre VARCHAR2(100) CONSTRAINT PK_autobuses PRIMARY KEY, 
                    marca VARCHAR2(100), 
                    clave varchar2(256) NOT NULL,
                    CONSTRAINT UK_CLAVE UNIQUE  (CLAVE),
                    CONSTRAINT FK_AUTOBUSES_PLAZAS FOREIGN KEY (CLAVE) REFERENCES PLAZAS_PARKING(CLAVE)
 );
CREATE TABLE CONDUCTORES (dni VARCHAR2(9) CONSTRAINT PK_CONDUCTORES PRIMARY KEY, nombre VARCHAR2(100) NOT NULL, antiguedad INTEGER);
CREATE TABLE LO_CONDUCE (conductor VARCHAR2(9),  fecha DATE NOT NULL , CONSTRAINT PK_LO_CONDUCE PRIMARY KEY (conductor),CONSTRAINT FK_LO_CONDUCE_CONDUCTORES FOREIGN KEY (conductor) REFERENCES CONDUCTORES(dni));
CREATE TABLE SALARIOS (codigo VARCHAR2(50), nombre VARCHAR2(100), fecha_alta date, salario_fijo number(6,2), salario_complementos number(6,2),   CONSTRAINT PK_SALARIOS PRIMARY KEY (codigo));

-- Ejercicio 2

ALTER TABLE CONDUCTORES MODIFY nombre  NULL;

 
ALTER TABLE LO_CONDUCE ADD NOMBRE_AUTOBUS VARCHAR2(10) CONSTRAINT FK_LO_CONDUCE_AUTOBUS  REFERENCES AUTOBUSES;

ALTER TABLE LO_CONDUCE drop constraint PK_LO_CONDUCE;
ALTER TABLE LO_CONDUCE ADD (CONSTRAINT PK_LO_CONDUCE primary  key(conductor, nombre_autobus ));

ALTER TABLE SALARIOS ADD conductor VARCHAR2(9) CONSTRAINT FK_SALARIOS_CONDUCTORES REFERENCES CONDUCTORES;

-- Ejercicio 3

-- Tabla PLAZAS_PARKING

INSERT INTO PLAZAS_PARKING(Clave) VALUES ('PLAZA 1');
INSERT INTO PLAZAS_PARKING(Clave) VALUES ('PLAZA 2');
INSERT INTO PLAZAS_PARKING(Clave) VALUES ('PLAZA 3');
INSERT INTO PLAZAS_PARKING(Clave) VALUES ('PLAZA 4');
INSERT INTO PLAZAS_PARKING(Clave) VALUES ('PLAZA 5');

-- Tabla AUTOBUSES

INSERT INTO AUTOBUSES(nombre, marca, clave) VALUES ('Autobús 1','Mercedes', 'PLAZA 1');
INSERT INTO AUTOBUSES(nombre, marca, clave) VALUES ('Autobús 2','Irízar','PLAZA 2');
INSERT INTO AUTOBUSES(nombre, marca, clave) VALUES ('Autobús 3','Renault','PLAZA 3');
INSERT INTO AUTOBUSES(nombre, marca, clave) VALUES ('Autobús 4','Irízar','PLAZA 4');

-- Tabla CONDUCTORES

INSERT INTO CONDUCTORES (dni, nombre, antiguedad) VALUES ('11111111A','Juan García',5);
INSERT INTO CONDUCTORES (dni, nombre, antiguedad) VALUES ('22222222B','Pedro Pérez',1);
INSERT INTO CONDUCTORES (dni, nombre, antiguedad) VALUES ('33333333C','Diego Sánchez',10);
INSERT INTO CONDUCTORES (dni, nombre, antiguedad) VALUES ('44444444D','Raúl Martínez',25);

-- Tabla LO_CONDUCE

INSERT INTO LO_CONDUCE (nombre_autobus, conductor, fecha) VALUES ('Autobús 1','11111111A',to_date('01/01/2017','dd/mm/yyyy'));
INSERT INTO LO_CONDUCE (nombre_autobus, conductor, fecha) VALUES ('Autobús 2','11111111A',to_date('02/01/2017','dd/mm/yyyy'));
INSERT INTO LO_CONDUCE (nombre_autobus, conductor, fecha) VALUES ('Autobús 2','22222222B',to_date('01/01/2017','dd/mm/yyyy'));
INSERT INTO LO_CONDUCE (nombre_autobus, conductor, fecha) VALUES('Autobús 3','33333333C',to_date('02/02/2013','dd/mm/yyyy'));

-- Tabla RECURSO

INSERT INTO SALARIOS (codigo, nombre, conductor, fecha_alta, salario_fijo, salario_complementos) VALUES ('S01', 'Salario base', '11111111A',to_date('01/01/2013','dd/mm/yyyy'),1200.50,500);
INSERT INTO SALARIOS (codigo, nombre, conductor, fecha_alta, salario_fijo, salario_complementos) VALUES ('S02', 'Antigüedad', '11111111A',to_date('01/04/2016','dd/mm/yyyy'),200.30,20.25);
INSERT INTO SALARIOS (codigo, nombre, conductor, fecha_alta, salario_fijo, salario_complementos) VALUES ('S03', 'Desplazamiento', '11111111A',to_date('01/01/2016','dd/mm/yyyy'),50.50,0);
INSERT INTO SALARIOS (codigo, nombre, conductor, fecha_alta, salario_fijo, salario_complementos) VALUES ('S04', 'Incentivos','11111111A', to_date('01/10/2015','dd/mm/yyyy'),60.25,30.50);

-- Ejercicio 4

CREATE TABLE CONDUCIENDO(cod_autobus VARCHAR2(100) CONSTRAINT PK_CONDUCIENDO PRIMARY KEY, notas VARCHAR2(150), supervisor VARCHAR2(100), pasajeros INTEGER);

-- Ejercicio 5

-- a)

DROP TABLE AUTOBUSES;

-- No nos permite borrarla, porque la integridad referencial nos lo impide. La tabla LO_CONDUCE tiene una clave ajena hacia AUTOBUSES.

-- b)

DROP TABLE CONDUCIENDO;

-- Sí permite borrarla, ya que es una tabla independiente.

-- Ejercicio 6

DELETE SALARIOS WHERE nombre like '%base%';

-- Ejericio 7

UPDATE AUTOBUSES SET marca='Irízar' WHERE nombre='Autobús 3';

-- Ejercicio 8

-- La sentencia ALTER TABLE sirve para modificar la estructura de las tablas, y la sentencia UPDATE para modificar la información de ellas, es decir,
-- datos de filas ya existentes. Aunque ambas sirven para modificar cosas, el significado de su ejecución es totalmente distinto.

-- Ejercicio 9

CREATE TABLE EJERCICIO9 (col1 VARCHAR2(4) DEFAULT 'COL1' NULL,col2 VARCHAR2(4) NULL, col3 VARCHAR2(4) DEFAULT 'COL3' NOT NULL, col4 VARCHAR2(4) NOT NULL); 

-- En todos los casos supondremos que la sentencia de inserción es correcta para el resto de columnas.

-- INSERCIÓN DE NULL

-- Si insertamos un NULO en la col1, el SGBD incluirá el valor NULL, ya que estamos forzando que se inserte ese valor. No tomará el valor por defecto.
-- Si insertamos un NULO en la col2, el SGBD incluirá un NULO en esa fila por la misma razón que para col1, aunque éste no tiene valor por defecto.
-- En ningún caso podremos insertar nulos en las filas definidas como NOT NULL. Esto es en la col3 y col 4. La razón es obvia: están definidas para que no los admitan.

-- INSERCIÓN DE DEFAULT

INSERT INTO EJERCICIO9(COL1,COL2,COL3,COL4) VALUES(DEFAULT, DEFAULT,DEFAULT,'DEFA');

-- El resultado es:    COL1,NULL,COL3,DEFA
-- En la col1 pondrá el valor COL1 porque tiene definida esa cadena por defecto.
-- En la col2 pondrá un nulo, porque no tiene valor por defecto.
-- En la col3 pondrá COL3, porque no tiene valor definido por defecto (caso similar al de col1).
-- En la col4 pondrá la cadena 'DEFA', ya que es el que le hemos puesto al no admitir nulos y no tener valor por defecto asignado. Lo hacemos así para que no dé fallo la senencia insert.

-- NO PONIENDO VALOR A LA COLUMNA

-- Si no ponemos valor para la col1, el SGBD incluirá automáticamente el valor 'COL1', tal como está definido en la restricción DEFAULT.
-- Si no ponemos valor para la col2, el SGBD incluirá un NULO en esa fila, ya que no hay definida restricción DEFAULT y además la columna admite nulos.
-- Si no ponemos valor para la col3, el SGBD incluirá automáticamente el valor 'COL3', tal como está definido en la restricción DEFAULT.
-- Si no ponemos valor para la col4, el SGBD nos dará un error, y no nos dejará insertar. El motivo es que al no haber valor, intenta insertar un NULL, y como esa columna no los admite
-- falla la sentencia

-- EJERCICIO 10

DROP TABLE EJERCICIO9;


-- EJERCICIO 11

insert into AUTOBUSES (nombre, marca, clave ) values ('PRUEBA','PRUEBA','PLAZA 5');

select * from AUTOBUSES;

-> Sí que aparece

rollback;

select * from AUTOBUSES;
-> Ya no aparece pues la transacción ha sido anulada 


-- EJERCICIO 12

grant select on AUTOBUSES to dbdm_micompañero

insert into AUTOBUSES (nombre, marca, clave ) values ('PRUEBA','PRUEBA','PLAZA 5');

select * from AUTOBUSES;

-- > A ti sí debe salirte

-- Tu compañero ejecuta 

select * from dbdm_miusuario.AUTOBUSES

--> Y no le sale (lógico, al no haberse producido el commit)

--> Tú ejecutas el commit
commit;

--> A tu compañero ya le sale



